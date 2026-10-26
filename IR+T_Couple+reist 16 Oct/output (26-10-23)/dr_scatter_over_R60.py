"""Scatter: x = candidate ÷ R60 (dr_candidates_over_R60.csv), y = R at IR=60 C, with least-squares line over all points."""
import sys, numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs

d = pd.read_csv(f"dr_candidates_over_R60{SUF}.csv")
cols = list(d.columns[9:-1])
fig, axs = plt.subplots(3, 3, figsize=(15, 12))
for ax, k in zip(axs.flat, cols):
    for i, (n, g) in enumerate(d.groupby("sample")):
        ax.scatter(g[k], g.R60_ohm, c=f"C{i + (1 if SUF else 0)}", label=n)
    m, b = np.polyfit(d[k], d.R60_ohm, 1)
    xs = np.array([d[k].min(), d[k].max()])
    ax.plot(xs, m * xs + b, "k--", lw=1)
    ax.set_title(f"{k} ÷ R(60 °C)  (R² = {d[k].corr(d.R60_ohm)**2:.2f})")
    ax.set_xlabel(f"{k} ÷ R(60 °C)"); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3)
axs[0, 0].legend(); fig.tight_layout(); fig.savefig(f"dr_scatter_over_R60{SUF}.png", dpi=130)
