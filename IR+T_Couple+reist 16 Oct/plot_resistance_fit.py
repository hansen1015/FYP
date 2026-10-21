import csv, glob, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

D = "output (26-10-20)"
names, R40, Y = [], [], []
for f in sorted(glob.glob(f"{D}/G5-[1-4]_*.csv")):  # G5-5 left out as an outlier
    a = np.array([[float(x[k]) for k in ("time_s", "resistance_ohm", "pwm_pct", "voltage_V", "current_mA")] for x in csv.DictReader(open(f))])
    w = a[(a[:, 0] >= 39) & (a[:, 0] <= 41)]
    d = a[(a[:, 0] >= 150) & (a[:, 0] <= 153) & (a[:, 2] == 100)]  # PWM 100% ramp
    P = d[:, 3] * d[:, 4] / 1000
    k = P > 0.05  # drop the first 0 V / 0 mA reading after the PWM jump
    names.append(f.split("/")[-1][:4]); R40.append(w[:, 1].mean())
    Y.append(np.polyfit(d[:, 0], d[:, 1], 1)[0] / P[k].mean())
R40, Y = np.array(R40), np.array(Y)
m, b = np.polyfit(R40, Y, 1)
r2 = np.corrcoef(R40, Y)[0, 1] ** 2
for n, r, y in zip(names, R40, Y):
    print(f"{n}  R40={r:.1f}  (dR/dt)/P={y:.0f}  ratio={y/r:.3f}")
print(f"fit: y = {m:.3f}*R {b:+.1f}, R^2={r2:.2f}")

fig, ax = plt.subplots(figsize=(7, 5))
ax.scatter(R40, Y, color=[f"C{i}" for i in range(len(names))], zorder=3)
for n, r, y in zip(names, R40, Y):
    ax.annotate(n, (r, y), textcoords="offset points", xytext=(6, -12))
xs = np.array([R40.min() - 10, R40.max() + 10])
ax.plot(xs, m * xs + b, "k--", label=f"y = {m:.3f}·R {b:+.1f}   (R² = {r2:.2f})")
ax.set(xlabel="Resistance at T ≈ 40 s (Ω)", ylabel="(dR/dt) / P at PWM 100%  (Ω/s/W)")
ax.grid(alpha=.3); ax.legend()
fig.tight_layout(); fig.savefig("resistance_fit.png", dpi=150)
