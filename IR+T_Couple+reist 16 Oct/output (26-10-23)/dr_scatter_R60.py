"""Scatter: x = candidate value (dr_candidates.csv), y = R at IR=60 C of that sample (from dr_candidates_over_R60.csv)."""
import sys
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv(f"dr_candidates{SUF}.csv")
d["R60_ohm"] = pd.read_csv(f"dr_candidates_over_R60{SUF}.csv").R60_ohm
cols = list(d.columns[9:-1])
fig, axs = plt.subplots(3, 3, figsize=(15, 12))
for ax, k in zip(axs.flat, cols):
    for n, i in d.groupby("sample"):
        ax.scatter(i[k], i.R60_ohm, label=n)
    m, b = np.polyfit(d[k], d.R60_ohm, 1)
    xs = np.array([d[k].min(), d[k].max()])
    ax.plot(xs, m * xs + b, "k--", lw=1)
    ax.set_title(f"{k}  (R² = {d[k].corr(d.R60_ohm)**2:.2f})"); ax.set_xlabel(k); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3)
axs[0, 0].legend(); fig.tight_layout(); fig.savefig(f"dr_scatter_R60{SUF}.png", dpi=130)
