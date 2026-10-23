"""dr runs: for each 100% PWM pulse, fit dR/dt and dIR/dt over the pulse and divide by mean electrical power."""
import glob, numpy as np, pandas as pd

rows = []
for f in sorted(glob.glob("G5-*_dr_*.csv")):
    d = pd.read_csv(f)
    on = (d.pwm_pct >= 99.9).to_numpy()
    grp = np.cumsum(np.diff(on.astype(int), prepend=0) == 1)  # pulse index
    for k in np.unique(grp[on]):
        p = d[on & (grp == k)]
        dur = p.time_s.iloc[-1] - p.time_s.iloc[0]
        if p.time_s.iloc[0] < 10 or dur > 5:  # skip start-up 100% and anything not a 2 s pulse
            continue
        t = p.time_s.to_numpy()
        pw = (p.voltage_V * p.current_mA).mean()  # mW
        dR = np.polyfit(t, p.resistance_ohm, 1)[0]
        dT = np.polyfit(t, p.ir_C, 1)[0]
        rows.append(dict(sample=f.split("_")[0], pulse=len(rows) and sum(r["sample"] == f.split("_")[0] for r in rows) + 1 or 1,
                         t_start_s=t[0], duration_s=dur, ir_start_C=p.ir_C.iloc[0], R_start_ohm=p.resistance_ohm.iloc[0],
                         power_mW=pw, dR_dt_ohm_s=dR, dIR_dt_C_s=dT,
                         dR_dt_per_power=dR / pw, dIR_dt_per_power=dT / pw))
out = pd.DataFrame(rows)
out.round(5).to_csv("dr_pulses.csv", index=False)
print(out.round(3).to_string())
