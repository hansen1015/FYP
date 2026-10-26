"""Search log-linear models R60 ~ f(R_start, power, dR/dt, steady power); score by leave-one-sample-out error."""
import itertools, numpy as np, pandas as pd
d = pd.read_csv("dr_candidates_over_R60.csv")
ss = pd.read_csv("steady_state.csv"); ss = ss[ss.source == "dr"].reset_index(drop=True)
d["Pss"] = ss.power_mW; d["Rss"] = ss.resistance_ohm
F = {"R": d.Rss, "Ppulse": d.power_mW, "dRdt": d.dR_dt_ohm_s, "Pss": d.Pss}
y = np.log(d.R60_ohm.values); S = d["sample"].values

def design(names, df):
    return np.column_stack([np.ones(len(df))] + [np.log(F[n].loc[df.index]) for n in names])

res = []
for r in range(1, 4):
    for names in itertools.combinations(F, r):
        err = []
        for s in np.unique(S):
            tr, te = d[S != s], d[S == s]
            b = np.linalg.lstsq(design(names, tr), np.log(tr.R60_ohm), rcond=None)[0]
            err.append(np.exp(design(names, te) @ b).mean() / te.R60_ohm.iloc[0] - 1)  # per-sample mean prediction
        b = np.linalg.lstsq(design(names, d), y, rcond=None)[0]
        res.append((np.sqrt(np.mean(np.square(err))) * 100, names, b, dict(zip(np.unique(S), np.round(np.array(err) * 100, 1)))))
for e, n, b, per in sorted(res, key=lambda x: x[0]):
    print(f"LOSO rmse {e:5.1f}%  {n}  coef {np.round(b, 2)}  per-sample err% {per}")
