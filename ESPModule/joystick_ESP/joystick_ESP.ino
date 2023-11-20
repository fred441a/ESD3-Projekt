/*
 * This ESP32 code is created by esp32io.com
 *
 * This ESP32 code is released in the public domain
 *
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-joystick
 */

#define VRX_PIN 34  // ESP32 pin GPIO36 (ADC0) connected to VRX pin
#define VRY_PIN 35  // ESP32 pin GPIO39 (ADC0) connected to VRY pin

int valueX = 0;  // to store the X-axis value
int valueY = 0;  // to store the Y-axis value
uint32_t desiredHeight = 500;


void setup() {
  Serial.begin(115200);
  pinMode(15, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(4, OUTPUT);
}

void loop() {
  // read X and Y analog values
  valueX = analogRead(VRX_PIN);
  valueY = analogRead(VRY_PIN);

  // print data to Serial Monitor on Arduino IDE
  Serial.print("x = ");
  Serial.print(valueX);
  Serial.print(", y = ");
  Serial.println(valueY);
  //delay(200);
  if (valueX >= 3500) {  // If the joystick is completely at the top, the drone should rise quickly
    desiredHeight += 15;         // Increments desiredHeight by 15mm
    Serial.println("SÅ SKER DER SATME NOGET OPAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
  } else if (valueX >= 3000 && valueX < 3500) {
    desiredHeight += 10;  // Increments desiredHeight by 10mm
  } else if (valueX > 2500 && valueX < 3000) {
    desiredHeight += 5;  // Increments desiredHeight by 5mm
  } else if (valueX < 1500 && valueX > 1000) {
    desiredHeight -= 5;  // Decrements desiredHeight by 5mm
  } else if (valueX <= 1000 && valueX > 500) {
    desiredHeight -= 10;  // Decrements desiredHeight by 10mm
  } else if (valueX <= 500) {
    desiredHeight -= 15;  // Decrements desiredHeight by 15mm
  }
  Serial.println(desiredHeight);
}