import csv
import time
from typing import Iterable, Sequence

DEFAULT_HEADER = [
    "clock", "ms",
    "T1", "T2", "T3", "T4", "T5",
    "T1_filt", "T2_filt", "T3_filt", "T4_filt", "T5_filt",
    "PWM1", "PWM2", "PWM3", "PWM4", "PWM5",
    "event",
]


class CSVLogger:
    """Manage CSV logging sessions with automatic date/header rows and timestamps."""

    def __init__(self, path: str, flush_period: float, header: Sequence[str] = DEFAULT_HEADER):
        self.path = path
        self.flush_period = flush_period
        self.header = list(header)
        self.value_fields = [h for h in self.header if h not in ("clock", "ms", "event")]
        self._file = None
        self._writer = None
        self._last_flush = 0.0

    @property
    def is_open(self) -> bool:
        return self._writer is not None

    def start(self):
        """Open the CSV file (append mode) and write session metadata + header."""
        if self.is_open:
            return
        self._file = open(self.path, "a", newline="")
        self._writer = csv.writer(self._file)
        self._last_flush = time.time()
        session_date = time.strftime("%Y-%m-%d")
        if self._file.tell() != 0:
            self._writer.writerow([])
        self._writer.writerow(["Recording Date", session_date])
        self._writer.writerow(self.header)

    def stop(self):
        """Flush and close the underlying CSV file."""
        if self._file:
            try:
                self._file.flush()
                self._file.close()
            except Exception:
                pass
        self._file = None
        self._writer = None

    def close(self):
        self.stop()

    def _flush_if_needed(self):
        if not self._file:
            return
        if time.time() - self._last_flush >= self.flush_period:
            try:
                self._file.flush()
            except Exception:
                pass
            self._last_flush = time.time()

    def write_sample(self, row: Iterable):
        """Write a single sample row (with iterable values)."""
        if not self.is_open:
            return
        self._writer.writerow(row)
        self._flush_if_needed()

    def write_measurement(self, ms_val, value_map, event=""):
        """Helper to log a temperature measurement dict with a clock timestamp."""
        row = [time.strftime("%H:%M:%S"), ms_val]
        for field in self.value_fields:
            row.append(value_map.get(field, float("nan")))
        row.append(event)
        self.write_sample(row)

    def write_event(self, ms_val, event: str):
        """Log an event row with NaNs for all sensor values."""
        blank_map = {field: float("nan") for field in self.value_fields}
        self.write_measurement(ms_val, blank_map, event=event)
