# IR + Resistance + Power control (3 Nov)

Power-controlled version of the 16 Oct prediction GUI. Nothing is driven by a typed PWM %: the heater is always run by a PID.

- [esp_board/](esp_board): firmware from 16 Oct plus PID input 3 = electrical power (mW, V*I from the INA3221). `src 3`, `sp 3 <mW>`, `pid 3 kp ki kd`. Flash it first (`pio run -t upload`), the old firmware has no `src 3`.
- [gui.py](gui.py): base GUI, 4 PID inputs (IR, thermocouple, resistance, power), no manual PWM row. Script inputs: `ir | tc | res | pow`.
- [gui_test_power.py](gui_test_power.py): the prediction test. R0 at ~1 mW (power PID, minimum duty), then a 2 s pulse at a constant 300 mW (`P_PULSE_MW`) for dR/dt, P = 300 in x = dR/dt*R0/P, then resistance PID hold at the predicted R, then IR holds. Same "Set to [temp] C" box. Output goes to `output/prediction.csv` here.

The R(T) fit inside gui_test_power.py is still the old one (100 % PWM pulse, measured P): refit on rows from this GUI before trusting it.
Power PID defaults Kp 0.3 %/mW, Ki 0.5 %/(mW s), Kd 0 are a first guess, untuned.

Run: `python gui_test_power.py` (from the FYP venv, or /usr/bin/python3).
