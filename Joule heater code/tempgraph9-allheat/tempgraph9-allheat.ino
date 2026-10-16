#include <Arduino.h>
#include <max6675.h>
#include <Adafruit_NeoPixel.h>
#include <math.h>

// ==================================================
// =============== PIN / HW CONFIG ===================
// ==================================================

// Heater pins (match your schematic H1..H5)
static const int HEAT_PINS[5] = {4, 3, 2, 1, 0};     // H1..H5
static const int HEAT_CH[5]   = {0, 1, 2, 3, 4};     // LEDC channels (used for older cores)

// ESP32 PWM configuration
static const int PWM_FREQ = 1000;   // 1 kHz
static const int PWM_RES  = 8;      // 8-bit (0..255)

// Thermocouple pins (shared SCK/SO, separate CS)
static const int PIN_SCK = 5;
static const int PIN_SO  = 6;
static const int CS1 = 20;
static const int CS2 = 10;
static const int CS3 = 9;
static const int CS4 = 8;
static const int CS5 = 7;

// Calibration
static const float CAL_OFFSET  = -2.5f;

// NeoPixel LED setup
#define LED_PIN     21
#define LED_COUNT   5
#define LED_BRIGHT  80
Adafruit_NeoPixel leds(LED_COUNT, LED_PIN, NEO_GRB + NEO_KHZ800);

// Thermocouple objects
MAX6675 tc1(PIN_SCK, CS1, PIN_SO);
MAX6675 tc2(PIN_SCK, CS2, PIN_SO);
MAX6675 tc3(PIN_SCK, CS3, PIN_SO);
MAX6675 tc4(PIN_SCK, CS4, PIN_SO);
MAX6675 tc5(PIN_SCK, CS5, PIN_SO);

// Timing
static const unsigned long READ_PERIOD_MS = 250;

// ==================================================
// ================= FILTERING =======================
// ==================================================

static const int   SMA_N      = 8;
static const float EMA_ALPHA  = 0.18f;
static const float DEADBAND_C = 0.00f;

struct FilterState {
  // Median(3)
  double m3[3] = {0, 0, 0};
  uint8_t m3i = 0;
  bool m3filled = false;

  // SMA
  double smaBuf[SMA_N] = {0};
  int smaIdx = 0;
  bool smaFilled = false;
  double sma_accum = 0;

  // EMA
  double emaVal = 0;
  bool emaInit = false;

  // Deadband hold
  double held = NAN;
};

FilterState filters[5];

inline double median3(double a, double b, double c) {
  if (a > b) { double t=a; a=b; b=t; }
  if (b > c) { double t=b; b=c; c=t; }
  if (a > b) { double t=a; a=b; b=t; }
  return b;
}

double runFilter(double inputC, FilterState &f, unsigned long /*dt_ms*/) {
  if (isnan(inputC)) return NAN;

  // 1) Median(3)
  f.m3[f.m3i] = inputC;
  f.m3i = (f.m3i + 1) % 3;
  if (f.m3i == 0) f.m3filled = true;
  double med = f.m3filled ? median3(f.m3[0], f.m3[1], f.m3[2]) : inputC;

  // 2) SMA(N)
  if (!f.smaFilled && f.smaIdx == 0) {
    for (int i = 0; i < SMA_N; i++) { f.smaBuf[i] = med; f.sma_accum += med; }
    f.smaFilled = true;
  } else {
    f.sma_accum -= f.smaBuf[f.smaIdx];
    f.smaBuf[f.smaIdx] = med;
    f.sma_accum += med;
    f.smaIdx = (f.smaIdx + 1) % SMA_N;
  }
  double sma = f.sma_accum / SMA_N;

  // 3) EMA
  if (!f.emaInit) {
    f.emaVal = sma;
    f.emaInit = true;
  } else {
    f.emaVal = EMA_ALPHA * sma + (1.0 - EMA_ALPHA) * f.emaVal;
  }

  // 4) Deadband
  if (isnan(f.held)) f.held = f.emaVal;
  if (fabs(f.emaVal - f.held) >= DEADBAND_C) {
    f.held = f.emaVal;
  }
  return f.held;
}

// ==================================================
// =============== HEATER CONTROL ====================
// ==================================================

int currentPWM[5] = {0, 0, 0, 0, 0};   // duty 0..255 per heater
bool safetyTriggered = false;

static inline int heaterIndexFromToken(const String& token) {
  // Accept: H1..H5 or N1..N5
  if (token.length() < 2) return -1;
  char c0 = token.charAt(0);
  if (c0 != 'H' && c0 != 'N') return -1;
  int n = token.substring(1).toInt();
  if (n < 1 || n > 5) return -1;
  return n - 1; // 0..4
}

void setHeaterPWMIdx(int idx, int duty) {
  duty = constrain(duty, 0, 255);
  currentPWM[idx] = duty;

#if defined(ESP_ARDUINO_VERSION_MAJOR) && (ESP_ARDUINO_VERSION_MAJOR >= 3)
  // Arduino-ESP32 v3+: ledcWrite takes pin
  ledcWrite(HEAT_PINS[idx], duty);
#else
  // Older Arduino-ESP32: ledcWrite takes channel
  ledcWrite(HEAT_CH[idx], duty);
#endif
}

void setAllHeatersPWM(int duty) {
  duty = constrain(duty, 0, 255);
  for (int i = 0; i < 5; i++) setHeaterPWMIdx(i, duty);
}

void allHeatersOff() {
  for (int i = 0; i < 5; i++) setHeaterPWMIdx(i, 0);
}

// ==================================================
// ================= LED TREND =======================
// ==================================================

void updateLEDTrend(int ledIdx, double current, double previous) {
  const double THRESHOLD = 0.2; // °C per sample
  if (isnan(current) || isnan(previous)) {
    leds.setPixelColor(ledIdx, 0);
    return;
  }
  double diff = current - previous;
  if (diff > THRESHOLD) {
    leds.setPixelColor(ledIdx, leds.Color(255, 0, 0));   // rising = red
  } else if (diff < -THRESHOLD) {
    leds.setPixelColor(ledIdx, leds.Color(0, 255, 0));   // falling = green
  } else {
    leds.setPixelColor(ledIdx, 0);                       // steady = off
  }
}

// ==================================================
// ================= COMMAND PARSER ==================
// ==================================================
//
// Supported commands (case-insensitive):
//
// Legacy (keeps your Python GUI working):
//   - "N1 ON"     -> H1 full ON (255) and clears safetyTriggered
//   - "N1 OFF"    -> H1 OFF
//   - "PWM 123"   -> sets H1 duty (0..255) if not safetyTriggered
//
// Independent per-heater control:
//   - "N2 ON" / "N2 OFF" / "N2 PWM 80" -> controls ONLY heater 2
//   - "H3 ON" / "H3 OFF" / "H3 PWM 80" -> controls ONLY heater 3
//
// All-heaters control:
//   - "ALL ON" / "ALL OFF" / "ALL PWM 120"
//
// Safety reset:
//   - "RESET" clears safetyTriggered latch (does NOT turn heaters on)
//
void handleCommand(const String& sIn) {
  String s = sIn;
  s.trim();
  s.toUpperCase();
  if (s.length() == 0) return;

  if (s == "RESET") {
    safetyTriggered = false;
    Serial.println("SAFETY RESET (commands enabled)");
    return;
  }

  // -------- Legacy: N1 + PWM (heater 1 only) --------
  if (s == "N1 ON") {
    safetyTriggered = false;
    setHeaterPWMIdx(0, 255);                 // ONLY H1
    Serial.println("N1 -> ON (H1=255)");
    return;
  }
  if (s == "N1 OFF") {
    setHeaterPWMIdx(0, 0);                   // ONLY H1
    Serial.println("N1 -> OFF (H1=0)");
    return;
  }
  if (s.startsWith("PWM ")) {
    if (safetyTriggered) {
      Serial.println("IGNORED: Safety Cutoff Active");
      return;
    }
    int duty = s.substring(4).toInt();
    setHeaterPWMIdx(0, duty);                // ONLY H1
    Serial.print("PWM SET (H1) -> "); Serial.println(currentPWM[0]);
    return;
  }

  // -------- All-heaters commands --------
  if (s == "ALL ON") {
    if (safetyTriggered) { Serial.println("IGNORED: Safety Cutoff Active"); return; }
    setAllHeatersPWM(255);
    Serial.println("ALL -> ON (255)");
    return;
  }
  if (s == "ALL OFF") {
    allHeatersOff();
    Serial.println("ALL -> OFF");
    return;
  }
  if (s.startsWith("ALL PWM ")) {
    if (safetyTriggered) { Serial.println("IGNORED: Safety Cutoff Active"); return; }
    int duty = s.substring(String("ALL PWM ").length()).toInt();
    setAllHeatersPWM(duty);
    Serial.print("ALL PWM -> "); Serial.println(constrain(duty, 0, 255));
    return;
  }

  // -------- Per-heater commands: "Nn ..." or "Hn ..." --------
  int sp = s.indexOf(' ');
  String tok1 = (sp < 0) ? s : s.substring(0, sp);   // e.g. N2 / H3
  String rest = (sp < 0) ? "" : s.substring(sp + 1); // e.g. ON / OFF / PWM 80
  rest.trim();

  int idx = heaterIndexFromToken(tok1);
  if (idx >= 0) {
    if (rest == "ON") {
      if (safetyTriggered) { Serial.println("IGNORED: Safety Cutoff Active"); return; }
      setHeaterPWMIdx(idx, 255);                     // ONLY this heater
      Serial.print(tok1); Serial.println(" -> ON (255)");
      return;
    }
    if (rest == "OFF") {
      setHeaterPWMIdx(idx, 0);                       // ONLY this heater
      Serial.print(tok1); Serial.println(" -> OFF (0)");
      return;
    }
    if (rest.startsWith("PWM ")) {
      if (safetyTriggered) { Serial.println("IGNORED: Safety Cutoff Active"); return; }
      int duty = rest.substring(4).toInt();
      setHeaterPWMIdx(idx, duty);                    // ONLY this heater
      Serial.print(tok1); Serial.print(" PWM -> "); Serial.println(currentPWM[idx]);
      return;
    }
  }

  Serial.print("UNKNOWN CMD: ");
  Serial.println(s);
}

// ==================================================
// ==================== SETUP ========================
// ==================================================

void setupPWM() {
  for (int i = 0; i < 5; i++) {
#if defined(ESP_ARDUINO_VERSION_MAJOR) && (ESP_ARDUINO_VERSION_MAJOR >= 3)
    // Arduino-ESP32 v3+: ledcAttach(pin, freq, resolution) and ledcWrite(pin, duty)
    if (!ledcAttach(HEAT_PINS[i], PWM_FREQ, PWM_RES)) {
      Serial.print("PWM Attach Failed on pin ");
      Serial.println(HEAT_PINS[i]);
    }
    ledcWrite(HEAT_PINS[i], 0);
#else
    // Older Arduino-ESP32: ledcSetup(channel,freq,res) + ledcAttachPin(pin,channel)
    ledcSetup(HEAT_CH[i], PWM_FREQ, PWM_RES);
    ledcAttachPin(HEAT_PINS[i], HEAT_CH[i]);
    ledcWrite(HEAT_CH[i], 0);
#endif
  }
}

void setup() {
  Serial.begin(115200);
  delay(300);

  // PWM outputs
  setupPWM();
  allHeatersOff();

  // LEDs
  leds.begin();
  leds.setBrightness(LED_BRIGHT);
  leds.clear();
  leds.show();

  // Thermocouple CS pins as outputs (keep HIGH when idle)
  pinMode(CS1, OUTPUT); digitalWrite(CS1, HIGH);
  pinMode(CS2, OUTPUT); digitalWrite(CS2, HIGH);
  pinMode(CS3, OUTPUT); digitalWrite(CS3, HIGH);
  pinMode(CS4, OUTPUT); digitalWrite(CS4, HIGH);
  pinMode(CS5, OUTPUT); digitalWrite(CS5, HIGH);

  Serial.println("ESP32 Ready: 5-Heater PWM + 5-Channel Filtering (independent heaters)");
}

// ==================================================
// ===================== LOOP ========================
// ==================================================

void loop() {
  // ---------- Serial command handling ----------
  static String cmd;
  while (Serial.available()) {
    char c = (char)Serial.read();
    if (c == '\n') {
      if (cmd.length()) {
        handleCommand(cmd);
        cmd = "";
      }
    } else if (c != '\r') {
      cmd += c;
    }
  }

  // ---------- Timing ----------
  static unsigned long last = 0;
  unsigned long now = millis();
  if (now - last < READ_PERIOD_MS) return;
  unsigned long dt_ms = now - last;
  last = now;

  // ---------- 1) Read raw thermocouples ----------
  double raw[5];
  raw[0] = tc1.readCelsius();
  raw[1] = tc2.readCelsius();
  raw[2] = tc3.readCelsius();
  raw[3] = tc4.readCelsius();
  raw[4] = tc5.readCelsius();

  // ---------- 2) Offset + filter ----------
  double t_final[5];
  for (int i = 0; i < 5; i++) {
    double valWithOffset = isnan(raw[i]) ? NAN : (raw[i] + CAL_OFFSET);
    t_final[i] = runFilter(valWithOffset, filters[i], dt_ms);
  }

  // ---------- 3) Safety cutoff removed ----------

  // ---------- 4) LED trend for all 5 channels ----------
  static double prevT[5] = {NAN, NAN, NAN, NAN, NAN};
  for (int i = 0; i < 5; i++) {
    updateLEDTrend(i, t_final[i], prevT[i]);
    prevT[i] = t_final[i];
  }
  leds.show();

  // ---------- 5) Serial output (for your Python plotter) ----------
  Serial.print("T1:");      Serial.print(raw[0] + CAL_OFFSET, 2); Serial.print(" ");
  Serial.print("T1_filt:"); Serial.print(t_final[0], 2);          Serial.print(" ");

  Serial.print("T2:");      Serial.print(raw[1] + CAL_OFFSET, 2); Serial.print(" ");
  Serial.print("T2_filt:"); Serial.print(t_final[1], 2);          Serial.print(" ");

  Serial.print("T3:");      Serial.print(raw[2] + CAL_OFFSET, 2); Serial.print(" ");
  Serial.print("T3_filt:"); Serial.print(t_final[2], 2);          Serial.print(" ");

  Serial.print("T4:");      Serial.print(raw[3] + CAL_OFFSET, 2); Serial.print(" ");
  Serial.print("T4_filt:"); Serial.print(t_final[3], 2);          Serial.print(" ");

  Serial.print("T5:");      Serial.print(raw[4] + CAL_OFFSET, 2); Serial.print(" ");
  Serial.print("T5_filt:"); Serial.print(t_final[4], 2);          Serial.print(" ");

  // Output PWM states for all heaters
  Serial.print("PWM1:"); Serial.print(currentPWM[0]); Serial.print(" ");
  Serial.print("PWM2:"); Serial.print(currentPWM[1]); Serial.print(" ");
  Serial.print("PWM3:"); Serial.print(currentPWM[2]); Serial.print(" ");
  Serial.print("PWM4:"); Serial.print(currentPWM[3]); Serial.print(" ");
  Serial.print("PWM5:"); Serial.print(currentPWM[4]); Serial.print(" ");

  // Legacy "PWM:" for compatibility (maps to heater 1)
  Serial.print("PWM:");  Serial.println(currentPWM[0]);
}
