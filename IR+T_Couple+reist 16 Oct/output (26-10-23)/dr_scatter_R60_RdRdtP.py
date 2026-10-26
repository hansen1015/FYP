"""R60 vs dR/dt × R ÷ P for pulses starting at 30-40 C, with log fit."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

k = "dR/dt × R ÷ P"
d = pd.read_csv("dr_candidates.csv"); d["R60_ohm"] = pd.read_csv("dr_candidates_over_R60.csv").R60_ohm
d = d[d.ir_C < 41]; y = d.R60_ohm
c = np.polyfit(np.log(d[k]), y, 1)
r2 = 1 - ((y - np.polyval(c, np.log(d[k]))) ** 2).sum() / ((y - y.mean()) ** 2).sum()
fig, ax = plt.subplots(figsize=(7.5, 6))
for n, g in d.groupby("sample"):
    ax.scatter(g[k], g.R60_ohm, s=50, label=n, zorder=3)
x = np.linspace(d[k].min(), d[k].max(), 200)
ax.plot(x, np.polyval(c, np.log(x)), "k", label=f"R60 = {c[0]:.1f}·ln(x) + {c[1]:.1f}\nR² = {r2:.2f}")
ax.set_xlabel("dR/dt × R ÷ P"); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3); ax.legend(loc="lower right")
fig.tight_layout(); fig.savefig("dr_scatter_R60_RdRdtP.png", dpi=140)
