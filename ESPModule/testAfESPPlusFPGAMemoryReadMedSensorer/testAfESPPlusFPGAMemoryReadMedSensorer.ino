// Integrationtest of ESP/FPGA/Sensors

#define FPGAAddress 0x08         // I2C address of the FPGA
#define READ_SENSOR_I2C_WORKS 0  // Conditional compiling variable to change if the running code uses the FPGA as i2c master or if the ESP is the I2C master
#define builtInLED 2             // Builtin LED pin for debugging

#include <Adafruit_MPU6050.h>

Adafruit_MPU6050 mpu;
Adafruit_Sensor *mpu_temp, *mpu_accel, *mpu_gyro;

#include "Adafruit_VL53L0X.h"

Adafruit_VL53L0X lox = Adafruit_VL53L0X();
VL53L0X_RangingMeasurementData_t measure;

void setup(void) {
  Serial.begin(115200);         // Initialisation of serial monitor
  Wire.begin();                 // Join I2C bus
  Wire.setClock(400000);        // 400khz
  pinMode(builtInLED, OUTPUT);  // Enables the LED for debugging

  while (!Serial)
    delay(10);  // will pause Zero, Leonardo, etc until serial console opens

  Serial.println("Adafruit MPU6050 test!");

  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }

  Serial.println("MPU6050 Found!");
  mpu_temp = mpu.getTemperatureSensor();
  mpu_temp->printSensorDetails();

  mpu_accel = mpu.getAccelerometerSensor();
  mpu_accel->printSensorDetails();

  mpu_gyro = mpu.getGyroSensor();
  mpu_gyro->printSensorDetails();

  Serial.println("Adafruit VL53L0X test");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    while (1)
      ;
  }

  /*Ranging Profile:
    VL53L0X_SENSE_DEFAULT
    VL53L0X_SENSE_LONG_RANGE
    VL53L0X_SENSE_HIGH_SPEED
    VL53L0X_SENSE_HIGH_ACCURACY
  */
  lox.configSensor(Adafruit_VL53L0X::VL53L0X_SENSE_LONG_RANGE);

  // power
  Serial.println(F("VL53L0X API Simple Ranging example\n\n"));
  Serial.println("Calibration done");
  readyFPGA();                     // Sending ready signal for FPGA
  digitalWrite(builtInLED, HIGH);  // Sets the builtInLED on so we know when to switch the physical switch
  delay(15000);                    // Delay while the FPGA is setting up
  digitalWrite(builtInLED, LOW);   // Sets the builtInLED off so we know when we can no longer switch the physical switch
}

void loop() {
#if READ_SENSOR_I2C_WORKS == 1
  getData();
  delay(1000);
  Serial.println("Starter forfra");
#else
  //   Get a new normalized sensor event
  sensors_event_t accel;
  sensors_event_t gyro;
  sensors_event_t temp;
  mpu_temp->getEvent(&temp);
  mpu_accel->getEvent(&accel);
  mpu_gyro->getEvent(&gyro);

  Serial.print("\t\tTemperature ");
  Serial.print(temp.temperature);
  Serial.println(" deg C");

  // Display the results (acceleration is measured in m/s^2)
  Serial.print("\t\tAccel X: ");
  Serial.print(accel.acceleration.x);
  Serial.print(" \tY: ");
  Serial.print(accel.acceleration.y);
  Serial.print(" \tZ: ");
  Serial.print(accel.acceleration.z);
  Serial.println(" m/s^2 ");

  // Display the results (rotation is measured in rad/s)
  Serial.print("\t\tGyro X: ");
  Serial.print(gyro.gyro.x);
  Serial.print(" \tY: ");
  Serial.print(gyro.gyro.y);
  Serial.print(" \tZ: ");
  Serial.print(gyro.gyro.z);
  Serial.println(" radians/s ");
  Serial.println();

  delay(100);

//   serial plotter friendly format
/*Serial.print(temp.temperature);
  Serial.print(",");

  Serial.print(accel.acceleration.x);
  Serial.print(",");
  Serial.print(accel.acceleration.y);
  Serial.print(",");
  Serial.print(accel.acceleration.z);
  Serial.print(",");

  Serial.print(gyro.gyro.x);
  Serial.print(",");
  Serial.print(gyro.gyro.y);
  Serial.print(",");
  Serial.print(gyro.gyro.z);
  Serial.println();
  delay(10);*/

//Serial.print("Reading a measurement... ");
//lox.rangingTest(&measure, false);  // pass in 'true' to get debug data printout!

/*if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    Serial.print("Distance (mm): ");
    Serial.println(measure.RangeMilliMeter);
  } else {
    Serial.println(" out of range ");
  }*/
#endif
}

void readyFPGA() {
  writeToAddress(FPGAAddress, 0x01, 0x01);  // Updates the external ready bit to a high
}

void getData() {
  // writte to all registers
  //writeToAddress(SLAVE_ADDR, 0x01, 0xffffffff);
  //for (int i = 2; i <= 45; i++)
  //   writeToAddress(SLAVE_ADDR, i, 0x18192021);

  // read all register values
  for (int i = 1; i <= 45; i++)
    readFromAddress(FPGAAddress, i);
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

uint32_t readIntFromAddress(uint8_t slaveAddress, uint8_t regAddress) {
  Serial.println("Read Int From Address");            // Status update
  Wire.beginTransmission(slaveAddress);               // Starts sending data to assigned address
  Wire.write(regAddress);                             // Register to read from
  Wire.endTransmission();                             // Ends sending data to assigned address
  Wire.requestFrom(slaveAddress, 4);                  // Request 4 bytes from slave device
                                                      //Serial.print("Reg: 0x");               // Current register address being read
                                                      //Serial.print(regAddress, HEX);         // The actual address in hex
                                                      //Serial.print(" value: 0x");            // The value read from the register address
  uint32_t intReading = 0;                            // 32 bit value read
  for (int i = 0; i <= 3 && Wire.available(); i++) {  // Slave may send less than requested, but a cap has been implemented as well
    //char c = Wire.read();                             // Receive a byte as character
    //Serial.print(c, HEX);                // Print the character
    intReading = (intReading << 8) | Wire.read();  // Shift previous bytes and combine with the new byte
  }
  //Serial.println();  // Newline for readability
  Serial.println(intReading);
  return intReading;
}

float readFloatFromAddress(uint8_t slaveAddress, uint8_t regAddress) {
  Serial.println("Read Int From Address");  // Status update
  Wire.beginTransmission(slaveAddress);     // Starts sending data to assigned address
  Wire.write(regAddress);                   // Register to read from
  Wire.endTransmission();                   // Ends sending data to assigned address
  Wire.requestFrom(slaveAddress, 4);        // Request 4 bytes from slave device
  //Serial.print("Reg: 0x");               // Current register address being read
  //Serial.print(regAddress, HEX);         // The actual address in hex
  //Serial.print(" value: 0x");            // The value read from the register address
  float floatReading = 0;                             // 32 bit value read
  for (int i = 0; i <= 3 && Wire.available(); i++) {  // Slave may send less than requested, but a cap has been implemented as well
    //char c = Wire.read();                             // Receive a byte as character
    //Serial.print(c, HEX);                // Print the character
    *((uint32_t *)&floatReading) = (*((uint32_t *)&floatReading) << 8) | Wire.read();  // Shift previous bytes and combine with the new byte
  }
  //Serial.println();  // Newline for readability
  Serial.println(floatReading);
  return floatReading;
}