import time
from typing import Callable, Optional


class PIDController:
    """Basic PID controller with optional output/integral clamping."""

    def __init__(self, kp: float, ki: float, kd: float, *, setpoint: float,
                 output_limits=(0.0, 1.0), integral_limits=(None, None)):
        self.kp = kp
        self.ki = ki
        self.kd = kd
        self.setpoint = setpoint
        self.output_limits = output_limits
        self.integral_limits = integral_limits
        self.integral = 0.0
        self.prev_error = None
        self.prev_time = None

    def reset(self):
        self.integral = 0.0
        self.prev_error = None
        self.prev_time = None

    def update(self, measurement: float, now: float = None) -> float:
        if measurement != measurement:  # NaN check
            return 0.0
        if now is None:
            now = time.time()
        error = self.setpoint - measurement
        if self.prev_time is None:
            dt = 0.0
        else:
            dt = max(0.0, now - self.prev_time)
        if dt > 0.0:
            self.integral += error * dt * self.ki
            lo, hi = self.integral_limits
            if lo is not None and self.integral < lo:
                self.integral = lo
            if hi is not None and self.integral > hi:
                self.integral = hi
        derivative = 0.0
        if self.prev_error is not None and dt > 0.0:
            derivative = (error - self.prev_error) / dt

        output = self.kp * error + self.integral + self.kd * derivative
        lo, hi = self.output_limits
        if lo is not None and output < lo:
            output = lo
        if hi is not None and output > hi:
            output = hi

        self.prev_error = error
        self.prev_time = now
        return output


StatusCallback = Callable[[str], None]
OutputCallback = Callable[[float], None]


class PIDManager:
    """Wrap PID control logic with a PWM/voltage output callback."""

    def __init__(self, controller: PIDController, output_cb: OutputCallback,
                 status_cb: Optional[StatusCallback] = None):
        self.controller = controller
        self.output_cb = output_cb
        self.status_cb = status_cb or (lambda msg: None)
        self.enabled = False
        self.last_output = 0.0

    def _set_status(self, message: Optional[str]):
        if message:
            self.status_cb(message)

    def set_enabled(self, enabled: bool, *, reason: str = None, force: bool = False, silent: bool = False):
        if not force and self.enabled == enabled:
            if reason and not silent:
                self._set_status(reason)
            return
        self.enabled = enabled
        self.controller.reset()
        self.last_output = 0.0
        if enabled:
            message = reason or f"PID enabled; targeting {self.controller.setpoint:.1f} °C"
        else:
            self.output_cb(0.0)
            message = reason or "PID disabled; heater OFF"
        if not silent:
            self._set_status(message)

    def apply(self, latest_value: float):
        if latest_value is None or latest_value != latest_value:
            return
        if not self.enabled:
            return
        now = time.time()
        self.last_output = self.controller.update(latest_value, now)
        self.output_cb(self.last_output)
