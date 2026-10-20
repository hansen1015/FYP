#!/usr/bin/env python3
"""
Live GUI for two boards:
  ESP board (esp_board/)          : IR temp, resistance, heater PWM + PID
  Thermocouple board (thermocouple_board/): thermocouple 1 only

The thermocouple reading is forwarded to the ESP board ("tc <degC>") so the
heater PID can also use it as its input. One PID runs at a time; pick its input
(IR / thermocouple / resistance) below. Each input has its own SP and gains.

Needs: pyserial, matplotlib, tkinter
"""

import csv
import json
import math
import os
import queue
import re
import threading
import time
from datetime import datetime
import tkinter as tk
from tkinter import filedialog, messagebox, ttk

import serial
import serial.tools.list_ports
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

BAUD = 115200
NAN = float("nan")
SRC_NAMES = ["IR temp (°C)", "Thermocouple (°C)", "Resistance (Ω)"]
SRC_DEFAULTS = [("0", "5", "0.05", "0"), ("0", "5", "0.05", "0"), ("0", "0.5", "0", "0")]
TC_RE = re.compile(r"TC1:\s*(NC|-?\d+(?:\.\d+)?)")
TC_STALE_S = 3.0  # matches TC_TIMEOUT_MS in the ESP firmware
UPDATE_MS = 200
HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, "output")
SETTINGS = os.path.join(HERE, "gui_settings.json")
SCRIPT_DIR = os.path.join(HERE, "scripts")
EXAMPLE_SCRIPT = os.path.join(SCRIPT_DIR, "example.json")
SCRIPT_INPUTS = {"ir": 0, "tc": 1, "res": 2}
MAX_TEMP_TARGET = 79.0  # the ESP board cuts the heater at 80 degC
CSV_HEADER = ["serial_number", "time_s", "timestamp", "ir_C", "thermocouple_C", "resistance_ohm", "voltage_V",
              "current_mA", "pwm_pct", "pid_auto", "pid_input"]


def parse_data(line):
    """'DATA ms V mA mW ohm amb ir pwm auto src' -> dict, or None."""
    f = line.split()
    if len(f) != 11 or f[0] != "DATA":
        return None
    try:
        v = [float(x) for x in f[1:]]  # float() accepts 'nan' / '-nan'
    except ValueError:
        return None
    return dict(volt=v[1], ma=v[2], ohm=v[4], amb=v[5], ir=v[6], pwm=v[7],
                auto=int(v[8]), src=int(v[9]))


def parse_tc(line):
    m = TC_RE.match(line)
    if not m:
        return None
    return NAN if m.group(1) == "NC" else float(m.group(1))


def parse_script(text):
    """JSON text -> list of (start_s, end_s, src 0-2, target); raises ValueError with a readable message."""
    try:
        data = json.loads(text)
    except ValueError as e:
        raise ValueError(f"Not valid JSON: {e}")
    rows = data.get("segments") if isinstance(data, dict) else data
    if not isinstance(rows, list) or not rows:
        raise ValueError('Need a non-empty "segments" list')
    segs, prev_end = [], 0.0
    for n, row in enumerate(rows, 1):
        try:
            start, end, target = (float(row[k]) for k in ("start", "end", "target"))
            src = SCRIPT_INPUTS[str(row["input"]).lower()]
        except (KeyError, TypeError, ValueError):
            raise ValueError(f'Segment {n}: needs numbers "start", "end", "target" and '
                             f'"input" (ir, tc or res)')
        if not all(map(math.isfinite, (start, end, target))) or start < 0 or end <= start:
            raise ValueError(f"Segment {n}: need 0 <= start < end")
        if start < prev_end:
            raise ValueError(f"Segment {n}: starts before the previous segment ends")
        if src < 2 and target > MAX_TEMP_TARGET:
            raise ValueError(f"Segment {n}: temperature target must be <= {MAX_TEMP_TARGET:g} C")
        if src == 2 and target <= 0:
            raise ValueError(f"Segment {n}: resistance target must be > 0")
        segs.append((start, end, src, target))
        prev_end = end
    return segs


def segment_at(segs, t):
    """Latest segment that has started by t (so a gap keeps the previous one); None before the first."""
    cur = None
    for s in segs:
        if s[0] <= t:
            cur = s
    return cur


class App:
    def __init__(self, root):
        self.root = root
        root.title("IR + Thermocouple + Resistance")
        root.geometry("1100x900")

        self.ser = {"esp": None, "tc": None}
        self.stop = {"esp": threading.Event(), "tc": threading.Event()}
        self.rx = queue.Queue()
        self.t0 = time.time()
        self.tc_now, self.tc_time = NAN, 0.0
        self.times, self.ir, self.tc, self.res, self.pwm = [], [], [], [], []
        self.volt, self.cur = [], []
        self.log = []  # full history for the CSV (the plot lists get trimmed)
        self.cfg = self.load_settings()
        self.script = None  # running script: {segs, t0, cur}

        self._build_ports()
        self._build_readouts()
        self._build_plot()
        self._build_control()
        self._build_script_editor()
        self.status = tk.StringVar(value="Disconnected")
        ttk.Label(root, textvariable=self.status, anchor="w").pack(fill="x", padx=8, pady=(0, 4))

        self.refresh_ports()
        self.root.after(UPDATE_MS, self.tick)
        root.protocol("WM_DELETE_WINDOW", self.on_close)

    # ---------- UI ----------
    def _build_ports(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8, pady=6)
        self.port_vars, self.port_boxes, self.conn_btns = {}, {}, {}
        for key, title in (("esp", "ESP board (IR/res/PWM):"), ("tc", "Thermocouple board:")):
            ttk.Label(f, text=title).pack(side="left", padx=(0, 2))
            var = tk.StringVar()
            box = ttk.Combobox(f, textvariable=var, width=16)
            box.pack(side="left", padx=2)
            btn = ttk.Button(f, text="Connect", command=lambda k=key: self.toggle(k))
            btn.pack(side="left", padx=(2, 14))
            self.port_vars[key], self.port_boxes[key], self.conn_btns[key] = var, box, btn
        ttk.Button(f, text="Refresh", command=self.refresh_ports).pack(side="left")
        ttk.Label(f, text="Window (s):").pack(side="left", padx=(14, 2))
        self.window_var = tk.IntVar(value=self.cfg.get("window", 120))
        ttk.Spinbox(f, from_=10, to=3600, increment=10, width=6,
                    textvariable=self.window_var).pack(side="left")
        ttk.Button(f, text="Clear graph", command=self.clear_data).pack(side="left", padx=10)
        ttk.Label(f, text="Serial no.:").pack(side="left", padx=(4, 2))
        self.serial_var = tk.StringVar(value=self.cfg.get("serial", ""))
        ttk.Entry(f, textvariable=self.serial_var, width=14).pack(side="left", padx=(0, 6))
        ttk.Button(f, text="Save CSV + screenshot", command=self.save_outputs).pack(side="left")

    def _build_readouts(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8)
        self.read_lbl = {}
        for key, title in (("ir", "IR temp"), ("tc", "Thermocouple"), ("res", "Resistance"),
                           ("volt", "Voltage"), ("cur", "Current"), ("pwm", "PWM")):
            box = ttk.LabelFrame(f, text=title)
            box.pack(side="left", expand=True, fill="x", padx=4)
            lbl = ttk.Label(box, text="--", font=("TkDefaultFont", 20, "bold"), anchor="center")
            lbl.pack(fill="x", padx=6, pady=2)
            self.read_lbl[key] = lbl

    def _build_plot(self):
        self.fig = Figure(figsize=(8, 6), dpi=100)
        self.ax_t, self.ax_r, self.ax_v, self.ax_p = self.fig.subplots(4, 1, sharex=True)
        self.ax_i = self.ax_v.twinx()
        self.ax_t.set_ylabel("Temp (°C)")
        self.ax_r.set_ylabel("Resistance (Ω)")
        self.ax_v.set_ylabel("Voltage (V)", color="#911eb4")
        self.ax_i.set_ylabel("Current (mA)", color="#008080")
        self.ax_p.set_ylabel("PWM (%)")
        self.ax_p.set_xlabel("Time (s)")
        self.ax_p.set_ylim(-5, 105)
        for ax in (self.ax_t, self.ax_r, self.ax_v, self.ax_p):
            ax.grid(True, alpha=0.3)
        self.ln_ir, = self.ax_t.plot([], [], color="#e6194b", label="IR")
        self.ln_tc, = self.ax_t.plot([], [], color="#4363d8", label="Thermocouple")
        self.ln_res, = self.ax_r.plot([], [], color="#3cb44b")
        self.ln_volt, = self.ax_v.plot([], [], color="#911eb4")
        self.ln_cur, = self.ax_i.plot([], [], color="#008080")
        self.ln_pwm, = self.ax_p.plot([], [], color="#f58231")
        self.ln_sp_t, = self.ax_t.plot([], [], "k--", alpha=0.6, label="Setpoint")
        self.ln_sp_r, = self.ax_r.plot([], [], "k--", alpha=0.6)
        self.ax_t.legend(loc="upper left", ncol=3)
        self.fig.tight_layout()
        self.canvas = FigureCanvasTkAgg(self.fig, master=self.root)
        self.canvas.get_tk_widget().pack(fill="both", expand=True, padx=8)

    def _build_control(self):
        box = ttk.LabelFrame(self.root, text="Heater control (ESP board)")
        box.pack(fill="x", padx=8, pady=6)

        self.src_var = tk.IntVar(value=self.cfg.get("src", 0))
        self.auto_var = tk.BooleanVar(value=False)
        self.pwm_var = tk.DoubleVar(value=0)
        self.sp_vars, self.gain_vars = [], []
        for s in range(3):
            col = ttk.Frame(box)
            col.pack(side="left", padx=10, pady=4)
            ttk.Radiobutton(col, text=f"PID input: {SRC_NAMES[s]}", variable=self.src_var,
                            value=s, command=self.send_src).grid(row=0, column=0, columnspan=2)
            vs = []
            saved = self.cfg.get("inputs", [])
            vals = saved[s] if len(saved) == 3 and len(saved[s]) == 4 else SRC_DEFAULTS[s]
            for r, (name, val) in enumerate(zip(("SP", "Kp", "Ki", "Kd"), vals), 1):
                v = tk.StringVar(value=str(val))
                ttk.Label(col, text=name).grid(row=r, column=0, sticky="e")
                e = ttk.Entry(col, textvariable=v, width=8)
                e.bind("<Return>", lambda ev: self.push_config())
                e.grid(row=r, column=1, padx=2, pady=1)
                vs.append(v)
            self.sp_vars.append(vs[0])
            self.gain_vars.append(vs[1:])

        side = ttk.Frame(box)
        side.pack(side="left", padx=12)
        ttk.Checkbutton(side, text="Enable PID", variable=self.auto_var,
                        command=self.toggle_auto).pack()
        ttk.Button(side, text="Apply PID (all inputs)", command=self.push_config).pack(pady=2)
        row = ttk.Frame(side)
        row.pack(pady=2)
        ttk.Label(row, text="Manual PWM %").pack(side="left")
        ttk.Spinbox(row, from_=0, to=100, increment=1, width=5, textvariable=self.pwm_var).pack(side="left")
        ttk.Button(row, text="Set", command=self.send_pwm).pack(side="left")
        ttk.Button(side, text="ALL OFF", command=self.all_off).pack(pady=2)
        ttk.Button(side, text="Script…", command=self.show_editor).pack(pady=2)
        self.script_var = tk.StringVar(value="Script: not running")
        ttk.Label(side, textvariable=self.script_var).pack()

    def _build_script_editor(self):
        w = self.editor = tk.Toplevel(self.root)
        w.title("Target script (JSON)")
        w.geometry("560x460")
        w.protocol("WM_DELETE_WINDOW", w.withdraw)
        w.withdraw()
        ttk.Label(w, justify="left", text=(
            'Times in seconds. "input": ir | tc | res. A gap between segments keeps the previous\n'
            "target; after the last segment the PID stops and the heater turns off.")
        ).pack(anchor="w", padx=8, pady=4)
        bar = ttk.Frame(w)
        bar.pack(fill="x", padx=8)
        for text, cmd in (("Open…", self.open_script), ("Save…", self.save_script),
                          ("Run script", self.start_script), ("Stop", lambda: self.stop_script(off=True))):
            ttk.Button(bar, text=text, command=cmd).pack(side="left", padx=2)
        ttk.Label(w, textvariable=self.script_var).pack(anchor="w", padx=8)
        self.script_text = tk.Text(w, wrap="none", undo=True, font=("TkFixedFont", 10))
        self.script_text.pack(fill="both", expand=True, padx=8, pady=6)
        text = self.cfg.get("script_text")
        if not text:
            try:
                with open(EXAMPLE_SCRIPT) as f:
                    text = f.read()
            except OSError:
                text = '{"segments": []}'
        self.script_text.insert("1.0", text)

    def show_editor(self):
        self.editor.deiconify()
        self.editor.lift()

    # ---------- serial ----------
    def refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        for k, box in self.port_boxes.items():
            box["values"] = ports
        for k, port in zip(("esp", "tc"), ports):
            if not self.port_vars[k].get():
                self.port_vars[k].set(self.cfg.get("ports", {}).get(k) or port)

    def toggle(self, key):
        if self.ser[key]:
            self.disconnect(key)
        else:
            self.connect(key)

    def connect(self, key):
        port = self.port_vars[key].get().strip()
        if not port:
            messagebox.showerror("Error", "Select a serial port")
            return
        try:
            # DTR/RTS low so opening the port doesn't reset the board
            s = serial.Serial()
            s.port, s.baudrate, s.timeout = port, BAUD, 0.2
            s.dtr = s.rts = False
            s.open()
        except (serial.SerialException, OSError) as e:
            messagebox.showerror("Connection failed", str(e))
            return
        self.ser[key] = s
        self.stop[key].clear()
        threading.Thread(target=self.reader, args=(key, s), daemon=True).start()
        self.conn_btns[key].config(text="Disconnect")
        self.status.set(f"{key} connected to {port}")
        if key == "esp":
            self.clear_data()
            self.root.after(500, self.push_config)  # board forgets settings on reset

    def disconnect(self, key):
        if key == "esp":
            self.send("auto 0")
            self.send("pwm 0")  # fail safe: heater off
            self.auto_var.set(False)
            time.sleep(0.05)
        self.stop[key].set()
        try:
            self.ser[key].close()
        except Exception:
            pass
        self.ser[key] = None
        self.conn_btns[key].config(text="Connect")
        self.status.set(f"{key} disconnected")

    def reader(self, key, s):
        buf = b""
        while not self.stop[key].is_set():
            try:
                chunk = s.read(256)
            except Exception as e:
                self.rx.put((key, "error", str(e)))
                return
            buf += chunk
            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                self.rx.put((key, "line", line.decode(errors="replace").strip()))

    def send(self, text):
        s = self.ser["esp"]
        if not s:
            self.status.set("ESP board not connected - command not sent")
            return False
        try:
            s.write((text + "\n").encode())
            return True
        except Exception as e:
            self.status.set(f"Send failed: {e}")
            return False

    # ---------- commands ----------
    def push_config(self):
        """Validate and send SP + gains of all 3 inputs, then the active input."""
        try:
            cfg = [(float(self.sp_vars[s].get()), *(float(v.get()) for v in self.gain_vars[s]))
                   for s in range(3)]
        except ValueError:
            messagebox.showerror("Invalid value", "Setpoints and gains must be numbers")
            return False
        if any(min(c[1:]) < 0 or not all(map(math.isfinite, c)) for c in cfg):
            messagebox.showerror("Invalid value", "Gains must not be negative")
            return False
        for s, (sp, kp, ki, kd) in enumerate(cfg):
            if not (self.send(f"pid {s} {kp:g} {ki:g} {kd:g}") and self.send(f"sp {s} {sp:g}")):
                return False
        self.save_settings()
        return self.send_src()

    def send_src(self):
        self.save_settings()
        return self.send(f"src {self.src_var.get()}")

    def toggle_auto(self):
        if self.auto_var.get():
            if not self.push_config() or not self.send("auto 1"):
                self.auto_var.set(False)
        else:
            self.stop_script()
            self.send("auto 0")

    def send_pwm(self):
        try:
            pct = max(0.0, min(100.0, float(self.pwm_var.get())))
        except (tk.TclError, ValueError):
            return
        if self.send(f"pwm {pct:g}"):
            self.stop_script()
            self.auto_var.set(False)

    def all_off(self):
        self.stop_script()
        self.pwm_var.set(0)
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")

    # ---------- script ----------
    def open_script(self):
        path = filedialog.askopenfilename(parent=self.editor, initialdir=SCRIPT_DIR,
                                          filetypes=[("JSON", "*.json"), ("All", "*")])
        if path:
            with open(path) as f:
                self.script_text.delete("1.0", "end")
                self.script_text.insert("1.0", f.read())

    def save_script(self):
        os.makedirs(SCRIPT_DIR, exist_ok=True)
        path = filedialog.asksaveasfilename(parent=self.editor, initialdir=SCRIPT_DIR,
                                            defaultextension=".json",
                                            filetypes=[("JSON", "*.json")])
        if path:
            with open(path, "w") as f:
                f.write(self.script_text.get("1.0", "end").rstrip() + "\n")

    def start_script(self):
        try:
            segs = parse_script(self.script_text.get("1.0", "end"))
        except ValueError as e:
            messagebox.showerror("Script error", str(e), parent=self.editor)
            return
        if not self.ser["esp"]:
            messagebox.showerror("Script", "Connect the ESP board first", parent=self.editor)
            return
        if not self.push_config():  # gains for all inputs; the script only sets SP + input
            return
        self.save_settings()
        self.clear_data()  # fresh graph + CSV (and time 0) for this run
        self.script = {"segs": segs, "t0": time.time(), "cur": None}
        self.run_script()

    def stop_script(self, off=False, why="stopped"):
        if self.script is None:
            return
        self.script = None
        self.script_var.set(f"Script: {why}")
        if off:  # heater off, like ALL OFF
            self.auto_var.set(False)
            self.send("auto 0")
            self.send("pwm 0")
        self.save_outputs()  # every run ends with a CSV + screenshot, even a stopped one

    def run_script(self):
        sc = self.script
        if sc is None:
            return
        if not self.ser["esp"]:
            self.stop_script(why="stopped (ESP disconnected)")
            return
        t = time.time() - sc["t0"]
        if t > sc["segs"][-1][1]:
            self.stop_script(off=True, why="finished, heater off")
            return
        seg = segment_at(sc["segs"], t)
        n = sc["segs"].index(seg) + 1 if seg else 0
        self.script_var.set(f"Script: {t:.1f}s, segment {n}/{len(sc['segs'])}" if seg
                            else f"Script: waiting for first segment ({t:.1f}s)")
        if seg is None or seg is sc["cur"]:
            return
        sc["cur"] = seg
        _, _, s, target = seg
        self.src_var.set(s)  # also drives the setpoint line in the plot
        self.sp_vars[s].set(f"{target:g}")
        self.send(f"sp {s} {target:g}")
        self.send(f"src {s}")
        self.send("auto 1")
        self.auto_var.set(True)

    # ---------- data ----------
    def clear_data(self):
        self.t0 = time.time()
        for a in (self.times, self.ir, self.tc, self.res, self.pwm, self.volt, self.cur, self.log):
            a.clear()

    def handle(self, key, line):
        if key == "tc":
            v = parse_tc(line)
            if v is None:
                return
            self.tc_now, self.tc_time = v, time.time()
            self.read_lbl["tc"].config(text="NC" if v != v else f"{v:.2f} °C")
            if v == v and self.ser["esp"]:
                self.send(f"tc {v:.2f}")
            return
        d = parse_data(line)
        if d is None:
            if line.startswith(("OK", "ERR")):
                self.status.set(line)
            return
        fresh = time.time() - self.tc_time < TC_STALE_S
        self.times.append(time.time() - self.t0)
        self.ir.append(d["ir"])
        self.tc.append(self.tc_now if fresh else NAN)
        self.res.append(d["ohm"])
        self.pwm.append(d["pwm"])
        self.volt.append(d["volt"])
        self.cur.append(d["ma"])
        self.auto_var.set(bool(d["auto"]))  # board drops to manual if the PC goes quiet
        self.log.append([f"{self.times[-1]:.1f}", datetime.now().isoformat(timespec="seconds"),
                         d["ir"], self.tc[-1], d["ohm"], d["volt"], d["ma"], d["pwm"],
                         d["auto"], d["src"]])
        self.read_lbl["ir"].config(text=f"{d['ir']:.2f} °C")
        self.read_lbl["res"].config(text=f"{d['ohm']:.2f} Ω")
        self.read_lbl["volt"].config(text=f"{d['volt']:.3f} V")
        self.read_lbl["cur"].config(text=f"{d['ma']:.2f} mA")
        self.read_lbl["pwm"].config(text=f"{d['pwm']:.1f} %")

    def tick(self):
        try:
            while True:
                key, kind, payload = self.rx.get_nowait()
                if kind == "line":
                    self.handle(key, payload)
                else:
                    self.status.set(f"{key} serial error: {payload}")
                    self.disconnect(key)
        except queue.Empty:
            pass
        self.run_script()
        if self.ser["esp"]:
            self.send("hb")  # watchdog: the board turns the heater off without this
        self.redraw()
        self.root.after(UPDATE_MS, self.tick)

    def redraw(self):
        if not self.times:
            return
        try:
            win = max(10, int(self.window_var.get()))
        except (tk.TclError, ValueError):
            win = 120
        tmax = self.times[-1]
        tmin = max(0, tmax - win)
        while len(self.times) > 1 and self.times[0] < tmin - win:  # bound memory
            for a in (self.times, self.ir, self.tc, self.res, self.pwm, self.volt, self.cur):
                a.pop(0)
        self.ln_ir.set_data(self.times, self.ir)
        self.ln_tc.set_data(self.times, self.tc)
        self.ln_res.set_data(self.times, self.res)
        self.ln_pwm.set_data(self.times, self.pwm)
        self.ln_volt.set_data(self.times, self.volt)
        self.ln_cur.set_data(self.times, self.cur)

        # setpoint line only while the PID is running on that input
        s = self.src_var.get()
        try:
            sp = float(self.sp_vars[s].get()) if self.auto_var.get() else None
        except ValueError:
            sp = None
        line = ([tmin, tmax], [sp, sp]) if sp is not None else ([], [])
        self.ln_sp_t.set_data(*(line if s < 2 else ([], [])))
        self.ln_sp_r.set_data(*(line if s == 2 else ([], [])))

        i0 = next((i for i, t in enumerate(self.times) if t >= tmin), 0)
        extra_t = [sp] if sp is not None and s < 2 else []
        extra_r = [sp] if sp is not None and s == 2 else []
        for ax, series in ((self.ax_t, [self.ir[i0:], self.tc[i0:], extra_t]),
                           (self.ax_r, [self.res[i0:], extra_r]),
                           (self.ax_v, [self.volt[i0:]]), (self.ax_i, [self.cur[i0:]])):
            vis = [v for ser in series for v in ser if math.isfinite(v)]
            if vis:
                lo, hi = min(vis), max(vis)
                pad = max(1.0, (hi - lo) * 0.1)
                ax.set_ylim(lo - pad, hi + pad)
        self.ax_p.set_xlim(tmin, max(tmax, tmin + 10))
        self.canvas.draw_idle()

    # ---------- save / settings ----------
    def save_outputs(self):
        if not self.log:
            self.status.set("Nothing to save yet")
            return
        os.makedirs(OUT_DIR, exist_ok=True)
        sn = self.serial_var.get().strip()
        safe = re.sub(r"[^\w.-]+", "_", sn).strip("_")  # keep it a valid file name
        stamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        base = os.path.join(OUT_DIR, f"{safe}_{stamp}" if safe else stamp)
        with open(base + ".csv", "w", newline="") as f:
            w = csv.writer(f)
            w.writerow(CSV_HEADER)
            w.writerows([sn, *row] for row in self.log)
        self.redraw()
        self.fig.savefig(base + ".png", dpi=120)  # the plot area, not the whole window
        self.status.set(f"Saved {base}.csv and .png")

    def load_settings(self):
        try:
            with open(SETTINGS) as f:
                return json.load(f)
        except (OSError, ValueError):
            return {}

    def save_settings(self):
        try:
            data = {"ports": {k: v.get() for k, v in self.port_vars.items()},
                    "src": self.src_var.get(), "serial": self.serial_var.get(), "window": self.window_var.get(),
                    "script_text": self.script_text.get("1.0", "end").rstrip(),
                    "inputs": [[self.sp_vars[s].get(), *(v.get() for v in self.gain_vars[s])]
                               for s in range(3)]}
            with open(SETTINGS, "w") as f:
                json.dump(data, f, indent=1)
        except (OSError, tk.TclError):
            pass  # settings are a convenience; never block the GUI

    def on_close(self):
        self.stop_script(off=True)
        self.save_settings()
        for k in ("esp", "tc"):
            if self.ser[k]:
                self.disconnect(k)
        self.root.destroy()


if __name__ == "__main__":
    assert parse_data("DATA 1000 12.000 80.0 960.0 150.00 24.00 31.50 25.5 1 2")["ohm"] == 150.0
    assert math.isnan(parse_data("DATA 1 0.0 0.0 0.0 nan 24.0 -nan 0.0 0 0")["ir"])
    assert parse_data("garbage") is None and math.isnan(parse_tc("TC1: NC"))
    assert parse_tc("TC1: 24.50") == 24.5
    segs = parse_script(open(EXAMPLE_SCRIPT).read())
    assert len(segs) == 3 and segment_at(segs, 0.5)[3] == 30 and segment_at(segs, 1.05)[3] == 30
    assert segment_at(segs, 10.5)[2] == 1 and segment_at(segs, 5)[3] == 50
    for bad in ('{', '{"segments": []}', '[{"start":0,"end":0,"input":"ir","target":30}]',
                '[{"start":0,"end":5,"input":"x","target":30}]',
                '[{"start":0,"end":5,"input":"ir","target":95}]',
                '[{"start":0,"end":5,"input":"ir","target":30},{"start":4,"end":6,"input":"ir","target":30}]'):
        try:
            parse_script(bad)
            raise SystemExit(f"accepted bad script: {bad}")
        except ValueError:
            pass
    root = tk.Tk()
    App(root)
    root.mainloop()
