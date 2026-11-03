"""Contrast S1 (gather_data.csv, power-controlled 800 mW 2 s pulse, IR holds at real 50/60/70 C) with the earlier before/after-recovery
runs (100 % PWM pulse; their 'R60' / 'R70' were held at sensor IR 60 / 70 = real 69.39 / 82.27 C) and their combined ln model.
x = dR/dt * R0 / P. For S1, P is the measured mean pulse power (what the old x used); nominal-800 x is also written to the csv."""
import os
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
OLD = os.path.join(HERE, "..", "..", "IR+T_Couple+reist 16 Oct", "output (26-10-27)")
A0, A1, B0, B1 = 100.9887, 0.024363, -319.2978, 5.72745  # combined old model: R = (A0+A1 T) ln x + B0 + B1 T, T real C
T_OLD = {60: 69.39, 70: 82.27}  # old labels (sensor IR) -> real C

old = pd.concat([pd.read_csv(os.path.join(OLD, f"prediction_{g}_recovery.csv")).assign(group=g) for g in ("before", "after")], ignore_index=True)
old["x"] = old.dR_dt_ohm_s * old.initial_resistance_ohm / old.power_at_100pct_pwm_mW
s1 = pd.read_csv(os.path.join(HERE, "gather_data.csv")); s1 = s1[s1["sample"] == "S1"].reset_index(drop=True)
s1["x_meas"] = s1.dR_dt_ohm_s * s1.initial_resistance_ohm / s1.pulse_power_measured_mW
s1["x_nominal"] = s1.dR_dt_ohm_s * s1.initial_resistance_ohm / s1.pulse_power_setpoint_mW
temps = [50, 60, 70]; model = lambda T, x: (A0 + A1 * T) * np.log(x) + B0 + B1 * T

# ---- csv: S1 actual vs the old model ----
rows = []
for _, r in s1.iterrows():
    for T in temps:
        pred = model(T, r.x_meas); act = r[f"actual_R{T}_ohm"]
        rows.append(dict(run=_ + 1, T_real_C=T, dR_dt=r.dR_dt_ohm_s, R0=r.initial_resistance_ohm, P_measured_mW=r.pulse_power_measured_mW,
                         x_measured_P=r.x_meas, x_nominal_800=r.x_nominal, actual_R=act, old_model_R=pred, error_ohm=pred - act,
                         error_pct=(pred / act - 1) * 100, error_C=(pred - act) / (A1 * np.log(r.x_meas) + B1)))
cmp = pd.DataFrame(rows).round(3); cmp.to_csv(os.path.join(HERE, "S1_vs_old_model.csv"), index=False)
summ = [("S1 (3 runs)", s1.dR_dt_ohm_s.mean(), s1.initial_resistance_ohm.mean(), s1.pulse_power_measured_mW.mean(), s1.x_meas.mean(), None, None)]
d = old
summ.append((f"old runs, before + after recovery ({len(d)} runs)", d.dR_dt_ohm_s.mean(), d.initial_resistance_ohm.mean(), d.power_at_100pct_pwm_mW.mean(), d.x.mean(), d.actual_R60_ohm.mean(), d.actual_R70_ohm.mean()))
pd.DataFrame(summ, columns=["set", "dR_dt", "R0", "pulse_power_mW", "x", "old R at real 69.4 C", "old R at real 82.3 C"]).round(1).to_csv(os.path.join(HERE, "S1_vs_old_summary.csv"), index=False)

# ---- graph 1: R vs x, colour = real temperature ----
COL = {50: "#2a9d8f", 60: "#3a7bd5", 69.39: "#f4a261", 70: "#e76f51", 82.27: "#9d0208"}; col = COL.__getitem__
fig, ax = plt.subplots(figsize=(9, 6.5)); xs = np.linspace(5, 200, 300)
for k, T in T_OLD.items():
    ax.scatter(old.x, old[f"actual_R{k}_ohm"], marker="o", s=28, c=[col(T)], alpha=.55, zorder=2, label=f"old runs (before + after recovery), {T} °C")
for T in (50, 60, 69.39, 82.27):
    ax.plot(xs, model(T, xs), c=col(T), lw=1.2, ls="--", alpha=.8, label=f"old model at {T:g} °C")
for T in temps:
    ax.scatter(s1.x_meas, s1[f"actual_R{T}_ohm"], marker="*", s=230, c=[col(T)], edgecolors="k", linewidths=.8, zorder=5, label=f"S1 at {T} °C")
ax.set_xlabel("dR/dt × R0 ÷ P  (S1: measured mean pulse power)"); ax.set_ylabel("Resistance (Ω)"); ax.grid(alpha=.3); ax.legend(fontsize=7, ncol=2)
ax.set_xlim(0, 100); ax.set_title("S1 (stars) vs the earlier runs and their combined ln model")
fig.tight_layout(); fig.savefig(os.path.join(HERE, "S1_vs_old_R_vs_x.png"), dpi=140)

# ---- graph 2: R against real temperature ----
fig, ax = plt.subplots(figsize=(8, 6))
for k, T in T_OLD.items():
    ax.scatter(np.full(len(old), T) + np.random.default_rng(0).uniform(-.6, .6, len(old)), old[f"actual_R{k}_ohm"], marker="o", s=22, c="gray", alpha=.5, label="old runs (before + after recovery)" if k == 60 else None)
for i, r in s1.iterrows():
    ax.plot(temps, [r[f"actual_R{T}_ohm"] for T in temps], "-*", c="C3", ms=12, lw=1.5, label="S1 runs" if i == 0 else None)
ax.set_xlabel("IR temperature, real °C"); ax.set_ylabel("Resistance (Ω)"); ax.grid(alpha=.3); ax.legend(); ax.set_title("R at each held temperature")
fig.tight_layout(); fig.savefig(os.path.join(HERE, "S1_vs_old_R_vs_T.png"), dpi=140)

print(pd.DataFrame(summ, columns=["set", "dR_dt", "R0", "P", "x", "R69.4", "R82.3"]).round(1).to_string(index=False))
print(cmp[["run", "T_real_C", "x_measured_P", "x_nominal_800", "actual_R", "old_model_R", "error_ohm", "error_pct", "error_C"]].round(1).to_string(index=False))
print(cmp.groupby("T_real_C")[["actual_R", "old_model_R", "error_ohm", "error_pct", "error_C"]].mean().round(1))
print("S1 slope ohm/C (50->70):", ((s1.actual_R70_ohm - s1.actual_R50_ohm) / 20).round(2).tolist(), "| old model slope at x=15:", round(B1 + A1 * np.log(15) + A0 * 0, 2), "(+ ln x term x A1)")
print("old per-sample mean R0, R at real 69.4 / 82.3:"); print(old.groupby("sample")[["initial_resistance_ohm", "actual_R60_ohm", "actual_R70_ohm"]].mean().round(0).to_string())
