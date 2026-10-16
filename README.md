# FYP — Joule-heated self-folding structures

Final-year project: self-folding (kirigami / hinge) structures printed in conductive PLA and
folded by Joule heating. This repo holds the controller firmware, lab tooling, and CAD / print files.

## Layout

| Folder | What it is |
|---|---|
| [hansen_thermocouple/](hansen_thermocouple) | ESP32-C3 SuperMini firmware: 5× MAX6675 thermocouples driving 5 PWM heaters with per-channel PID, plus `thermocouple_gui.py`, a Tk/matplotlib live plot and control panel. Serial protocol is documented at the top of `src/main.cpp`. |
| [hansen_esp/](hansen_esp) | ESP32-S3 SuperMini firmware: INA3221 current/voltage + GY-906 (MLX90614) IR temperature, MOSFET heater on GPIO8. `tools/live_plot.py` plots temperature vs resistance and logs CSV. Sample logs included. |
| [resistance_hold/](resistance_hold) | Arduino sketch that holds a target heater resistance with PID on a MOSFET. |
| [Joule heater code/](<Joule heater code>) | Early prototyping: Python `pid.py` / `pwm.py`, plotting and CSV scripts, and the `tempgraph9-allheat` Arduino sketch. |
| [Joule heater print files/](<Joule heater print files>) | Heater design iterations V0–V12 (STL / 3MF) and sliced gcode. |
| [Zhi Rong finger designs/](<Zhi Rong finger designs>) | Finger/hinge CAD (SolidWorks + STEP) and conductive-PLA resistance log. |

## Getting started

Firmware uses [PlatformIO](https://platformio.org/):

```bash
cd hansen_thermocouple   # or hansen_esp
pio run -t upload
pio device monitor       # 115200 baud
```

Host tools:

```bash
python3 -m venv venv && source venv/bin/activate
pip install pyserial matplotlib numpy
python hansen_thermocouple/thermocouple_gui.py
python hansen_esp/tools/live_plot.py
```

(`tkinter` must be installed system-wide, e.g. `sudo apt install python3-tk`.)

## Notes

- Pin assignments, shunt resistor value (`SHUNT_RESISTANCE_OHMS`) and PID gains are specific to my
  hardware — check them before flashing your own board.
- Heaters carry real power at up to 24 V; be careful with unattended heating.
