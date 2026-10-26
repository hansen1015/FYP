"""Scatter: x = candidate value (dr_candidates.csv), y = R at IR=60 C of that sample (from dr_candidates_over_R60.csv)."""
import sys
BASE = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
SUF = BASE + ("_30-40C" if "--t30-40" in sys.argv else "")  # --t30-40: only pulses starting at 30-40 C
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv(f"dr_candidates{BASE}.csv")
cols = list(d.columns[9:])
d["R60_ohm"] = pd.read_csv(f"dr_candidates_over_R60{BASE}.csv").R60_ohm
if "--t30-40" in sys.argv:
    d = d[d.ir_C < 41]
fig, axs = plt.subplots(3, 3, figsize=(15, 12))
for ax, k in zip(axs.flat, cols):
    for n, i in d.groupby("sample"):
        ax.scatter(i[k], i.R60_ohm, label=n)
    m, b = np.polyfit(d[k], d.R60_ohm, 1)
    xs = np.array([d[k].min(), d[k].max()])
    ax.plot(xs, m * xs + b, "k--", lw=1)
    ax.set_title(f"{k}  (R² = {d[k].corr(d.R60_ohm)**2:.2f})"); ax.set_xlabel(k); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3)
axs[0, 0].legend(); fig.tight_layout(); fig.savefig(f"dr_scatter_R60{SUF}.png", dpi=130)
