#!/usr/bin/env python3
"""
Data gathering + R(T) prediction check for the ESP board (esp_board/ in this folder). One file, no thermocouple.
The pulse and the PIDs are in PWM: the IR and resistance PIDs output a PWM %. The firmware also has a power PID input
(2, mW): its column stays in the control box for manual use, the tests do not use it.

"Gather data" (needs a serial no.):
  0-3 s    heater R0_PWM = 1 % PWM: R0 = mean R of the last second
  3-5 s    heater PULSE_PWM = 100 % PWM for 2 s: measure dR/dt and the mean power P (mW)
  then     IR PID holds 50, 60 and 70 C for 20 s each; actual R(T) = mean R of the last 5 s of each hold
then one row is appended to output/gather_data_pwm.csv and the time-series CSV + png of the run are saved. No prediction is made.

"Set to [temp] C" + Go runs R0 + pulse + prediction, then holds the predicted resistance for 20 s with the
resistance PID: no IR, nothing recorded, heater off at the end.
"Go, then hold P" does the same for 3 s, averages the power of the last 1 s, then holds that power with the power PID for 5 s.

Prediction (Set to only): ln fits of R against x = dR/dt * R0 / P, joined linearly in real T:
  R(T) = (100.99 + 0.02436 T) * ln(x) + (-319.30 + 5.727 T), T = (R - 100.99 ln(x) + 319.30) / (0.02436 ln(x) + 5.727)
The temperature panel shows this predicted T (dashed) from the live resistance once the pulse has set x; it uses no IR.
These constants were measured with exactly this protocol (5 % PWM R0, 100 % PWM pulse, P = mean measured pulse power).

IR temperature: real = 1.288 * IR_sensor - 7.89 (R2 0.995) is applied to every IR reading (readout, plot, CSV); the IR
setpoint typed here is real C and converted back to the sensor scale before it goes to the board (whose PID runs on the raw sensor).

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
from tkinter import messagebox, ttk

import serial
import serial.tools.list_ports
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

BAUD = 115200
NAN = float("nan")
UPDATE_MS = 200
HERE = os.path.dirname(os.path.abspath(__file__))
OUT_DIR = os.path.join(HERE, "output")
SETTINGS = os.path.join(HERE, "gui_test_settings.json")
DATA_CSV = os.path.join(OUT_DIR, "gather_data_pwm.csv")  # not gather_data.csv: that one has the constant-power columns
IR_TEMPS = (50.0, 60.0, 70.0)  # real C, held in this order by Gather data
DATA_HEADER = ["sample", "dR_dt_ohm_s", "pulse_pwm_pct", "initial_resistance_ohm", "pulse_power_measured_mW",
               *(f"actual_R{t:g}_ohm" for t in IR_TEMPS)]
CSV_HEADER = ["serial_number", "time_s", "timestamp", "ir_C", "resistance_ohm", "voltage_V", "current_mA",
              "power_mW", "pwm_pct", "pid_auto", "pid_input"]
SRC = {"ir": 0, "res": 1, "pow": 2}  # PID inputs in the firmware
SRC_NAMES = ["IR temp (°C)", "Resistance (Ω)", "Power (mW)"]
SRC_DEFAULTS = [("0", "5", "0.05", "0"), ("0", "0.5", "0", "0"), ("0", "0.3", "0.5", "0")]  # SP, Kp, Ki, Kd

T_R0, T_PULSE, T_RHOLD, T_IR = 3.0, 2.0, 20.0, 20.0  # phase lengths (s); T_RHOLD is for Set to only
R0_PWM = 1.0      # R0 is read at this PWM %
PULSE_PWM = 100.0  # PWM % of the dR/dt pulse; P in x = dR/dt * R0 / P is the mean measured power over it
T_RH_P, T_PH = 3.0, 5.0  # Hold P button: resistance hold, then constant-power hold (s)
T_AVG = 5.0  # actual R = mean over the last T_AVG s of each IR hold
R_OK = (200.0, 800.0)  # sanity band for the predicted resistance (ohm)
SET_RANGE = (30.0, 80.0)  # allowed temperatures for "Set to" (C)

# R = a(T) ln(x) + b(T), T in real C: the fits at real 69.39 and 82.27 C joined linearly in T (data only between those)
A0, A1, B0, B1 = 100.9887, 0.024363, -319.2978, 5.72745
IR_GAIN, IR_OFFSET = 1.288, -7.89  # real C = IR_GAIN * sensor + IR_OFFSET


def ir_real(sensor):
    return IR_GAIN * sensor + IR_OFFSET


def ir_sensor(real):
    return (real - IR_OFFSET) / IR_GAIN


def predict_r(temp, drdt, r0, p_mw):
    return (A0 + A1 * temp) * math.log(drdt * r0 / p_mw) + B0 + B1 * temp


def predict_temp(r, x):  # x = dR/dt * R0 / P of the pulse
    lx = math.log(x)
    return (r - A0 * lx - B0) / (A1 * lx + B1)


def parse_data(line):
    """'DATA ms V mA mW ohm amb ir pwm auto src' -> dict (ir already in real C), or None."""
    f = line.split()
    if len(f) != 11 or f[0] != "DATA":
        return None
    try:
        v = [float(x) for x in f[1:]]  # float() accepts 'nan' / '-nan'
    except ValueError:
        return None
    return dict(volt=v[1], ma=v[2], mw=v[3], ohm=v[4], amb=v[5], ir=ir_real(v[6]), pwm=v[7],
                auto=int(v[8]), src=int(v[9]))


def pulse_features(rows):
    """Log rows inside the pulse -> (dR/dt ohm/s, first R ohm, mean power mW); None if unusable."""
    pts = [(float(r[0]), r[3]) for r in rows if math.isfinite(r[3])]
    if len(pts) < 5 or pts[-1][0] - pts[0][0] < 1.0:
        return None
    n = len(pts)
    tm, rm = sum(t for t, _ in pts) / n, sum(r for _, r in pts) / n
    slope = sum((t - tm) * (r - rm) for t, r in pts) / sum((t - tm) ** 2 for t, _ in pts)
    p = sum(r[6] for r in rows) / len(rows)  # power column, mW
    return slope, pts[0][1], p


def mean(vals):
    vals = [v for v in vals if math.isfinite(v)]
    return sum(vals) / len(vals) if vals else float("nan")


# log rows: [time_s, timestamp, ir, ohm, volt, mA, mW, pwm, auto, src] (without the serial number)
class App:
    def __init__(self, root):
        self.root = root
        root.title("Power-controlled data gathering: R(T)")
        root.geometry("1300x900")
        self.ser = None
        self.stop_reader = threading.Event()
        self.rx = queue.Queue()
        self.t0 = time.time()
        self.times, self.ir, self.res, self.pwm, self.pw = [], [], [], [], []
        self.log = []  # full history for the CSV (the plot lists get trimmed)
        self.cfg = self.load_settings()
        self.test = None  # running test: {"phase", "set", ...}
        self.x_pulse = None  # dR/dt * R0 / P of the running test, set when the pulse ends

        self._build_top()
        self._build_readouts()
        self.mid = ttk.Frame(root)
        self.mid.pack(fill="both", expand=True)
        self._build_results()
        self._build_plot()
        self._build_control()
        self._build_test_bar()
        self.status = tk.StringVar(value="Disconnected")
        ttk.Label(root, textvariable=self.status, anchor="w").pack(fill="x", padx=8, pady=(0, 4))

        self.refresh_ports()
        self.root.after(UPDATE_MS, self.tick)
        root.protocol("WM_DELETE_WINDOW", self.on_close)

    # ---------- UI ----------
    def _build_top(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8, pady=6)
        ttk.Label(f, text="ESP board:").pack(side="left", padx=(0, 2))
        self.port_var = tk.StringVar()
        self.port_box = ttk.Combobox(f, textvariable=self.port_var, width=16)
        self.port_box.pack(side="left", padx=2)
        self.conn_btn = ttk.Button(f, text="Connect", command=self.toggle)
        self.conn_btn.pack(side="left", padx=(2, 14))
        ttk.Button(f, text="Refresh", command=self.refresh_ports).pack(side="left")
        ttk.Label(f, text="Window (s):").pack(side="left", padx=(14, 2))
        self.window_var = tk.IntVar(value=self.cfg.get("window", 120))
        ttk.Spinbox(f, from_=10, to=3600, increment=10, width=6, textvariable=self.window_var).pack(side="left")
        ttk.Button(f, text="Clear graph", command=self.clear_data).pack(side="left", padx=10)
        ttk.Label(f, text="Serial no.:").pack(side="left", padx=(4, 2))
        self.serial_var = tk.StringVar(value=self.cfg.get("serial", ""))
        ttk.Entry(f, textvariable=self.serial_var, width=14).pack(side="left", padx=(0, 6))
        ttk.Button(f, text="Save CSV + screenshot", command=self.save_outputs).pack(side="left")

    def _build_readouts(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8)
        self.read_lbl = {}
        for key, title in (("ir", "IR temp"), ("res", "Resistance"), ("volt", "Voltage"), ("cur", "Current"),
                           ("pow", "Power"), ("pwm", "PWM")):
            box = ttk.LabelFrame(f, text=title)
            box.pack(side="left", expand=True, fill="x", padx=4)
            lbl = ttk.Label(box, text="--", font=("TkDefaultFont", 20, "bold"), anchor="center")
            lbl.pack(fill="x", padx=6, pady=2)
            self.read_lbl[key] = lbl

    def _build_results(self):
        w = ttk.LabelFrame(self.mid, text="Results")
        w.pack(side="right", fill="y", padx=(4, 8), pady=4)
        self.result_text = tk.Text(w, wrap="word", width=38, state="disabled", font=("TkFixedFont", 10))
        self.result_text.pack(fill="both", expand=True, padx=6, pady=6)

    def _build_plot(self):
        self.fig = Figure(figsize=(8, 7), dpi=100)
        self.ax_t, self.ax_r, self.ax_p, self.ax_w = self.fig.subplots(4, 1, sharex=True)
        for ax, lab in ((self.ax_t, "Temp (°C)"), (self.ax_r, "Resistance (Ω)"), (self.ax_p, "PWM (%)"),
                        (self.ax_w, "Power (mW)")):
            ax.set_ylabel(lab)
            ax.grid(True, alpha=0.3)
        self.ax_w.set_xlabel("Time (s)")
        self.ax_p.set_ylim(-5, 105)
        for ax in (self.ax_t, self.ax_r, self.ax_p):
            ax.tick_params(labelbottom=False)
        self.ln_ir, = self.ax_t.plot([], [], color="#e6194b", label="IR")
        self.ln_pt, = self.ax_t.plot([], [], color="#911eb4", ls="--", label="Predicted T (from R)")
        self.ln_sp_t, = self.ax_t.plot([], [], "k--", alpha=0.6, label="Setpoint")
        self.ln_res, = self.ax_r.plot([], [], color="#3cb44b")
        self.ln_sp_r, = self.ax_r.plot([], [], "k--", alpha=0.6)
        self.ln_pwm, = self.ax_p.plot([], [], color="#f58231")
        self.ln_pw, = self.ax_w.plot([], [], color="#42d4f4")
        self.ln_sp_w, = self.ax_w.plot([], [], "k--", alpha=0.6)
        self.ax_t.legend(loc="upper left", bbox_to_anchor=(1.01, 1.0), borderaxespad=0, fontsize=8)
        self.fig.subplots_adjust(left=0.09, right=0.80, top=0.97, bottom=0.07, hspace=0.12)
        self.canvas = FigureCanvasTkAgg(self.fig, master=self.mid)
        self.canvas.get_tk_widget().pack(side="left", fill="both", expand=True, padx=(8, 4))

    def _build_control(self):
        box = ttk.LabelFrame(self.root, text="Heater control (ESP board)")
        box.pack(fill="x", padx=8, pady=6)
        self.src_var = tk.IntVar(value=self.cfg.get("src", 0))
        self.auto_var = tk.BooleanVar(value=False)
        self.sp_vars, self.gain_vars = [], []
        saved = self.cfg.get("inputs", [])
        for s in range(len(SRC_NAMES)):
            col = ttk.Frame(box)
            col.pack(side="left", padx=10, pady=4)
            ttk.Radiobutton(col, text=f"PID input: {SRC_NAMES[s]}", variable=self.src_var,
                            value=s, command=self.send_src).grid(row=0, column=0, columnspan=2)
            vals = saved[s] if len(saved) == len(SRC_NAMES) and len(saved[s]) == 4 else SRC_DEFAULTS[s]
            vs = []
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
        ttk.Checkbutton(side, text="Enable PID", variable=self.auto_var, command=self.toggle_auto).pack()
        ttk.Button(side, text="Apply PID (all inputs)", command=self.push_config).pack(pady=2)
        ttk.Button(side, text="ALL OFF", command=self.all_off).pack(pady=2)

    def _build_test_bar(self):
        f = ttk.Frame(self.root)
        f.pack(fill="x", padx=8, pady=(0, 6))
        ttk.Button(f, text="Gather data", command=self.start_test).pack(side="left")
        self.set_var = tk.StringVar(value="60")
        ttk.Label(f, text="Set to").pack(side="left", padx=(10, 2))
        ttk.Entry(f, textvariable=self.set_var, width=5).pack(side="left")
        ttk.Button(f, text="°C  Go", command=self.start_set).pack(side="left", padx=(2, 0))
        ttk.Button(f, text="°C  Go, then hold P", command=lambda: self.start_set(True)).pack(side="left", padx=(6, 0))
        self.test_var = tk.StringVar(value="Idle (ALL OFF aborts a run)")
        ttk.Label(f, textvariable=self.test_var).pack(side="left", padx=10)

    def note(self, text):
        self.result_text.config(state="normal")
        self.result_text.insert("end", text + "\n")
        self.result_text.see("end")
        self.result_text.config(state="disabled")

    # ---------- serial ----------
    def refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_box["values"] = ports
        if not self.port_var.get():
            self.port_var.set(self.cfg.get("port") or (ports[0] if ports else ""))

    def toggle(self):
        if self.ser:
            self.disconnect()
            return
        port = self.port_var.get().strip()
        if not port:
            messagebox.showerror("Error", "Select a serial port")
            return
        try:
            s = serial.Serial()  # DTR/RTS low so opening the port doesn't reset the board
            s.port, s.baudrate, s.timeout = port, BAUD, 0.2
            s.dtr = s.rts = False
            s.open()
        except (serial.SerialException, OSError) as e:
            messagebox.showerror("Connection failed", str(e))
            return
        self.ser = s
        self.stop_reader.clear()
        threading.Thread(target=self.reader, args=(s,), daemon=True).start()
        self.conn_btn.config(text="Disconnect")
        self.status.set(f"Connected to {port}")
        self.clear_data()
        self.root.after(500, self.push_config)  # board forgets settings on reset

    def disconnect(self):
        self.send("auto 0")
        self.send("pwm 0")  # fail safe: heater off
        self.auto_var.set(False)
        time.sleep(0.05)
        self.stop_reader.set()
        try:
            self.ser.close()
        except Exception:
            pass
        self.ser = None
        self.conn_btn.config(text="Connect")
        self.status.set("Disconnected")

    def reader(self, s):
        buf = b""
        while not self.stop_reader.is_set():
            try:
                chunk = s.read(256)
            except Exception as e:
                self.rx.put(("error", str(e)))
                return
            buf += chunk
            while b"\n" in buf:
                line, buf = buf.split(b"\n", 1)
                self.rx.put(("line", line.decode(errors="replace").strip()))

    def send(self, text):
        if not self.ser:
            self.status.set("ESP board not connected - command not sent")
            return False
        if text.startswith("sp 0 "):  # the IR setpoint is typed in real C, the board's PID runs on the raw sensor
            try:
                text = f"sp 0 {ir_sensor(float(text.split()[2])):g}"
            except (ValueError, IndexError):
                pass
        try:
            self.ser.write((text + "\n").encode())
            return True
        except Exception as e:
            self.status.set(f"Send failed: {e}")
            return False

    # ---------- commands ----------
    def push_config(self):
        """Validate and send SP + gains of all inputs, then the active input."""
        try:
            cfg = [(float(self.sp_vars[s].get()), *(float(v.get()) for v in self.gain_vars[s]))
                   for s in range(len(SRC_NAMES))]
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
            self.abort_test("PID unticked")
            self.send("auto 0")

    def all_off(self):
        self.abort_test("ALL OFF")
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")

    def set_pwm(self, pct):  # fixed PWM %, PID off
        self.auto_var.set(False)
        self.send("auto 0")
        self.send(f"pwm {pct:g}")

    def hold(self, kind, target):  # PID on one input at a setpoint; kind: ir | res | pow
        s = SRC[kind]
        self.sp_vars[s].set(f"{target:g}")
        self.src_var.set(s)
        self.send(f"sp {s} {target:g}")
        self.send(f"src {s}")
        self.send("auto 1")
        self.auto_var.set(True)

    # ---------- test ----------
    def start_set(self, hold_p=False):
        try:
            temp = float(self.set_var.get())
        except ValueError:
            temp = float("nan")
        if not SET_RANGE[0] <= temp <= SET_RANGE[1]:
            messagebox.showerror("Set to", f"Enter a temperature from {SET_RANGE[0]:g} to {SET_RANGE[1]:g} C")
            return
        self.start_test(temp, hold_p)

    def start_test(self, set_temp=None, hold_p=False):  # set_temp: just hold that temperature, no IR, no recording
        if not self.ser:
            messagebox.showerror("Test", "Connect the ESP board first")
            return
        if set_temp is None and not self.serial_var.get().strip():
            messagebox.showerror("Test", "Enter the serial no. (sample name)")
            return
        if self.test is not None:
            messagebox.showerror("Test", "A test is already running")
            return
        if not self.push_config():  # gains / setpoints for all inputs
            return
        self.x_pulse = None
        self.clear_data()  # time 0 = start of the low-PWM R0 read
        self.set_pwm(R0_PWM)
        name = f"set {set_temp:g} C" if set_temp is not None else self.serial_var.get().strip()
        self.note(f"--- {name}  {datetime.now():%H:%M:%S} ---")
        self.test = {"phase": "r0", "set": set_temp, "hold_p": hold_p, "rlen": T_RH_P if hold_p else T_RHOLD}

    def rows(self, lo, hi):
        return [r for r in self.log if lo <= float(r[0]) < hi]

    def abort_test(self, why):
        if self.test is None:
            return
        self.test = None
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")
        self.test_var.set(f"Aborted ({why}), heater off")
        self.note(f"aborted: {why}\n")

    def run_test(self):
        t = self.test
        if t is None:
            return
        if not self.ser:
            self.abort_test("ESP disconnected")
            return
        now = time.time() - self.t0
        self.test_var.set(f"{t['phase']} ({now:.0f} s)")
        if t["phase"] == "r0" and now >= T_R0:
            r0 = mean([r[3] for r in self.rows(T_R0 - 1, T_R0)])
            if not r0 > 0:
                self.abort_test(f"no resistance reading at {R0_PWM:g} % PWM")
                return
            t.update(phase="pulse", r0=r0)
            self.set_pwm(PULSE_PWM)
        elif t["phase"] == "pulse" and now >= T_R0 + T_PULSE:
            feat = pulse_features(self.rows(T_R0, T_R0 + T_PULSE))
            if feat is None or feat[0] <= 0:
                self.abort_test("no usable resistance data in the pulse")
                return
            drdt, _, p = feat  # p: mean measured power over the pulse
            r0 = t["r0"]  # read at the R0 PWM, not the first pulse sample
            self.x_pulse = drdt * r0 / p
            t.update(drdt=drdt, p=p)
            self.note(f"dR/dt        {drdt:8.2f} ohm/s\nR0           {r0:8.2f} ohm\n"
                      f"Power @{PULSE_PWM:g}%   {p:8.1f} mW\ndR/dt*R0/P   {self.x_pulse:8.2f}")
            if t["set"] is None:  # Gather data: straight to the IR holds
                t.update(phase="ir", k=0, actual=[])
                self.set_ir(IR_TEMPS[0], T_IR)
                return
            pred = predict_r(t["set"], drdt, r0, p)
            if not R_OK[0] < pred < R_OK[1]:
                self.abort_test(f"predicted R {pred:.0f} ohm is outside {R_OK}")
                return
            t.update(phase="rhold", pred=pred)
            self.note(f"Predicted R @{t['set']:g}C {pred:5.1f} ohm\nholding R for {t['rlen']:.0f} s ...")
            self.hold("res", pred)
        elif t["phase"] == "rhold" and t["hold_p"] and now >= T_R0 + T_PULSE + t["rlen"]:
            p_hold = mean([r[6] for r in self.rows(now - 1, now)])  # power over the last 1 s of the R hold
            if not p_hold > 0:
                self.abort_test("no power reading in the R hold")
                return
            t.update(phase="phold", p_hold=p_hold, t_ph=now)
            self.note(f"Power @R hold  {p_hold:7.1f} mW\nholding that power for {T_PH:.0f} s ...")
            self.hold("pow", p_hold)
        elif t["phase"] == "phold" and now >= t["t_ph"] + T_PH:
            self.test = None
            self.auto_var.set(False)
            self.send("auto 0")
            self.send("pwm 0")
            self.note("done, heater off\n")
            self.test_var.set(f"Hold P {t['p_hold']:.0f} mW: done, heater off")
        elif t["phase"] == "rhold" and now >= T_R0 + T_PULSE + t["rlen"]:  # Set to: done
            self.test = None
            self.auto_var.set(False)
            self.send("auto 0")
            self.send("pwm 0")
            self.note("done, heater off\n")
            self.test_var.set(f"Set to {t['set']:g} C: done, heater off")
        elif t["phase"] == "ir" and now >= T_R0 + T_PULSE + (t["k"] + 1) * T_IR:
            r = mean([r[3] for r in self.rows(now - T_AVG, now)])
            t["actual"].append(r)
            self.note(f"Actual R{IR_TEMPS[t['k']]:g}      {r:7.1f} ohm")
            t["k"] += 1
            if t["k"] < len(IR_TEMPS):
                self.set_ir(IR_TEMPS[t["k"]], T_IR)
            else:
                self.finish_test()

    def set_ir(self, target, secs):  # target in real C
        self.note(f"holding IR {target:g} C for {secs:.0f} s ...")
        self.hold("ir", target)

    def finish_test(self):
        t, self.test = self.test, None
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")
        os.makedirs(OUT_DIR, exist_ok=True)
        new = not os.path.exists(DATA_CSV)
        with open(DATA_CSV, "a", newline="") as f:
            w = csv.writer(f)
            if new:
                w.writerow(DATA_HEADER)
            w.writerow([self.serial_var.get().strip(), f"{t['drdt']:.4f}", f"{PULSE_PWM:g}", f"{t['r0']:.3f}",
                        f"{t['p']:.1f}", *(f"{r:.3f}" for r in t["actual"])])
        self.save_outputs()
        self.note("")
        self.test_var.set("Gather data done: " + ", ".join(f"R{T:g} {r:.1f}" for T, r in zip(IR_TEMPS, t["actual"])) + " ohm")

    # ---------- data ----------
    def clear_data(self):
        self.t0 = time.time()
        for a in (self.times, self.ir, self.res, self.pwm, self.pw, self.log):
            a.clear()

    def handle(self, line):
        d = parse_data(line)
        if d is None:
            if line.startswith(("OK", "ERR")):
                self.status.set(line)
            return
        self.times.append(time.time() - self.t0)
        self.ir.append(d["ir"])
        self.res.append(d["ohm"])
        self.pwm.append(d["pwm"])
        self.pw.append(d["mw"])
        self.auto_var.set(bool(d["auto"]))  # board drops to manual if the PC goes quiet
        self.log.append([f"{self.times[-1]:.1f}", datetime.now().isoformat(timespec="seconds"),
                         d["ir"], d["ohm"], d["volt"], d["ma"], d["mw"], d["pwm"], d["auto"], d["src"]])
        self.read_lbl["ir"].config(text=f"{d['ir']:.2f} °C")
        self.read_lbl["res"].config(text=f"{d['ohm']:.2f} Ω")
        self.read_lbl["volt"].config(text=f"{d['volt']:.3f} V")
        self.read_lbl["cur"].config(text=f"{d['ma']:.2f} mA")
        self.read_lbl["pow"].config(text=f"{d['mw']:.1f} mW")
        self.read_lbl["pwm"].config(text=f"{d['pwm']:.1f} %")

    def tick(self):
        try:
            while True:
                kind, payload = self.rx.get_nowait()
                if kind == "line":
                    self.handle(payload)
                else:
                    self.status.set(f"serial error: {payload}")
                    self.disconnect()
        except queue.Empty:
            pass
        self.run_test()
        if self.ser:
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
            for a in (self.times, self.ir, self.res, self.pwm, self.pw):
                a.pop(0)
        self.ln_ir.set_data(self.times, self.ir)
        self.ln_res.set_data(self.times, self.res)
        self.ln_pwm.set_data(self.times, self.pwm)
        self.ln_pw.set_data(self.times, self.pw)
        if self.x_pulse:  # predicted T from the live resistance, once the pulse has set x
            pts = [(t, predict_temp(r, self.x_pulse)) for t, r in zip(self.times, self.res)
                   if t >= T_R0 + T_PULSE and math.isfinite(r) and r > 0]
            self.ln_pt.set_data([p[0] for p in pts], [p[1] for p in pts])
        else:
            self.ln_pt.set_data([], [])

        # setpoint line only while the PID is running on that input
        s = self.src_var.get()
        try:
            sp = float(self.sp_vars[s].get()) if self.auto_var.get() else None
        except ValueError:
            sp = None
        line = ([tmin, tmax], [sp, sp]) if sp is not None else ([], [])
        for ln, idx in ((self.ln_sp_t, 0), (self.ln_sp_r, 1), (self.ln_sp_w, 2)):
            ln.set_data(*(line if s == idx else ([], [])))

        i0 = next((i for i, t in enumerate(self.times) if t >= tmin), 0)
        pt_y = [y for t, y in zip(*self.ln_pt.get_data()) if t >= tmin]
        for ax, idx, series in ((self.ax_t, 0, [self.ir[i0:], pt_y]), (self.ax_r, 1, [self.res[i0:]]),
                                (self.ax_w, 2, [self.pw[i0:]])):
            vis = [v for ser in series for v in ser if math.isfinite(v)] + ([sp] if sp is not None and s == idx else [])
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
            data = {"port": self.port_var.get(), "src": self.src_var.get(), "serial": self.serial_var.get(),
                    "window": self.window_var.get(),
                    "inputs": [[self.sp_vars[s].get(), *(v.get() for v in self.gain_vars[s])]
                               for s in range(len(SRC_NAMES))]}
            with open(SETTINGS, "w") as f:
                json.dump(data, f, indent=1)
        except (OSError, tk.TclError):
            pass  # settings are a convenience; never block the GUI

    def on_close(self):
        self.abort_test("window closed")
        self.save_settings()
        if self.ser:
            self.disconnect()
        self.root.destroy()


if __name__ == "__main__":
    assert parse_data("DATA 1000 12.000 80.0 960.0 150.00 24.00 31.50 25.5 1 2")["ohm"] == 150.0
    assert abs(parse_data("DATA 1 0.0 0.0 0.0 nan 24.0 60.0 0.0 0 0")["ir"] - 69.39) < 1e-9
    assert parse_data("garbage") is None
    # synthetic pulse: R rises 100 ohm/s from 300 ohm, 300 mW
    rows = [[f"{i * 0.2:.1f}", "", 30, 300 + 100 * i * 0.2, 10.0, 30.0, 300.0, 100, 0, 2] for i in range(10)]
    s, r0, p = pulse_features(rows)
    assert abs(s - 100) < 1e-6 and r0 == 300 and abs(p - 300) < 1e-9
    assert abs(predict_r(ir_real(60), 100, 300, 300) - (102.68 * math.log(100) + 78.13)) < 0.05
    assert abs(predict_r(ir_real(70), 100, 300, 300) - (102.99 * math.log(100) + 151.90)) < 0.05
    assert abs(ir_real(ir_sensor(45.0)) - 45.0) < 1e-9
    assert abs(predict_temp(predict_r(65, 100, 300, 300), 100) - 65) < 1e-9  # inverse
    assert pulse_features(rows[:3]) is None and math.isnan(mean([float("nan")]))
    root = tk.Tk()
    App(root)
    root.mainloop()
