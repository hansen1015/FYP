"""Candidate normalisations of dR/dt vs IR temp, from dr_pulses.csv (run dr_pulses.py first)."""
import sys
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
import pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv(f"dr_pulses{SUF}.csv")
g, P, R = d.dR_dt_ohm_s, d.power_mW, d.R_start_ohm
c = {"dR/dt (Ω/s)": g, "dR/dt ÷ P": g / P, "dR/dt ÷ P²": g / P**2, "dR/dt × P": g * P,
     "dR/dt ÷ R": g / R, "dR/dt × R ÷ P": g * R / P, "dR/dt × R ÷ P²": g * R / P**2,
     "dR/dt × R^0.8": g * R**0.8, "dR/dt ÷ (P^0.22 · R^-0.88)": g / (P**0.22 * R**-0.88)}
d.assign(**{k: v for k, v in c.items()}).to_csv(f"dr_candidates{SUF}.csv", index=False)
fig, axs = plt.subplots(3, 3, figsize=(15, 12), sharex=True)
for ax, (k, v) in zip(axs.flat, c.items()):
    for n, i in d.groupby("sample"):
        ax.plot(i.ir_C, v[i.index], "o-", label=n)
    ax.set_title(k); ax.grid(alpha=.3)
for ax in axs[-1]: ax.set_xlabel("IR temp at pulse start (°C)")
axs[0, 0].legend(); fig.tight_layout(); fig.savefig(f"dr_candidates{SUF}.png", dpi=130)
