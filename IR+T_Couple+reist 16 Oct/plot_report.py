import openpyxl, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

rows = list(openpyxl.load_workbook("00 Report 14 Oct - 20 Oct.xlsx")["Sheet1"].iter_rows(min_row=3, values_only=True))
rows = [r for r in rows if isinstance(r[0], (int, float))]
t = [r[0] for r in rows]
col = lambda g, k: [r[1 + 3 * g + k] for r in rows]  # k: 0 IR, 1 TC, 2 R

# (lo, hi, reference signal k, file)
CHARTS = [(0, 50, 0, "report_chart_1.png"), (80, 130, 1, "report_chart_2.png"), (150, 200, 2, "report_chart_3.png")]
END = 2.0  # s at chart end averaged for normalisation
LABELS = ["IR temperature (°C)", "Thermocouple temperature (°C)", "Resistance (Ω)"]

for lo, hi, ref, fname in CHARTS:
    idx = [i for i, v in enumerate(t) if lo <= v <= hi]
    x = [t[i] for i in idx]
    data = [[[col(g, k)[i] for i in idx] for k in range(3)] for g in range(5)]
    ends = [sum(d[ref][-int(END / 0.2):]) / int(END / 0.2) for d in data]
    target = sum(ends) / len(ends)

    fig, axes = plt.subplots(3, 1, figsize=(11, 12), sharex=True)
    for k, ax in enumerate(axes):
        for g, (d, e) in enumerate(zip(data, ends)):
            f = target / e if (k != 2 or ref == 2) else 1  # R is only scaled when it is the reference
            ax.plot(x, [v * f for v in d[k]], color=f"C{g}", label=f"G5_{g+1}")
        ax.set(xlim=(lo, hi), ylabel=LABELS[k] + (", normalised" if k != 2 or ref == 2 else ""))
        ax.grid(alpha=.3)
    axes[0].set_title(f"T = {lo} to {hi} s  (each sample normalised to {LABELS[ref].split()[0]} at chart end)")
    axes[-1].set_xlabel("time (s)")
    axes[0].legend(loc="center left", bbox_to_anchor=(1.01, .5))
    fig.tight_layout()
    fig.savefig(fname, dpi=150)
