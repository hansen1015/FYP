"""Steady-state R and power vs IR temp: dr = last 10 s before each pulse, R2 = t 185-195 s (IR=60 C)."""
import sys, glob, pandas as pd, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
SUF = "_noG5-1" if "--no-g51" in sys.argv else ""  # --no-g51: exclude G5-1, suffix outputs

pulses = pd.read_csv("dr_pulses.csv")
rows = []
def add(n, src, w):
    rows.append(dict(sample=n, source=src, ir_C=w.ir_C.mean(), ir_sd=w.ir_C.std(), resistance_ohm=w.resistance_ohm.mean(),
                     power_mW=(w.voltage_V * w.current_mA).mean()))
for f in sorted(glob.glob("G5-*_dr_*.csv")):
    n = f.split("_")[0]
    if SUF and n == "G5-1": continue
    d = pd.read_csv(f)
    for t0 in pulses[pulses["sample"] == n].t_start_s:
        add(n, "dr", d[(d.time_s >= t0 - 10.5) & (d.time_s < t0 - 0.5)])
for f in sorted(glob.glob("G5-*_R2_*.csv")):
    n = f.split("_")[0]
    if SUF and n == "G5-1": continue
    d = pd.read_csv(f)
    add(n, "R2", d[(d.time_s >= 185) & (d.time_s <= 195)])
out = pd.DataFrame(rows)
out["R_norm"] = out.resistance_ohm / out.groupby("sample").resistance_ohm.transform("first")  # first row = dr 30 C
out.round(4).to_csv(f"steady_state{SUF}.csv", index=False)
print(out.groupby("source").ir_sd.max())  # steady-state check

for col, lab, fn in [("resistance_ohm", "Resistance (Ω)", "steady_R_vs_IR"), ("power_mW", "Power (mW)", "steady_power_vs_IR"),
                        ("R_norm", "R / R(30 °C)", "steady_Rnorm_vs_IR")]:
    fig, ax = plt.subplots(figsize=(8, 6))
    for i, (n, g) in enumerate(out.groupby("sample")):
        c = f"C{i if not SUF else i + 1}"
        ax.plot(g.ir_C, g[col], "o-", c=c, label=n, ms=5)
    ax.set_xlabel("Temp (°C)"); ax.set_ylabel(lab); ax.grid(alpha=.3); ax.legend()
    fig.tight_layout(); fig.savefig(f"{fn}{SUF}.png", dpi=140)
