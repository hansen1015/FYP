#!/usr/bin/env python3
"""
Live viewer for the ESP32-S3 INA3221 + GY-906 firmware.

Reads the board's serial output, shows the latest readings, plots
Object Temperature vs Resistance live, and can save everything to CSV.

Usage:
    python3 tools/live_plot.py
"""

import csv
import queue
import re
import threading
import time
import tkinter as tk
from datetime import datetime
from tkinter import filedialog, messagebox, ttk

import numpy as np
import serial
import serial.tools.list_ports
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure

INA_RE = re.compile(
    r"INA3221 CH3 -> Voltage:\s*([\-\d.]+)\s*V,\s*Current:\s*([\-\d.]+)\s*mA,"
    r"\s*Power:\s*([\-\d.]+)\s*mW,\s*Resistance:\s*([\-\d.a-zA-Z]+)\s*ohm"
)
GY906_RE = re.compile(
    r"GY-906\s*-> Ambient:\s*([\-\d.]+)\s*C,\s*Object:\s*([\-\d.]+)\s*C"
)
HEATER_RE = re.compile(
    r"Heater\s*-> Phase:\s*(\w+),\s*Setpoint:\s*([\-\d.]+)\s*C,\s*PWM:\s*(\d+)/255"
)


def parse_float(text):
    try:
        return float(text)
    except ValueError:
        return float("nan")


class SerialReader(threading.Thread):
    def __init__(self, port, baud, line_queue, status_callback):
        super().__init__(daemon=True)
        self.port = port
        self.baud = baud
        self.line_queue = line_queue
        self.status_callback = status_callback
        self._stop_event = threading.Event()
        self.ser = None

    def stop(self):
        self._stop_event.set()

    def run(self):
        try:
            self.ser = serial.Serial(self.port, self.baud, timeout=1)
        except Exception as exc:
            self.status_callback(f"Failed to open {self.port}: {exc}")
            return

        self.status_callback(f"Connected to {self.port} @ {self.baud}")
        while not self._stop_event.is_set():
            try:
                raw = self.ser.readline()
            except Exception as exc:
                self.status_callback(f"Serial error: {exc}")
                break
            if not raw:
                continue
            line = raw.decode(errors="replace").strip()
            if line:
                self.line_queue.put(line)

        if self.ser and self.ser.is_open:
            self.ser.close()
        self.status_callback("Disconnected")


class App:
    MAX_POINTS_DEFAULT = None  # keep all points; set an int to cap for perf

    def __init__(self, root):
        self.root = root
        self.root.title("INA3221 + GY-906 Live Viewer")

        self.line_queue = queue.Queue()
        self.reader = None
        self.pending_ina = None
        self.pending_gy = None

        self.timestamps = []
        self.voltages = []
        self.currents_mA = []
        self.powers_mW = []
        self.resistances = []
        self.ambient_temps = []
        self.object_temps = []
        self.target_temps = []
        self.phases = []
        self.pwm_duties = []

        self._build_ui()
        self._refresh_ports()
        self.root.after(100, self._poll_queue)
        self.root.protocol("WM_DELETE_WINDOW", self._on_close)

    # ---------------- UI ----------------
    def _build_ui(self):
        top = ttk.Frame(self.root, padding=8)
        top.pack(side=tk.TOP, fill=tk.X)

        ttk.Label(top, text="Port:").pack(side=tk.LEFT)
        self.port_var = tk.StringVar()
        self.port_combo = ttk.Combobox(top, textvariable=self.port_var, width=18)
        self.port_combo.pack(side=tk.LEFT, padx=4)

        ttk.Button(top, text="Refresh", command=self._refresh_ports).pack(
            side=tk.LEFT, padx=4
        )

        ttk.Label(top, text="Baud:").pack(side=tk.LEFT, padx=(12, 0))
        self.baud_var = tk.StringVar(value="115200")
        ttk.Entry(top, textvariable=self.baud_var, width=8).pack(side=tk.LEFT, padx=4)

        self.connect_btn = ttk.Button(
            top, text="Connect", command=self._toggle_connection
        )
        self.connect_btn.pack(side=tk.LEFT, padx=12)

        ttk.Button(top, text="Save CSV", command=self._save_csv).pack(
            side=tk.LEFT, padx=4
        )
        ttk.Button(top, text="Clear data", command=self._clear_data).pack(
            side=tk.LEFT, padx=4
        )

        self.status_var = tk.StringVar(value="Not connected")
        ttk.Label(top, textvariable=self.status_var).pack(side=tk.RIGHT)

        # Current readings panel
        readings = ttk.LabelFrame(self.root, text="Latest reading", padding=8)
        readings.pack(side=tk.TOP, fill=tk.X, padx=8, pady=4)

        self.reading_vars = {
            "voltage": tk.StringVar(value="-- V"),
            "current": tk.StringVar(value="-- mA"),
            "power": tk.StringVar(value="-- mW"),
            "resistance": tk.StringVar(value="-- ohm"),
            "ambient": tk.StringVar(value="-- C"),
            "object": tk.StringVar(value="-- C"),
            "target": tk.StringVar(value="-- C"),
            "phase": tk.StringVar(value="--"),
            "pwm": tk.StringVar(value="-- %"),
        }
        row1 = [
            ("Voltage", "voltage"),
            ("Current", "current"),
            ("Power", "power"),
            ("Resistance", "resistance"),
            ("Ambient Temp", "ambient"),
            ("Object Temp", "object"),
        ]
        row2 = [
            ("Target Temp", "target"),
            ("Phase", "phase"),
            ("Heater PWM", "pwm"),
        ]
        for row, items in enumerate((row1, row2)):
            for i, (label, key) in enumerate(items):
                ttk.Label(readings, text=f"{label}:").grid(
                    row=row, column=i * 2, sticky="e", padx=4, pady=2
                )
                ttk.Label(
                    readings,
                    textvariable=self.reading_vars[key],
                    font=("TkDefaultFont", 10, "bold"),
                ).grid(row=row, column=i * 2 + 1, sticky="w", padx=4, pady=2)

        # Plot
        self.figure = Figure(figsize=(6, 4), dpi=100)
        self.ax = self.figure.add_subplot(111)
        self.ax.set_xlabel("Object Temperature (C)")
        self.ax.set_ylabel("Resistance (ohm)")
        self.ax.set_title("Resistance vs Object Temperature")
        self.scatter = self.ax.scatter([], [], s=15)
        (self.fit_line,) = self.ax.plot([], [], color="red", linewidth=1.5)
        self.fit_text = self.ax.text(
            0.02,
            0.98,
            "",
            transform=self.ax.transAxes,
            va="top",
            ha="left",
            fontsize=9,
        )

        self.canvas = FigureCanvasTkAgg(self.figure, master=self.root)
        self.canvas.get_tk_widget().pack(
            side=tk.TOP, fill=tk.BOTH, expand=True, padx=8, pady=8
        )

    def _refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_combo["values"] = ports
        if ports and not self.port_var.get():
            # Prefer a USB ACM/USB serial port if present
            preferred = next((p for p in ports if "ACM" in p or "USB" in p), ports[0])
            self.port_var.set(preferred)

    # ---------------- Connection handling ----------------
    def _toggle_connection(self):
        if self.reader is not None:
            self._disconnect()
        else:
            self._connect()

    def _connect(self):
        port = self.port_var.get().strip()
        if not port:
            messagebox.showerror("No port", "Select a serial port first.")
            return
        try:
            baud = int(self.baud_var.get())
        except ValueError:
            messagebox.showerror("Bad baud rate", "Baud rate must be an integer.")
            return

        self.reader = SerialReader(port, baud, self.line_queue, self._set_status)
        self.reader.start()
        self.connect_btn.config(text="Disconnect")

    def _disconnect(self):
        if self.reader:
            self.reader.stop()
            self.reader = None
        self.connect_btn.config(text="Connect")

    def _set_status(self, text):
        self.status_var.set(text)

    def _on_close(self):
        self._disconnect()
        self.root.destroy()

    # ---------------- Data handling ----------------
    def _poll_queue(self):
        updated = False
        try:
            while True:
                line = self.line_queue.get_nowait()
                self._handle_line(line)
                updated = True
        except queue.Empty:
            pass

        if updated:
            self._update_plot()

        self.root.after(100, self._poll_queue)

    def _handle_line(self, line):
        ina_match = INA_RE.search(line)
        if ina_match:
            voltage, current, power, resistance = ina_match.groups()
            self.pending_ina = {
                "voltage": parse_float(voltage),
                "current": parse_float(current),
                "power": parse_float(power),
                "resistance": parse_float(resistance),
            }
            self._update_reading_labels(ina=self.pending_ina)
            return

        gy_match = GY906_RE.search(line)
        if gy_match:
            ambient, obj = gy_match.groups()
            self.pending_gy = {"ambient": parse_float(ambient), "object": parse_float(obj)}
            self._update_reading_labels(gy=self.pending_gy)
            return

        heater_match = HEATER_RE.search(line)
        if heater_match:
            phase, setpoint, pwm = heater_match.groups()
            heater_data = {
                "phase": phase,
                "target": parse_float(setpoint),
                "pwm": int(pwm),
            }
            self._update_reading_labels(heater=heater_data)

            if self.pending_ina is not None and self.pending_gy is not None:
                self._add_record(self.pending_ina, self.pending_gy, heater_data)
                self.pending_ina = None
                self.pending_gy = None

    def _update_reading_labels(self, ina=None, gy=None, heater=None):
        if ina:
            self.reading_vars["voltage"].set(f"{ina['voltage']:.3f} V")
            self.reading_vars["current"].set(f"{ina['current']:.3f} mA")
            self.reading_vars["power"].set(f"{ina['power']:.3f} mW")
            self.reading_vars["resistance"].set(f"{ina['resistance']:.2f} ohm")
        if gy:
            self.reading_vars["ambient"].set(f"{gy['ambient']:.2f} C")
            self.reading_vars["object"].set(f"{gy['object']:.2f} C")
        if heater:
            self.reading_vars["target"].set(f"{heater['target']:.2f} C")
            self.reading_vars["phase"].set(heater["phase"])
            self.reading_vars["pwm"].set(f"{heater['pwm']}/255 ({heater['pwm']/255*100:.1f}%)")

    def _add_record(self, ina, gy, heater):
        self.timestamps.append(datetime.now())
        self.target_temps.append(heater["target"])
        self.phases.append(heater["phase"])
        self.pwm_duties.append(heater["pwm"])
        self.voltages.append(ina["voltage"])
        self.currents_mA.append(ina["current"])
        self.powers_mW.append(ina["power"])
        self.resistances.append(ina["resistance"])
        self.ambient_temps.append(gy["ambient"])
        self.object_temps.append(gy["object"])

    def _update_plot(self):
        if not self.object_temps:
            return

        x = np.array(self.object_temps, dtype=float)
        y = np.array(self.resistances, dtype=float)
        self.scatter.set_offsets(np.column_stack((x, y)))

        mask = np.isfinite(x) & np.isfinite(y)
        x_valid = x[mask]
        y_valid = y[mask]

        if len(x_valid) >= 2 and np.ptp(x_valid) > 0:
            slope, intercept = np.polyfit(x_valid, y_valid, 1)
            y_pred = slope * x_valid + intercept
            ss_res = np.sum((y_valid - y_pred) ** 2)
            ss_tot = np.sum((y_valid - np.mean(y_valid)) ** 2)
            r_squared = 1 - ss_res / ss_tot if ss_tot > 0 else 1.0

            x_line = np.array([x_valid.min(), x_valid.max()])
            self.fit_line.set_data(x_line, slope * x_line + intercept)

            sign = "+" if intercept >= 0 else "-"
            self.fit_text.set_text(
                f"y = {slope:.4g}x {sign} {abs(intercept):.4g}\n"
                f"R² = {r_squared:.4f}"
            )
        else:
            self.fit_line.set_data([], [])
            self.fit_text.set_text("")

        self.ax.relim()
        self.ax.autoscale_view()
        self.canvas.draw_idle()

    def _clear_data(self):
        self.timestamps.clear()
        self.voltages.clear()
        self.currents_mA.clear()
        self.powers_mW.clear()
        self.resistances.clear()
        self.ambient_temps.clear()
        self.object_temps.clear()
        self.target_temps.clear()
        self.phases.clear()
        self.pwm_duties.clear()
        self._update_plot()

    # ---------------- CSV export ----------------
    def _save_csv(self):
        if not self.timestamps:
            messagebox.showinfo("No data", "No data collected yet.")
            return

        path = filedialog.asksaveasfilename(
            defaultextension=".csv",
            filetypes=[("CSV files", "*.csv")],
            initialfile=f"ina3221_gy906_{datetime.now():%Y%m%d_%H%M%S}.csv",
        )
        if not path:
            return

        with open(path, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerow(
                [
                    "timestamp",
                    "voltage_V",
                    "current_mA",
                    "power_mW",
                    "resistance_ohm",
                    "ambient_C",
                    "object_C",
                    "target_C",
                    "phase",
                    "pwm_duty",
                ]
            )
            for row in zip(
                self.timestamps,
                self.voltages,
                self.currents_mA,
                self.powers_mW,
                self.resistances,
                self.ambient_temps,
                self.object_temps,
                self.target_temps,
                self.phases,
                self.pwm_duties,
            ):
                ts, v, i, p, r, ta, tobj, target, phase, pwm = row
                writer.writerow([ts.isoformat(), v, i, p, r, ta, tobj, target, phase, pwm])

        messagebox.showinfo("Saved", f"Saved {len(self.timestamps)} rows to:\n{path}")


def main():
    root = tk.Tk()
    App(root)
    root.mainloop()


if __name__ == "__main__":
    main()
