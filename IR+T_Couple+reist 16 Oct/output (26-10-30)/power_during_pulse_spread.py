"""Spread version of power_during_pulse.png: per folder, mean line with the 25-75 % quartile band of power, voltage and current.
Reads power_during_pulse.csv; each run is interpolated onto a common 0.1 s grid (only where the run has data)."""
import os
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
d = pd.read_csv(os.path.join(HERE, "power_during_pulse.csv"))
grid = np.arange(0, 1.81, 0.1)
cols = (("power_mW", "Power (mW)"), ("voltage_V", "Voltage (V)"), ("current_mA", "Current (mA)"))
fig, axs = plt.subplots(3, 1, figsize=(9, 10), sharex=True)
for (folder, g0), color in zip(d.groupby("folder"), ("C0", "C3")):
    for ax, (c, _) in zip(axs, cols):
        m = np.array([np.interp(grid, g.t_s, g[c], left=np.nan, right=np.nan) for _, g in g0.groupby("run")])
        q1, q3 = np.nanpercentile(m, [25, 75], axis=0)
        ax.fill_between(grid, q1, q3, color=color, alpha=.25, lw=0)
        ax.plot(grid, np.nanmean(m, axis=0), c=color, lw=2, label=f"{folder}, mean (band = quartiles, {len(m)} runs)")
for ax, (_, lab) in zip(axs, cols):
    ax.set_ylabel(lab); ax.grid(alpha=.3)
axs[0].legend(fontsize=8); axs[-1].set_xlabel("Time since the 100 % PWM pulse started (s)")
fig.tight_layout(); fig.savefig(os.path.join(HERE, "power_during_pulse_spread.png"), dpi=140)
