"""R60 and R70 vs x = dR/dt*R0/P: one ln fit per temperature on before + after recovery combined (colour = temperature: blue 60 C, red 70 C; marker = group: circle before, square after)."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

A0, A1, B0, B1 = 100.9, 0.03, -364.7, 7.38  # same temperature model as gui_test_prediction.py
G = {"before recovery": ("prediction_before_recovery.csv", "o"), "after recovery": ("prediction_after_recovery.csv", "s")}
d = pd.concat([pd.read_csv(f).assign(group=g) for g, (f, _) in G.items()], ignore_index=True)
d["x"] = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW
fig, ax = plt.subplots(figsize=(9, 6.5))
for deg, ls, c in ((60, "-", "C0"), (70, "--", "C3")):
    for g, (_, mk) in G.items():
        s = d[d.group == g]
        ax.scatter(s.x, s[f"actual_R{deg}_ohm"], marker=mk, s=40, c=c, label=f"{g}, {deg} °C", zorder=3)
    y = d[f"actual_R{deg}_ohm"]; k = np.polyfit(np.log(d.x), y, 1); r2 = np.corrcoef(np.log(d.x), y)[0, 1] ** 2; l1 = (np.polyval(k, np.log(d.x)) - y).abs().mean()
    lx = np.log(d.x); l1c = ((y - (A0 * lx + B0)) / (A1 * lx + B1) - deg).abs().mean()  # L1 in C: temperature the model reads from each actual R, vs the true deg
    xs = np.linspace(d.x.min(), d.x.max(), 200)
    ax.plot(xs, np.polyval(k, np.log(xs)), c=c, ls=ls, label=f"{deg} °C, both groups: {k[0]:.1f}·ln(x) {k[1]:+.1f}  (R² = {r2:.2f}, L1 = {l1:.0f} Ω ≈ {l1c:.1f} °C)")
ax.set_xlabel("dR/dt × R0 ÷ P"); ax.set_ylabel("Actual resistance (Ω)"); ax.grid(alpha=.3); ax.legend(fontsize=8)
fig.tight_layout(); fig.savefig("recovery_R60_R70_vs_RdRdtP.png", dpi=140)
