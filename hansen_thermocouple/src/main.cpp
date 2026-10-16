/*
 * ESP32-C3 SuperMini + 5x MAX6675 thermocouple amplifiers + 5x PWM heaters
 *
 * Wiring (shared bus, separate CS per sensor):
 *   SCK (all 5 modules) -> GPIO 5
 *   SO  (all 5 modules)  -> GPIO 6
 *   CS1 -> GPIO 20
 *   CS2 -> GPIO 10
 *   CS3 -> GPIO 9
 *   CS4 -> GPIO 8
 *   CS5 -> GPIO 7
 *   VCC -> 3.3V, GND -> GND
 *
 * Heaters (PWM outputs), heater N is controlled from thermocouple N:
 *   H1 -> GPIO 4, H2 -> GPIO 3, H3 -> GPIO 2, H4 -> GPIO 1, H5 -> GPIO 0
 *
 * Serial commands (115200, newline terminated):
 *   "<1-5|all> <0-100>"          manual PWM %, switches that heater to manual
 *   "auto <1-5|all>"             enable PID control
 *   "manual <1-5|all>"           disable PID, hold current output
 *   "sp <1-5> <degC>"            PID setpoint            (saved to flash)
 *   "pid <1-5> <kp> <ki> <kd>"   PID gains               (saved to flash)
 *   "tau <seconds>"              temperature low-pass time constant (0 = off)
 *   "est <on|off>"               PID uses the model-fused estimate (default on)
 *   "fuse <0-1]"                 trust in the measurement when fusing (1 = ignore model)
 *   "learn <1-5|all> <on|off>"   on = start learning the thermal model (vary the
 *                                PWM); off = freeze it and save it to flash
 *   "mdl reset <1-5|all>"        delete the learned model (also from flash)
 *   "ahead <seconds>"            PID looks this far ahead using the model (default 3, 0 = off)
 *   "autotune <1-5|all>"         set PID gains from the learned model (saved)
 *   "adapt <on|off>"             keep re-tuning PID gains from the model (every 60 s)
 *   "lambda <0.05-2>"            tuning speed: closed-loop time = lambda * plant tau
 *   "get"                        print the saved config of every channel
 *
 * Thermal model (learned only on request, then frozen): for each channel a
 * first-order model
 *   x[k+1] = a*x[k] + b*u[k] + c      (x = (T-25)/100, u = heater duty 0..1)
 * is fitted with recursive least squares from the measured temperature and the
 * PWM that was applied, but ONLY between "learn on" and "learn off". Afterwards
 * it is frozen, saved, and reloaded at every boot. It predicts the next reading from the PWM, and
 * the prediction is blended with the measurement (complementary filter):
 *   est = pred + fuse*(meas - pred)
 * so the estimate reacts to PWM changes before the thermocouple does.
 *
 * Look-ahead: with "ahead", the PID error is computed from where the model
 * says the temperature will be in N seconds if the present PWM is held, so
 * it backs off before an overshoot / pushes sooner before an undershoot.
 *
 * Auto-tune: from the learned plant (time constant tau_m, gain K in degC per
 * %) the gains follow IMC/lambda tuning:  Kp = tau_m / (K*(lam+theta)),
 * Ki = Kp/tau_m, with lam = lambda*tau_m and theta = loop period + filter tau.
 *
 * PID: out% = kp*e + ki*integral(e) + kd*(-dPV/dt), e in degC, time in s.
 * Gains and setpoints survive a restart. PID mode does NOT: after a reset
 * every heater starts OFF in manual mode.
 *
 * MAX6675 is read-only SPI. We bit-bang it with the built-in shiftIn()
 * so all 5 modules can share one SCK/SO bus, each selected one at a time
 * via its own CS pin.
 */

#include <Arduino.h>
#include <Preferences.h>

const uint8_t SCK_PIN = 5;
const uint8_t SO_PIN  = 6;
const uint8_t CS_PINS[] = {20, 10, 9, 8, 7};
const uint8_t NUM_SENSORS = sizeof(CS_PINS) / sizeof(CS_PINS[0]);

const uint8_t HEATER_PINS[] = {4, 3, 2, 1, 0};
const uint8_t NUM_HEATERS = sizeof(HEATER_PINS) / sizeof(HEATER_PINS[0]);
const uint32_t PWM_FREQ = 1000;  // Hz
const uint8_t PWM_BITS = 8;      // duty 0..255

// Control/print period. The MAX6675 needs 0.17-0.22 s per conversion and
// pulling CS low aborts one in progress, so each sensor is read exactly once
// per cycle (reading faster only returns stale data).
const uint32_t LOOP_MS = 500;

float heaterOut[NUM_HEATERS] = {0};  // current output, percent

// Low-pass filter (first order, time constant tau in seconds):
//   y += alpha * (x - y),  alpha = dt / (tau + dt)
// alpha is recomputed from the real time between samples, so tau stays
// correct even if the loop period changes. tau = 0 -> no filtering.
// A median-of-3 stage in front removes single-sample spikes (e.g. PWM pickup).
float filterTau = 0.5f;  // seconds
double filtered[NUM_SENSORS];
bool filterValid[NUM_SENSORS] = {false};

double medianBuf[NUM_SENSORS][3];
uint8_t medianCount[NUM_SENSORS] = {0};
uint8_t medianPos[NUM_SENSORS] = {0};

double median3(uint8_t i, double raw) {
  medianBuf[i][medianPos[i]] = raw;
  medianPos[i] = (medianPos[i] + 1) % 3;
  if (medianCount[i] < 3) medianCount[i]++;
  if (medianCount[i] < 3) return raw;  // not enough history yet
  double a = medianBuf[i][0], b = medianBuf[i][1], c = medianBuf[i][2];
  return max(min(a, b), min(max(a, b), c));
}

double smooth(uint8_t i, double raw, float dt) {
  if (isnan(raw)) {
    filterValid[i] = false;  // restart from the first good sample on reconnect
    medianCount[i] = 0;
    return NAN;
  }
  raw = median3(i, raw);
  if (!filterValid[i]) {
    filtered[i] = raw;
    filterValid[i] = true;
  } else {
    filtered[i] += (dt / (filterTau + dt)) * (raw - filtered[i]);
  }
  return filtered[i];
}

// ---------------- PID ----------------
struct Pid {
  float kp, ki, kd, sp;
  bool autoMode;
  float integral;
  float lastPv;
  bool hasLast;
};

Pid pid[NUM_HEATERS];
Preferences prefs;

void setHeater(uint8_t idx, float percent) {
  percent = constrain(percent, 0.0f, 100.0f);
  heaterOut[idx] = percent;
  ledcWrite(HEATER_PINS[idx],
            (uint32_t)(percent * ((1 << PWM_BITS) - 1) / 100.0f + 0.5f));
}

void resetPid(uint8_t i) {
  pid[i].integral = 0;
  pid[i].hasLast = false;
}

void savePid(uint8_t i) {
  char k[8];
  snprintf(k, sizeof k, "kp%u", i); prefs.putFloat(k, pid[i].kp);
  snprintf(k, sizeof k, "ki%u", i); prefs.putFloat(k, pid[i].ki);
  snprintf(k, sizeof k, "kd%u", i); prefs.putFloat(k, pid[i].kd);
  snprintf(k, sizeof k, "sp%u", i); prefs.putFloat(k, pid[i].sp);
}

void loadPid() {
  prefs.begin("pid", false);
  for (uint8_t i = 0; i < NUM_HEATERS; i++) {
    char k[8];
    snprintf(k, sizeof k, "kp%u", i); pid[i].kp = prefs.getFloat(k, 5.0f);
    snprintf(k, sizeof k, "ki%u", i); pid[i].ki = prefs.getFloat(k, 0.05f);
    snprintf(k, sizeof k, "kd%u", i); pid[i].kd = prefs.getFloat(k, 0.0f);
    snprintf(k, sizeof k, "sp%u", i); pid[i].sp = prefs.getFloat(k, 0.0f);
    pid[i].autoMode = false;
    resetPid(i);
  }
}

void runPid(uint8_t i, double pv, float dt) {
  Pid &p = pid[i];
  if (!p.autoMode) return;

  // Sensor lost: fail safe, heater off and forget the integral
  if (isnan(pv)) {
    setHeater(i, 0);
    resetPid(i);
    return;
  }

  float e = p.sp - (float)pv;

  // Integral with anti-windup: clamp so ki*integral stays within 0..100%
  p.integral += e * dt;
  if (p.ki > 0) p.integral = constrain(p.integral, 0.0f, 100.0f / p.ki);
  else p.integral = 0;

  // Derivative on measurement (no kick when the setpoint changes)
  float d = 0;
  if (p.hasLast && dt > 0) d = -((float)pv - p.lastPv) / dt;
  p.lastPv = (float)pv;
  p.hasLast = true;

  setHeater(i, p.kp * e + p.ki * p.integral + p.kd * d);
}

// ---------------- learned thermal model ----------------
const float MODEL_REF = 25.0f;     // degC reference
const float MODEL_SCALE = 100.0f;  // degC per unit of x
const float RLS_LAMBDA = 0.999f;   // forgetting factor (~1000 samples memory)
const float RLS_PMAX = 1000.0f;    // covariance trace cap (stops blow-up)
const uint32_t MODEL_READY_UPDATES = 120;  // ~1 min of learning data needed

struct Model {
  float th[3];     // a, b, c
  float P[3][3];   // RLS covariance
  uint32_t updates;
  bool learning;   // true only between "learn on" and "learn off"
  bool hasPrev;
  float prevMeas;  // x at the last sample
  float prevEst;   // fused x at the last sample
  float prevU;     // duty (0..1) applied since the last sample
  float pred;      // x predicted for this sample
  bool predValid;
  float est;       // fused x
  bool estValid;
};

Model mdl[NUM_SENSORS];
bool useEst = true;     // PID input: false = measurement, true = fused estimate
float fuseGain = 0.5f;  // 1 = measurement only, small = trust model more
uint32_t lastGainSave = 0;

void resetModel(uint8_t i) {
  Model &m = mdl[i];
  m.th[0] = 0.95f; m.th[1] = 0.02f; m.th[2] = 0.0f;
  for (int r = 0; r < 3; r++)
    for (int c = 0; c < 3; c++) m.P[r][c] = (r == c) ? 10.0f : 0.0f;
  m.updates = 0;
  m.hasPrev = m.predValid = m.estValid = false;
  m.prevU = 0;
}

// Enough data to give sensible predictions (also true while still learning)
bool modelValid(uint8_t i) {
  return mdl[i].updates >= MODEL_READY_UPDATES && mdl[i].th[1] > 0.0005f;
}

// Frozen and trusted: only then do the PID, look-ahead and auto-tune use it
bool modelReady(uint8_t i) {
  return modelValid(i) && !mdl[i].learning;
}

void rlsUpdate(Model &m, const float phi[3], float y) {
  float trace = m.P[0][0] + m.P[1][1] + m.P[2][2];
  float lam = (trace > RLS_PMAX) ? 1.0f : RLS_LAMBDA;  // no forgetting if idle

  float Pphi[3];
  for (int r = 0; r < 3; r++)
    Pphi[r] = m.P[r][0] * phi[0] + m.P[r][1] * phi[1] + m.P[r][2] * phi[2];
  float denom = lam + phi[0] * Pphi[0] + phi[1] * Pphi[1] + phi[2] * Pphi[2];
  float err = y - (m.th[0] * phi[0] + m.th[1] * phi[1] + m.th[2] * phi[2]);

  for (int r = 0; r < 3; r++) {
    float K = Pphi[r] / denom;
    m.th[r] += K * err;
    for (int c = 0; c < 3; c++) m.P[r][c] = (m.P[r][c] - K * Pphi[c]) / lam;
  }

  // keep the model physical: stable, heater can only add heat
  m.th[0] = constrain(m.th[0], 0.0f, 0.9999f);
  m.th[1] = constrain(m.th[1], 0.0f, 1.0f);
  m.th[2] = constrain(m.th[2], -0.5f, 0.5f);
  if (!isfinite(m.th[0] + m.th[1] + m.th[2] + m.P[0][0])) resetModel(&m - mdl);
  m.updates++;
}

// Called once per cycle with the filtered measurement (NAN if disconnected)
void modelStep(uint8_t i, double meas) {
  Model &m = mdl[i];
  if (isnan(meas)) {
    m.hasPrev = m.predValid = m.estValid = false;
    return;
  }
  float x = ((float)meas - MODEL_REF) / MODEL_SCALE;
  m.predValid = false;

  if (m.hasPrev) {
    // 1. predict this sample from the last estimate and the PWM applied since
    m.pred = m.th[0] * m.prevEst + m.th[1] * m.prevU + m.th[2];
    m.predValid = true;
    // 2. learn from what actually happened (only while "learn" is on; the
    //    model is otherwise frozen so sudden changes cannot corrupt it)
    if (m.learning) {
      float phi[3] = {m.prevMeas, m.prevU, 1.0f};
      rlsUpdate(m, phi, x);
    }
    // 3. complementary blend of model prediction and measurement
    m.est = modelReady(i) ? m.pred + fuseGain * (x - m.pred) : x;
  } else {
    m.est = x;
  }
  m.estValid = true;
  m.hasPrev = true;
  m.prevMeas = x;
  m.prevEst = m.est;
}

void saveModel(uint8_t i) {
  char k[8];
  snprintf(k, sizeof k, "ma%u", i); prefs.putFloat(k, mdl[i].th[0]);
  snprintf(k, sizeof k, "mb%u", i); prefs.putFloat(k, mdl[i].th[1]);
  snprintf(k, sizeof k, "mc%u", i); prefs.putFloat(k, mdl[i].th[2]);
}

void eraseModel(uint8_t i) {
  char k[8];
  snprintf(k, sizeof k, "ma%u", i); prefs.remove(k);
  snprintf(k, sizeof k, "mb%u", i); prefs.remove(k);
  snprintf(k, sizeof k, "mc%u", i); prefs.remove(k);
}

// Restore channel i from flash (or "no model" if none was ever saved)
void loadModelOne(uint8_t i) {
  resetModel(i);
  mdl[i].learning = false;
  char k[8];
  snprintf(k, sizeof k, "ma%u", i);
  if (!prefs.isKey(k)) return;
  mdl[i].th[0] = prefs.getFloat(k, mdl[i].th[0]);
  snprintf(k, sizeof k, "mb%u", i); mdl[i].th[1] = prefs.getFloat(k, mdl[i].th[1]);
  snprintf(k, sizeof k, "mc%u", i); mdl[i].th[2] = prefs.getFloat(k, mdl[i].th[2]);
  mdl[i].updates = MODEL_READY_UPDATES;  // usable immediately after boot
}

void loadModel() {
  for (uint8_t i = 0; i < NUM_SENSORS; i++) loadModelOne(i);
}

// Start a fresh learning run: forget the old model and fit a new one
void startLearning(uint8_t i) {
  resetModel(i);
  mdl[i].learning = true;
}

// End the run: freeze the model and keep it in flash if it got enough data
bool stopLearning(uint8_t i) {
  mdl[i].learning = false;
  if (modelValid(i)) {
    saveModel(i);
    return true;
  }
  loadModelOne(i);  // not enough data: go back to the previous saved model
  return false;
}

// ---------------- look-ahead + auto-tune ----------------
float aheadSec = 3.0f;       // look-ahead horizon in s (default 3), 0 = off
bool adapt = false;          // periodically re-tune from the learned model
float lambdaFactor = 0.3f;   // closed loop time = lambdaFactor * plant tau
uint32_t lastAdapt = 0;

// Temperature expected after aheadSec if the present duty is held
double predictAhead(uint8_t i, double T) {
  int steps = constrain((int)(aheadSec / (LOOP_MS / 1000.0f) + 0.5f), 0, 40);
  const Model &m = mdl[i];
  float x = ((float)T - MODEL_REF) / MODEL_SCALE;
  float u = heaterOut[i] / 100.0f;
  for (int s = 0; s < steps; s++) x = m.th[0] * x + m.th[1] * u + m.th[2];
  return x * MODEL_SCALE + MODEL_REF;
}

// IMC / lambda tuning from the learned first-order plant
bool computeTune(uint8_t i, float &kp, float &ki) {
  if (!modelReady(i)) return false;
  float a = mdl[i].th[0], b = mdl[i].th[1];
  if (a <= 0.0f || a >= 0.9999f) return false;

  float loopS = LOOP_MS / 1000.0f;
  float tauM = -loopS / logf(a);                     // plant time constant, s
  float K = b / (1.0f - a) * MODEL_SCALE / 100.0f;   // degC per % duty
  if (K < 0.02f) return false;                       // heater barely moves it

  float theta = loopS + filterTau;                   // loop + filter delay
  float lam = max(lambdaFactor * tauM, 2.0f * theta);
  kp = tauM / (K * (lam + theta));
  ki = kp / tauM;
  kp = constrain(kp, 0.1f, 50.0f);
  ki = constrain(ki, 0.001f, 5.0f);
  return true;
}

void applyTune(uint8_t i, float kp, float ki) {
  Pid &p = pid[i];
  if (p.ki > 0 && ki > 0) p.integral *= p.ki / ki;  // keep ki*integral: no bump
  p.kp = kp;
  p.ki = ki;
}

// ---------------- serial commands ----------------
void printCfg(uint8_t i) {
  Serial.printf("CFG %u %g %g %g %g %u\n", i + 1, pid[i].kp, pid[i].ki,
                pid[i].kd, pid[i].sp, pid[i].autoMode ? 1 : 0);
}

// "1".."5" -> first=last=idx, "all" -> 0..N-1
bool parseTarget(const String &t, int &first, int &last) {
  if (t == "all") {
    first = 0;
    last = NUM_HEATERS - 1;
    return true;
  }
  int h = t.toInt();
  if (h < 1 || h > NUM_HEATERS) return false;
  first = last = h - 1;
  return true;
}

void setMode(int first, int last, bool autoMode) {
  for (int i = first; i <= last; i++) {
    if (autoMode && !pid[i].autoMode) resetPid(i);
    pid[i].autoMode = autoMode;
  }
}

void handleCommand(String line) {
  line.trim();
  line.toLowerCase();
  if (line.length() == 0) return;

  // split into up to 5 space separated tokens
  String tok[5];
  int n = 0;
  while (line.length() && n < 5) {
    int sp = line.indexOf(' ');
    if (sp < 0) {
      tok[n++] = line;
      break;
    }
    tok[n++] = line.substring(0, sp);
    line = line.substring(sp + 1);
    line.trim();
  }

  int a, b;

  if (tok[0] == "get") {
    for (uint8_t i = 0; i < NUM_HEATERS; i++) printCfg(i);
    Serial.printf("EST %u %g\n", useEst ? 1 : 0, fuseGain);
    Serial.printf("TUNE %g %u %g\n", aheadSec, adapt ? 1 : 0, lambdaFactor);
  } else if (tok[0] == "tau" && n == 2) {
    float v = tok[1].toFloat();
    if (v < 0.0f || v > 60.0f) {
      Serial.println("ERR: tau must be 0-60 seconds");
      return;
    }
    filterTau = v;
    Serial.printf("OK: tau %.2f s\n", v);
  } else if (tok[0] == "est" && n == 2) {
    useEst = (tok[1] == "on" || tok[1] == "1");
    Serial.printf("OK: est %s\n", useEst ? "on" : "off");
  } else if (tok[0] == "fuse" && n == 2) {
    float v = tok[1].toFloat();
    if (v <= 0.0f || v > 1.0f) {
      Serial.println("ERR: fuse must be >0 and <=1");
      return;
    }
    fuseGain = v;
    Serial.printf("OK: fuse %.2f\n", v);
  } else if (tok[0] == "ahead" && n == 2) {
    float v = tok[1].toFloat();
    if (v < 0.0f || v > 20.0f) {
      Serial.println("ERR: ahead must be 0-20 seconds");
      return;
    }
    aheadSec = v;
    Serial.printf("OK: ahead %.1f s\n", v);
  } else if (tok[0] == "adapt" && n == 2) {
    adapt = (tok[1] == "on" || tok[1] == "1");
    lastAdapt = millis();
    Serial.printf("OK: adapt %s\n", adapt ? "on" : "off");
  } else if (tok[0] == "lambda" && n == 2) {
    float v = tok[1].toFloat();
    if (v < 0.05f || v > 2.0f) {
      Serial.println("ERR: lambda must be 0.05-2");
      return;
    }
    lambdaFactor = v;
    Serial.printf("OK: lambda %.2f\n", v);
  } else if (tok[0] == "autotune" && n == 2) {
    if (!parseTarget(tok[1], a, b)) {
      Serial.println("ERR: heater must be 1-5 or 'all'");
      return;
    }
    for (int i = a; i <= b; i++) {
      float kp, ki;
      if (computeTune(i, kp, ki)) {
        applyTune(i, kp, ki);
        savePid(i);
        printCfg(i);
        Serial.printf("OK: heater %d autotune kp %g ki %g\n", i + 1, kp, ki);
      } else {
        Serial.printf("ERR: heater %d model not ready (run it at several PWM levels)\n", i + 1);
      }
    }
  } else if (tok[0] == "learn" && n == 3) {
    if (!parseTarget(tok[1], a, b)) {
      Serial.println("ERR: heater must be 1-5 or 'all'");
      return;
    }
    bool on = (tok[2] == "on" || tok[2] == "1");
    for (int i = a; i <= b; i++) {
      if (on) {
        startLearning(i);
        Serial.printf("OK: heater %d learning started - vary the PWM\n", i + 1);
      } else if (mdl[i].learning) {
        if (stopLearning(i))
          Serial.printf("OK: heater %d model learned and saved\n", i + 1);
        else
          Serial.printf("ERR: heater %d too little data (need ~1 min), kept old model\n", i + 1);
      }
    }
  } else if (tok[0] == "mdl" && n == 3 && tok[1] == "reset") {
    if (!parseTarget(tok[2], a, b)) {
      Serial.println("ERR: heater must be 1-5 or 'all'");
      return;
    }
    for (int i = a; i <= b; i++) {
      resetModel(i);
      mdl[i].learning = false;
      eraseModel(i);
    }
    Serial.printf("OK: model %s reset\n", tok[2].c_str());
  } else if ((tok[0] == "auto" || tok[0] == "manual") && n == 2) {
    if (!parseTarget(tok[1], a, b)) {
      Serial.println("ERR: heater must be 1-5 or 'all'");
      return;
    }
    setMode(a, b, tok[0] == "auto");
    Serial.printf("OK: %s %s\n", tok[1].c_str(), tok[0].c_str());
  } else if (tok[0] == "sp" && n == 3) {
    if (!parseTarget(tok[1], a, b) || tok[1] == "all") {
      Serial.println("ERR: sp needs heater 1-5");
      return;
    }
    pid[a].sp = tok[2].toFloat();
    savePid(a);
    Serial.printf("OK: heater %d sp %g\n", a + 1, pid[a].sp);
  } else if (tok[0] == "pid" && n == 5) {
    if (!parseTarget(tok[1], a, b) || tok[1] == "all") {
      Serial.println("ERR: pid needs heater 1-5");
      return;
    }
    pid[a].kp = tok[2].toFloat();
    pid[a].ki = tok[3].toFloat();
    pid[a].kd = tok[4].toFloat();
    resetPid(a);
    savePid(a);
    Serial.printf("OK: heater %d pid %g %g %g saved\n", a + 1, pid[a].kp,
                  pid[a].ki, pid[a].kd);
  } else if (n == 2 && parseTarget(tok[0], a, b)) {
    // manual PWM: "<1-5|all> <0-100>"
    int pct = tok[1].toInt();
    if (pct < 0 || pct > 100) {
      Serial.println("ERR: percent must be 0-100");
      return;
    }
    setMode(a, b, false);
    for (int i = a; i <= b; i++) setHeater(i, pct);
    Serial.printf("OK: heater %s %d%%\n", tok[0].c_str(), pct);
  } else {
    Serial.println("ERR: unknown command");
  }
}

void pollSerial() {
  static String buf;
  while (Serial.available()) {
    char c = Serial.read();
    if (c == '\n' || c == '\r') {
      handleCommand(buf);
      buf = "";
    } else if (buf.length() < 48) {
      buf += c;
    }
  }
}

// ---------------- thermocouples ----------------
double readThermocouple(uint8_t csPin) {
  uint16_t v;

  digitalWrite(csPin, LOW);
  delayMicroseconds(10);

  v = shiftIn(SO_PIN, SCK_PIN, MSBFIRST);
  v <<= 8;
  v |= shiftIn(SO_PIN, SCK_PIN, MSBFIRST);

  digitalWrite(csPin, HIGH);

  if (v & 0x4) {
    // Bit 2 set = thermocouple input open (not connected)
    return NAN;
  }

  v >>= 3;          // drop the 3 status/tristate bits
  return v * 0.25;  // 12-bit value, 0.25 C per LSB
}

void setup() {
  Serial.begin(115200);
  delay(500);

  pinMode(SCK_PIN, OUTPUT);
  digitalWrite(SCK_PIN, LOW);

  pinMode(SO_PIN, INPUT);

  for (uint8_t i = 0; i < NUM_SENSORS; i++) {
    pinMode(CS_PINS[i], OUTPUT);
    digitalWrite(CS_PINS[i], HIGH); // idle high (deselected)
  }

  // Heaters start OFF
  for (uint8_t i = 0; i < NUM_HEATERS; i++) {
    ledcAttach(HEATER_PINS[i], PWM_FREQ, PWM_BITS);
    setHeater(i, 0);
  }

  loadPid();
  loadModel();
  lastGainSave = millis();

  // MAX6675 needs time after power-up before first valid conversion
  delay(500);
}

void loop() {
  static uint32_t cycleStart = millis();
  static uint32_t lastCtrl = millis();

  // Wait for the end of the period (listening for commands), then read, so
  // the newest reading is processed right away
  uint32_t until = cycleStart + LOOP_MS;
  while ((int32_t)(millis() - until) < 0) {
    pollSerial();
    delay(1);
  }

  uint32_t now = millis();
  float dt = (now - lastCtrl) / 1000.0f;
  lastCtrl = now;
  cycleStart += LOOP_MS;
  if ((int32_t)(now - cycleStart) > (int32_t)LOOP_MS) cycleStart = now;  // overrun

  for (uint8_t i = 0; i < NUM_SENSORS; i++) {
    double tempC = smooth(i, readThermocouple(CS_PINS[i]), dt);
    modelStep(i, tempC);

    // PID input: the measurement, or the model-fused estimate if enabled
    double pv = tempC;
    if (useEst && mdl[i].estValid && modelReady(i))
      pv = mdl[i].est * MODEL_SCALE + MODEL_REF;
    if (aheadSec > 0.0f && !isnan(pv) && modelReady(i))
      pv = predictAhead(i, pv);
    runPid(i, pv, dt);
    mdl[i].prevU = heaterOut[i] / 100.0f;  // duty that acts until next sample

    Serial.print("TC");
    Serial.print(i + 1);
    Serial.print(": ");

    if (isnan(tempC)) {
      Serial.print("NC");
    } else {
      Serial.print(tempC, 2);
    }

    if (i < NUM_SENSORS - 1) Serial.print(" | ");
  }

  Serial.print(" | OUT:");
  for (uint8_t i = 0; i < NUM_HEATERS; i++) {
    Serial.print(' ');
    Serial.print(heaterOut[i], 1);
  }

  // Model prediction of this sample (made before seeing it), "-" if none
  Serial.print(" | PRD:");
  for (uint8_t i = 0; i < NUM_SENSORS; i++) {
    Serial.print(' ');
    if (mdl[i].predValid && modelValid(i))
      Serial.print(mdl[i].pred * MODEL_SCALE + MODEL_REF, 2);
    else
      Serial.print('-');
  }

  // Learned model coefficients a, b, c per channel ("- - -" until ready);
  // the GUI uses them to draw the forecast
  Serial.print(" | MDL:");
  for (uint8_t i = 0; i < NUM_SENSORS; i++) {
    Serial.print(' ');
    if (modelValid(i)) {
      Serial.print(mdl[i].th[0], 5);
      Serial.print(' ');
      Serial.print(mdl[i].th[1], 5);
      Serial.print(' ');
      Serial.print(mdl[i].th[2], 5);
    } else {
      Serial.print("- - -");
    }
  }

  // Learning progress: samples collected while learning, "-" when frozen
  Serial.print(" | LRN:");
  for (uint8_t i = 0; i < NUM_SENSORS; i++) {
    Serial.print(' ');
    if (mdl[i].learning) Serial.print(mdl[i].updates);
    else Serial.print('-');
  }
  Serial.println();

  // Adaptive PID: re-tune from the learned model once a minute
  if (adapt && millis() - lastAdapt > 60000UL) {
    lastAdapt = millis();
    for (uint8_t i = 0; i < NUM_HEATERS; i++) {
      float kp, ki;
      if (pid[i].autoMode && computeTune(i, kp, ki)) {
        applyTune(i, kp, ki);
        printCfg(i);
      }
    }
  }

  // Adapted PID gains are written less often
  if (adapt && millis() - lastGainSave > 600000UL) {
    lastGainSave = millis();
    for (uint8_t i = 0; i < NUM_HEATERS; i++) savePid(i);
  }
}
