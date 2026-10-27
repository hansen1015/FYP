#!/usr/bin/env python3
"""
gui.py plus a "Start prediction test" button that tests the R(60 C) prediction:

  0-3 s    heater 5 % PWM: start resistance R0 = mean R of the last second
  3-5 s    heater 100 % PWM: measure dR/dt and the mean power P (mW)
  5-25 s   resistance PID holds the predicted R(60 C); the IR is recorded at the end
  25-45 s  IR PID holds 60 C; actual R(60 C) = mean R of the last 5 s
  45-65 s  IR PID holds 70 C; actual R(70 C) = mean R of the last 5 s

then one row is appended to output/prediction.csv. The usual time-series CSV + png are saved too.
Prediction (ln fits of output/prediction.csv, actual R at 60 / 70 C against dR/dt * R0 / P):
  R60 = 80.780 * ln(x) + 135.588,  R70 = 88.143 * ln(x) + 177.684,  x = dR/dt * R0 / P
The "Set to 60 C" / "Set to 70 C" buttons run R0 + pulse + prediction, then hold the predicted
resistance for 20 s with the resistance PID: no IR, nothing recorded, heater off at the end. The thermocouple board is not used (no port, readout or plot line).
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


FIT = {60: (80.780, 135.588), 70: (88.143, 177.684)}  # temp -> (slope, intercept) of R against ln(x)


def predict_r(temp, drdt, r0, p_mw):
    a, b = FIT[temp]
    return a * math.log(drdt * r0 / p_mw) + b


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
        for temp in FIT:
            ttk.Button(f, text=f"Set to {temp} °C", command=lambda T=temp: self.start_test(T)).pack(side="left", padx=(6, 0))
        self.test_var = tk.StringVar(value="Prediction test: idle (ALL OFF aborts it)")
        ttk.Label(f, textvariable=self.test_var).pack(side="left", padx=10)

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
        self.clear_data()  # time 0 = start of the 5 % PWM R0 read
        self.auto_var.set(False)
        self.send("auto 0")
        self.pwm_var.set(R0_PWM)
        self.send(f"pwm {R0_PWM}")
        name = f"set {set_temp} C" if set_temp else self.serial_var.get().strip()
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
            pred = predict_r(t["set"] or 60, drdt, r0, p)
            if not R_OK[0] < pred < R_OK[1]:
                self.abort_test(f"predicted R {pred:.0f} ohm is outside {R_OK}")
                return
            t.update(phase="rhold", drdt=drdt, p=p, pred=pred)
            self.note(f"dR/dt        {drdt:8.2f} ohm/s\nR0           {r0:8.2f} ohm\n"
                      f"Power @100%  {p:8.1f} mW\ndR/dt*R0/P   {drdt * r0 / p:8.2f}\n"
                      f"Predicted R{t['set'] or 60} {pred:7.1f} ohm\nholding R for {T_RHOLD:.0f} s ...")
            self.sp_vars[2].set(f"{pred:g}")
            self.src_var.set(2)
            self.send(f"sp 2 {pred:g}")
            self.send("src 2")
            self.send("auto 1")
            self.auto_var.set(True)
        elif t["phase"] == "rhold" and now >= T_R0 + T_PULSE + T_RHOLD:
            if t["set"]:
                self.test = None
                self.auto_var.set(False)
                self.send("auto 0")
                self.send("pwm 0")
                self.note("done, heater off\n")
                self.test_var.set(f"Set to {t['set']} C: done, heater off")
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

    def set_ir(self, target, secs):
        self.note(f"holding IR {target:g} C for {secs:.0f} s ...")
        self.sp_vars[0].set(f"{target:g}")
        self.src_var.set(0)
        self.send(f"sp 0 {target:g}")
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
    assert abs(predict_r(60, 100, 300, 300) - (80.780 * math.log(100) + 135.588)) < 1e-9
    assert abs(predict_r(70, 100, 300, 300) - (88.143 * math.log(100) + 177.684)) < 1e-9
    assert pulse_features(rows[:3]) is None and math.isnan(mean([float("nan")]))
    root = tk.Tk()
    TestApp(root)
    root.mainloop()
