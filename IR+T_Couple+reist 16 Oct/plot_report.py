import openpyxl, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

rows = list(openpyxl.load_workbook("00 Report 14 Oct - 20 Oct.xlsx")["Sheet1"].iter_rows(min_row=3, values_only=True))
rows = [r for r in rows if isinstance(r[0], (int, float))]
LABELS = ["IR temperature (°C)", "Thermocouple temperature (°C)", "Resistance (Ω)"]

for n, (lo, hi) in enumerate([(0, 50), (80, 130), (150, 200)], 1):
    win = [r for r in rows if lo <= r[0] <= hi]
    fig, axes = plt.subplots(3, 1, figsize=(11, 12), sharex=True)
    for k, ax in enumerate(axes):
        for g in range(5):
            ax.plot([r[0] for r in win], [r[1 + 3 * g + k] for r in win], color=f"C{g}", label=f"G5_{g+1}")
        ax.set(xlim=(lo, hi), ylabel=LABELS[k])
        ax.grid(alpha=.3)
    axes[0].set_title(f"T = {lo} to {hi} s")
    axes[-1].set_xlabel("time (s)")
    axes[0].legend(loc="center left", bbox_to_anchor=(1.01, .5))
    fig.tight_layout()
    fig.savefig(f"report_chart_{n}.png", dpi=150)
