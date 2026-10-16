int current_sens = A4;
int mosfet = 9;
int pwm_out = 0;

float voltage_suply = 12.0;
float target_res = 600;
int pwm_resolution = 12;
int adc_resolution = 14;

float error,deri,inter, l_error, l_time;
float kp = 0.1;
float ki = 0;
float kd = 80;
float trendderi = -10;
// Define a structure to hold all three readings
struct Measurement {
  float resistance;
  float voltage;
  float current;
};

void setup() {
  analogReadResolution(adc_resolution);
  Serial.begin(115200);
  pinMode(current_sens, INPUT);  
  pinMode(mosfet, OUTPUT);
}

void loop() {
  checkSerialInput();

  Measurement data = measure(current_sens, mosfet);
  float now = millis();
  float passing = now - l_time;
  l_time = now;
  error = target_res - data.resistance;
  deri = error - l_error;
  inter += error;
  l_error = error;

  pwm_out = (kp*error + kd*deri/passing + ki*inter/passing)*pow(2,pwm_resolution);

  pwm_out = constrain(pwm_out, 0, pow(2,pwm_resolution));
  analogWrite(mosfet, pwm_out);  
  float time_lapse = millis()/(1000.0f*60.0f);

  trendderi = trendderi*0.8 + deri/passing*0.2;
  Serial.println(trendderi, 10);
  if(trendderi > 0.01){
    target_res = data.resistance;
  }
  // Print formatted values to the Serial Monitor
  Serial.print("Time: ");
  Serial.print(time_lapse, 3);
  Serial.print(" | Voltage: ");
  Serial.print(data.voltage, 1);
  Serial.print(" V | Current: ");
  Serial.print(data.current, 4);
  Serial.print(" A | Resistance: "); 
  Serial.print(data.resistance, 2);
  Serial.print(" Ohms | Target: ");
  Serial.print(target_res, 2);
  Serial.print(" Ohms | PWM: ");
  Serial.print(pwm_out*100/pow(2,pwm_resolution));
  Serial.print("%");
  Serial.println();
  
  delay(100);
}

Measurement measure(int pin_in, int pin_out) {
  analogWrite(pin_out, pow(2,pwm_resolution));
  int raw_adc = pow(2,adc_resolution);
  for(int a=0;a<100;a++){
    raw_adc = min(analogRead(pin_in),raw_adc);
  }
  analogWrite(pin_out, 0);

  Measurement m;
  m.current = (raw_adc * 5.0f / pow(2,adc_resolution)) / 9.2f;
  m.voltage = voltage_suply - (raw_adc * 5.0f / pow(2,adc_resolution));
  
  // Guard against division by zero if current is 0
  if (m.current != 0.0f) {
    m.resistance = m.voltage / m.current;
  } else {
    m.resistance = 99999999.0f;
  }

  return m;
}

void checkSerialInput() {
  if (Serial.available() > 0) {
    float new_target = Serial.parseFloat();
    // Clear out any trailing characters (like '\n') left in the buffer
    while (Serial.available() > 0) {
      Serial.read();
    }
    if (new_target > 0.0f) {
      target_res = new_target;
      Serial.print(">> Target resistance updated to: ");
      Serial.print(target_res, 2);
      Serial.println(" Ohms");
    }
  }
}