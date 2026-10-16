import argparse, time, re, threading
import csv
import tkinter as tk
from tkinter import filedialog
from collections import deque
from queue import Queue, Empty, Full

import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.widgets import Button, CheckButtons, TextBox
import serial

from csvgen import CSVLogger
from pid import PIDController, PIDManager
from pwm import PWMController

KV_RE = re.compile(r'(\w+):([-+]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][-+]?\d+)?|nan)', re.IGNORECASE)

ALL_CH = ["T1", "T2", "T3", "T4", "T5",
          "T1_filt", "T2_filt", "T3_filt", "T4_filt", "T5_filt",
          "PWM1", "PWM2", "PWM3", "PWM4", "PWM5"]
COLOR = {
    "T1": "C0",
    "T2": "C1",
    "T3": "C2",
    "T4": "C3",
    "T5": "C4",
    "T1_filt": "brown",
    "T2_filt": "#d97706",
    "T3_filt": "#2e8b57",
    "T4_filt": "#8c564b",
    "T5_filt": "#6f42c1",
    "PWM1": "C0",
    "PWM2": "C1",
    "PWM3": "C2",
    "PWM4": "C3",
    "PWM5": "C4",
}
VALUE_FIELDS = ALL_CH[:]
TEMP_BASE_FIELDS = [f"T{i}" for i in range(1, 6)]
TEMP_ALERT_THRESHOLD_C = 80.0  # temperature limit to show automatic N1 OFF message
SENSOR_FAIL_CUTOFF_C = 200.0   # sensor failure cutoff for T1

def apply_temp_offsets(value_map: dict, temp_offsets_c):
    """Apply per-node offsets to both raw and filtered thermocouple channels."""
    for idx, base in enumerate(TEMP_BASE_FIELDS):
        if idx >= len(temp_offsets_c):
            break
        offset = temp_offsets_c[idx]
        if not offset:
            continue
        for field in (base, f"{base}_filt"):
            val = value_map.get(field, float("nan"))
            if val == val:  # not NaN
                value_map[field] = val + offset

def parse_args():
    p = argparse.ArgumentParser(description="Live temperature plotter (threaded) with live channel selection + heater buttons.")
    p.add_argument("--port", required=True, help="COM port (e.g. COM5, /dev/ttyACM0)")
    p.add_argument("--baud", type=int, default=115200)#change baud rate with this
    p.add_argument("--outfile", default="log.csv")# outfile to store CSV file 
    p.add_argument("--window", type=int, default=1200, help="plot points kept in memory")
    p.add_argument("--flush_s", type=float, default=0.5, help="CSV flush period (s)")
    p.add_argument("--read_burst", type=int, default=200, help="max lines per read burst")
    p.add_argument("--no_log", action="store_true", help="start with recording OFF")
    p.add_argument("--show", default=",".join(ALL_CH),
                   help="channels to show initially, comma-separated (e.g. T1,T3,T1_filt)")
    p.add_argument("--pid_setpoint", type=float, default=65.0, help="PID temperature target (deg C)")
    p.add_argument("--pid_kp", type=float, default=4, help="PID proportional gain")
    p.add_argument("--pid_ki", type=float, default=0.6, help="PID integral gain")
    p.add_argument("--pid_kd", type=float, default=3, help="PID derivative gain")
    p.add_argument("--pid_window", type=float, default=3.0, help="PID window for on/off control (s)")
    p.add_argument("--no_pid", action="store_true", help="Disable PID control logic")
    p.add_argument("--supply_v", type=float, default=24.4, help="Heater supply voltage used for PWM scaling")
    p.add_argument("--pwm_default", type=float, default=4.0, help="Default PWM output voltage")
    p.add_argument("--pwm_gain", type=float, default=1.021, help="Measured gain (actual V per commanded V)")
    p.add_argument("--pwm_offset", type=float, default=0.66, help="Measured offset (actual V at zero command)")
    p.add_argument("--temp_offset_t1", type=float, default=-18, help="Offset for T1/T1_filt (deg C)")
    p.add_argument("--temp_offset_t2", type=float, default=+0, help="Offset for T2/T2_filt (deg C)")
    p.add_argument("--temp_offset_t3", type=float, default=+0, help="Offset for T3/T3_filt (deg C)")
    p.add_argument("--temp_offset_t4", type=float, default=+0, help="Offset for T4/T4_filt (deg C)")
    p.add_argument("--temp_offset_t5", type=float, default=0, help="Offset for T5/T5_filt (deg C)")
    p.add_argument("--temp_offset", type=float, default=None,
                   help="Deprecated: apply one shared offset to all T1..T5 channels")
    return p.parse_args()

def serial_reader(port, baud, out_q: Queue, stop_evt: threading.Event,
                  record_evt: threading.Event, cmd_q: Queue, event_q: Queue,
                  log_path: str, flush_period: float, read_burst: int, temp_offsets_c):
    """Read serial, parse CSV or key:value lines, push to queue. Log when record_evt is set.
       Also listens for outgoing commands from cmd_q and writes them to serial."""
    ser = None
    while not stop_evt.is_set():
        try:
            ser = serial.Serial(port, baud, timeout=1)
            time.sleep(2.0)  # allow USB reset
            ser.reset_input_buffer()
            break
        except Exception:
            out_q.put(("status", f"Searching for {port}..."))
            time.sleep(1.0)

    if stop_evt.is_set():
        return

    # Pass explicit header to ensure CSVLogger knows about all channels (including new PWMs)
    logger = CSVLogger(log_path, flush_period, header=["clock", "ms"] + VALUE_FIELDS + ["event"])
    out_q.put(("status", f"Connected to {port} @ {baud}"))

    def process_cmd_queue():
        sent = 0
        while True:
            try:
                cmd = cmd_q.get_nowait()
            except Empty:
                break
            try:
                # Ensure newline so Arduino's line parser triggers
                if not cmd.endswith("\n"):
                    cmd += "\n"
                ser.write(cmd.encode("utf-8"))
                ser.flush()
                out_q.put(("status", f"TX: {cmd.strip()}"))
                sent += 1
            except Exception as e:
                out_q.put(("status", f"TX error: {e}"))
        return sent

    def process_event_queue():
        while True:
            try:
                event_label, event_ms = event_q.get_nowait()
            except Empty:
                break
            if event_ms is None:
                event_ms = int(time.time() * 1000)
            if logger.is_open:
                try:
                    logger.write_event(event_ms, event_label)
                    out_q.put(("status", f"Event logged: {event_label}"))
                except Exception:
                    pass

    while not stop_evt.is_set():
        # 1) process any pending commands first
        process_cmd_queue()
        process_event_queue()

        # 2) manage logfile open/close
        if record_evt.is_set() and not logger.is_open:
            try:
                logger.start()
                out_q.put(("status", "Recording: ON"))
            except Exception as e:
                out_q.put(("status", f"Failed to open log: {e}"))
        elif not record_evt.is_set() and logger.is_open:
            logger.stop()
            out_q.put(("status", "Recording: OFF"))

        # 3) read burst of lines
        for _ in range(read_burst):
            # also interleave command handling so buttons feel snappy
            process_cmd_queue()
            process_event_queue()

            try:
                line = ser.readline().decode(errors="ignore").strip()
            except Exception:
                line = ""
            if not line:
                break

            value_map = {}
            ms_val = None
            # CSV mode: CSV,ms,t1,...,t5_filt
            if line.startswith("CSV,"):
                parts = line.split(",")
                if len(parts) < 2:
                    continue
                try:
                    ms_val = int(parts[1])
                except ValueError:
                    continue
                for idx, field in enumerate(VALUE_FIELDS, start=2):
                    if idx < len(parts):
                        try:
                            value_map[field] = float(parts[idx])
                        except ValueError:
                            value_map[field] = float("nan")
                    else:
                        value_map[field] = float("nan")
            else:
                # Key:Value mode
                kv = dict(KV_RE.findall(line))
                if "T1" not in kv:
                    continue
                def fget(k):
                    v = kv.get(k, "nan")
                    return float("nan") if v.lower() == "nan" else float(v)
                ms_val = int(time.time() * 1000)
                for field in VALUE_FIELDS:
                    value_map[field] = fget(field)

            apply_temp_offsets(value_map, temp_offsets_c)

            out_q.put(("data", (ms_val, dict(value_map))))

            if logger.is_open:
                try:
                    logger.write_measurement(ms_val, value_map)
                except Exception:
                    pass

        time.sleep(0.005)

    try: ser.close()
    except Exception: pass
    logger.close()
    out_q.put(("status", "Reader stopped"))

def main():
    args = parse_args()
    temp_offsets = [
        args.temp_offset_t1,
        args.temp_offset_t2,
        args.temp_offset_t3,
        args.temp_offset_t4,
        args.temp_offset_t5,
    ]
    if args.temp_offset is not None:
        temp_offsets = [args.temp_offset] * 5

    # initial visible set from CLI
    init_show = [s.strip() for s in args.show.split(",") if s.strip()]
    init_show = [ch for ch in init_show if ch in ALL_CH]
    if not init_show:
        init_show = ALL_CH[:]

    # queues and events
    q = Queue(maxsize=8192)       # data/status from reader
    cmd_q = Queue(maxsize=128)    # commands to reader (heater control)
    event_q = Queue(maxsize=128)  # event annotations/logging
    stop_evt = threading.Event()
    record_evt = threading.Event()
    if not args.no_log:
        record_evt.set()          # start recording by default unless --no_log

    pwm_controller = PWMController(args.supply_v, output_gain=args.pwm_gain, output_offset=args.pwm_offset)
    pwm_voltage = args.pwm_default
    pwm_actual_voltage = None

    # reader thread
    reader = threading.Thread(
        target=serial_reader,
        args=(args.port, args.baud, q, stop_evt, record_evt, cmd_q, event_q,
              args.outfile, args.flush_s, args.read_burst, tuple(temp_offsets)),
        daemon=True
    )
    reader.start()

    # ===== Figure & layout
    try:
        plt.style.use("seaborn-v0_8-darkgrid")
    except Exception:
        try:
            plt.style.use("seaborn-darkgrid")
        except Exception:
            pass
    fig = plt.figure(figsize=(12, 6))
    fig.canvas.manager.set_window_title("SIMTECH- Joule heater") 
    # ==========================

    # 2-Column Layout Definition
    # Left Column (70%): Main Plot, Status, Bottom Buttons
    # Right Column (30%): Heaters, Raw, Filt, PWM, PID
    
    # Main Plot: Left 70%
    ax = fig.add_axes([0.05, 0.15, 0.65, 0.80])
    
    # Right Column Config
    rc_x = 0.73
    rc_w = 0.24
    
    # Raw Temp Panel (Block 2)
    cb_raw_ax = fig.add_axes([rc_x, 0.65, rc_w, 0.15])
    
    # Filtered Temp Panel (Block 3)
    cb_filt_ax = fig.add_axes([rc_x, 0.48, rc_w, 0.15])
    
    # PWM Checkbox Panel (Block 4a)
    cb_pwm_ax = fig.add_axes([rc_x, 0.35, rc_w, 0.11])
    
    cb_raw_ax.set_title("Temp T1-T5", fontsize=9)
    cb_filt_ax.set_title("Temp T1_filt-T5_filt", fontsize=9)
    cb_pwm_ax.set_title("PWM 1-5", fontsize=9)
    
    # Clean up checkbox axes appearance
    for cax in [cb_raw_ax, cb_filt_ax, cb_pwm_ax]:
        cax.set_xticks([])
        cax.set_yticks([])
        cax.spines['top'].set_visible(False)
        cax.spines['right'].set_visible(False)
        cax.spines['bottom'].set_visible(False)
        cax.spines['left'].set_visible(False)

    ax.set_xlabel("time (s)")
    ax.set_ylabel("°C")
    setpoint_line = ax.axhline(args.pid_setpoint, color="#2ca02c", linestyle="--", linewidth=1.2, alpha=0.8)
    safety_line = ax.axhline(TEMP_ALERT_THRESHOLD_C, color="#d62728", linestyle="--", linewidth=1.2, alpha=0.8)

    status_ax = fig.add_axes([0.05, 0.10, 0.65, 0.03])
    status_ax.axis("off")
    status_txt = status_ax.text(0.01, 0.5, "Connecting...", va="center", ha="left")

    # Add ASTAR logo
    try:
        logo_img = plt.imread("ASTAR.png")
        logo_ax = fig.add_axes([0.92, 0.02, 0.07, 0.07]) # Bottom right corner
        logo_ax.imshow(logo_img)
        logo_ax.axis("off")
    except Exception:
        pass

    # Bottom row buttons (Load, Rec, Exit)
    btn_y = 0.02
    btn_h = 0.05
    # Load button is defined later, but we reserve space: x=0.05
    rec_btn_ax  = fig.add_axes([0.18, btn_y, 0.12, btn_h])
    exit_btn_ax = fig.add_axes([0.31, btn_y, 0.10, btn_h])

    rec_button  = Button(rec_btn_ax, "Stop Rec" if record_evt.is_set() else "Start Rec",
                         color="lightgreen" if record_evt.is_set() else "lightgray",
                         hovercolor="green")
    exit_button = Button(exit_btn_ax, "Exit", color="lightcoral", hovercolor="red")

    heater_btns = {}
    # Heater Buttons (Block 1) - Inset on cb_raw_ax
    # Positioned above Raw Panel (y > 1.0 relative to cb_raw_ax)
    for i in range(1, 6):
        # Stack N1 (top) to N5 (bottom)
        # Relative coords: ~2.0 down to ~1.1
        y_pos = 2.05 - (i-1)*0.23
        btn_ax = cb_raw_ax.inset_axes([0.0, y_pos, 1.0, 0.20])
        heater_btns[i] = Button(btn_ax, f"N{i} ON", color="#cce5ff", hovercolor="#99ccff")

    def update_heater_btn(idx):
        btn = heater_btns[idx]
        if heater_states[idx]:
            btn.label.set_text(f"N{idx} OFF")
            btn.color = "#ffd6cc"
            btn.hovercolor = "#ffb399"
            btn.ax.set_facecolor("#ffd6cc")
        else:
            btn.label.set_text(f"N{idx} ON")
            btn.color = "#cce5ff"
            btn.hovercolor = "#99ccff"
            btn.ax.set_facecolor("#cce5ff")
        fig.canvas.draw_idle()

    # PID / PWM Controls (Block 4b)
    # y range 0.02 to 0.33
    pid_x = rc_x
    pid_w = rc_w

    # PWM Heater & Actual V
    pwm_select_ax = fig.add_axes([pid_x, 0.29, pid_w*0.48, 0.04])
    pwm_actual_ax = fig.add_axes([pid_x + pid_w*0.52, 0.29, pid_w*0.48, 0.04])
    
    pwm_actual_box = TextBox(pwm_actual_ax, "Actual V", initial="--")
    try:
        pwm_actual_box.set_active(False)
    except Exception:
        pass

    pwm_select_box = TextBox(pwm_select_ax, "PWM Heater", initial="1")
    # Note: PID logic will always use Heater 1 regardless of this box.
    # This box controls which heater receives the manual "Actual V" setting.

    # PID Boxes (Vertical Stack)
    pid_kp_ax = fig.add_axes([pid_x, 0.24, pid_w, 0.04])
    pid_ki_ax = fig.add_axes([pid_x, 0.19, pid_w, 0.04])
    pid_kd_ax = fig.add_axes([pid_x, 0.14, pid_w, 0.04])
    pid_sp_ax = fig.add_axes([pid_x, 0.09, pid_w, 0.04])
    pid_kp_box = TextBox(pid_kp_ax, "Kp", initial=f"{args.pid_kp:.3f}")
    pid_ki_box = TextBox(pid_ki_ax, "Ki", initial=f"{args.pid_ki:.3f}")
    pid_kd_box = TextBox(pid_kd_ax, "Kd", initial=f"{args.pid_kd:.3f}")
    pid_sp_box = TextBox(pid_sp_ax, "Setpoint", initial=f"{args.pid_setpoint:.2f}")

    # Apply & Rise Time
    pid_apply_ax = fig.add_axes([pid_x, 0.04, pid_w*0.48, 0.04])
    pid_apply_btn = Button(pid_apply_ax, "Apply", color="lightgray", hovercolor="white")

    time_to_sp_ax = fig.add_axes([pid_x + pid_w*0.52, 0.04, pid_w*0.48, 0.04])
    time_to_sp_box = TextBox(time_to_sp_ax, "Rise T.", initial="--")
    try:
        time_to_sp_box.set_active(False) # Read-only
        time_to_sp_box.ax.set_facecolor("0.95")
    except Exception:
        pass

    # Initialize PID boxes to yellow (applied state)
    PID_APPLIED_COLOR = "#ffff99"
    PID_EDIT_COLOR = "0.95"
    pid_boxes = [pid_kp_box, pid_ki_box, pid_kd_box, pid_sp_box]
    for box in pid_boxes:
        box.ax.set_facecolor(PID_APPLIED_COLOR)
        box.color = PID_APPLIED_COLOR
        box.hovercolor = PID_APPLIED_COLOR

    # buffers
    ms = deque(maxlen=args.window)
    data = {ch: deque(maxlen=args.window) for ch in ALL_CH}
    t0 = None
    latest_ms = None
    over_temp_alerted = False  # prevents spamming the status message
    sensor_fault = False       # latch on invalid sensor readings
    event_marks = []
    viewing_history = False
    rise_timers = {}           # map heater_idx -> start_time
    heater_states = {i: False for i in range(1, 6)}

    # lines (one per series)
    lines = {}
    for ch in ALL_CH:
        (ln,) = ax.plot([], [], label=ch, color=COLOR.get(ch, "black"), linewidth=2 if ch.endswith("_filt") else 1.5)
        ln.set_visible(ch in init_show)
        lines[ch] = ln
    def update_legend():
        vis = [(ch, ln) for ch, ln in lines.items() if ln.get_visible()]
        if vis:
            ax.legend(handles=[ln for _, ln in vis], labels=[ch for ch, _ in vis], loc="best")
        else:
            ax.legend(handles=[], labels=[], loc="best")
    update_legend()

    # checkboxes to toggle visibility
    raw_labels = [ch for ch in ALL_CH if not ch.endswith("_filt")]
    filt_labels = [ch for ch in ALL_CH if ch.endswith("_filt")]
    # raw_labels currently includes PWMs because they don't end with _filt, so we separate them
    pwm_labels = [ch for ch in raw_labels if ch.startswith("PWM")]
    raw_labels = [ch for ch in raw_labels if not ch.startswith("PWM")]

    checkbox_groups = []
    if raw_labels:
        vis_raw = [ch in init_show for ch in raw_labels]
        cb_raw = CheckButtons(cb_raw_ax, labels=raw_labels, actives=vis_raw)
        for i, ch in enumerate(raw_labels):
            cb_raw.labels[i].set_color(COLOR.get(ch, "black"))
        checkbox_groups.append((raw_labels, cb_raw))
    else:
        cb_raw = None
        cb_raw_ax.axis("off")
    if filt_labels:
        vis_filt = [ch in init_show for ch in filt_labels]
        cb_filt = CheckButtons(cb_filt_ax, labels=filt_labels, actives=vis_filt)
        for i, ch in enumerate(filt_labels):
            cb_filt.labels[i].set_color(COLOR.get(ch, "black"))
        checkbox_groups.append((filt_labels, cb_filt))
    else:
        cb_filt = None
        cb_filt_ax.axis("off")
    if pwm_labels:
        vis_pwm = [ch in init_show for ch in pwm_labels]
        cb_pwm = CheckButtons(cb_pwm_ax, labels=pwm_labels, actives=vis_pwm)
        for i, ch in enumerate(pwm_labels):
            cb_pwm.labels[i].set_color(COLOR.get(ch, "black"))
        checkbox_groups.append((pwm_labels, cb_pwm))
    else:
        cb_pwm = None
        cb_pwm_ax.axis("off")

    def on_checkbox(label):
        ln = lines.get(label)
        if ln is None: return
        ln.set_visible(not ln.get_visible())
        update_legend()
        fig.canvas.draw_idle()
    if cb_raw:
        cb_raw.on_clicked(on_checkbox)
    if cb_filt:
        cb_filt.on_clicked(on_checkbox)
    if cb_pwm:
        cb_pwm.on_clicked(on_checkbox)

    def try_send_cmd(cmd: str) -> bool:
        """Push a command to the reader thread without blocking."""
        try:
            cmd_q.put_nowait(cmd)
        except Full:
            status_txt.set_text("Command queue full; command dropped")
            return False
        return True

    def pid_status(message: str):
        status_txt.set_text(message)
        fig.canvas.draw_idle()

    def apply_pwm_voltage(voltage: float, heater_idx: int = None, announce: bool = True):
        nonlocal pwm_voltage, pwm_actual_voltage
        cmd_v, duty, analog, predicted = pwm_controller.describe_desired(voltage)
        
        # Determine which heater to control
        if heater_idx is not None:
            h_idx = heater_idx
        else:
            try:
                h_idx = int(pwm_select_box.text)
                h_idx = max(1, min(5, h_idx))
            except ValueError:
                h_idx = 1

        # Format command: "PWM <val>" for H1 (legacy), "H<n> PWM <val>" for others
        if h_idx == 1:
            cmd = f"PWM {analog}"
        else:
            cmd = f"H{h_idx} PWM {analog}"

        if try_send_cmd(cmd):
            pwm_voltage = voltage
            pwm_actual_voltage = predicted
            try:
                pwm_actual_box.set_val(f"{predicted:.2f}")
            except Exception:
                pass
            if announce:
                status_txt.set_text(
                    f"H{h_idx} PWM target {voltage:.2f} V => cmd {cmd_v:.2f} V (analog {analog})")
                fig.canvas.draw_idle()
        else:
            if announce:
                status_txt.set_text("Failed to send PWM command")
                fig.canvas.draw_idle()

    apply_pwm_voltage(pwm_voltage, announce=False)
    try_send_cmd("N1 OFF")

    def make_pid_edit_cb(box):
        def cb(text):
            box.ax.set_facecolor(PID_EDIT_COLOR)
            box.color = PID_EDIT_COLOR
            box.hovercolor = PID_EDIT_COLOR
        return cb

    for box in pid_boxes:
        box.on_text_change(make_pid_edit_cb(box))

    def on_pid_apply(event):
        if not pid_managers:
            status_txt.set_text("PID disabled (no_pid)")
            return
        try:
            kp = float(pid_kp_box.text)
            ki = float(pid_ki_box.text)
            kd = float(pid_kd_box.text)
            sp = float(pid_sp_box.text)
        except ValueError:
            status_txt.set_text("Invalid PID/Setpoint values")
            return
        
        for pm in pid_managers.values():
            pm.controller.kp = kp
            pm.controller.ki = ki
            pm.controller.kd = kd
            pm.controller.setpoint = sp

        setpoint_line.set_ydata([sp, sp])
        
        for box in pid_boxes:
            box.ax.set_facecolor(PID_APPLIED_COLOR)
            box.color = PID_APPLIED_COLOR
            box.hovercolor = PID_APPLIED_COLOR
            
        status_txt.set_text(f"Applied: Kp={kp} Ki={ki} Kd={kd} SP={sp}")
        fig.canvas.draw_idle()

    pid_apply_btn.on_clicked(on_pid_apply)

    def on_load_csv(event):
        nonlocal ms, data, viewing_history, t0
        
        # Stop recording if active
        if record_evt.is_set():
            on_toggle_record(None)

        root = tk.Tk()
        root.withdraw()
        root.attributes('-topmost', True)
        path = filedialog.askopenfilename(filetypes=[("CSV Files", "*.csv"), ("All Files", "*.*")])
        root.destroy()
        
        if not path:
            return
            
        try:
            new_ms = []
            new_data = {ch: [] for ch in ALL_CH}
            
            with open(path, "r", newline="") as f:
                reader = csv.reader(f)
                header = None
                for row in reader:
                    if not row: continue
                    if "ms" in row and any(c in row for c in ALL_CH):
                        header = row
                        break
                
                if not header:
                    status_txt.set_text("Error: No header found")
                    return
                
                col_map = {name: i for i, name in enumerate(header)}
                if "ms" not in col_map:
                    status_txt.set_text("Error: 'ms' column missing")
                    return

                t_start = None
                for row in reader:
                    if not row or len(row) <= col_map["ms"]: continue
                    try:
                        m = float(row[col_map["ms"]])
                    except ValueError: continue
                    
                    if t_start is None: t_start = m
                    new_ms.append((m - t_start) / 1000.0)
                    
                    row_values = {}
                    for ch in ALL_CH:
                        val = float("nan")
                        if ch in col_map and len(row) > col_map[ch]:
                            try: val = float(row[col_map[ch]])
                            except ValueError: pass
                        row_values[ch] = val
                    apply_temp_offsets(row_values, temp_offsets)
                    for ch in ALL_CH:
                        new_data[ch].append(row_values[ch])
            
            ms = list(new_ms)
            data = new_data
            viewing_history = True
            t0 = None 
            status_txt.set_text(f"Loaded {len(ms)} points from CSV")
            fig.canvas.draw_idle()
        except Exception as e:
            status_txt.set_text(f"Load failed: {e}")

    load_btn_ax = fig.add_axes([0.05, 0.02, 0.12, 0.06])
    load_button = Button(load_btn_ax, "load past csv result", color="lightgray", hovercolor="white")
    load_button.on_clicked(on_load_csv)

    def annotate_event(label: str):
        nonlocal event_marks
        if t0 is None:
            x = ms[-1] if len(ms) else 0.0
            event_ms = None
        else:
            if latest_ms is None:
                event_ms = int(time.time() * 1000)
            else:
                event_ms = latest_ms
            x = (event_ms - t0) / 1000.0
        ymin, ymax = ax.get_ylim()
        y = ymax if ymax > ymin else 1.0
        line = ax.axvline(x, color="gray", linestyle=":", linewidth=1.0, alpha=0.7)
        text = ax.text(x, y, label, rotation=90, va="top", ha="right", fontsize=8,
                       color="gray", clip_on=True)
        event_marks.append((line, text))
        fig.canvas.draw_idle()
        return event_ms

    def log_event(label: str, event_ms):
        try:
            event_q.put_nowait((label, event_ms))
        except Full:
            status_txt.set_text("Event queue full; event dropped")

    pid_managers = {}
    if not args.no_pid:
        for i in range(1, 6):
            # Create independent controller for each heater
            ctrl = PIDController(
                args.pid_kp,
                args.pid_ki,
                args.pid_kd,
                setpoint=args.pid_setpoint,
                output_limits=(0.0, args.supply_v),
                integral_limits=(-5.0, 5.0),
            )
            
            # Capture index for callbacks
            def make_output_cb(idx):
                return lambda v: apply_pwm_voltage(v, heater_idx=idx, announce=False)
            
            # We only show status for N1 to avoid spam, or generic
            pm = PIDManager(ctrl, make_output_cb(i), pid_status if i == 1 else None)
            pm.set_enabled(False, force=True, silent=True)
            pid_managers[i] = pm

    def drain_queue():
        nonlocal t0, latest_ms
        if viewing_history:
            try:
                while True: q.get_nowait()
            except Empty: pass
            return 0

        got = 0
        while True:
            try:
                kind, payload = q.get_nowait()
            except Empty:
                break
            if kind == "status":
                status_txt.set_text(str(payload))
            elif kind == "error":
                status_txt.set_text(f"ERROR: {payload}")
            elif kind == "data":
                ms_val, values = payload
                latest_ms = ms_val
                if t0 is None: t0 = ms_val
                ms.append((ms_val - t0)/1000.0)
                for ch in ALL_CH:
                    data[ch].append(values.get(ch, float("nan")))
                got += 1
        return got

    def refresh(_):
        nonlocal over_temp_alerted, sensor_fault
        got = drain_queue()
        if got or viewing_history:
            # update only visible series
            for ch, ln in lines.items():
                if ln.get_visible():
                    ln.set_data(ms, data[ch])
            update_legend()

            if len(ms) > 5:
                ax.set_xlim(ms[0], max(ms[-1], 10))
                # autoscale based on visible series only
                vals = []
                for ch, ln in lines.items():
                    if ln.get_visible():
                        vals.extend([v for v in data[ch] if v == v])
                # keep reference lines visible in autoscale
                vals.extend([0, args.pid_setpoint, TEMP_ALERT_THRESHOLD_C])
                if vals:
                    ymin, ymax = min(vals), max(vals)
                    pad = max(1.0, 0.05*(ymax - ymin))
                    ax.set_ylim(ymin - pad, ymax + pad)

        # --- Update checkbox labels to show latest value beside node ---
        # For each checkbox label, append the most recent temperature (or "--" if none).
        latest_t1_val = None
        for labels_group, cb_obj in checkbox_groups:
            for i, ch in enumerate(labels_group):
                val = None
                dq = data.get(ch)
                if dq and len(dq):
                    # take last valid numeric (skip NaN)
                    for v in reversed(dq):
                        if v == v:  # not NaN
                            val = v
                            break
                if ch == "T1" and val is not None:
                    latest_t1_val = val
                if val is None:
                    txt = f"{ch}  --"
                else:
                    if ch.startswith("PWM"):
                        # PWM is usually integer 0-255
                        txt = f"{ch}  {val:.0f}"
                    else:
                        # Temps
                        txt = f"{ch}  {val:.2f}°C"
                try:
                    cb_obj.labels[i].set_text(txt)
                except Exception:
                    pass

        sensor_invalid = (
            latest_t1_val is not None
            and (latest_t1_val != latest_t1_val or latest_t1_val >= SENSOR_FAIL_CUTOFF_C)
        )
        if sensor_invalid:
            if not sensor_fault:
                status_txt.set_text("Sensor fault: T1 invalid or >= 200 C, heater OFF")
                sensor_fault = True
                for i in range(1, 6):
                    if heater_states[i]:
                        heater_states[i] = False
                        update_heater_btn(i)
                        try_send_cmd(f"N{i} OFF")
                for pm in pid_managers.values():
                    pm.set_enabled(False, silent=True, force=True)
                if rise_timers:
                    rise_timers.clear()
                    time_to_sp_box.set_val("Fault")
        elif sensor_fault:
            sensor_fault = False

        if latest_t1_val is not None and not sensor_fault:
            if (latest_t1_val > TEMP_ALERT_THRESHOLD_C) and not over_temp_alerted:
                status_txt.set_text("N1 off , temp reached 75 degree c")
                over_temp_alerted = True
                for i in range(1, 6):
                    if heater_states[i]:
                        heater_states[i] = False
                        update_heater_btn(i)
                        try_send_cmd(f"N{i} OFF")
                for pm in pid_managers.values():
                    pm.set_enabled(False, silent=True, force=True)
                if rise_timers:
                    rise_timers.clear()
                    time_to_sp_box.set_val("Aborted")
            elif (latest_t1_val <= TEMP_ALERT_THRESHOLD_C) and over_temp_alerted:
                over_temp_alerted = False

        if latest_t1_val is not None and not over_temp_alerted and not sensor_fault:
            for i, pm in pid_managers.items():
                if pm.enabled:
                    # Get latest value for T{i}
                    dq = data.get(f"T{i}")
                    val = None
                    if dq and len(dq) > 0:
                        for v in reversed(dq):
                            if v == v:
                                val = v
                                break
                    if val is not None:
                        pm.apply(val)
            
            # Check if we reached setpoint
            if rise_timers:
                try:
                    target_sp = float(pid_sp_box.text)
                except ValueError:
                    target_sp = args.pid_setpoint
                
                # Check each active timer against its corresponding temperature
                current_time = time.time()
                for idx in list(rise_timers.keys()):
                    # Get latest value for T{idx}
                    dq = data.get(f"T{idx}")
                    val = None
                    if dq and len(dq) > 0:
                        # find last non-nan
                        for v in reversed(dq):
                            if v == v:
                                val = v
                                break
                    if val is not None and val >= target_sp:
                        elapsed = current_time - rise_timers[idx]
                        time_to_sp_box.set_val(f"N{idx}: {elapsed:.1f} s")
                        log_event(f"N{idx} reached SP in {elapsed:.1f}s", latest_ms)
                        del rise_timers[idx]

        return tuple(lines.values()) + (status_txt,)

    ani = animation.FuncAnimation(fig, refresh, interval=100, blit=False, cache_frame_data=False)

    # Button callbacks
    def on_toggle_record(event):
        if record_evt.is_set():
            record_evt.clear()
            rec_button.label.set_text("Start Rec")
            try: rec_button.ax.set_facecolor("lightgray")
            except Exception: pass
            status_txt.set_text("Recording: OFF")
        else:
            record_evt.set()
            rec_button.label.set_text("Stop Rec")
            try: rec_button.ax.set_facecolor("lightgreen")
            except Exception: pass
            status_txt.set_text("Recording: ON")
        fig.canvas.draw_idle()

    def on_exit(event):
        stop_evt.set()
        status_txt.set_text("Stopping...")
        fig.canvas.draw_idle()
        plt.close(fig)

    def on_toggle_heater(idx):
        
        if not heater_states[idx]:
            # Turn ON
            heater_states[idx] = True
            update_heater_btn(idx)
            
            # Enable PID if available
            if idx in pid_managers:
                pm = pid_managers[idx]
                # Sync setpoint from UI box
                try:
                    sp = float(pid_sp_box.text)
                    pm.controller.setpoint = sp
                    if idx == 1:
                        setpoint_line.set_ydata([sp, sp])
                except ValueError:
                    pass
                
                try_send_cmd(f"N{idx} ON")
                msg = f"N{idx} PID enabled; targeting {pm.controller.setpoint:.1f} °C"
                pm.set_enabled(True, reason=msg)
                event_ms = annotate_event(f"N{idx} ON")
                log_event(f"N{idx} ON", event_ms)
            else:
                # Manual mode
                if try_send_cmd(f"N{idx} ON"):
                    status_txt.set_text(f"N{idx} ON")
                    event_ms = annotate_event(f"N{idx} ON")
                    log_event(f"N{idx} ON", event_ms)
            
            # Start measuring rise time for all
            rise_timers[idx] = time.time()
            time_to_sp_box.set_val(f"N{idx}...")
        else:
            # Turn OFF
            heater_states[idx] = False
            update_heater_btn(idx)
            
            if idx in rise_timers:
                del rise_timers[idx]
                time_to_sp_box.set_val("Aborted")
            
            if idx in pid_managers:
                pid_managers[idx].set_enabled(False, reason=f"PID disabled via N{idx} OFF", force=True)
                try_send_cmd(f"N{idx} OFF")
                event_ms = annotate_event(f"N{idx} OFF")
                log_event(f"N{idx} OFF", event_ms)
            else:
                if try_send_cmd(f"N{idx} OFF"):
                    status_txt.set_text(f"N{idx} OFF")
                    event_ms = annotate_event(f"N{idx} OFF")
                    log_event(f"N{idx} OFF", event_ms)

    rec_button.on_clicked(on_toggle_record)
    exit_button.on_clicked(on_exit)
    
    # Bind callbacks for all heater buttons
    def make_toggle_cb(i):
        return lambda event: on_toggle_heater(i)
        
    for i in range(1, 6):
        heater_btns[i].on_clicked(make_toggle_cb(i))

    try:
        plt.show()
    finally:
        stop_evt.set()
        reader.join(timeout=2.0)

if __name__ == "__main__":
    main()
