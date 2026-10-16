#include <Arduino.h>
#include <Wire.h>

// I2C pins wired on this board.
#define I2C_SDA 13
#define I2C_SCL 12

// ---------------- INA3221 (0x40) ----------------
#define INA3221_ADDR 0x40

#define INA3221_REG_CONFIG 0x00
#define INA3221_REG_SHUNTVOLTAGE_1 0x01
#define INA3221_REG_BUSVOLTAGE_1 0x02

// Shunt resistor value on the INA3221 breakout. 0.1 ohm is the common
// default on most GY-219 style boards — change this if yours is different.
#define SHUNT_RESISTANCE_OHMS 7.9

const float SHUNT_VOLTS_PER_LSB = 0.00004f; // 40uV
const float BUS_VOLTS_PER_LSB = 0.008f;     // 8mV

// ---------------- GY-906 / MLX90614 (0x5A) ----------------
#define MLX90614_ADDR 0x5A
#define MLX90614_REG_TA 0x06    // ambient temperature
#define MLX90614_REG_TOBJ1 0x07 // object (target) temperature

// ---------------- Heater MOSFET (PWM on GPIO8) ----------------
#define HEATER_PIN 8
#define HEATER_PWM_FREQ_HZ 1000 // 20kHz: above audible range, still plenty for a resistive heater

#define SWEEP_MIN_TEMP_C 40.0f
#define SWEEP_MAX_TEMP_C 70.0f

// One full cycle: ramp up, hold at 70C, ramp down, hold at 40C, repeat.
#define SWEEP_CYCLE_MS (1UL * 60UL * 1000UL)  // total cycle length
#define SWEEP_HOLD_HIGH_MS (1UL * 1000UL)     // hold time at 70C
#define SWEEP_HOLD_LOW_MS (1UL * 1000UL)      // hold time at 40C
// Remaining cycle time is split evenly between ramp up and ramp down.
#define SWEEP_RAMP_MS \
  ((SWEEP_CYCLE_MS - SWEEP_HOLD_HIGH_MS - SWEEP_HOLD_LOW_MS) / 2)

// Hard safety cutoff: heater is forced off above this, regardless of setpoint.
#define HEATER_MAX_SAFE_TEMP_C 80.0f

// Proportional gain: PWM counts (0-255) added per degree C of error.
// Tune this to your thermal mass/MOSFET/heater — too high overshoots and
// oscillates, too low can't reach the setpoint against heat loss.
#define HEATER_KP 150.0f

enum SweepPhase { PHASE_RAMP_UP, PHASE_HOLD_HIGH, PHASE_RAMP_DOWN, PHASE_HOLD_LOW };
const char *SWEEP_PHASE_NAMES[] = {"RAMP_UP", "HOLD_HIGH", "RAMP_DOWN", "HOLD_LOW"};

unsigned long sweepStartMillis;

int16_t readRegister16(uint8_t i2cAddr, uint8_t reg) {
  Wire.beginTransmission(i2cAddr);
  Wire.write(reg);
  Wire.endTransmission(false);
  Wire.requestFrom((int)i2cAddr, 2);
  uint8_t msb = Wire.read();
  uint8_t lsb = Wire.read();
  return (int16_t)((msb << 8) | lsb);
}

void readIna3221Channel(uint8_t channel, float &busVoltage, float &current,
                         float &power, float &resistance) {
  uint8_t shuntReg = INA3221_REG_SHUNTVOLTAGE_1 + (channel - 1) * 2;
  uint8_t busReg = INA3221_REG_BUSVOLTAGE_1 + (channel - 1) * 2;

  int16_t shuntRaw = readRegister16(INA3221_ADDR, shuntReg) >> 3;
  int16_t busRaw = readRegister16(INA3221_ADDR, busReg) >> 3;

  float shuntVoltage = shuntRaw * SHUNT_VOLTS_PER_LSB;
  busVoltage = busRaw * BUS_VOLTS_PER_LSB;
  current = shuntVoltage / SHUNT_RESISTANCE_OHMS;
  power = busVoltage * current;
  resistance = (current != 0) ? busVoltage / current : NAN;
}

float readMlxTemperature(uint8_t reg) {
  Wire.beginTransmission(MLX90614_ADDR);
  Wire.write(reg);
  Wire.endTransmission(false);
  Wire.requestFrom((int)MLX90614_ADDR, 3);
  uint8_t lowByte = Wire.read();
  uint8_t highByte = Wire.read();
  Wire.read(); // PEC byte, not checked

  uint16_t raw = (highByte << 8) | lowByte;
  return raw * 0.02f - 273.15f;
}

void setup() {
  Serial.begin(115200);
  while (!Serial) {
    delay(10);
  }
  delay(1000);

  Wire.begin(I2C_SDA, I2C_SCL);

  // Ensure INA3221 is in known state: all 3 channels enabled, continuous
  // shunt+bus voltage conversion (this is also the power-on default).
  Wire.beginTransmission(INA3221_ADDR);
  Wire.write(INA3221_REG_CONFIG);
  Wire.write(0x71);
  Wire.write(0x27);
  Wire.endTransmission();

  analogWriteFrequency(HEATER_PIN, HEATER_PWM_FREQ_HZ);
  analogWrite(HEATER_PIN, 0);
  sweepStartMillis = millis();

  Serial.println();
  Serial.println("INA3221 + GY-906 (MLX90614) reader");
}

void loop() {
  float busVoltage, current, power, resistance;
  readIna3221Channel(3, busVoltage, current, power, resistance);

  Serial.printf("INA3221 CH3 -> Voltage: %.3f V, Current: %.3f mA, "
                "Power: %.3f mW, Resistance: %.2f ohm\n",
                busVoltage, current * 1000.0f, power * 1000.0f, resistance);

  float ambientTemp = readMlxTemperature(MLX90614_REG_TA);
  float objectTemp = readMlxTemperature(MLX90614_REG_TOBJ1);
  Serial.printf("GY-906   -> Ambient: %.2f C, Object: %.2f C\n", ambientTemp,
                objectTemp);

  unsigned long t = (millis() - sweepStartMillis) % SWEEP_CYCLE_MS;
  SweepPhase phase;
  float setpoint;

  if (t < SWEEP_RAMP_MS) {
    phase = PHASE_RAMP_UP;
    setpoint = SWEEP_MIN_TEMP_C +
               (SWEEP_MAX_TEMP_C - SWEEP_MIN_TEMP_C) * ((float)t / (float)SWEEP_RAMP_MS);
  } else if ((t -= SWEEP_RAMP_MS) < SWEEP_HOLD_HIGH_MS) {
    phase = PHASE_HOLD_HIGH;
    setpoint = SWEEP_MAX_TEMP_C;
  } else if ((t -= SWEEP_HOLD_HIGH_MS) < SWEEP_RAMP_MS) {
    phase = PHASE_RAMP_DOWN;
    setpoint = SWEEP_MAX_TEMP_C -
               (SWEEP_MAX_TEMP_C - SWEEP_MIN_TEMP_C) * ((float)t / (float)SWEEP_RAMP_MS);
  } else {
    phase = PHASE_HOLD_LOW;
    setpoint = SWEEP_MIN_TEMP_C;
  }

  int dutyValue = 0;
  if (objectTemp < HEATER_MAX_SAFE_TEMP_C) {
    float dutyF = HEATER_KP * (setpoint - objectTemp);
    dutyValue = (int)constrain(dutyF, 10.0f, 255.0f);
  }
  analogWrite(HEATER_PIN, dutyValue);

  Serial.printf("Heater   -> Phase: %s, Setpoint: %.2f C, PWM: %d/255 (%.1f%%)\n",
                SWEEP_PHASE_NAMES[phase], setpoint, dutyValue,
                dutyValue / 255.0f * 100.0f);

  Serial.println();
  delay(200);
}
