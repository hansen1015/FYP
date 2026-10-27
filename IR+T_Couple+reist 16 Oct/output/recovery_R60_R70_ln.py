"""R60 and R70 vs x = dR/dt*R0/P on one graph, ln fit for before / after recovery (colour = group, filled = 60 C, hollow = 70 C)."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

G = {"before recovery": ("prediction_before_recovery.csv", "C0"), "after recovery": ("prediction_after_recovery.csv", "C3")}
fig, ax = plt.subplots(figsize=(9, 6.5))
for g, (f, c) in G.items():
    d = pd.read_csv(f); x = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW; xs = np.linspace(x.min(), x.max(), 200)
    for deg, ls, mk in ((60, "-", "o"), (70, "--", "s")):
        y = d[f"actual_R{deg}_ohm"]; k = np.polyfit(np.log(x), y, 1); r2 = np.corrcoef(np.log(x), y)[0, 1] ** 2
        ax.scatter(x, y, marker=mk, s=40, facecolors=c if deg == 60 else "none", edgecolors=c, zorder=3)
        ax.plot(xs, np.polyval(k, np.log(xs)), c=c, ls=ls, label=f"{g}, {deg} °C: {k[0]:.1f}·ln(x) {k[1]:+.1f}  (R² = {r2:.2f})")
ax.set_xlabel("dR/dt × R0 ÷ P"); ax.set_ylabel("Actual resistance (Ω)"); ax.grid(alpha=.3); ax.legend(fontsize=8)
fig.tight_layout(); fig.savefig("recovery_R60_R70_vs_RdRdtP.png", dpi=140)
