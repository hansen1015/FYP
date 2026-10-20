import openpyxl, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

rows = list(openpyxl.load_workbook("00 Report 14 Oct - 20 Oct.xlsx")["Sheet1"].iter_rows(min_row=3, values_only=True))
rows = [r for r in rows if isinstance(r[0], (int, float))]
t = [r[0] for r in rows]

fig, axes = plt.subplots(3, 1, figsize=(12, 14))
for ax, (lo, hi) in zip(axes, [(0, 50), (80, 130), (150, 200)]):
    idx = [i for i, v in enumerate(t) if lo <= v <= hi]
    x = [t[i] for i in idx]
    for g in range(5):
        c = f"C{g}"
        ax.plot(x, [rows[i][1 + 3 * g] for i in idx], color=c, label=f"G5_{g+1} IR")
        ax.plot(x, [rows[i][2 + 3 * g] for i in idx], color=c, ls="--", label=f"G5_{g+1} TC")
    ax.set(title=f"T = {lo} to {hi} s", xlabel="time (s)", ylabel="Temperature (°C)", xlim=(lo, hi))
    ax.grid(alpha=.3)
    ax.legend(loc="center left", bbox_to_anchor=(1, .5), fontsize=8)
fig.tight_layout()
fig.savefig("report_charts.png", dpi=150)
