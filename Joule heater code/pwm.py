import time


class PWMController:
    """Convert desired output voltages into PWM/analogWrite commands."""

    def __init__(self, supply_voltage: float = 24.0, analog_max: int = 255,
                 output_gain: float = 1.0, output_offset: float = 0.0):
        self.supply_voltage = max(0.01, float(supply_voltage))
        self.analog_max = max(1, int(analog_max))
        self.output_gain = output_gain if output_gain != 0 else 1.0
        self.output_offset = output_offset

    def clamp_voltage(self, voltage: float) -> float:
        if voltage != voltage:
            voltage = 0.0
        return max(0.0, min(self.supply_voltage, float(voltage)))

    def voltage_to_duty(self, voltage: float) -> float:
        clamped = self.clamp_voltage(voltage)
        return clamped / self.supply_voltage

    def voltage_to_analog(self, voltage: float) -> int:
        duty = self.voltage_to_duty(voltage)
        return int(round(self.analog_max * duty))

    def command_voltage_for(self, desired_voltage: float) -> float:
        """Map a desired heater voltage to the actual command voltage sent to PWM."""
        if desired_voltage != desired_voltage:
            desired_voltage = 0.0
        command = (desired_voltage - self.output_offset) / self.output_gain
        return self.clamp_voltage(command)

    def describe_desired(self, desired_voltage: float):
        """Return (command_voltage, duty, analog_value, predicted_actual_voltage)."""
        cmd = self.command_voltage_for(desired_voltage)
        duty = self.voltage_to_duty(cmd)
        analog = self.voltage_to_analog(cmd)
        predicted = self.output_gain * cmd + self.output_offset
        predicted = max(0.0, min(self.supply_voltage, predicted))
        return cmd, duty, analog, predicted

    def format_command(self, command_voltage: float) -> str:
        analog = self.voltage_to_analog(command_voltage)
        return f"PWM {analog}"
