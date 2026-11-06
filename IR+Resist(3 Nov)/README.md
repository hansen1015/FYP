# IR + Resistance + Power control (3 Nov)

Power-controlled version of the 16 Oct prediction GUI. Nothing is driven by a typed PWM %: the heater is always run by a PID. No thermocouple.

- [esp_board/](esp_board): firmware, PID inputs 0 = IR, 1 = resistance, 2 = electrical power (mW, V*I from the INA3221). `src 2`, `sp 2 <mW>`, `pid 2 kp ki kd`. Flash: `~/.platformio/penv/bin/pio run -t upload` from that folder.
- [gui_test_power.py](gui_test_power.py): one-file GUI, PWM based like the 16 Oct one. **Gather data** (needs a serial no.): R0 at 5 % PWM (`R0_PWM`), a 2 s pulse at 100 % PWM (`PULSE_PWM`) for dR/dt and the mean power, then the IR PID holds 50, 60 and 70 C for 20 s each; one row per run goes to `output/gather_data_pwm.csv` (dR/dt, pulse PWM, R0, measured pulse power, actual R at 50/60/70). No prediction is made. **Set to [temp] C** runs R0, pulse, prediction (x = dR/dt*R0/P, P = mean pulse power), then holds the predicted R for 20 s with the resistance PID; nothing recorded. The power PID input (src 2) is still in the control box and the firmware, the tests do not use it.

The R(T) fit is the old one, measured with exactly this protocol (5 % PWM R0, 100 % PWM pulse, measured P).
Power PID defaults Kp 0.3 %/mW, Ki 0.5 %/(mW s) are a first guess, untuned.

Run: `python gui_test_power.py` (from the FYP venv, or /usr/bin/python3).
