"""dr runs: for each 100% PWM pulse, fit dR/dt over the pulse and divide by mean electrical power."""
import sys
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
import glob, numpy as np, pandas as pd

rows = []
for f in sorted(glob.glob("G5-*_dr_*.csv")):
    if SUF and "G5-1" in f:
        continue
    d = pd.read_csv(f)
    on = (d.pwm_pct >= 99.9).to_numpy()
    grp = np.cumsum(np.diff(on.astype(int), prepend=0) == 1)  # pulse index
    for k in np.unique(grp[on]):
        p = d[on & (grp == k)]
        dur = p.time_s.iloc[-1] - p.time_s.iloc[0]
        if p.time_s.iloc[0] < 10 or dur > 5:  # skip start-up 100% and anything not a 2 s pulse
            continue
        t = p.time_s.to_numpy()
        pw = (p.voltage_V * p.current_mA).mean()  # mW
        dR = np.polyfit(t, p.resistance_ohm, 1)[0]
        rows.append(dict(sample=f.split("_")[0], pulse=len(rows) and sum(r["sample"] == f.split("_")[0] for r in rows) + 1 or 1,
                         t_start_s=t[0], duration_s=dur, ir_C=p.ir_C.iloc[0], R_start_ohm=p.resistance_ohm.iloc[0],
                         power_mW=pw, dR_dt_ohm_s=dR,
                         dR_dt_per_power=dR / pw))
out = pd.DataFrame(rows)
out.round(5).to_csv(f"dr_pulses{SUF}.csv", index=False)
print(out.round(3).to_string())

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
fig, axs = plt.subplots(3, 1, sharex=True, figsize=(8, 10))
for n, g in out.groupby("sample"):
    for ax, c in zip(axs, ["dR_dt_ohm_s", "power_mW", "dR_dt_per_power"]):
        ax.plot(g.ir_C, g[c], "o-", label=n)
for ax, l in zip(axs, ["dR/dt (Ω/s)", "Power (mW)", "(dR/dt) / power (Ω/s/mW)"]):
    ax.set_ylabel(l); ax.grid(alpha=.3)
axs[-1].set_xlabel("IR temp at pulse start (°C)"); axs[0].legend()
fig.tight_layout(); fig.savefig(f"dr_pulses{SUF}.png", dpi=150)
