"""One power-law fit for all data: ln R = c0 + a ln(dR/dt) + b ln(R0) + c ln(P) + d*T (T real C), old runs (100 % PWM pulse, before + after
recovery, R at real 69.39 / 82.27 C) plus S1 (800 mW pulse, measured P, R at real 50/60/70 C). Reports pooled error, the group shifts that stay, and how
well a fit to the old runs alone predicts S1."""
import itertools, os
import numpy as np, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
OLD = os.path.join(HERE, "..", "..", "IR+T_Couple+reist 16 Oct", "output (26-10-27)")
rows = []
for g in ("before", "after"):
    d = pd.read_csv(os.path.join(OLD, f"prediction_{g}_recovery.csv"))
    for _, r in d.iterrows():
        for k, T in ((60, 69.39), (70, 82.27)):
            rows.append(dict(group=g, sample=r["sample"], drdt=r.dR_dt_ohm_s, R0=r.initial_resistance_ohm, P=r.power_at_100pct_pwm_mW, T=T, R=r[f"actual_R{k}_ohm"]))
s1 = pd.read_csv(os.path.join(HERE, "gather_data.csv")); s1 = s1[s1["sample"] == "S1"]
for _, r in s1.iterrows():
    for T in (50, 60, 70):
        rows.append(dict(group="S1", sample="S1", drdt=r.dR_dt_ohm_s, R0=r.initial_resistance_ohm, P=r.pulse_power_measured_mW, T=T, R=r[f"actual_R{T}_ohm"]))
d = pd.DataFrame(rows); y = np.log(d.R.to_numpy())
F = {"dRdt": np.log(d.drdt), "R0": np.log(d.R0), "P": np.log(d.P), "T": d["T"]}
old, new = (d.group != "S1").to_numpy(), (d.group == "S1").to_numpy()
def fit(X, y): return np.linalg.lstsq(X, y, rcond=None)[0]
def design(names, extra=()): return np.column_stack([np.ones(len(d))] + [F[n] for n in names] + list(extra))
print(f"{'inputs':22s} {'exponents / coeff':34s} {'rms %':>6s} {'S1 shift %':>10s} {'after shift %':>13s} | {'old-only fit -> S1: bias %':>26s}")
res = {}
for names in (["T"], ["R0", "T"], ["dRdt", "T"], ["dRdt", "R0", "T"], ["dRdt", "P", "T"], ["R0", "P", "T"], ["dRdt", "R0", "P", "T"]):
    X = design(names); b = fit(X, y); rms = np.std(y - X @ b) * 100
    sh = fit(design(names, [(d.group == "S1").astype(float), (d.group == "after").astype(float)]), y)
    bo = fit(X[old], y[old]); bias = ((X[new] @ bo) - y[new]).mean() * 100
    print(f"{','.join(names):22s} {np.round(b[1:], 3)!s:34s} {rms:6.1f} {sh[-2] * 100:10.1f} {sh[-1] * 100:13.1f} | {bias:26.1f}")
    res[tuple(names)] = b
# the same, model with S1's shift allowed away: what does a free shift buy?
names = ["dRdt", "R0", "T"]; X = design(names)
print("\nfitting only the old runs, T slope:", round(fit(X[old], y[old])[-1] * 100, 2), "%/C;  S1 alone, T slope:", round(np.polyfit(d["T"][new], y[new], 1)[0] * 100, 2), "%/C")
b = res[("dRdt", "R0", "T")]; pred = np.exp(design(names) @ b)
fig, ax = plt.subplots(figsize=(7, 6.5)); col = {"before": "C0", "after": "C3", "S1": "k"}
for g in ("before", "after", "S1"):
    k = (d.group == g).to_numpy(); ax.scatter(d.R[k], pred[k], c=col[g], marker="*" if g == "S1" else "o", s=120 if g == "S1" else 30, alpha=.75, label=g)
lim = [d.R.min() - 20, d.R.max() + 20]; ax.plot(lim, lim, "k--", lw=1)
ax.set_xlabel("Actual R (Ω)"); ax.set_ylabel("Fitted R (Ω)"); ax.grid(alpha=.3); ax.legend()
ax.set_title("R = c · dRdt^%.2f · R0^%.2f · exp(%.4f T), one fit for everything" % (b[1], b[2], b[3]))
fig.tight_layout(); fig.savefig(os.path.join(HERE, "fit_search_all_data.png"), dpi=140)

for names in (["dRdt", "R0", "T"], ["R0", "T"]):
    X = design(names); b = fit(X, y); e = np.exp(X @ b) - d.R.to_numpy(); tc = b[-1]
    print(f"\n{names}: L1 {np.abs(e).mean():.0f} ohm = {np.mean(np.abs(e) / (d.R.to_numpy() * tc)):.1f} C (all), S1 only L1 {np.abs(e[new]).mean():.0f} ohm; after-recovery bias {e[(d.group == 'after').to_numpy()].mean():+.0f} ohm, before {e[(d.group == 'before').to_numpy()].mean():+.0f} ohm")
    print("  coefficients (c0, exponents..., per C):", np.round(b, 4), " c = %.3g" % np.exp(b[0]))
