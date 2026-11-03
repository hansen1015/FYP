# IR + Resistance + Power control (3 Nov)

Power-controlled version of the 16 Oct prediction GUI. Nothing is driven by a typed PWM %: the heater is always run by a PID. No thermocouple.

- [esp_board/](esp_board): firmware, PID inputs 0 = IR, 1 = resistance, 2 = electrical power (mW, V*I from the INA3221). `src 2`, `sp 2 <mW>`, `pid 2 kp ki kd`. Flash: `~/.platformio/penv/bin/pio run -t upload` from that folder.
- [gui_test_power.py](gui_test_power.py): one-file GUI + prediction test. R0 at ~1 mW (power PID, minimum duty), then a 2 s pulse at a constant 300 mW (`P_PULSE_MW`) for dR/dt, P = 300 in x = dR/dt*R0/P, then resistance PID hold at the predicted R, then IR holds. "Set to [temp] C" box. Output goes to `output/prediction.csv` here.

The R(T) fit is still the old one (100 % PWM pulse, measured P): refit on rows from this GUI before trusting it.
Power PID defaults Kp 0.3 %/mW, Ki 0.5 %/(mW s) are a first guess, untuned.

Run: `python gui_test_power.py` (from the FYP venv, or /usr/bin/python3).
