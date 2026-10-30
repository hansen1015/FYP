#!/usr/bin/env python3
"""
gui.py plus a "Start prediction test" button that tests the R(60 C) prediction:

  0-3 s    heater 5 % PWM: start resistance R0 = mean R of the last second
  3-5 s    heater 100 % PWM: measure dR/dt and the mean power P (mW)
  5-25 s   resistance PID holds the predicted R(60 C); the IR is recorded at the end
  25-45 s  IR PID holds 60 C; actual R(60 C) = mean R of the last 5 s
  45-65 s  IR PID holds 70 C; actual R(70 C) = mean R of the last 5 s

then one row is appended to output/prediction.csv. The usual time-series CSV + png are saved too.
Prediction (ln fits of before + after recovery data, actual R at 60 / 70 C against x = dR/dt * R0 / P):
  R60 = 102.7 * ln(x) + 78.1,  R70 = 103.0 * ln(x) + 151.9; in between they are interpolated linearly:
  R(T) = (100.9 + 0.03 T) * ln(x) + (-364.7 + 7.38 T), so the temperature of any resistance is
  T = (R - 100.9 ln(x) + 364.7) / (0.03 ln(x) + 7.38). The plot's temperature panel shows this predicted T
  (dashed) from the live resistance once the pulse has set x; it uses no IR.
The "Set to [temp] C" box (30-80 C) + Go runs R0 + pulse + prediction, then hold the predicted
resistance for 20 s with the resistance PID: no IR, nothing recorded, heater off at the end. The thermocouple board is not used (no port, readout or plot line).

IR temperature: real = 1.288 * IR_sensor - 7.89 (R2 0.995) is applied to every IR reading (readout, plot, CSV) and the
IR setpoint typed in the GUI is real C, converted back to the sensor scale before it goes to the board (the board's
PID still runs on the raw sensor). The R(60/70 C) fits were measured at raw sensor 60 / 70 (= real 69.4 / 82.2 C), so
the model's temperatures are on the sensor scale: "Set to" and the predicted-T line convert real <-> sensor, and the
test's two IR holds stay at sensor 60 / 70 so prediction.csv keeps comparing like with like.
"""

import csv
import math
import os
import time
from datetime import datetime
from tkinter import messagebox, ttk
import tkinter as tk

import gui
from gui import App

gui.SETTINGS = os.path.join(gui.HERE, "gui_test_settings.json")  # keep gui.py's own settings untouched
PRED_CSV = os.path.join(gui.OUT_DIR, "prediction.csv")
PRED_HEADER = ["sample", "dR_dt_ohm_s", "power_at_100pct_pwm_mW", "initial_resistance_ohm",
               "predicted_R60_ohm", "actual_R60_ohm", "actual_R70_ohm", "ir_at_predicted_R_C"]
T_R0, T_PULSE, T_RHOLD, T_IR60, T_IR70 = 3.0, 2.0, 20.0, 20.0, 20.0  # phase lengths (s); R0 is read at R0_PWM
R0_PWM = 5
T_AVG = 5.0  # actual R60 / R70 = mean over the last T_AVG s of each IR hold
R_OK = (200.0, 800.0)  # sanity band for the predicted resistance (ohm)
# log rows from gui.py: [time_s, timestamp, ir, tc, ohm, volt, mA, pwm, auto, src]


# R = a(T) ln(x) + b(T): the 60 C and 70 C fits joined linearly in T (valid about 40-90 C, outside that is extrapolation)
A0, A1, B0, B1 = 100.9, 0.03, -364.7, 7.38
IR_GAIN, IR_OFFSET = 1.288, -7.89  # real C = IR_GAIN * sensor + IR_OFFSET


def ir_real(sensor):
    return IR_GAIN * sensor + IR_OFFSET


def ir_sensor(real):
    return (real - IR_OFFSET) / IR_GAIN


_parse_data = gui.parse_data


def parse_data_real(line):  # gui.py's reader calls gui.parse_data: correct the IR value once, here
    d = _parse_data(line)
    if d is not None:
        d["ir"] = ir_real(d["ir"])
    return d


gui.parse_data = parse_data_real
SET_RANGE = (30.0, 80.0)  # allowed temperatures for "Set to" (C)


def predict_r(temp, drdt, r0, p_mw):
    return (A0 + A1 * temp) * math.log(drdt * r0 / p_mw) + B0 + B1 * temp


def predict_temp(r, x):  # x = dR/dt * R0 / P of the pulse
    lx = math.log(x)
    return (r - A0 * lx - B0) / (A1 * lx + B1)


def pulse_features(rows):
    """Rows inside the 100 % pulse -> (dR/dt ohm/s, R0 ohm, mean power mW); None if unusable."""
    pts = [(float(r[0]), r[4]) for r in rows if math.isfinite(r[4])]
    if len(pts) < 5 or pts[-1][0] - pts[0][0] < 1.0:
        return None
    n = len(pts)
    tm, rm = sum(t for t, _ in pts) / n, sum(r for _, r in pts) / n
    slope = sum((t - tm) * (r - rm) for t, r in pts) / sum((t - tm) ** 2 for t, _ in pts)
    p = sum(r[5] * r[6] for r in rows) / len(rows)  # V * mA = mW
    return slope, pts[0][1], p


def mean(vals):
    vals = [v for v in vals if math.isfinite(v)]
    return sum(vals) / len(vals) if vals else float("nan")


class TestApp(App):
    MANUAL_PWM = False
    USE_TC = False

    def send(self, text):  # the IR setpoint is typed in real C, the board's PID runs on the raw sensor
        if text.startswith("sp 0 "):
            try:
                text = f"sp 0 {ir_sensor(float(text.split()[2])):g}"
            except (ValueError, IndexError):
                pass
        return super().send(text)

    def _build_plot(self):
        super()._build_plot()
        self.x_pulse = None  # dR/dt * R0 / P of the running test, set when the pulse ends
        self.ln_pt, = self.ax_t.plot([], [], color="#911eb4", ls="--", label="Predicted T (from R)")
        self.ax_t.legend(loc="upper left", bbox_to_anchor=(1.01, 1.0), borderaxespad=0, fontsize=8)

    def redraw(self):
        if self.x_pulse and self.times:
            pts = [(t, ir_real(predict_temp(r, self.x_pulse))) for t, r in zip(self.times, self.res)
                   if t >= T_R0 + T_PULSE and math.isfinite(r) and r > 0]
            self.ln_pt.set_data([p[0] for p in pts], [p[1] for p in pts])
        else:
            self.ln_pt.set_data([], [])
        super().redraw()
        lo, hi = self.ax_t.get_ylim()
        xmin = self.ax_p.get_xlim()[0]
        vis = [v for t, v in zip(*self.ln_pt.get_data()) if t >= xmin and math.isfinite(v)] if self.x_pulse else []
        if vis:
            self.ax_t.set_ylim(min(lo, min(vis) - 1), max(hi, max(vis) + 1))

    def _build_script_editor(self):  # replaces gui.py's script editor with a results box
        w = ttk.LabelFrame(self.mid, text="Prediction results")
        w.pack(side="right", fill="y", padx=(4, 8), pady=4)
        self.result_text = tk.Text(w, wrap="word", width=38, state="disabled", font=("TkFixedFont", 10))
        self.result_text.pack(fill="both", expand=True, padx=6, pady=6)
        self.script_text = tk.Text(self.root)  # never shown; gui.py's save_settings reads it

    def note(self, text):
        self.result_text.config(state="normal")
        self.result_text.insert("end", text + "\n")
        self.result_text.see("end")
        self.result_text.config(state="disabled")

    def __init__(self, root):
        super().__init__(root)
        root.title("Prediction test: R(60 C)")
        self.test = None  # running test: {"phase", "t0"}
        f = ttk.Frame(root)
        f.pack(fill="x", padx=8, pady=(0, 6))
        ttk.Button(f, text="Start prediction test", command=self.start_test).pack(side="left")
        self.set_var = tk.StringVar(value="60")
        ttk.Label(f, text="Set to").pack(side="left", padx=(10, 2))
        ttk.Entry(f, textvariable=self.set_var, width=5).pack(side="left")
        ttk.Button(f, text="°C  Go", command=self.start_set).pack(side="left", padx=(2, 0))
        self.test_var = tk.StringVar(value="Prediction test: idle (ALL OFF aborts it)")
        ttk.Label(f, textvariable=self.test_var).pack(side="left", padx=10)

    def start_set(self):
        try:
            temp = float(self.set_var.get())
        except ValueError:
            temp = float("nan")
        if not SET_RANGE[0] <= temp <= SET_RANGE[1]:
            messagebox.showerror("Set to", f"Enter a temperature from {SET_RANGE[0]:g} to {SET_RANGE[1]:g} C")
            return
        self.start_test(temp)

    def start_test(self, set_temp=None):  # set_temp: just hold that temperature, no IR, no recording
        if not self.ser["esp"]:
            messagebox.showerror("Test", "Connect the ESP board first")
            return
        if set_temp is None and not self.serial_var.get().strip():
            messagebox.showerror("Test", "Enter the serial no. (sample name)")
            return
        if self.script is not None or self.test is not None:
            messagebox.showerror("Test", "A script or test is already running")
            return
        if not self.push_config():  # gains / setpoints for all inputs
            return
        self.x_pulse = None
        self.clear_data()  # time 0 = start of the 5 % PWM R0 read
        self.auto_var.set(False)
        self.send("auto 0")
        self.pwm_var.set(R0_PWM)
        self.send(f"pwm {R0_PWM}")
        name = f"set {set_temp:g} C" if set_temp else self.serial_var.get().strip()
        self.note(f"--- {name}  {datetime.now():%H:%M:%S} ---")
        self.test = {"phase": "r0", "set": set_temp}

    def rows(self, lo, hi):
        return [r for r in self.log if lo <= float(r[0]) < hi]

    def abort_test(self, why):
        if self.test is None:
            return
        self.test = None
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")
        self.test_var.set(f"Prediction test: aborted ({why}), heater off")
        self.note(f"aborted: {why}\n")

    def stop_script(self, off=False, why="stopped"):
        self.abort_test("stopped")  # ALL OFF / manual PWM / unchecking PID also end the test
        super().stop_script(off, why)

    def run_script(self):
        super().run_script()
        t = self.test
        if t is None:
            return
        if not self.ser["esp"]:
            self.abort_test("ESP disconnected")
            return
        now = time.time() - self.t0
        self.test_var.set(f"Prediction test: {t['phase']} ({now:.0f} s)")
        if t["phase"] == "r0" and now >= T_R0:
            r0 = mean([r[4] for r in self.rows(T_R0 - 1, T_R0)])
            if not r0 > 0:
                self.abort_test(f"no resistance reading at {R0_PWM} % PWM")
                return
            t.update(phase="pulse", r0=r0)
            self.pwm_var.set(100)
            self.send("pwm 100")
        elif t["phase"] == "pulse" and now >= T_R0 + T_PULSE:
            feat = pulse_features(self.rows(T_R0, T_R0 + T_PULSE))
            if feat is None or feat[0] <= 0:
                self.abort_test("no usable resistance data in the pulse")
                return
            drdt, _, p = feat
            r0 = t["r0"]  # read at 5 % PWM, not the first pulse sample
            pred = predict_r(ir_sensor(t["set"]) if t["set"] is not None else 60, drdt, r0, p)  # model is on the sensor scale
            if not R_OK[0] < pred < R_OK[1]:
                self.abort_test(f"predicted R {pred:.0f} ohm is outside {R_OK}")
                return
            t.update(phase="rhold", drdt=drdt, p=p, pred=pred)
            self.x_pulse = drdt * r0 / p
            self.note(f"dR/dt        {drdt:8.2f} ohm/s\nR0           {r0:8.2f} ohm\n"
                      f"Power @100%  {p:8.1f} mW\ndR/dt*R0/P   {drdt * r0 / p:8.2f}\n"
                      f"Predicted R{t['set'] if t['set'] is not None else 60:g} {pred:7.1f} ohm\nholding R for {T_RHOLD:.0f} s ...")
            self.sp_vars[2].set(f"{pred:g}")
            self.src_var.set(2)
            self.send(f"sp 2 {pred:g}")
            self.send("src 2")
            self.send("auto 1")
            self.auto_var.set(True)
        elif t["phase"] == "rhold" and now >= T_R0 + T_PULSE + T_RHOLD:
            if t["set"] is not None:
                self.test = None
                self.auto_var.set(False)
                self.send("auto 0")
                self.send("pwm 0")
                self.note("done, heater off\n")
                self.test_var.set(f"Set to {t['set']:g} C: done, heater off")
                return
            last = self.rows(now - 2, now)  # last 2 s of the resistance hold
            t.update(phase="ir60", ir_pred=mean([r[2] for r in last]))
            self.note(f"at predicted R:  IR {t['ir_pred']:.1f} C")
            self.set_ir(60.0, T_IR60)
        elif t["phase"] == "ir60" and now >= T_R0 + T_PULSE + T_RHOLD + T_IR60:
            t.update(phase="ir70", actual60=mean([r[4] for r in self.rows(now - T_AVG, now)]))
            self.note(f"Actual R60      {t['actual60']:7.1f} ohm\nPred - actual  {t['pred'] - t['actual60']:+7.1f} ohm "
                      f"({(t['pred'] / t['actual60'] - 1) * 100:+.1f} %)")
            self.set_ir(70.0, T_IR70)
        elif t["phase"] == "ir70" and now >= T_R0 + T_PULSE + T_RHOLD + T_IR60 + T_IR70:
            self.finish_test(now)

    def set_ir(self, target, secs):  # target on the sensor scale (as the fits were measured)
        real = ir_real(target)
        self.note(f"holding IR {real:.1f} C (sensor {target:g}) for {secs:.0f} s ...")
        self.sp_vars[0].set(f"{real:.2f}")
        self.src_var.set(0)
        self.send(f"sp 0 {real:.2f}")
        self.send("src 0")
        self.send("auto 1")

    def finish_test(self, now):
        t, self.test = self.test, None
        actual70 = mean([r[4] for r in self.rows(now - T_AVG, now)])
        self.auto_var.set(False)
        self.send("auto 0")
        self.send("pwm 0")
        os.makedirs(gui.OUT_DIR, exist_ok=True)
        new = not os.path.exists(PRED_CSV)
        with open(PRED_CSV, "a", newline="") as f:
            w = csv.writer(f)
            if new:
                w.writerow(PRED_HEADER)
            w.writerow([self.serial_var.get().strip(), f"{t['drdt']:.4f}", f"{t['p']:.3f}", f"{t['r0']:.3f}",
                        f"{t['pred']:.3f}", f"{t['actual60']:.3f}", f"{actual70:.3f}", f"{t['ir_pred']:.2f}"])
        self.save_outputs()
        self.note(f"Actual R70      {actual70:7.1f} ohm\n")
        self.test_var.set(f"Prediction test done: predicted R60 {t['pred']:.1f}, actual R60 {t['actual60']:.1f}, "
                          f"actual R70 {actual70:.1f} ohm")


if __name__ == "__main__":
    # synthetic pulse: R rises 100 ohm/s from 300 ohm, V*mA = 300 mW
    rows = [[f"{i * 0.2:.1f}", "", 30, 30, 300 + 100 * i * 0.2, 10.0, 30.0, 100, 0, 0] for i in range(10)]
    s, r0, p = pulse_features(rows)
    assert abs(s - 100) < 1e-6 and r0 == 300 and abs(p - 300) < 1e-9
    assert abs(predict_r(60, 100, 300, 300) - (102.7 * math.log(100) + 78.1)) < 1e-9
    assert abs(predict_r(70, 100, 300, 300) - (103.0 * math.log(100) + 151.9)) < 1e-9
    assert abs(ir_real(ir_sensor(45.0)) - 45.0) < 1e-9 and abs(ir_real(60) - 69.39) < 1e-9
    d = parse_data_real("not a data line")
    assert d is None
    assert abs(predict_temp(predict_r(65, 100, 300, 300), 100) - 65) < 1e-9  # inverse
    assert pulse_features(rows[:3]) is None and math.isnan(mean([float("nan")]))
    root = tk.Tk()
    TestApp(root)
    root.mainloop()
