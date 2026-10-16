#!/usr/bin/env python3
"""
Live temperature graph + heater PWM control for the ESP32-C3 thermocouple rig.

Needs: pyserial, matplotlib, tkinter
    pip install pyserial matplotlib

Serial protocol (see src/main.cpp):
  in : "TC1: 24.50 | TC2: NC | ... | OUT: 0.0 55.2 0.0 0.0 0.0"
       "CFG <n> <kp> <ki> <kd> <sp> <auto 0/1>"   (reply to "get")
  out: "<1-5|all> <percent>", "auto <n>", "manual <n>",
       "sp <n> <degC>", "pid <n> <kp> <ki> <kd>", "get"
PID gains/setpoints are saved in the ESP32's flash by the firmware.
"""

import math
import queue
import re
import threading
import time
import tkinter as tk
from tkinter import ttk, messagebox

import serial
import serial.tools.list_ports
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

NUM_CH = 5
LOOP_S = 0.5  # firmware loop period (LOOP_MS)
LEARN_NEEDED = 120  # samples the firmware needs before a model is usable
BAUD = 115200
COLORS = ["#e6194b", "#3cb44b", "#4363d8", "#f58231", "#911eb4"]
TC_RE = re.compile(r"TC(\d)\s*:\s*(NC|-?\d+(?:\.\d+)?)")
OUT_RE = re.compile(r"OUT:((?:\s+-?\d+(?:\.\d+)?)+)")
PRD_RE = re.compile(r"PRD:((?:\s+(?:-|-?\d+(?:\.\d+)?))+)")
LRN_RE = re.compile(r"LRN:((?:\s+(?:-|\d+))+)")
MDL_RE = re.compile(r"MDL:((?:\s+(?:-|-?\d+(?:\.\d+)?))+)")


class App:
    def __init__(self, root):
        self.root = root
        root.title("Thermocouple / Heater Control")
        root.geometry("1150x900")

        self.ser = None
        self.rx_queue = queue.Queue()
        self.reader_stop = threading.Event()
        self.t0 = time.time()
        self.times = []
        self.temps = [[] for _ in range(NUM_CH)]
        self.preds = [[] for _ in range(NUM_CH)]  # model prediction (nan = none)
        self.auto_state = [False] * NUM_CH
        self.model = [None] * NUM_CH   # learned (a, b, c) per channel
        self.last_out = [0.0] * NUM_CH  # latest PWM %
        self.learning = [False] * NUM_CH

        self._build_top()
        self._build_tuning()
        self._build_plot()
        self._build_heaters()
        self.status = tk.StringVar(value="Disconnected")
        ttk.Label(root, textvariable=self.status, anchor="w").pack(
            fill="x", padx=8, pady=(0, 4))

        self.refresh_ports()
        self.root.after(100, self.tick)
        root.protocol("WM_DELETE_WINDOW", self.on_close)

    # ---------- UI construction ----------
    def _build_top(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8, pady=6)

        ttk.Label(f, text="Port:").pack(side="left")
        self.port_var = tk.StringVar()
        self.port_box = ttk.Combobox(f, textvariable=self.port_var, width=22)
        self.port_box.pack(side="left", padx=4)
        ttk.Button(f, text="Refresh", command=self.refresh_ports).pack(side="left")
        self.conn_btn = ttk.Button(f, text="Connect", command=self.toggle_connect)
        self.conn_btn.pack(side="left", padx=6)

        ttk.Label(f, text="Window (s):").pack(side="left", padx=(16, 2))
        self.window_var = tk.IntVar(value=120)
        ttk.Spinbox(f, from_=10, to=3600, increment=10, width=6,
                    textvariable=self.window_var).pack(side="left")

        ttk.Label(f, text="Filter τ (s):").pack(side="left", padx=(16, 2))
        self.tau_var = tk.StringVar(value="0.5")
        ae = ttk.Entry(f, textvariable=self.tau_var, width=5)
        ae.bind("<Return>", lambda e: self.send_tau())
        ae.pack(side="left")
        ttk.Button(f, text="Set", command=self.send_tau).pack(side="left", padx=2)

        self.est_var = tk.BooleanVar(value=True)
        ttk.Checkbutton(f, text="PID uses prediction", variable=self.est_var,
                        command=self.send_est).pack(side="left", padx=(16, 2))
        ttk.Label(f, text="Fuse:").pack(side="left")
        self.fuse_var = tk.StringVar(value="0.5")
        fe = ttk.Entry(f, textvariable=self.fuse_var, width=5)
        fe.bind("<Return>", lambda e: self.send_est())
        fe.pack(side="left")

        ttk.Button(f, text="Clear graph", command=self.clear_data).pack(
            side="left", padx=12)

    def _build_tuning(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8, pady=(0, 4))
        ttk.Label(f, text="Look-ahead (s):").pack(side="left")
        self.ahead_var = tk.StringVar(value="3")
        self.adapt_var = tk.BooleanVar(value=False)
        self.lambda_var = tk.StringVar(value="0.3")
        e = ttk.Entry(f, textvariable=self.ahead_var, width=5)
        e.bind("<Return>", lambda ev: self.send_tune())
        e.pack(side="left", padx=2)
        ttk.Checkbutton(f, text="Adaptive PID (re-tune every 60 s)",
                        variable=self.adapt_var, command=self.send_tune
                        ).pack(side="left", padx=(16, 2))
        ttk.Label(f, text="Response λ:").pack(side="left", padx=(12, 2))
        e = ttk.Entry(f, textvariable=self.lambda_var, width=5)
        e.bind("<Return>", lambda ev: self.send_tune())
        e.pack(side="left", padx=2)
        ttk.Button(f, text="Set", command=self.send_tune).pack(side="left", padx=2)
        ttk.Label(f, text="(λ: smaller = faster / more aggressive)",
                  foreground="gray").pack(side="left", padx=8)
        ttk.Label(f, text="Forecast (s):").pack(side="left", padx=(12, 2))
        self.forecast_var = tk.StringVar(value="30")
        ttk.Entry(f, textvariable=self.forecast_var, width=5).pack(side="left")

    def _build_plot(self):
        self.fig = Figure(figsize=(8, 3.6), dpi=100)
        self.ax = self.fig.add_subplot(111)
        self.ax.set_xlabel("Time (s)")
        self.ax.set_ylabel("Temperature (°C)")
        self.ax.grid(True, alpha=0.3)
        self.lines = [
            self.ax.plot([], [], color=COLORS[i], label=f"TC{i + 1}")[0]
            for i in range(NUM_CH)
        ]
        self.pred_lines = [
            self.ax.plot([], [], color=COLORS[i], linestyle=":", linewidth=1.8)[0]
            for i in range(NUM_CH)
        ]
        self.fc_lines = [
            self.ax.plot([], [], color=COLORS[i], linestyle="-.", linewidth=1.6,
                         alpha=0.8)[0]
            for i in range(NUM_CH)
        ]
        self.now_line = self.ax.axvline(0, color="gray", linewidth=0.8, alpha=0.5)
        self.ax.set_title("solid = measured   dotted = model prediction   "
                          "dash-dot = forecast if PWM held   dashed = setpoint",
                          fontsize=9)
        self.sp_lines = [
            self.ax.plot([], [], color=COLORS[i], linestyle="--", alpha=0.6)[0]
            for i in range(NUM_CH)
        ]
        self.ax.legend(handles=self.lines, loc="upper left", ncol=NUM_CH)
        self.fig.tight_layout()
        self.canvas = FigureCanvasTkAgg(self.fig, master=self.root)
        self.canvas.get_tk_widget().pack(fill="both", expand=True, padx=8)

    def _build_heaters(self):
        box = ttk.LabelFrame(self.root, text="Heaters")
        box.pack(fill="x", padx=8, pady=6)

        self.temp_labels = []
        self.out_labels = []
        self.mdl_labels = []
        self.learn_btns = []
        self.sliders = []
        self.pct_vars = []
        self.mode_vars = []
        self.sp_vars = []
        self.gain_vars = []  # per channel: (kp, ki, kd)
        for i in range(NUM_CH):
            col = ttk.Frame(box)
            col.pack(side="left", expand=True, fill="y", padx=6, pady=4)

            tk.Label(col, text=f"H{i + 1}", fg=COLORS[i],
                     font=("TkDefaultFont", 11, "bold")).pack()
            tl = ttk.Label(col, text="-- °C", width=10, anchor="center")
            tl.pack()
            self.temp_labels.append(tl)
            ol = ttk.Label(col, text="PWM: -- %", width=12, anchor="center",
                           font=("TkDefaultFont", 10, "bold"))
            ol.pack()
            self.out_labels.append(ol)
            ml = ttk.Label(col, text="model: not learned", anchor="center",
                           font=("TkDefaultFont", 8))
            ml.pack()
            self.mdl_labels.append(ml)
            lb = ttk.Button(col, text="Learn model",
                            command=lambda i=i: self.toggle_learn(i))
            lb.pack(pady=(0, 2))
            self.learn_btns.append(lb)

            var = tk.IntVar(value=0)
            self.pct_vars.append(var)
            sc = tk.Scale(col, from_=100, to=0, orient="vertical", length=100,
                          variable=var, showvalue=False)
            # send only when the slider is released, not on every drag step
            sc.bind("<ButtonRelease-1>", lambda e, i=i: self.send_heater(i))
            sc.pack()
            self.sliders.append(sc)

            row = ttk.Frame(col)
            row.pack()
            ent = ttk.Spinbox(row, from_=0, to=100, width=4, textvariable=var,
                              command=lambda i=i: self.send_heater(i))
            ent.bind("<Return>", lambda e, i=i: self.send_heater(i))
            ent.pack(side="left")
            ttk.Label(row, text="%").pack(side="left")

            mv = tk.BooleanVar(value=False)
            self.mode_vars.append(mv)
            ttk.Checkbutton(col, text="PID control", variable=mv,
                            command=lambda i=i: self.toggle_mode(i)).pack(pady=(6, 2))

            grid = ttk.Frame(col)
            grid.pack()
            sp = tk.StringVar(value="0")
            self.sp_vars.append(sp)
            gains = []
            for r, (name, v) in enumerate(
                    [("SP °C", sp), ("Kp", tk.StringVar(value="5")),
                     ("Ki", tk.StringVar(value="0.05")),
                     ("Kd", tk.StringVar(value="0"))]):
                ttk.Label(grid, text=name).grid(row=r, column=0, sticky="e")
                e = ttk.Entry(grid, textvariable=v, width=7)
                e.bind("<Return>", lambda ev, i=i: self.apply_pid(i))
                e.grid(row=r, column=1, padx=2, pady=1)
                if r > 0:
                    gains.append(v)
            self.gain_vars.append(gains)
            ttk.Button(col, text="Apply + Save",
                       command=lambda i=i: self.apply_pid(i)).pack(pady=(4, 0))
            ttk.Button(col, text="Auto-tune from model",
                       command=lambda i=i: self.autotune(i)).pack(pady=(2, 4))

        side = ttk.Frame(box)
        side.pack(side="left", padx=12)
        ttk.Button(side, text="ALL OFF", command=self.all_off).pack(pady=4)
        ttk.Button(side, text="Reload from\nESP", command=lambda: self.send("get")
                   ).pack(pady=4)

    # ---------- serial ----------
    def refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_box["values"] = ports
        if ports and not self.port_var.get():
            self.port_var.set(ports[0])

    def toggle_connect(self):
        if self.ser:
            self.disconnect()
        else:
            self.connect()

    def connect(self):
        port = self.port_var.get().strip()
        if not port:
            messagebox.showerror("Error", "Select a serial port")
            return
        try:
            # Keep DTR/RTS low so opening the port doesn't reset the board
            s = serial.Serial()
            s.port = port
            s.baudrate = BAUD
            s.timeout = 0.2
            s.dtr = False
            s.rts = False
            s.open()
        except (serial.SerialException, OSError) as e:
            messagebox.showerror("Connection failed", str(e))
            return
        self.ser = s
        self.reader_stop.clear()
        self.t0 = time.time()
        self.clear_data()
        threading.Thread(target=self.reader, args=(s,), daemon=True).start()
        self.conn_btn.config(text="Disconnect")
        self.status.set(f"Connected to {port}")
        self.root.after(400, lambda: self.send("get"))

    def disconnect(self):
        if self.ser:
            self.send("all 0")  # fail safe: heaters off
            time.sleep(0.05)
        self.reader_stop.set()
        if self.ser:
            try:
                self.ser.close()
            except Exception:
                pass
        self.ser = None
        for i in range(NUM_CH):
            self.pct_vars[i].set(0)
            self.set_auto(i, False)
        self.conn_btn.config(text="Connect")
        self.status.set("Disconnected")

    def reader(self, s):
        buf = b""
        while not self.reader_stop.is_set():
            try:
                chunk = s.read(256)
            except Exception as e:
                self.rx_queue.put(("error", str(e)))
                return
            if not chunk:
                continue
            buf += chunk
            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                self.rx_queue.put(("line", line.decode(errors="replace").strip()))

    def send(self, text):
        if not self.ser:
            return False
        try:
            self.ser.write((text + "\n").encode())
            return True
        except Exception as e:
            self.status.set(f"Send failed: {e}")
            return False

    def set_auto(self, i, on):
        """Update the GUI to show channel i as PID (on) or manual (off)."""
        self.auto_state[i] = on
        self.mode_vars[i].set(on)
        self.sliders[i].config(state="disabled" if on else "normal")

    def send_heater(self, i):
        try:
            pct = max(0, min(100, int(self.pct_vars[i].get())))
        except (tk.TclError, ValueError):
            return
        self.pct_vars[i].set(pct)
        if self.send(f"{i + 1} {pct}"):
            self.set_auto(i, False)  # manual PWM command leaves PID mode
        else:
            self.status.set("Not connected - heater command not sent")

    def send_tau(self):
        try:
            t = float(self.tau_var.get())
        except ValueError:
            return
        if not 0 <= t <= 60:
            messagebox.showerror("Invalid value", "tau must be 0-60 seconds (0 = off)")
            return
        if not self.send(f"tau {t:g}"):
            self.status.set("Not connected")

    def send_est(self):
        try:
            f = float(self.fuse_var.get())
        except ValueError:
            return
        if not 0 < f <= 1:
            messagebox.showerror("Invalid value", "fuse must be >0 and <=1 "
                                 "(1 = measurement only)")
            return
        if not self.ser:
            self.status.set("Not connected")
            return
        self.send(f"fuse {f:g}")
        self.send("est on" if self.est_var.get() else "est off")

    def send_tune(self):
        try:
            ah = float(self.ahead_var.get())
            lam = float(self.lambda_var.get())
        except ValueError:
            return
        if not 0 <= ah <= 20 or not 0.05 <= lam <= 2:
            messagebox.showerror("Invalid value",
                                 "look-ahead must be 0-20 s and lambda 0.05-2")
            return
        if not self.ser:
            self.status.set("Not connected")
            return
        self.send(f"lambda {lam:g}")
        self.send(f"ahead {ah:g}")
        self.send("adapt on" if self.adapt_var.get() else "adapt off")

    def toggle_learn(self, i):
        if not self.ser:
            self.status.set("Not connected")
            return
        if self.learning[i]:
            self.send(f"learn {i + 1} off")
        else:
            if not messagebox.askyesno(
                    "Learn model",
                    f"Start learning H{i + 1}?\n\nThe old model is discarded. "
                    "Vary the PWM (steps up and down, wait for the temperature "
                    "to respond) for a few minutes, then press 'Stop + save'."):
                return
            self.send(f"learn {i + 1} on")

    def autotune(self, i):
        if not self.send(f"autotune {i + 1}"):
            self.status.set("Not connected")

    def toggle_mode(self, i):
        want_auto = self.mode_vars[i].get()
        if not self.ser:
            self.mode_vars[i].set(False)
            self.status.set("Not connected")
            return
        if want_auto:
            # push the current setpoint/gains first so PID never starts with
            # stale values
            if not self.apply_pid(i):
                self.mode_vars[i].set(False)
                return
            self.send(f"auto {i + 1}")
        else:
            self.send(f"manual {i + 1}")
        self.set_auto(i, want_auto)

    def apply_pid(self, i):
        try:
            sp = float(self.sp_vars[i].get())
            kp, ki, kd = (float(v.get()) for v in self.gain_vars[i])
        except ValueError:
            messagebox.showerror("Invalid value",
                                 f"H{i + 1}: setpoint and gains must be numbers")
            return False
        if min(kp, ki, kd) < 0:
            messagebox.showerror("Invalid value",
                                 f"H{i + 1}: gains must not be negative")
            return False
        if not self.send(f"pid {i + 1} {kp:g} {ki:g} {kd:g}"):
            self.status.set("Not connected - not saved")
            return False
        self.send(f"sp {i + 1} {sp:g}")
        return True

    def all_off(self):
        for i in range(NUM_CH):
            self.pct_vars[i].set(0)
            self.set_auto(i, False)
        if not self.send("all 0"):
            self.status.set("Not connected - heater command not sent")

    # ---------- data / plotting ----------
    def clear_data(self):
        self.t0 = time.time()
        self.times.clear()
        for t in self.temps + self.preds:
            t.clear()

    def handle_line(self, line):
        if line.startswith("CFG"):
            f = line.split()
            if len(f) == 7:
                i = int(f[1]) - 1
                if 0 <= i < NUM_CH:
                    for var, val in zip(self.gain_vars[i], f[2:5]):
                        var.set(val)
                    self.sp_vars[i].set(f[5])
                    self.set_auto(i, f[6] == "1")
            return
        if line.startswith("TUNE "):
            f = line.split()
            if len(f) == 4:
                self.ahead_var.set(f[1])
                self.adapt_var.set(f[2] == "1")
                self.lambda_var.set(f[3])
            return
        if line.startswith("EST "):
            f = line.split()
            if len(f) == 3:
                self.est_var.set(f[1] == "1")
                self.fuse_var.set(f[2])
            return
        found = TC_RE.findall(line)
        if found:
            t = time.time() - self.t0
            vals = [float("nan")] * NUM_CH
            for idx, v in found:
                k = int(idx) - 1
                if 0 <= k < NUM_CH and v != "NC":
                    vals[k] = float(v)
            self.times.append(t)
            for k in range(NUM_CH):
                self.temps[k].append(vals[k])
                lbl = "NC" if vals[k] != vals[k] else f"{vals[k]:.2f} °C"
                self.temp_labels[k].config(text=lbl)
            m = PRD_RE.search(line)
            prd = m.group(1).split() if m else []
            for k in range(NUM_CH):
                v = prd[k] if k < len(prd) else "-"
                self.preds[k].append(float("nan") if v == "-" else float(v))
            m = MDL_RE.search(line)
            if m:
                md = m.group(1).split()
                for k in range(NUM_CH):
                    abc = md[3 * k:3 * k + 3]
                    if len(abc) == 3 and "-" not in abc:
                        a_, b_, c_ = (float(v) for v in abc)
                        self.model[k] = (a_, b_, c_)
                        if 0 < a_ < 0.9999:
                            tau = -LOOP_S / math.log(a_)
                            gain = b_ / (1 - a_) * 100
                            self.mdl_labels[k].config(
                                text=f"model: τ {tau:.1f}s, +{gain:.0f}°C@100%")
                    else:
                        self.model[k] = None
                        self.mdl_labels[k].config(text="model: not learned")
            m = LRN_RE.search(line)
            if m:
                lr = m.group(1).split()
                for k in range(min(NUM_CH, len(lr))):
                    on = lr[k] != "-"
                    self.learning[k] = on
                    self.learn_btns[k].config(text="Stop + save" if on else "Learn model")
                    if on:
                        self.mdl_labels[k].config(
                            text=f"learning… {lr[k]}/{LEARN_NEEDED}")
            m = OUT_RE.search(line)
            if m:
                outs = m.group(1).split()
                for k in range(min(NUM_CH, len(outs))):
                    self.last_out[k] = float(outs[k])
                    self.out_labels[k].config(text=f"PWM: {float(outs[k]):.1f} %")
                    if self.auto_state[k]:  # show what the PID is driving
                        self.pct_vars[k].set(round(float(outs[k])))
        elif line.startswith(("OK", "ERR")):
            self.status.set(line)

    def tick(self):
        try:
            while True:
                kind, payload = self.rx_queue.get_nowait()
                if kind == "line":
                    self.handle_line(payload)
                else:
                    self.status.set(f"Serial error: {payload}")
                    self.disconnect()
        except queue.Empty:
            pass
        self.redraw()
        self.root.after(200, self.tick)

    def redraw(self):
        if not self.times:
            return
        try:
            win = max(10, int(self.window_var.get()))
        except (tk.TclError, ValueError):
            win = 120
        tmax = self.times[-1]
        tmin = max(0, tmax - win)
        # drop data well outside the window to bound memory
        while len(self.times) > 1 and self.times[0] < tmin - win:
            self.times.pop(0)
            for t in self.temps + self.preds:
                t.pop(0)
        for k, ln in enumerate(self.lines):
            ln.set_data(self.times, self.temps[k])
            self.pred_lines[k].set_data(self.times, self.preds[k])
        try:
            horizon = max(0.0, float(self.forecast_var.get()))
        except ValueError:
            horizon = 0.0
        fc_vals = []
        for k, ln in enumerate(self.fc_lines):
            temp_now = self.temps[k][-1] if self.temps[k] else float("nan")
            if horizon <= 0 or self.model[k] is None or temp_now != temp_now:
                ln.set_data([], [])
                continue
            a_, b_, c_ = self.model[k]
            x = (temp_now - 25.0) / 100.0
            u = self.last_out[k] / 100.0
            ts, ys = [tmax], [temp_now]
            for j in range(1, int(horizon / LOOP_S) + 1):
                x = a_ * x + b_ * u + c_
                ts.append(tmax + j * LOOP_S)
                ys.append(x * 100.0 + 25.0)
            ln.set_data(ts, ys)
            fc_vals.extend(ys)
        self.now_line.set_xdata([tmax, tmax])
        self.ax.set_xlim(tmin, max(tmax + horizon, tmin + 10))
        sps = []
        for k, ln in enumerate(self.sp_lines):
            if self.auto_state[k]:
                try:
                    sp = float(self.sp_vars[k].get())
                except ValueError:
                    sp = None
            else:
                sp = None
            if sp is None:
                ln.set_data([], [])
            else:
                ln.set_data([tmin, tmax], [sp, sp])
                sps.append(sp)
        vis = sps + fc_vals + [v for t in self.temps + self.preds for tt, v in zip(self.times, t)
               if tt >= tmin and v == v]
        if vis:
            lo, hi = min(vis), max(vis)
            pad = max(2.0, (hi - lo) * 0.1)
            self.ax.set_ylim(lo - pad, hi + pad)
        self.canvas.draw_idle()

    def on_close(self):
        if self.ser:
            self.disconnect()
        self.root.destroy()


if __name__ == "__main__":
    root = tk.Tk()
    App(root)
    root.mainloop()
