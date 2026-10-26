#!/usr/bin/env python3
"""
gui.py plus a "Start prediction test" button that tests the R(60 C) prediction:

  0-2 s    heater 100 % PWM: measure dR/dt, start resistance R0 and mean power P (mW)
  2-22 s   resistance PID holds the predicted R(60 C); TC and IR are recorded at the end
  22-72 s  IR PID holds 60 C (20 s to settle + 30 s hold); actual R(60 C) = mean R of the last 10 s

then one row is appended to output/prediction.csv. The usual time-series CSV + png are saved too.
Prediction (fit of output (26-10-23)/dr_scatter_R60_RdRdtP.png, pulses that start at 30-40 C):
  R60 = 72.505 * ln(dR/dt * R0 / P) + 201.591
so the sample should start at roughly 30-40 C. Needs the same parts as gui.py.
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
               "predicted_R60_ohm", "actual_R60_ohm", "ir_at_predicted_R_C", "tc_at_predicted_R_C"]
T_PULSE, T_RHOLD, T_IR = 2.0, 20.0, 50.0  # phase lengths (s)
T_AVG = 10.0  # actual R60 = mean over the last T_AVG s of the IR hold
IR_TARGET = 60.0
R_OK = (200.0, 800.0)  # sanity band for the predicted resistance (ohm)
# log rows from gui.py: [time_s, timestamp, ir, tc, ohm, volt, mA, pwm, auto, src]


def predict_r60(drdt, r0, p_mw):
    return 72.505 * math.log(drdt * r0 / p_mw) + 201.591


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
        self.test_var = tk.StringVar(value="Prediction test: idle (ALL OFF aborts it)")
        ttk.Label(f, textvariable=self.test_var).pack(side="left", padx=10)

    def start_test(self):
        if not self.ser["esp"]:
            messagebox.showerror("Test", "Connect the ESP board first")
            return
        if not self.serial_var.get().strip():
            messagebox.showerror("Test", "Enter the serial no. (sample name)")
            return
        if self.script is not None or self.test is not None:
            messagebox.showerror("Test", "A script or test is already running")
            return
        if not self.push_config():  # gains / setpoints for all inputs
            return
        self.clear_data()  # time 0 = start of the pulse
        self.auto_var.set(False)
        self.send("auto 0")
        self.pwm_var.set(100)
        self.send("pwm 100")
        self.note(f"--- {self.serial_var.get().strip()}  {datetime.now():%H:%M:%S} ---")
        self.test = {"phase": "pulse", "ir_pred": float("nan"), "tc_pred": float("nan")}

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
        if t["phase"] == "pulse" and now >= T_PULSE:
            feat = pulse_features(self.rows(0, T_PULSE))
            if feat is None or feat[0] <= 0:
                self.abort_test("no usable resistance data in the pulse")
                return
            drdt, r0, p = feat
            pred = predict_r60(drdt, r0, p)
            if not R_OK[0] < pred < R_OK[1]:
                self.abort_test(f"predicted R {pred:.0f} ohm is outside {R_OK}")
                return
            t.update(phase="rhold", drdt=drdt, r0=r0, p=p, pred=pred)
            self.note(f"dR/dt        {drdt:8.2f} ohm/s\nR0           {r0:8.2f} ohm\n"
                      f"Power @100%  {p:8.1f} mW\ndR/dt*R0/P   {drdt * r0 / p:8.2f}\n"
                      f"Predicted R60 {pred:7.1f} ohm\nholding R for {T_RHOLD:.0f} s ...")
            self.sp_vars[2].set(f"{pred:g}")
            self.src_var.set(2)
            self.send(f"sp 2 {pred:g}")
            self.send("src 2")
            self.send("auto 1")
            self.auto_var.set(True)
        elif t["phase"] == "rhold" and now >= T_PULSE + T_RHOLD:
            last = self.rows(now - 2, now)  # last 2 s of the resistance hold
            t.update(phase="ir", ir_pred=mean([r[2] for r in last]), tc_pred=mean([r[3] for r in last]))
            self.note(f"at predicted R:  IR {t['ir_pred']:.1f} C, TC {t['tc_pred']:.1f} C\n"
                      f"holding IR {IR_TARGET:g} C for {T_IR:.0f} s ...")
            self.sp_vars[0].set(f"{IR_TARGET:g}")
            self.src_var.set(0)
            self.send(f"sp 0 {IR_TARGET:g}")
            self.send("src 0")
            self.send("auto 1")
        elif t["phase"] == "ir" and now >= T_PULSE + T_RHOLD + T_IR:
            self.finish_test(now)

    def finish_test(self, now):
        t, self.test = self.test, None
        actual = mean([r[4] for r in self.rows(now - T_AVG, now)])
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
                        f"{t['pred']:.3f}", f"{actual:.3f}", f"{t['ir_pred']:.2f}", f"{t['tc_pred']:.2f}"])
        self.save_outputs()
        self.note(f"Actual R60    {actual:7.1f} ohm\nPred - actual {t['pred'] - actual:+7.1f} ohm "
                  f"({(t['pred'] / actual - 1) * 100:+.1f} %)\n")
        self.test_var.set(f"Prediction test done: predicted {t['pred']:.1f} ohm, actual {actual:.1f} ohm "
                          f"(IR {t['ir_pred']:.1f} C, TC {t['tc_pred']:.1f} C at the predicted R)")


if __name__ == "__main__":
    # synthetic pulse: R rises 100 ohm/s from 300 ohm, V*mA = 300 mW
    rows = [[f"{i * 0.2:.1f}", "", 30, 30, 300 + 100 * i * 0.2, 10.0, 30.0, 100, 0, 0] for i in range(10)]
    s, r0, p = pulse_features(rows)
    assert abs(s - 100) < 1e-6 and r0 == 300 and abs(p - 300) < 1e-9
    assert abs(predict_r60(100 * 300 / 300, 300, 300) - (72.505 * math.log(100) + 201.591)) < 1e-9
    assert pulse_features(rows[:3]) is None and math.isnan(mean([float("nan")]))
    root = tk.Tk()
    TestApp(root)
    root.mainloop()
