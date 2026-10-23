"""Each candidate from dr_candidates.csv divided by that sample's R at IR=60 C (R2 run, mean over t=185-195 s)."""
import sys
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
import glob, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

R60 = {}
for f in glob.glob("G5-*_R2_*.csv"):
    if SUF and "G5-1" in f:
        continue
    r = pd.read_csv(f)
    w = r[(r.time_s >= 185) & (r.time_s <= 195)]
    assert abs(w.ir_C.mean() - 60) < 0.5, f
    R60[f.split("_")[0]] = w.resistance_ohm.mean()
print({k: round(v, 1) for k, v in sorted(R60.items())})

d = pd.read_csv(f"dr_candidates{SUF}.csv")
cols = list(d.columns[9:])  # the candidate columns
d["R60_ohm"] = d["sample"].map(R60)
d[cols] = d[cols].div(d.R60_ohm, axis=0)
d.to_csv(f"dr_candidates_over_R60{SUF}.csv", index=False)
fig, axs = plt.subplots(3, 3, figsize=(15, 12), sharex=True)
for ax, k in zip(axs.flat, cols):
    for n, i in d.groupby("sample"):
        ax.plot(i.ir_C, i[k], "o-", label=n)
    ax.set_title(k + " ÷ R(60 °C)"); ax.grid(alpha=.3)
for ax in axs[-1]: ax.set_xlabel("IR temp at pulse start (°C)")
axs[0, 0].legend(); fig.tight_layout(); fig.savefig(f"dr_candidates_over_R60{SUF}.png", dpi=130)
