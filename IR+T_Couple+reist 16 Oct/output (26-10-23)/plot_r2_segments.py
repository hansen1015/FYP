"""R2 runs: IR 60 C segment (t=100-200 s) and TC 55 C segment (t=300-400 s), from 3 s before the jump."""
import sys
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs
import glob, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

def plot(col, label, t0, t1, out):
    fig, (a, b, c) = plt.subplots(3, 1, sharex=True, figsize=(10, 10))
    rows = []
    for f in sorted(glob.glob("G5-*_R2_*.csv")):
        if SUF and "G5-1" in f:
            continue
        d = pd.read_csv(f)
        d = d[(d.time_s >= t0 - 3) & (d.time_s <= t1)]
        n = f.split("_")[0]
        d = d.assign(sample=n, t_rel_s=d.time_s - t0, R_norm=d.resistance_ohm / d.resistance_ohm.iloc[0])  # R at window start (3 s before jump)
        rows.append(d[["sample", "t_rel_s", "ir_C", "thermocouple_C", "resistance_ohm", "R_norm"]])
        a.plot(d.t_rel_s, d[col], label=n)
        b.plot(d.t_rel_s, d.resistance_ohm, label=n)
        c.plot(d.t_rel_s, d.R_norm, label=n)
    a.set_ylabel(f"{label} temp (°C)"); b.set_ylabel("Resistance (Ω)"); c.set_ylabel("R / R(t = -3 s)"); c.set_xlabel("Time from jump (s)")
    for ax in (a, b, c): ax.grid(alpha=.3); ax.axvline(0, c="k", ls=":")
    a.legend(); fig.tight_layout(); fig.savefig(out + ".png", dpi=150)
    pd.concat(rows).to_csv(out + ".csv", index=False)

plot("ir_C", "IR", 100, 200, "R2_IR60_segment" + SUF)
plot("thermocouple_C", "TC", 300, 400, "R2_TC55_segment" + SUF)
