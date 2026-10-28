"""MSE / L1 (MAE) of the ln fits in recovery_R60_R70_vs_RdRdtP.png, vs always guessing the mean (in-sample)."""
import numpy as np, pandas as pd
d = pd.concat([pd.read_csv(f).assign(g=g) for g, f in (("before", "prediction_before_recovery.csv"), ("after", "prediction_after_recovery.csv"))], ignore_index=True)
d["x"] = d.dR_dt_ohm_s * d.initial_resistance_ohm / d.power_at_100pct_pwm_mW; lx = np.log(d.x)
rows = []
for deg in (60, 70):
    y = d[f"actual_R{deg}_ohm"]; p = np.polyval(np.polyfit(lx, y, 1), lx); base = pd.Series(y.mean(), index=y.index)
    pg = pd.Series(index=y.index, dtype=float)
    for g in ("before", "after"): k = d.g == g; pg[k] = np.polyval(np.polyfit(lx[k], y[k], 1), lx[k])
    for name, pr in (("combined ln fit (the graph)", p), ("separate fit per group", pg), ("just the mean", base)):
        for grp, k in (("all", d.g != ""), ("before", d.g == "before"), ("after", d.g == "after")):
            e = (pr - y)[k]; rows.append((deg, name, grp, (e**2).mean(), np.sqrt((e**2).mean()), e.abs().mean(), e.mean()))
r = pd.DataFrame(rows, columns=["T", "model", "set", "MSE", "RMSE", "L1", "bias"]).round(1)
print(r.to_string(index=False))
