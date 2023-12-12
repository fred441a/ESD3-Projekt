#include <Arduino.h>            // Necessary for accessing FreeRTOS via Arduino IDE
#include "Wire.h"               // Necessary for I2C communication
#include <freertos/FreeRTOS.h>  // Necessary for accessing FreeRTOS
#include <freertos/task.h>      // Necessary for using tasks in FreeRTOS
#include <freertos/semphr.h>    // Enables semaphores
#include "Adafruit_VL53L0X.h"   // Library for the range sensor
#include <Adafruit_MPU6050.h>   // Library for gyroscope and accelormeter
void setup() {
  Serial.begin(115200);   // Initialisation of serial monitor
  Wire.begin();           // Join I2C bus
  Wire.setClock(400000);  // 400khz
  pinMode(26, OUTPUT);
  digitalWrite(26, LOW);
  writeToAddress(0x08, 0x01, 0x01);  // Updates the external ready bit to a high
  delay(10000);
  //getData();
}

void loop() {
  // put your main code here, to run repeatedly:
//readFromAddress(0x08, 0x15);
delay(10);
}

void getData() {
  // writte to all registers
  /*writeToAddress(SLAVE_ADDR, 0x01, 0xffffffff);
  for (int i = 2; i <= 45; i++)
    writeToAddress(SLAVE_ADDR, i, 0x18192021);
*/
  // read all register values
  for (int i = 1; i <= 45; i++)
    readFromAddress(0x08, i);
}

void writeToAddress(uint8_t slaveAddress, uint8_t regAddress, uint32_t data) {
  Wire.beginTransmission(slaveAddress);  // Starts sending data to assigned address
  Wire.write(regAddress);                // Register to write to
  Wire.write((byte)(data >> 24));        // Bitshits right 24 times so that the 8 MSB bits will be send first
  Wire.write((byte)(data >> 16));        // Bitshits right 16 times
  Wire.write((byte)(data >> 8));         // Bitshits right 8 times
  Wire.write((byte)(data >> 0));         // Bitshits right 0 times
  Wire.endTransmission();                // Ends sending data to assigned address
}

void readFromAddress(uint8_t slaveAddress, uint8_t regAddress) {
  Wire.beginTransmission(slaveAddress);  
  Wire.write(regAddress); // register to read from
  Wire.endTransmission();  

  Wire.requestFrom(slaveAddress, 4);    // request 4 bytes from slave device #8

  Serial.print("Reg: 0x"); Serial.print(regAddress, HEX);
  Serial.print(" value: 0x");
  while (Wire.available()) { // slave may send less than requested
    char c = Wire.read(); // receive a byte as character
    Serial.print(c, HEX);         // print the character
  }
  Serial.println();
}
