"""R60 from start resistance only (pulses starting at 30-40 C): log R60 = a + b log R_start, leave-one-sample-out."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv("dr_candidates_over_R60.csv")
d = d[d.ir_C < 41].reset_index(drop=True)
d["pred"] = np.nan
for s in d["sample"].unique():
    tr, te = d[d["sample"] != s], d[d["sample"] == s]
    b, a = np.polyfit(np.log(tr.R_start_ohm), np.log(tr.R60_ohm), 1)
    d.loc[te.index, "pred"] = np.exp(a + b * np.log(te.R_start_ohm))
d["err_pct"] = (d.pred / d.R60_ohm - 1) * 100
d[["sample", "pulse", "ir_C", "R_start_ohm", "R60_ohm", "pred", "err_pct"]].round(2).to_csv("predict_R60_from_Rstart.csv", index=False)

fig, (a1, a2) = plt.subplots(1, 2, figsize=(13, 5.5))
for i, (n, g) in enumerate(d.groupby("sample")):
    a1.scatter(g.R_start_ohm, g.R60_ohm, c=f"C{i}", label=n)
    a2.scatter(g.R60_ohm, g.pred, c=f"C{i}", label=n)
b, a = np.polyfit(np.log(d.R_start_ohm), np.log(d.R60_ohm), 1); x = np.linspace(d.R_start_ohm.min(), d.R_start_ohm.max(), 50)
a1.plot(x, np.exp(a + b * np.log(x)), "k--", lw=1)
a1.set_xlabel("Start resistance, 30–40 °C (Ω)"); a1.set_ylabel("R at 60 °C (Ω)"); a1.grid(alpha=.3); a1.legend()
lim = [330, 570]; a2.plot(lim, lim, "k--", lw=1)
a2.set_xlabel("Actual R at 60 °C (Ω)"); a2.set_ylabel("Predicted (Ω), leave-one-sample-out"); a2.grid(alpha=.3)
fig.tight_layout(); fig.savefig("predict_R60_from_Rstart.png", dpi=140)
print(d.groupby("sample").err_pct.agg(["mean", "min", "max"]).round(1))
