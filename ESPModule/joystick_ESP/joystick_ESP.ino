/*
 * This ESP32 code is created by esp32io.com
 *
 * This ESP32 code is released in the public domain
 *
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-joystick
 */

#define VRZ_PIN 34    // ESP32 pin GPIO36 (ADC0) connected to VRX pin
#define VRYAW_PIN 35  // ESP32 pin GPIO39 (ADC0) connected to VRY pin
#define VRX_PIN 36
#define VRY_PIN 39

int valueZ = 0;    // to store the X-axis value
int valueYaw = 0;  // to store the Y-axis value
int valueX = 0;
int valueY = 0;
uint32_t desiredHeight = 500;


void setup() {
  Serial.begin(115200);
  pinMode(15, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(4, OUTPUT);
}

void loop() {
  // read X and Y analog values
  valueZ = analogRead(VRZ_PIN);
  valueYaw = analogRead(VRYAW_PIN);
  valueX = analogRead(VRX_PIN);
  valueY = analogRead(VRY_PIN);

  // print data to Serial Monitor on Arduino IDE
  Serial.print("Z = ");
  Serial.print(valueZ);
  Serial.print(", yaw = ");
  Serial.print(valueYaw);
  Serial.print(", X = ");
  Serial.print(valueX);
  Serial.print(", y = ");
  Serial.println(valueY);
  //delay(200);
  /*
  if (valueZ >= 3500) {  // If the joystick is completely at the top, the drone should rise quickly
    desiredHeight += 15;         // Increments desiredHeight by 15mm
    Serial.println("SÅ SKER DER SATME NOGET OPAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
  } else if (valueZ >= 3000 && valueZ < 3500) {
    desiredHeight += 10;  // Increments desiredHeight by 10mm
  } else if (valueZ > 2500 && valueZ < 3000) {
    desiredHeight += 5;  // Increments desiredHeight by 5mm
  } else if (valueZ < 1500 && valueZ > 1000) {
    desiredHeight -= 5;  // Decrements desiredHeight by 5mm
  } else if (valueZ <= 1000 && valueZ > 500) {
    desiredHeight -= 10;  // Decrements desiredHeight by 10mm
  } else if (valueZ <= 500) {
    desiredHeight -= 15;  // Decrements desiredHeight by 15mm
  }
  //Serial.println(desiredHeight);*/
}