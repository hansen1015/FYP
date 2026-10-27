"""Graph of the fitted exponents (recovery_relation_search.py) + a small-ANN check. colour = group, marker = sample."""
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from sklearn.neural_network import MLPRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.model_selection import KFold, cross_val_predict

d = pd.concat([pd.read_csv(f).assign(after=i) for i, f in enumerate(["prediction_before_recovery.csv", "prediction_after_recovery.csv"])], ignore_index=True)
L = np.log(d[["dR_dt_ohm_s", "initial_resistance_ohm", "power_at_100pct_pwm_mW"]].to_numpy())
marks = dict(zip(sorted(d["sample"].unique()), "osD^v")); col = ["C0", "C3"]
def pts(ax, x, y):
    for g in (0, 1):
        for n, m in marks.items():
            k = (d.after == g) & (d["sample"] == n); ax.scatter(x[k], y[k], c=col[g], marker=m, s=40, zorder=3)
    for g, l in enumerate(("before recovery", "after recovery")): ax.scatter([], [], c=col[g], label=l)

fig, axs = plt.subplots(2, 2, figsize=(12, 9))
for r, deg in enumerate((60, 70)):
    y = d[f"actual_R{deg}_ohm"].to_numpy()
    # (a) shared log curve R = a ln(dRdt * R0^4 * P^-1.25) + b
    z = L[:, 0] + 4 * L[:, 1] - 1.25 * L[:, 2]; ax = axs[r, 0]; pts(ax, z, y)
    c = np.polyfit(z, y, 1); xs = np.linspace(z.min(), z.max(), 100); ax.plot(xs, np.polyval(c, xs), "k", label=f"one shared curve: {c[0]:.0f}·ln(x) {c[1]:+.0f}")
    ax.set_xlabel("ln( dR/dt · R0^4 · P^-1.25 )"); ax.set_ylabel(f"Actual R at {deg} °C (Ω)"); ax.set_title("best shared log curve"); ax.legend(fontsize=8); ax.grid(alpha=.3)
    # (b) power law fitted on all data: predicted vs actual
    X = np.column_stack([np.ones(len(d)), L]); p = np.exp(X @ np.linalg.lstsq(X, np.log(y), rcond=None)[0]); ax = axs[r, 1]; pts(ax, y, p)
    ax.plot([y.min(), y.max()], [y.min(), y.max()], "k--", lw=1, label="1:1"); ax.set_xlabel(f"Actual R{deg} (Ω)"); ax.set_ylabel("Predicted (Ω)")
    ax.set_title("power law R = c·dRdt^0.16·R0^0.63·P^-0.21" if deg == 60 else "power law (own exponents)"); ax.legend(fontsize=8); ax.grid(alpha=.3)
fig.tight_layout(); fig.savefig("recovery_fitted_exponents.png", dpi=130)

# ANN: inputs ln dRdt, ln R0, ln P (no group label) -> R60. Average of 5 seeds.
def ann(seed): return make_pipeline(StandardScaler(), MLPRegressor(hidden_layer_sizes=(8,), alpha=1e-2, max_iter=5000, random_state=seed))
def fitpred(tr, te, y):
    m, sd = y[tr].mean(), y[tr].std()  # scale the target: MLP outputs start near 0
    return m + sd * np.mean([ann(s).fit(L[tr], (y[tr] - m) / sd).predict(L[te]) for s in range(5)], axis=0)
y = d.actual_R60_ohm.to_numpy(); b, a = (d.after == 0).to_numpy(), (d.after == 1).to_numpy()
pa = fitpred(b, a, y); print("ANN train before -> test after: bias", round((pa - y[a]).mean(), 1), "ohm, rms", round(np.sqrt(((pa - y[a]) ** 2).mean()), 1))
pb = fitpred(a, b, y); print("ANN train after -> test before: bias", round((pb - y[b]).mean(), 1), "ohm, rms", round(np.sqrt(((pb - y[b]) ** 2).mean()), 1))
pk = np.zeros(len(d))
for tr, te in KFold(5, shuffle=True, random_state=0).split(L): pk[te] = fitpred(tr, te, y)
print("ANN pooled 5-fold (random): rms", round(np.sqrt(((pk - y) ** 2).mean()), 1), "ohm; after-group bias", round((pk - y)[a].mean(), 1), "before-group bias", round((pk - y)[b].mean(), 1))
print("reference: group means differ by", round(y[a].mean() - y[b].mean(), 1), "ohm; std of y", round(y.std(), 1))
