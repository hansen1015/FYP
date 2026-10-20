/*
 * ESP32-S3 SuperMini: INA3221 (resistance) + GY-906 (IR temp) + MOSFET heater PWM (GPIO8).
 *
 * One PID drives the heater. Its process variable is chosen from 3 inputs:
 *   0 = IR temperature (degC), 1 = thermocouple (degC, forwarded by the PC), 2 = resistance (ohm)
 * Each input keeps its own setpoint and gains. out% = kp*e + ki*integral(e) + kd*(-dPV/dt),
 * e = setpoint - PV (heater heats when PV is below setpoint). Nothing is saved to flash:
 * the PC GUI pushes the settings after connecting. After a reset the heater is off / manual.
 *
 * Serial out (115200), every 200 ms:
 *   DATA <ms> <V> <mA> <mW> <ohm> <ambient C> <IR C> <pwm %> <auto 0/1> <src 0-2>
 *   CFG <src> <kp> <ki> <kd> <sp>        (reply to "get")
 *   OK ... / ERR ...
 * Serial in (newline terminated):
 *   pwm <0-100>             manual PWM %, leaves auto mode
 *   auto <0|1>              PID on/off
 *   src <0-2>               choose PID input
 *   sp <src> <value>        setpoint of that input
 *   pid <src> <kp> <ki> <kd>
 *   tc <degC>               thermocouple reading from the PC
 *   hb                      heartbeat; the GUI sends it every cycle
 *
 * Host watchdog: no complete line from the PC for HOST_TIMEOUT_MS -> auto off, heater 0.
 * The heater is also 0 at boot, so nothing is driven unless the GUI is connected.
 *   get
 */

#include <Arduino.h>
#include <Wire.h>

#define I2C_SDA 13
#define I2C_SCL 12

// ---------------- INA3221 (0x40) ----------------
#define INA3221_ADDR 0x40
#define INA3221_REG_CONFIG 0x00
#define INA3221_REG_SHUNTVOLTAGE_1 0x01
#define INA3221_REG_BUSVOLTAGE_1 0x02
#define SHUNT_RESISTANCE_OHMS 2.06

const float SHUNT_VOLTS_PER_LSB = 0.00004f; // 40uV
const float BUS_VOLTS_PER_LSB = 0.008f;     // 8mV

// ---------------- GY-906 / MLX90614 (0x5A) ----------------
#define MLX90614_ADDR 0x5A
#define MLX90614_REG_TA 0x06
#define MLX90614_REG_TOBJ1 0x07

// ---------------- Heater ----------------
#define HEATER_PIN 8
#define HEATER_PWM_FREQ_HZ 1000
#define HEATER_MAX_SAFE_TEMP_C 80.0f  // IR above this forces the heater off in every mode
#define TC_TIMEOUT_MS 3000            // src 1: no "tc" update for this long -> heater off
#define MIN_PWM_PCT 2.0f              // PID and manual never drive below this (resistance stays measurable); 0 = off
#define HOST_TIMEOUT_MS 2000
#define PWM_BITS 12                   // finer than 8 bit
#define LOOP_MS 200

enum Src { SRC_IR, SRC_TC, SRC_RES, NUM_SRC };

struct Pid {
  float kp, ki, kd, sp;
  float integral, lastPv;
  bool hasLast;
};

Pid pid[NUM_SRC] = {
    {5.0f, 0.05f, 0.0f, 0.0f, 0, 0, false},  // IR
    {5.0f, 0.05f, 0.0f, 0.0f, 0, 0, false},  // thermocouple
    {0.5f, 0.0f, 0.0f, 0.0f, 0, 0, false},   // resistance
};
Src activeSrc = SRC_IR;
bool autoMode = false;
float pwmPct = 0;
float tcTemp = NAN;
uint32_t lastTcMs = 0;
uint32_t lastRxMs = 0;

void setHeater(float pct) {
  pwmPct = constrain(pct, 0.0f, 100.0f);
  analogWrite(HEATER_PIN, (int)(pwmPct * ((1 << PWM_BITS) - 1) / 100.0f + 0.5f));
}

void resetPid(Pid &p) {
  p.integral = 0;
  p.hasLast = false;
}

// Returns heater % for this sample; NAN pv = sensor lost -> off.
float runPid(Pid &p, float pv, float dt) {
  float e = p.sp - pv;

  // Integral with anti-windup: keep ki*integral within 0..100 %
  p.integral += e * dt;
  p.integral = (p.ki > 0) ? constrain(p.integral, 0.0f, 100.0f / p.ki) : 0;

  // Derivative on measurement (no kick when the setpoint changes)
  float d = 0;
  if (p.hasLast && dt > 0) d = -(pv - p.lastPv) / dt;
  p.lastPv = pv;
  p.hasLast = true;

  return p.kp * e + p.ki * p.integral + p.kd * d;
}

// ---------------- sensors ----------------
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
  resistance = (current > 0) ? busVoltage / current : NAN;
}

float readMlxTemperature(uint8_t reg) {
  Wire.beginTransmission(MLX90614_ADDR);
  Wire.write(reg);
  Wire.endTransmission(false);
  if (Wire.requestFrom((int)MLX90614_ADDR, 3) != 3) return NAN;  // sensor missing
  uint8_t lowByte = Wire.read();
  uint8_t highByte = Wire.read();
  Wire.read(); // PEC byte, not checked
  return ((highByte << 8) | lowByte) * 0.02f - 273.15f;
}

// ---------------- serial commands ----------------
void printCfg(int s) {
  Serial.printf("CFG %d %g %g %g %g\n", s, pid[s].kp, pid[s].ki, pid[s].kd, pid[s].sp);
}

void handleCommand(const char *line) {
  int s, n;
  float a, b, c;

  lastRxMs = millis();
  if (strcmp(line, "hb") == 0) return;
  if (sscanf(line, "pwm %f", &a) == 1 && a >= 0 && a <= 100) {
    autoMode = false;
    setHeater(a > 0 ? max(a, MIN_PWM_PCT) : 0);  // 0 stays a real off (ALL OFF, disconnect)
    Serial.printf("OK: pwm %g\n", pwmPct);
  } else if (sscanf(line, "auto %d", &n) == 1 && (n == 0 || n == 1)) {
    if (n && !autoMode) resetPid(pid[activeSrc]);
    autoMode = n;
    if (!autoMode) setHeater(0);
    Serial.printf("OK: auto %d\n", n);
  } else if (sscanf(line, "src %d", &s) == 1 && s >= 0 && s < NUM_SRC) {
    activeSrc = (Src)s;
    resetPid(pid[s]);
    Serial.printf("OK: src %d\n", s);
  } else if (sscanf(line, "sp %d %f", &s, &a) == 2 && s >= 0 && s < NUM_SRC) {
    pid[s].sp = a;
    Serial.printf("OK: sp %d %g\n", s, a);
  } else if (sscanf(line, "pid %d %f %f %f", &s, &a, &b, &c) == 4 && s >= 0 &&
             s < NUM_SRC && a >= 0 && b >= 0 && c >= 0) {
    pid[s].kp = a;
    pid[s].ki = b;
    pid[s].kd = c;
    resetPid(pid[s]);
    Serial.printf("OK: pid %d %g %g %g\n", s, a, b, c);
  } else if (sscanf(line, "tc %f", &a) == 1) {
    tcTemp = a;
    lastTcMs = millis();
  } else if (strncmp(line, "get", 3) == 0) {
    for (int i = 0; i < NUM_SRC; i++) printCfg(i);
    Serial.printf("MODE %d %d\n", activeSrc, autoMode ? 1 : 0);
  } else {
    Serial.println("ERR: bad command");
  }
}

void pollSerial() {
  static char buf[48];
  static uint8_t len = 0;
  while (Serial.available()) {
    char ch = Serial.read();
    if (ch == '\n' || ch == '\r') {
      buf[len] = 0;
      if (len) handleCommand(buf);
      len = 0;
    } else if (len < sizeof buf - 1) {
      buf[len++] = ch;
    }
  }
}

void setup() {
  // No "while (!Serial)": the heater logic must run without a PC attached.
  Serial.begin(115200);
  Wire.begin(I2C_SDA, I2C_SCL);

  // INA3221: all 3 channels enabled, continuous shunt+bus conversion
  Wire.beginTransmission(INA3221_ADDR);
  Wire.write(INA3221_REG_CONFIG);
  Wire.write(0x71);
  Wire.write(0x27);
  Wire.endTransmission();

  analogWriteResolution(HEATER_PIN, PWM_BITS);
  analogWriteFrequency(HEATER_PIN, HEATER_PWM_FREQ_HZ);
  setHeater(0);
}

void loop() {
  static uint32_t next = millis(), lastCtrl = millis();

  // Wait out the period while listening for commands
  while ((int32_t)(millis() - next) < 0) {
    pollSerial();
    delay(1);
  }
  uint32_t now = millis();
  float dt = (now - lastCtrl) / 1000.0f;
  lastCtrl = now;
  next += LOOP_MS;
  if ((int32_t)(now - next) > LOOP_MS) next = now;  // overrun

  float busVoltage, current, power, resistance;
  readIna3221Channel(3, busVoltage, current, power, resistance);
  float ambientTemp = readMlxTemperature(MLX90614_REG_TA);
  float objectTemp = readMlxTemperature(MLX90614_REG_TOBJ1);

  if (autoMode) {
    float pv;
    switch (activeSrc) {
      case SRC_IR: pv = objectTemp; break;
      case SRC_TC: pv = (now - lastTcMs < TC_TIMEOUT_MS) ? tcTemp : NAN; break;
      default: pv = resistance; break;
    }
    if (!isnan(pv)) {
      setHeater(max(runPid(pid[activeSrc], pv, dt), MIN_PWM_PCT));
    } else if (activeSrc == SRC_RES && pid[activeSrc].sp > 0) {
      // resistance is only measurable while current flows: keep the minimum duty
      setHeater(MIN_PWM_PCT);
    } else {
      resetPid(pid[activeSrc]);
      setHeater(0);
    }
  }
  if (!isnan(objectTemp) && objectTemp >= HEATER_MAX_SAFE_TEMP_C) setHeater(0);
  if (now - lastRxMs > HOST_TIMEOUT_MS) {  // PC gone: no PWM at all
    autoMode = false;
    setHeater(0);
  }

  Serial.printf("DATA %lu %.3f %.3f %.3f %.2f %.2f %.2f %.1f %d %d\n", (unsigned long)now,
                busVoltage, current * 1000.0f, power * 1000.0f, resistance, ambientTemp,
                objectTemp, pwmPct, autoMode ? 1 : 0, (int)activeSrc);
}
