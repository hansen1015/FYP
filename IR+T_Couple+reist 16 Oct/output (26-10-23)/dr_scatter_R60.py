"""Scatter: x = candidate value (dr_candidates.csv), y = R at IR=60 C of that sample (from dr_candidates_over_R60.csv)."""
import pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv("dr_candidates.csv")
d["R60_ohm"] = pd.read_csv("dr_candidates_over_R60.csv").R60_ohm
cols = list(d.columns[9:-1])
fig, axs = plt.subplots(3, 3, figsize=(15, 12))
for ax, k in zip(axs.flat, cols):
    for n, i in d.groupby("sample"):
        ax.scatter(i[k], i.R60_ohm, label=n)
    ax.set_title(f"{k}  (r = {d[k].corr(d.R60_ohm):.2f})"); ax.set_xlabel(k); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3)
axs[0, 0].legend(); fig.tight_layout(); fig.savefig("dr_scatter_R60.png", dpi=130)
