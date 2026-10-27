"""R60 and R70 vs x = dR/dt*R0/P: one ln fit per temperature on before + after recovery combined (colour = group, filled = 60 C, hollow = 70 C)."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

G = {"before recovery": ("prediction_before_recovery.csv", "C0"), "after recovery": ("prediction_after_recovery.csv", "C3")}
d = pd.concat([pd.read_csv(f).assign(group=g) for g, (f, _) in G.items()], ignore_index=True)
d["x"] = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW
fig, ax = plt.subplots(figsize=(9, 6.5))
for deg, ls, mk in ((60, "-", "o"), (70, "--", "s")):
    for g, (_, c) in G.items():
        s = d[d.group == g]
        ax.scatter(s.x, s[f"actual_R{deg}_ohm"], marker=mk, s=40, facecolors=c if deg == 60 else "none", edgecolors=c, label=f"{g}, {deg} °C", zorder=3)
    y = d[f"actual_R{deg}_ohm"]; k = np.polyfit(np.log(d.x), y, 1); r2 = np.corrcoef(np.log(d.x), y)[0, 1] ** 2
    xs = np.linspace(d.x.min(), d.x.max(), 200)
    ax.plot(xs, np.polyval(k, np.log(xs)), "k", ls=ls, label=f"{deg} °C, both groups: {k[0]:.1f}·ln(x) {k[1]:+.1f}  (R² = {r2:.2f})")
ax.set_xlabel("dR/dt × R0 ÷ P"); ax.set_ylabel("Actual resistance (Ω)"); ax.grid(alpha=.3); ax.legend(fontsize=8)
fig.tight_layout(); fig.savefig("recovery_R60_R70_vs_RdRdtP.png", dpi=140)
