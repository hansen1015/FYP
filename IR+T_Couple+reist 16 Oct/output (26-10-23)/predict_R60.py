"""Predict R(60 C) from steady R and steady power at an unknown start temp: R60 = R_ss * exp(a + b*P_ss).
Leave-one-sample-out (LOSO) predictions: each sample is predicted by a fit that never saw it."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv("dr_candidates_over_R60.csv")[["sample", "pulse", "R60_ohm"]]
ss = pd.read_csv("steady_state.csv"); ss = ss[ss.source == "dr"].reset_index(drop=True)
d = d.assign(ir_C=ss.ir_C, R_ss=ss.resistance_ohm, P_ss=ss.power_mW)
d["ratio"] = d.R60_ohm / d.R_ss
d["R60_pred"] = np.nan
for s in d["sample"].unique():
    tr, te = d[d["sample"] != s], d[d["sample"] == s]
    b, a = np.polyfit(tr.P_ss, np.log(tr.ratio), 1)
    d.loc[te.index, "R60_pred"] = te.R_ss * np.exp(a + b * te.P_ss)
d["err_pct"] = (d.R60_pred / d.R60_ohm - 1) * 100
d.round(3).to_csv("predict_R60.csv", index=False)
print(d.groupby("sample").err_pct.agg(["mean", lambda x: x.abs().max()]).round(1))

fig, (a1, a2) = plt.subplots(1, 2, figsize=(13, 5.5))
for i, (n, g) in enumerate(d.groupby("sample")):
    a1.scatter(g.P_ss, g.ratio, c=f"C{i}", label=n)
    a2.scatter(g.R60_ohm, g.R60_pred, c=f"C{i}", label=n)
b, a = np.polyfit(d.P_ss, np.log(d.ratio), 1); x = np.linspace(d.P_ss.min(), d.P_ss.max(), 50)
a1.plot(x, np.exp(a + b * x), "k--", lw=1)
a1.set_xlabel("Steady power before pulse (mW)"); a1.set_ylabel("R60 / R steady"); a1.grid(alpha=.3); a1.legend()
lim = [330, 570]; a2.plot(lim, lim, "k--", lw=1)
a2.set_xlabel("Actual R at 60 °C (Ω)"); a2.set_ylabel("Predicted R at 60 °C (Ω), leave-one-sample-out"); a2.grid(alpha=.3)
fig.tight_layout(); fig.savefig("predict_R60.png", dpi=140)
