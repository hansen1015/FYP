import openpyxl, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

rows = list(openpyxl.load_workbook("00 Report 14 Oct - 20 Oct.xlsx")["Sheet1"].iter_rows(min_row=3, values_only=True))
rows = [r for r in rows if isinstance(r[0], (int, float))]
t = [r[0] for r in rows]
col = lambda g, k: [r[1 + 3 * g + k] for r in rows]  # k: 0 IR, 1 TC, 2 R

# (lo, hi, reference signal k, file)
CHARTS = [(0, 50, 0, "report_chart_1.png"), (80, 130, 1, "report_chart_2.png"), (150, 200, 2, "report_chart_3.png")]
RISE = 3.0  # degC IR rise above window-start value that marks "start of the rise"
ALIGN = 1.0  # s after window start where every sample's rise is placed
END = 2.0  # s at chart end averaged for normalisation
NAMES = ["IR (°C)", "TC (°C)", "R (Ω)"]

for lo, hi, ref, fname in CHARTS:
    series = []  # per group: shifted time, [IR, TC, R]
    for g in range(5):
        ir = col(g, 0)
        i0 = next(i for i, v in enumerate(t) if v >= lo)
        tc = next(t[i] for i in range(i0, len(t)) if ir[i] > ir[i0] + RISE)
        series.append(([v - tc + lo + ALIGN for v in t], [col(g, k) for k in range(3)]))

    def end_mean(x, y):
        v = [b for a, b in zip(x, y) if hi - END <= a <= hi]
        return sum(v) / len(v)

    ends = [end_mean(x, ys[ref]) for x, ys in series]
    target = sum(ends) / len(ends)

    fig, ax = plt.subplots(figsize=(12, 6))
    ax2 = ax.twinx()
    for g, ((x, ys), e) in enumerate(zip(series, ends)):
        f = target / e  # makes the reference signal end at the same value in every group
        c = f"C{g}"
        ax.plot(x, [v * f for v in ys[0]], color=c)
        ax.plot(x, [v * f for v in ys[1]], color=c, ls="--")
        ax2.plot(x, [v * (f if ref == 2 else 1) for v in ys[2]], color=c, ls=":")
    ax.set(xlim=(lo, hi), xlabel="time (s, each sample shifted so its rise starts at %.0f s)" % (lo + ALIGN),
           ylabel="Temperature (°C, normalised to %s at chart end)" % NAMES[ref].split()[0])
    ax2.set_ylabel("Resistance (Ω)" + (", normalised" if ref == 2 else ""))
    ax.set_title(f"T = {lo} to {hi} s")
    ax.grid(alpha=.3)
    h = [Line2D([], [], color=f"C{g}", label=f"G5_{g+1}") for g in range(5)]
    h += [Line2D([], [], color="k", ls=s, label=n) for s, n in (("-", "IR"), ("--", "TC"), (":", "Resistance"))]
    ax.legend(handles=h, loc="center left", bbox_to_anchor=(1.1, .5))
    fig.tight_layout()
    fig.savefig(fname, dpi=150)
