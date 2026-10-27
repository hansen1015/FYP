"""Graphs from prediction.csv (gui_test_prediction.py runs): actual R60 / R70 vs dR/dt*R0/P, and predicted vs actual R60."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv("prediction.csv")
d["run"] = d.groupby("sample").cumcount() + 1  # run order within each sample (numbers on the points)
d["x"] = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW
samples = sorted(d["sample"].unique())

def scatter(ax, x, y, xlabel, ylabel, fit=None):
    for i, n in enumerate(samples):
        g = d[d["sample"] == n]
        ax.scatter(x[g.index], y[g.index], c=f"C{i}", s=50, label=n, zorder=3)
        for j in g.index:
            ax.annotate(d.run[j], (x[j], y[j]), textcoords="offset points", xytext=(4, 4), fontsize=7)
    if fit == "log":
        c = np.polyfit(np.log(x), y, 1); xs = np.linspace(x.min(), x.max(), 200)
        r2 = 1 - ((y - np.polyval(c, np.log(x))) ** 2).sum() / ((y - y.mean()) ** 2).sum()
        ax.plot(xs, np.polyval(c, np.log(xs)), "k", label=f"{c[0]:.1f}·ln(x) + {c[1]:.1f}  (R² = {r2:.2f})")
    ax.set_xlabel(xlabel); ax.set_ylabel(ylabel); ax.grid(alpha=.3); ax.legend(fontsize=8)

for col, deg in (("actual_R60_ohm", 60), ("actual_R70_ohm", 70)):
    fig, ax = plt.subplots(figsize=(7.5, 6))
    scatter(ax, d.x, d[col], "dR/dt × R0 ÷ P", f"Actual R at {deg} °C (Ω)", fit="log")
    fig.tight_layout(); fig.savefig(f"prediction_R{deg}_vs_RdRdtP.png", dpi=140)

fig, ax = plt.subplots(figsize=(7, 6))
scatter(ax, d.actual_R60_ohm, d.predicted_R60_ohm, "Actual R at 60 °C (Ω)", "Predicted R at 60 °C (Ω)")
lim = [d[["actual_R60_ohm", "predicted_R60_ohm"]].min().min() - 10, d[["actual_R60_ohm", "predicted_R60_ohm"]].max().max() + 10]
ax.plot(lim, lim, "k--", lw=1, label="1:1")
ax.legend(fontsize=8); fig.tight_layout(); fig.savefig("prediction_predicted_vs_actual_R60.png", dpi=140)

e = (d.predicted_R60_ohm / d.actual_R60_ohm - 1) * 100
print(e.groupby(d["sample"]).agg(["mean", "min", "max"]).round(1))
for col in ("actual_R60_ohm", "actual_R70_ohm"):
    c = np.log(d.x); print(col, "log R²", round(np.corrcoef(c, d[col])[0, 1] ** 2, 2), "| mean/min/max", d[col].mean().round(0), d[col].min(), d[col].max())
