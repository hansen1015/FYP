"""Same graphs as prediction_plots.py, but prediction_before_recovery.csv vs prediction_after_recovery.csv (colour = group, marker = sample)."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

GROUPS = {"before recovery": ("prediction_before_recovery.csv", "C0"), "after recovery": ("prediction_after_recovery.csv", "C3")}
d = pd.concat([pd.read_csv(f).assign(group=g) for g, (f, _) in GROUPS.items()], ignore_index=True)
d["x"] = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW
marks = dict(zip(sorted(d["sample"].unique()), "osD^v"))

def draw(ax, xcol, ycol, xlabel, ylabel, fit=False, one_to_one=False):
    for g, (_, color) in GROUPS.items():
        s = d[d.group == g]
        for n, m in marks.items():
            t = s[s["sample"] == n]
            ax.scatter(t[xcol], t[ycol], c=color, marker=m, s=45, zorder=3)
        if fit:
            c = np.polyfit(np.log(s.x), s[ycol], 1); xs = np.linspace(s.x.min(), s.x.max(), 200)
            r2 = np.corrcoef(np.log(s.x), s[ycol])[0, 1] ** 2
            ax.plot(xs, np.polyval(c, np.log(xs)), c=color, label=f"{g}: {c[0]:.1f}·ln(x) + {c[1]:.1f}  (R² = {r2:.2f})")
        else:
            ax.scatter([], [], c=color, label=g)
    for n, m in marks.items():
        ax.scatter([], [], c="gray", marker=m, label=n)
    if one_to_one:
        lim = [d[[xcol, ycol]].min().min() - 10, d[[xcol, ycol]].max().max() + 10]
        ax.plot(lim, lim, "k--", lw=1, label="1:1")
    ax.set_xlabel(xlabel); ax.set_ylabel(ylabel); ax.grid(alpha=.3); ax.legend(fontsize=8)

for deg in (60, 70):
    fig, ax = plt.subplots(figsize=(7.5, 6))
    draw(ax, "x", f"actual_R{deg}_ohm", "dR/dt × R0 ÷ P", f"Actual R at {deg} °C (Ω)", fit=True)
    fig.tight_layout(); fig.savefig(f"recovery_R{deg}_vs_RdRdtP.png", dpi=140)

fig, ax = plt.subplots(figsize=(7, 6))
draw(ax, "actual_R60_ohm", "predicted_R60_ohm", "Actual R at 60 °C (Ω)", "Predicted R at 60 °C (Ω)", one_to_one=True)
fig.tight_layout(); fig.savefig("recovery_predicted_vs_actual_R60.png", dpi=140)

fig, ax = plt.subplots(figsize=(7.5, 5))
bins = np.arange(np.floor(d.ir_at_predicted_R_C.min()), np.ceil(d.ir_at_predicted_R_C.max()) + 1, 1)
for g, (_, color) in GROUPS.items():
    ax.hist(d[d.group == g].ir_at_predicted_R_C, bins=bins, color=color, alpha=.6, edgecolor="white", label=g)
ax.axvline(60, c="k", ls="--", lw=1, label="60 °C target")
ax.set_xlabel("IR temp at the predicted resistance (°C)"); ax.set_ylabel("Runs"); ax.legend(fontsize=8)
fig.tight_layout(); fig.savefig("recovery_ir_at_predicted_R_distribution.png", dpi=140)

d["err_pct"] = (d.predicted_R60_ohm / d.actual_R60_ohm - 1) * 100
print(d.groupby("group")[["initial_resistance_ohm", "dR_dt_ohm_s", "power_at_100pct_pwm_mW", "x", "actual_R60_ohm", "actual_R70_ohm", "ir_at_predicted_R_C", "err_pct"]].mean().round(1).T)
print(d.groupby(["group", "sample"])[["actual_R60_ohm", "err_pct"]].mean().round(1))
