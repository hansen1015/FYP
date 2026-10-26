"""Like dr_scatter_R60_30-40C, but with log best-fit curve (R² in y space)."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

d = pd.read_csv("dr_candidates.csv"); d["R60_ohm"] = pd.read_csv("dr_candidates_over_R60.csv").R60_ohm
d = d[d.ir_C < 41]; y = d.R60_ohm.values; sst = ((y - y.mean()) ** 2).sum()
def fits(xd):  # each returns a predictor fitted on the data xd
    l, e, p, g = (np.polyfit(xd, y, 1), np.polyfit(xd, np.log(y), 1),
                  np.polyfit(np.log(xd), np.log(y), 1), np.polyfit(np.log(xd), y, 1))
    return {"linear": lambda x: np.polyval(l, x), "exponential": lambda x: np.exp(np.polyval(e, x)),
            "power": lambda x: np.exp(np.polyval(p, np.log(x))), "log": lambda x: np.polyval(g, np.log(x))}
fig, axs = plt.subplots(3, 3, figsize=(15, 12))
for ax, k in zip(axs.flat, d.columns[9:-1]):
    for n, g in d.groupby("sample"):
        ax.scatter(g[k], g.R60_ohm, label=n, zorder=3)
    x = np.linspace(d[k].min(), d[k].max(), 200)
    f = fits(d[k].values)["log"]
    ax.plot(x, f(x), "k", lw=1.2, label=f"log fit R²={1 - ((y - f(d[k].values)) ** 2).sum() / sst:.2f}")
    ax.set_title(f"{k}  (log fit R² = {1 - ((y - f(d[k].values)) ** 2).sum() / sst:.2f})")
    ax.set_xlabel(k); ax.set_ylabel("R at 60 °C (Ω)"); ax.grid(alpha=.3)
axs[0, 0].legend(fontsize=8); fig.tight_layout(); fig.savefig("dr_scatter_R60_log_30-40C.png", dpi=130)
