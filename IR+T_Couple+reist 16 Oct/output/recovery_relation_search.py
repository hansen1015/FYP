"""Find f(dR/dt, R0, P) that puts before- and after-recovery runs on one curve.
Model: ln R = c0 + a ln(dRdt) + b ln(R0) + c ln(P) (+ g*after). Good = pooled fit with g ~ 0 and train-on-before -> test-on-after error small."""
import numpy as np, pandas as pd, itertools
d = pd.concat([pd.read_csv(f).assign(after=i) for i, f in enumerate(["prediction_before_recovery.csv", "prediction_after_recovery.csv"])], ignore_index=True)
L = np.log(d[["dR_dt_ohm_s", "initial_resistance_ohm", "power_at_100pct_pwm_mW"]].to_numpy())
def fit(X, y): return np.linalg.lstsq(X, y, rcond=None)[0]
def feats(cols, m=None): return np.column_stack([np.ones(len(d))] + [L[:, c] for c in cols])
sets = {"dRdt": [0], "R0": [1], "P": [2], "dRdt,R0": [0, 1], "dRdt,P": [0, 2], "R0,P": [1, 2], "dRdt,R0,P": [0, 1, 2]}
b, a = d.after == 0, d.after == 1
for col in ("actual_R60_ohm", "actual_R70_ohm"):
    y = np.log(d[col].to_numpy()); print(f"\n== {col}  (ln-ln fit; g = shift of 'after' in % at same inputs)")
    print(f"{'inputs':12s} {'exps':26s} {'pooled rms%':>11s} {'g %':>6s} {'train-before->after bias %':>27s} {'rms %':>6s}")
    for k, cols in sets.items():
        X = feats(cols); beta = fit(X, y); rms = np.std(y - X @ beta) * 100
        g = fit(np.column_stack([X, d.after]), y)[-1] * 100
        tb = fit(X[b], y[b]); e = (X[a] @ tb - y[a]) * 100
        print(f"{k:12s} {np.round(beta[1:], 2)!s:26s} {rms:11.1f} {g:6.1f} {e.mean():27.1f} {np.sqrt((e**2).mean()):6.1f}")

# R = a*ln(dRdt^u * R0^p * P^q) + b  (u in {1,0}: u=0 means only R0,P), grid over p,q; shared curve, rms and 'after' shift in ohm
print("\n== shared log curve, best exponents (rms ohm of pooled fit; shift = 'after' offset in ohm; unit-free: dRdt exponent fixed 1)")
for col in ("actual_R60_ohm", "actual_R70_ohm"):
    y = d[col].to_numpy(); out = []
    for p, q in itertools.product(np.arange(-4, 4.01, .25), repeat=2):
        z = L[:, 0] + p * L[:, 1] + q * L[:, 2]
        X = np.column_stack([np.ones(len(d)), z]); r = y - X @ fit(X, y)
        s = fit(np.column_stack([X, d.after]), y)[-1]
        tb = fit(X[b], y[b]); e = X[a] @ tb - y[a]
        out.append((np.sqrt((r**2).mean()), p, q, s, np.sqrt((e**2).mean())))
    out.sort(); print(col, " rms  R0exp  Pexp  shift  before->after rms")
    for o in out[:4]: print("  ", np.round(o, 2))
    base = [o for o in out if o[1] == 1 and o[2] == -1][0]; print("   current (R0^1,P^-1):", np.round(base, 2))
