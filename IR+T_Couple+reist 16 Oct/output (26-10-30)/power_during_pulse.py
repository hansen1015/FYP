"""Power (V*mA, mW), voltage and current against time during the 100 % PWM pulse of every prediction-test run in output (26-10-27) and output (26-10-30).
Pulse = first block of rows at 100 % PWM with the PID off; t = 0 at its first row. Colour = folder."""
import glob, os
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.dirname(HERE)
DIRS = {"output (26-10-27)": "C0", "output (26-10-30)": "C3"}
fig, axs = plt.subplots(3, 1, figsize=(9, 10), sharex=True); rows = []
for folder, color in DIRS.items():
    first = True
    for f in sorted(glob.glob(os.path.join(ROOT, folder, "G5-*.csv"))):
        d = pd.read_csv(f); hit = (d.pwm_pct >= 99.9) & (d.pid_auto == 0)
        if not hit.any(): continue
        i0 = hit.idxmax(); blk = d.loc[i0:]; blk = blk[(blk.pwm_pct >= 99.9) & (blk.pid_auto == 0)]
        blk = blk.loc[:blk.index[(np.diff(blk.index, prepend=blk.index[0]) > 1).argmax() - 1] if (np.diff(blk.index) > 1).any() else blk.index[-1]]  # stop at the first gap
        t = blk.time_s - blk.time_s.iloc[0]; p = blk.voltage_V * blk.current_mA
        for ax, y in zip(axs, (p, blk.voltage_V, blk.current_mA)):
            ax.plot(t, y, c=color, alpha=.5, lw=1, label=folder if first else None)
        first = False
        rows += [(folder, os.path.basename(f), tt, pp, v, i) for tt, pp, v, i in zip(t, p, blk.voltage_V, blk.current_mA)]
for ax, lab in zip(axs, ("Power (mW)", "Voltage (V)", "Current (mA)")):
    ax.set_ylabel(lab); ax.grid(alpha=.3)
axs[0].legend(); axs[-1].set_xlabel("Time since the 100 % PWM pulse started (s)")
fig.tight_layout(); fig.savefig(os.path.join(HERE, "power_during_pulse.png"), dpi=140)
out = pd.DataFrame(rows, columns=["folder", "run", "t_s", "power_mW", "voltage_V", "current_mA"]); out.to_csv(os.path.join(HERE, "power_during_pulse.csv"), index=False)
print(out.groupby("folder").run.nunique(), out.groupby("folder").t_s.max(), out.groupby("folder").power_mW.agg(["mean", "min", "max"]).round(0))
