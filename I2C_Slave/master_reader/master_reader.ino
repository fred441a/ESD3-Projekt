// Wire Master Reader
// by Nicholas Zambetti <http://www.zambetti.com>

// Demonstrates use of the Wire library
// Reads data from an I2C/TWI slave device
// Refer to the "Wire Slave Sender" example for use with this

// Created 29 March 2006

// This example code is in the public domain.


#include <Wire.h>

#define SLAVE_ADDR 0x08

void setup() {
  Wire.begin();           // join I2C bus (address optional for master)
  Wire.setClock(400000);  // 400khz
  Serial.begin(115200);   // start serial for output

  getData();
}

void loop() {
  delay(100);
}

void getData() {
  // writte to all registers
  writeToAddress(SLAVE_ADDR, 0x01, 0xffffffff);
  for (int i = 2; i <= 45; i++)
    writeToAddress(SLAVE_ADDR, i, 0x18192021);

  // read all register values
  for (int i = 1; i <= 45; i++)
    readFromAddress(SLAVE_ADDR, i);
}

void writeToAddress(uint8_t slaveAddress, uint8_t regAddress, uint32_t data) {
  Wire.beginTransmission(slaveAddress);
  Wire.write(regAddress);  // register to write to
  Wire.write((byte)(data >> 24));
  Wire.write((byte)(data >> 16));
  Wire.write((byte)(data >> 8));
  Wire.write((byte)(data >> 0));
  Wire.endTransmission();
}

void readFromAddress(uint8_t slaveAddress, uint8_t regAddress) {
  Wire.beginTransmission(slaveAddress);
  Wire.write(regAddress);  // register to read from
  Wire.endTransmission();

  Wire.requestFrom(slaveAddress, 4);  // request 4 bytes from slave device #8

  Serial.print("Reg: 0x");
  Serial.print(regAddress, HEX);
  Serial.print(" value: 0x");
  while (Wire.available()) {  // slave may send less than requested
    char c = Wire.read();     // receive a byte as character
    Serial.print(c, HEX);     // print the character
  }
  Serial.println();
}