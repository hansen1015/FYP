# IR + Thermocouple + Resistance (16 Oct)

One GUI that reads two boards and runs a heater PID on any of three inputs.

| Part | What it does |
|---|---|
| [esp_board/](esp_board) | ESP32-S3 SuperMini. INA3221 resistance (ch3), GY-906 IR temperature, MOSFET heater PWM on GPIO8, PID. |
| [thermocouple_board/](thermocouple_board) | ESP32-C3 SuperMini. Reads MAX6675 thermocouple 1 only (SCK 5, SO 6, CS1 20). No heaters. |
| [gui.py](gui.py) | Tk/matplotlib GUI: live readouts (IR, thermocouple, resistance, voltage, current, PWM) and plots, PID settings, CSV + screenshot. |

Both boards print one line every 200 ms. The GUI forwards the thermocouple value to the ESP board
(`tc <degC>`), so the PID can use it as an input.

## Run

```bash
# flash each board (from its own folder)
cd esp_board && pio run -t upload
cd ../thermocouple_board && pio run -t upload

# GUI (pyserial, matplotlib, tkinter)
source ../venv/bin/activate        # from the FYP root: venv/bin/activate
python gui.py
```

Pick a port for each board, press **Connect**. Open order doesn't matter. The ports are remembered.

## Heater control

- **PID input**: choose IR temp, thermocouple or resistance. Each input has its own setpoint, Kp, Ki, Kd.
  Only one PID runs at a time, on the selected input.
- **Enable PID**: ticked = PID drives the heater. Unticked = manual. It always starts unticked.
- **Apply PID (all inputs)** sends all three sets of values to the board (Enter in a field does too).
- **Manual PWM %**: anything from 0 < x < 2 is raised to 2 %; exactly 0 is a real off. Setting it turns the PID off. **ALL OFF** = PID off, PWM 0.
- Heat when PV < setpoint: `out% = Kp*e + Ki*∫e + Kd*(-dPV/dt)`, `e = SP - PV`, output 0–100 %.

## Target script

**Script…** opens a JSON editor (Open / Save / **Run script** / Stop). It steps the PID target over
time, switching the PID input per segment. Example ([scripts/example.json](scripts/example.json)):

```json
{"segments": [
  {"start": 0,    "end": 1,  "input": "ir", "target": 30},
  {"start": 1.1,  "end": 10, "input": "ir", "target": 50},
  {"start": 10.1, "end": 20, "input": "tc", "target": 30}
]}
```

- Times are seconds from pressing Run. `input` is `ir`, `tc` or `res`. Targets are flat steps (no ramps).
- The Kp/Ki/Kd of each input come from the fields in the main window. The script sets only the SP and the input.
- A gap between segments keeps the previous target. After the last `end` the PID stops and the heater turns off.
- Temperature targets above 79 °C are rejected. The ESP board must be connected.
- Run clears the graph and CSV history first. When the script ends, for any reason, the CSV + screenshot are saved automatically (see Saving).
- Stop, ALL OFF, unticking Enable PID, setting a manual PWM, or an ESP disconnect all end the script.
- The editor text is remembered in `gui_settings.json`. While running, the SP field of the active input shows the script target.

## Safety

- IR >= 80 °C forces the heater off in every mode (needs a working IR sensor).
- The heater is 0 at boot. The GUI sends a heartbeat every 200 ms; if the board hears nothing for
  2 s it turns the PID off and the PWM to 0.
- PID on the thermocouple: no thermocouple update for 3 s (open probe, board unplugged) = heater off.
- The output never goes below 2 % in PID mode or manual mode (except an explicit 0), so the resistance
  can still be measured. The safety cases above (80 °C, no PC, lost sensor) always give 0.

## Saving

- **Save CSV + screenshot** writes `output/<serial>_YYYY-MM-DD_HH-MM-SS.csv` and `.png` (the **Serial no.** box; the name is just the timestamp if it is empty, and the CSV has a `serial_number` column) (plot area only).
  The CSV covers everything since the last **Clear graph**.
- PID inputs, setpoints, gains, ports and plot window are saved in `gui_settings.json` and restored
  on the next start. Nothing is stored on the boards.

## Serial protocol (115200)

ESP board out: `DATA <ms> <V> <mA> <mW> <ohm> <ambient C> <IR C> <pwm %> <pid 0/1> <src 0-2>`
ESP board in: `pwm <0-100>`, `auto <0|1>`, `src <0-2>`, `sp <src> <v>`, `pid <src> <kp> <ki> <kd>`,
`tc <degC>`, `hb`, `get`. Thermocouple board out: `TC1: 24.50` or `TC1: NC`.
`src`: 0 = IR, 1 = thermocouple, 2 = resistance.

## Notes

- Shunt resistor (7.9 Ω), pins and the 80 °C limit are in `esp_board/src/main.cpp`.
- Resistance is only valid while current flows through the heater; it can be noisy with PWM.
- Everything runs at 200 ms. The MAX6675 converts in 0.17-0.22 s, so a thermocouple value can occasionally repeat.
