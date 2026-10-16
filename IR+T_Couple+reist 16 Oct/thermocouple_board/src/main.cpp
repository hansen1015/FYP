/*
 * ESP32-C3 SuperMini + MAX6675 thermocouple 1 only (read-only; no heaters here).
 *
 * Wiring: SCK -> GPIO 5, SO -> GPIO 6, CS1 -> GPIO 20, VCC -> 3.3V, GND -> GND
 *
 * Serial out (115200), one line every 500 ms:  "TC1: 24.50"  or  "TC1: NC" (open)
 */

#include <Arduino.h>

const uint8_t SCK_PIN = 5;
const uint8_t SO_PIN = 6;
const uint8_t CS_PIN = 20;

// MAX6675 needs 0.17-0.22 s per conversion; reading faster returns stale data.
const uint32_t LOOP_MS = 500;

double readThermocouple() {
  digitalWrite(CS_PIN, LOW);
  delayMicroseconds(10);
  uint16_t v = shiftIn(SO_PIN, SCK_PIN, MSBFIRST);
  v <<= 8;
  v |= shiftIn(SO_PIN, SCK_PIN, MSBFIRST);
  digitalWrite(CS_PIN, HIGH);

  if (v & 0x4) return NAN;  // bit 2 set = thermocouple input open
  return (v >> 3) * 0.25;   // 12-bit value, 0.25 C per LSB
}

void setup() {
  Serial.begin(115200);
  pinMode(SCK_PIN, OUTPUT);
  digitalWrite(SCK_PIN, LOW);
  pinMode(SO_PIN, INPUT);
  pinMode(CS_PIN, OUTPUT);
  digitalWrite(CS_PIN, HIGH);
  delay(500);  // MAX6675 power-up time
}

void loop() {
  static uint32_t next = millis();
  double t = readThermocouple();
  if (isnan(t)) Serial.println("TC1: NC");
  else Serial.printf("TC1: %.2f\n", t);

  next += LOOP_MS;
  int32_t wait = (int32_t)(next - millis());
  if (wait > 0) delay(wait);
  else next = millis();  // overrun
}
