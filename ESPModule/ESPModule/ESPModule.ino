#include <Arduino.h>            // Necessary for accessing FreeRTOS via Arduino IDE
#include "Wire.h"               // Necessary for I2C communication
#include <freertos/FreeRTOS.h>  // Necessary for accessing FreeRTOS
#include <freertos/task.h>      // Necessary for using tasks in FreeRTOS
#include <freertos/semphr.h>    // Enables semaphores
#include "Adafruit_VL53L0X.h"   // Library for the range sensor
#include <Adafruit_MPU6050.h>   // Library for gyroscope and accelormeter

#define INCLUDE_vTaskSuspend 1            // Definition of suspend function being active
#define builtInLED 2                      // Builtin LED pin for debugging
#define externalEnablePin 27              // The pin to activate the FPGA
#define takeOffPin 25                     // Pin to start take off
#define landPin 32                        // Pin to land again
#define startHeight 500                   // Height to achieve upon power on in mm
#define heightReachedPin 13               // Pin to turn on led indicating desired height is reached within tolerance
#define somethingIsWrongPin 12            // Pin to light up red LED
#define allGoodPin 14                     // Pin to light op green LED
#define emergencyButtonPin 33             // Emergency button connection pin
#define emergencyLightPin 26              // LED that signifies an emergency has happened
#define joystickInputXPin 36              // Input for the x axis
#define joystickInputYPin 39              // Input for the y axis
#define joystickInputZPin 34              // Input for the z axis
#define joystickInputYawPin 35            // Input for the yaw
#define heightTolerance 10                // Tolerance for how much a difference is allowed between currentHeight and desiredHeight
#define pitchAndRollTolerance 0.1         // Tolerance for how much a difference is allowed between current roll/pitch and desired roll/pitch
#define FPGAAddress 0x08                  // I2C address of the FPGA
#define configCHECK_FOR_STACK_OVERFLOW 1  // Checks whether or not stack overflow occurs
#define READ_SENSOR_I2C_WORKS 0           // Conditional compiling variable to change if the running code uses the FPGA as i2c master or if the ESP is the I2C master

TaskHandle_t hdlSafeTakeOff, hdlSafeLand, hdlHeightRead, hdlHeightDesired, hdlYawRead, hdlYawDesired, hdlPitchRead, hdlPitchDesired, hdlRollRead, hdlRollDesired, hdlStop;  // Must be made in order for the handles to work in xTaskCreate

SemaphoreHandle_t avgSem, Mutex;  // Creation of semaphore handles

Adafruit_VL53L0X lox = Adafruit_VL53L0X();  // Instantiates the range sensor
VL53L0X_RangingMeasurementData_t measure;   // Struct to keep measurements from range sensor

Adafruit_MPU6050 mpu;                              // Instantiates MPU module
Adafruit_Sensor *mpu_temp, *mpu_accel, *mpu_gyro;  // Necessary for adafruit library to function

// Global variables:
uint32_t desiredHeight = 0;  // Desired height in mm
uint32_t currentHeight;      // Variable to store current height measured by the vl52l0x
float currentYaw = 0;        // Current yaw measurement. Float to handle values given by MPU6050
float desiredYaw = 0;        // Desired yaw angle. Float to handle values given by MPU6050
float currentPitch = 0;      // Current pitch measurement. Float to handle values given by MPU6050
float desiredPitch = 0;      // Desired pitch angle. Float to handle values given by MPU6050
float currentRoll = 0;       // Current roll measurement. Float to handle values given by MPU6050
float desiredRoll = 0;       // Desired roll angle. Float to handle values given by MPU6050
float gyroReadX = 0;         // X-axis reading from gyro
float gyroReadY = 0;         // Y-axis reading from gyro
float gyroReadZ = 0;         // Z-axis reading from gyro
float accelReadX = 0;        // X-axis reading from accelerometer
float accelReadY = 0;        // Y-axis reading from accelerometer
float accelReadZ = 0;        // Z-axis reading from accelerometer
uint32_t joystickInputX = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputY = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputZ = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputYaw = 0;  // Input value given by the joystick operated by user
sensors_event_t accel;  // Enables reaction to when a change has happened at the accelerometer
sensors_event_t gyro;   // Enables reaction to when a change has happened at the gyroscope

// PID start values
float heightP = 1.0;
float heightI = 0.05;
float heightD = 3;

float pitchP = 0.0058066;
float pitchI = 0.0000703;
float pitchD = 1.1680384;

float rollP = 0.0058066;
float rollI = 0.0000703;
float rollD = 1.1680384;

float yawP = 0.3665778;
float yawI = 0.0612539;
float yawD = 0.3496298;

void setup() {
  Serial.begin(115200);   // Initialisation of serial monitor
  Wire.begin();           // Join I2C bus
  Wire.setClock(400000);  // 400khz

  pinMode(builtInLED, OUTPUT);           // Enables the LED for debugging
  pinMode(externalEnablePin, OUTPUT);    // Enables the pin to be used as a power-source
  pinMode(heightReachedPin, OUTPUT);     // Enables the pin to be used as a power-source
  pinMode(somethingIsWrongPin, OUTPUT);  // Enables the pin to be used as a power-source
  pinMode(allGoodPin, OUTPUT);           // Enables the pin to be used as a power-source
  pinMode(emergencyButtonPin, INPUT);    // Enables the pin to be used as a input
  pinMode(emergencyLightPin, OUTPUT);    // Enables the pin to be used as a power-source
  pinMode(takeOffPin, INPUT_PULLUP);     // Sets the pin ready for button input using builtin pullup resistors
  pinMode(landPin, INPUT_PULLUP);        // Sets the pin ready for button input using builtin pullup resistors
  digitalWrite(emergencyLightPin, HIGH);

  while (!Serial) {  // Wait until serial port opens for native USB devices
    delay(10);
  }

  avgSem = xSemaphoreCreateBinary();  // Assigns avgSem to be a binary semaphore
  xSemaphoreGive(avgSem);
  Mutex = xSemaphoreCreateMutex();  // Assigns Mutex to be a mutex semaphore

  Serial.println("Adafruit VL53L0X test");        // Tests if a connection to the sensor has been established
  if (!lox.begin()) {                             // Checks all boolean states for buildin begin function from sensor library
    Serial.println(F("Failed to boot VL53L0X"));  // If no connection is present, this flag will be set high
    digitalWrite(somethingIsWrongPin, HIGH);
    while (1) {
      delay(10);
    }
  }

  Serial.println("Adafruit MPU6050 test!");         // Tests if a connection to the sensor has been established
  if (!mpu.begin()) {                               // Checks all boolean states for buildin begin function from sensor library
    Serial.println("Failed to find MPU6050 chip");  // If no connection is present, this flag will be set high
    digitalWrite(somethingIsWrongPin, HIGH);
    while (1) {
      delay(10);
    }
  }
  lox.configSensor(Adafruit_VL53L0X::VL53L0X_SENSE_LONG_RANGE);  // Changes sensor config from default (1.2metres) to long range (2.2 metres). Other options could be: VL53L0X_SENSE_DEFAULT, VL53L0X_SENSE_LONG_RANGE, VL53L0X_SENSE_HIGH_SPEED, VL53L0X_SENSE_HIGH_ACCURACY

  //Serial.println("MPU init soon");           // Status update to figure out which function is running
  mpu_temp = mpu.getTemperatureSensor();     // Do not delete, MPU won't calibrate without for some reason, even though temp is not used
  mpu_temp->printSensorDetails();            // Do not delete, MPU won't calibrate without for some reason, even though temp is not used
  mpu_accel = mpu.getAccelerometerSensor();  // Calibration of accelerometer and figuring out which sensor is connected
  mpu_accel->printSensorDetails();           // Internal update in sensor library
  mpu_gyro = mpu.getGyroSensor();            // Calibration of gyro and figuring out which sensor is connected
  mpu_gyro->printSensorDetails();            // Internal update in sensor library

  Serial.println("Calibration done");
  setupFPGA();
  readyFPGA();                     // Sending ready signal for FPGA
  digitalWrite(builtInLED, HIGH);  // Sets the builtInLED on so we know when to switch the physical switch
  delay(15000);                    // Delay while the FPGA is setting up
  digitalWrite(builtInLED, LOW);   // Sets the builtInLED off so we know when we can no longer switch the physical switch

  Serial.println("Task creation");                                                 // Status update to figure out which function is running
  xTaskCreate(MyIdleTask, "IdleTask", 1000, NULL, 0, NULL);                        // Idle task to check if there is any time left to execute tasks in
  xTaskCreate(safeTakeOff, "Safely takes off", 5000, NULL, 3, &hdlSafeTakeOff);    // Safely lifts the drone to 500mm
  xTaskCreate(safeLand, "Safely lands", 5000, NULL, 3, &hdlSafeLand);              // Safely lands the drone
  xTaskCreate(heightRead, "Reads current height", 8000, NULL, 2, &hdlHeightRead);  // Read current height from range sensor
  xTaskCreate(heightDesired, "Desired height", 8000, NULL, 2, &hdlHeightDesired);  // Sets a new desired height
  xTaskCreate(yawRead, "Reads current yaw", 5000, NULL, 1, &hdlYawRead);           // Read current yaw from range sensor
  xTaskCreate(yawDesired, "Desired yaw", 5000, NULL, 1, &hdlYawDesired);           // Sets a new desired yaw
  xTaskCreate(pitchRead, "Reads current pitch", 5000, NULL, 1, &hdlPitchRead);     // Read current pitch from range sensor
  xTaskCreate(pitchDesired, "Desired pitch", 5000, NULL, 1, &hdlPitchDesired);     // Sets a new desired pitch
  xTaskCreate(rollRead, "Reads current roll", 5000, NULL, 1, &hdlRollRead);        // Read current roll from range sensor
  xTaskCreate(rollDesired, "Desired roll", 5000, NULL, 1, &hdlRollDesired);        // Sets a new desired roll
  attachInterrupt(emergencyButtonPin, stop, RISING);                               // Emergency stop
  Serial.println("Init done");
}

void loop() {
  //Serial.println("Der skal ske noget her for at ESP'en er tilfreds");  // #skodMCU
  //getData();
  delay(1000);
}

void setupFPGA(){ 
  // Contains PID setup and the like
  // Altitude
  writeToAddress(FPGAAddress, 0x03, *((uint32_t*)&heightP));
  writeToAddress(FPGAAddress, 0x04, *((uint32_t*)&heightI));
  writeToAddress(FPGAAddress, 0x05, *((uint32_t*)&heightD));

  // PITCH
  writeToAddress(FPGAAddress, 0x07, *((uint32_t*)&pitchP));
  writeToAddress(FPGAAddress, 0x08, *((uint32_t*)&pitchI));
  writeToAddress(FPGAAddress, 0x09, *((uint32_t*)&pitchD));

  // ROLL
  writeToAddress(FPGAAddress, 0x0C, *((uint32_t*)&rollP));
  writeToAddress(FPGAAddress, 0x0D, *((uint32_t*)&rollI));
  writeToAddress(FPGAAddress, 0x0E, *((uint32_t*)&rollD));

  // YAW
  writeToAddress(FPGAAddress, 0x11, *((uint32_t*)&yawP));
  writeToAddress(FPGAAddress, 0x12, *((uint32_t*)&yawI));
  writeToAddress(FPGAAddress, 0x13, *((uint32_t*)&yawD));

}

void readyFPGA() {
  writeToAddress(FPGAAddress, 0x01, 0x01);  // Updates the external ready bit to a high
  digitalWrite(externalEnablePin, HIGH);    // Physically sets the external enable pin HIGH
  digitalWrite(allGoodPin, HIGH);           // Turns on the ready led for visual confirmation
}

void getData() {
  /* // Write to all registers
  writeToAddress(SLAVE_ADDR, 0x01, 0xffffffff);
  for (int i = 2; i <= 45; i++)
    writeToAddress(SLAVE_ADDR, i, 0x18192021);*/

  vTaskSuspend(hdlHeightRead);     // Suspends heightRead function
  vTaskSuspend(hdlHeightDesired);  // Suspends heightDesired function
  vTaskSuspend(hdlYawRead);        // Suspends yawRead function
  vTaskSuspend(hdlYawDesired);     // Suspends yawDesired function
  vTaskSuspend(hdlPitchRead);      // Suspends pitchRead function
  vTaskSuspend(hdlPitchDesired);   // Suspends pitchDesired function
  vTaskSuspend(hdlRollRead);       // Suspends rollRead function
  vTaskSuspend(hdlRollDesired);    // Suspends rollDesired function
  // Read all register values
  for (int i = 1; i <= 45; i++)
    readIntFromAddress(FPGAAddress, i);

  vTaskResume(hdlHeightRead);     // Resumes heightRead function
  vTaskResume(hdlHeightDesired);  // Resumes heightDesired function
  vTaskResume(hdlYawRead);        // Resumes yawRead function
  vTaskResume(hdlYawDesired);     // Resumes yawDesired function
  vTaskResume(hdlPitchRead);      // Resumes pitchRead function
  vTaskResume(hdlPitchDesired);   // Resumes pitchDesired function
  vTaskResume(hdlRollRead);       // Resumes rollRead function
  vTaskResume(hdlRollDesired);    // Resumes rollDesired function
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

static void safeTakeOff(void *pvParameters) {
  while (1) {
    if (digitalRead(takeOffPin) == LOW) {               // While a switch is enabled this function can be called
      Serial.println("Takeoff");                        // Status update to figure out which function is running
      vTaskSuspend(hdlHeightRead);                      // Suspends heightRead function
      vTaskSuspend(hdlHeightDesired);                   // Suspends heightDesired function
      vTaskSuspend(hdlYawRead);                         // Suspends yawRead function
      vTaskSuspend(hdlYawDesired);                      // Suspends yawDesired function
      vTaskSuspend(hdlPitchRead);                       // Suspends pitchRead function
      vTaskSuspend(hdlPitchDesired);                    // Suspends pitchDesired function
      vTaskSuspend(hdlRollRead);                        // Suspends rollRead function
      vTaskSuspend(hdlRollDesired);                     // Suspends rollDesired function
      writeToAddress(FPGAAddress, 0x01, 1);             // Sets the safe takeoff flag high in memory module
      desiredPitch = 0;                                 // Sets the desired pitch to 0 to ensure as level a takeoff as possible
      writeToAddress(FPGAAddress, 0x06, desiredPitch);  // Updates the desired memory module address with current desired pitch value
      desiredRoll = 0;                                  // Sets the desired roll to 0 to ensure as level a takeoff as possible
      writeToAddress(FPGAAddress, 0x0B, desiredRoll);   // Updates the desired memory module address with current desired roll value
#if READ_SENSOR_I2C_WORKS == 1
      currentHeight = readIntFromAddress(FPGAAddress, 0x18);  // Conditional compiling ensures this only runs if the read sensor fpga implementation works as desired
#else
      currentHeight = measure.RangeMilliMeter;  // Updates the currentHeight variable with the newest measured value
#endif
      desiredHeight = currentHeight;                       // Updates desired height to current height, so current height is taken into account
      desiredRoll = 0;                                     // Sets roll to 0 so the drone should be level
      desiredPitch = 0;                                    // Sets pitch to 0 so the drone should be level
      for (int i = 0; i <= startHeight; i++) {             // Loops until startheight of 500 mm has been achieved
        desiredHeight += 1;                                // Increments desiredheight with 1mm every iteration for a smooth ascend
        writeToAddress(FPGAAddress, 0x02, desiredHeight);  // Updates the memory module with newest desired height
        delay(200);                                        // Delay so that the MCU does not get ahead of the actual drone height
        Serial.println(desiredHeight);
      }
      vTaskResume(hdlHeightRead);            // Resumes heightRead function
      vTaskResume(hdlHeightDesired);         // Resumes heightDesired function
      vTaskResume(hdlYawRead);               // Resumes yawRead function
      vTaskResume(hdlYawDesired);            // Resumes yawDesired function
      vTaskResume(hdlPitchRead);             // Resumes pitchRead function
      vTaskResume(hdlPitchDesired);          // Resumes pitchDesired function
      vTaskResume(hdlRollRead);              // Resumes rollRead function
      vTaskResume(hdlRollDesired);           // Resumes rollDesired function
      writeToAddress(FPGAAddress, 0x01, 0);  // Sets the safe land flag low in memory module
    }
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void safeLand(void *pvParameters) {
  while (1) {
    if (digitalRead(landPin) == LOW) {                  // While a switch is enabled this function can be called
      Serial.println("Land");                           // Status update to figure out which function is running
      vTaskSuspend(hdlHeightRead);                      // Suspends heightRead function
      vTaskSuspend(hdlHeightDesired);                   // Suspends heightDesired function
      vTaskSuspend(hdlYawRead);                         // Suspends yawRead function
      vTaskSuspend(hdlYawDesired);                      // Suspends yawDesired function
      vTaskSuspend(hdlPitchRead);                       // Suspends pitchRead function
      vTaskSuspend(hdlPitchDesired);                    // Suspends pitchDesired function
      vTaskSuspend(hdlRollRead);                        // Suspends rollRead function
      vTaskSuspend(hdlRollDesired);                     // Suspends rollDesired function
      writeToAddress(FPGAAddress, 0x01, 1);             // Sets the safe land flag high in memory module
      desiredPitch = 0;                                 // Sets the desired pitch to 0 to ensure as level a takeoff as possible
      writeToAddress(FPGAAddress, 0x06, desiredPitch);  // Updates the desired memory module address with current desired pitch value
      desiredRoll = 0;                                  // Sets the desired roll to 0 to ensure as level a takeoff as possible
      writeToAddress(FPGAAddress, 0x0B, desiredRoll);   // Updates the desired memory module address with current desired roll value
#if READ_SENSOR_I2C_WORKS == 1
      currentHeight = readIntFromAddress(FPGAAddress, 0x18);  // Conditional compiling ensures this only runs if the read sensor fpga implementation works as desired
#else
      currentHeight = measure.RangeMilliMeter;  // Updates the currentHeight variable with the newest measured value
#endif
      desiredHeight = currentHeight;                       // Sets desiredheight to current height, so there is no need to suddenly increase altitude before a landing can occur, in the case desired height is much higher than current height.
      desiredRoll = 0;                                     // Sets roll to 0 so the drone should be level
      desiredPitch = 0;                                    // Sets pitch to 0 so the drone should be level
      for (int i = currentHeight; i > 0; i--) {            // Loops over until the drone has descended down to 0 mm height
        desiredHeight -= 1;                                // Decrements desired height with 1 mm, so that the drone slowly descends
        writeToAddress(FPGAAddress, 0x02, desiredHeight);  // Updates the desired memory module address with a new "desired" height, so that the drone should land safely
        delay(100);                                        // Delay so that the MCU does not get ahead of the actual drone height
        Serial.println(desiredHeight);
      }
      vTaskResume(hdlHeightRead);            // Resumes heightRead function
      vTaskResume(hdlHeightDesired);         // Resumes heightDesired function
      vTaskResume(hdlYawRead);               // Resumes yawRead function
      vTaskResume(hdlYawDesired);            // Resumes yawDesired function
      vTaskResume(hdlPitchRead);             // Resumes pitchRead function
      vTaskResume(hdlPitchDesired);          // Resumes pitchDesired function
      vTaskResume(hdlRollRead);              // Resumes rollRead function
      vTaskResume(hdlRollDesired);           // Resumes rollDesired function
      writeToAddress(FPGAAddress, 0x01, 0);  // Sets the safe land flag low in memory module
    }
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void heightRead(void *pvParameters) {
  while (1) {
#if READ_SENSOR_I2C_WORKS == 1
    currentHeight = readIntFromAddress(FPGAAddress, 0x18);  // Conditional compiling ensures this only runs if the read sensor fpga implementation works as desired
#else
   //Serial.println("heightRead");               // Status update to figure out which function is running
    //Serial.println("Reading a measurement... ");
    lox.rangingTest(&measure, false);  // Pass in 'true' to get debug data printout!

    if (measure.RangeStatus != 4) {  // Phase failures have incorrect data
     // Serial.print("Distance (mm): ");
      //Serial.println(measure.RangeMilliMeter);
      currentHeight = measure.RangeMilliMeter;  // Updates the currentHeight variable with the newest measured value
    } else {
      //Serial.println(" out of range ");
    }
    currentHeight = measure.RangeMilliMeter;        // Updates the currentHeight variable with the newest measured value
#endif
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void heightDesired(void *pvParameters) {
  while (1) {
    joystickInputZ = analogRead(joystickInputZPin);                // Reading from the joystick saved as input value
    if (joystickInputZ >= 3500) {                                  // If the joystick is completely at the top, the drone should rise quickly
      desiredHeight += 3;                                          // Increments desiredHeight by 3mm
    } else if (joystickInputZ >= 3000 && joystickInputZ < 3500) {  // If the joystick is somewhat at the top, the drone should rise
      desiredHeight += 2;                                          // Increments desiredHeight by 2mm
    } else if (joystickInputZ > 2500 && joystickInputZ < 3000) {   // If the joystick is a little at the top, the drone should rise slowly
      desiredHeight += 1;                                          // Increments desiredHeight by 1mm
    } else if (joystickInputZ < 1500 && joystickInputZ > 1000) {   // If the joystick is a little at the bottom, the drone should descend slowly
      desiredHeight -= 1;                                          // Decrements desiredHeight by 1mm
    } else if (joystickInputZ <= 1000 && joystickInputZ > 500) {   // If the joystick is somewhat at the bottom, the drone should descend
      desiredHeight -= 2;                                          // Decrements desiredHeight by 2mm
    } else if (joystickInputZ <= 500) {                            // If the joystick is completely at the bottom, the drone should descend quickly
      desiredHeight -= 3;                                          // Decrements desiredHeight by 3mm
    }
    if (currentHeight >= (desiredHeight - heightTolerance) && currentHeight <= (desiredHeight + heightTolerance)) {  // Checks if the desired height has been achieved within the given tolerances
      digitalWrite(heightReachedPin, HIGH);                                                                          // Turns on led if height reached
    } else {
      digitalWrite(heightReachedPin, LOW);  // Turns off LED if desired height has not been met.
    }
    if (desiredHeight < 0 || desiredHeight > 22000) {  // If desired height is lower than 0, the drone will crash. However, since the desiredHeight variable is unsigned, a failsafe of desiredHeight>22000 has been added, to catch the situations where the value rolls over and becomes approx 4294967295
      desiredHeight = 0;                               // Minimum height of drone
      Serial.println("Min height reached");
    } else if (desiredHeight > 2200) {  // If the desired height is higher than 2200, another sensor has to be used
      desiredHeight = 2200;             // Maximum stable height of altitude sensor
      Serial.println("Max height reached");
    }
    writeToAddress(FPGAAddress, 0x02, desiredHeight);  // Updates the desired memory module address with current desired height
  //Serial.println("heightDesired");                   // Status update to figure out which function is running
   //Serial.println(desiredHeight);
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void yawRead(void *pvParameters) {
  while (1) {
    //Serial.println("yawRead");  // Status update to figure out which function is running
    // Yaw reading code goes here
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void yawDesired(void *pvParameters) {
  while (1) {
   //Serial.println("yawDesired");                                      // Status update to figure out which function is running
    joystickInputYaw = analogRead(joystickInputYawPin);                // Reading from the joystick saved as input value
    if (joystickInputYaw >= 3500) {                                    // If the joystick is completely at the right, the drone should turn clockwise quickly
      desiredYaw += 15;                                                // Increments desiredYaw by 15mm
    } else if (joystickInputYaw >= 3000 && joystickInputYaw < 3500) {  // If the joystick is somewhat at the right, the drone should turn clockwise
      desiredYaw += 10;                                                // Increments desiredYaw by 10mm
    } else if (joystickInputYaw > 2500 && joystickInputYaw < 3000) {   // If the joystick is a little at the right, the drone should turn clockwise slowly
      desiredYaw += 5;                                                 // Increments desiredYaw by 5mm
    } else if (joystickInputYaw < 1500 && joystickInputYaw > 1000) {   // If the joystick is a little at the left, the drone should turn counterclockwise slowly
      desiredYaw -= 5;                                                 // Decrements desiredYaw by 5mm
    } else if (joystickInputYaw <= 1000 && joystickInputYaw > 500) {   // If the joystick is somewhat at the left, the drone should turn counterclockwise
      desiredYaw -= 10;                                                // Decrements desiredYaw by 10mm
    } else if (joystickInputYaw <= 500) {                              // If the joystick is completely at the left, the drone should turn counterclockwise quickly
      desiredYaw -= 15;                                                // Decrements desiredYaw by 15mm
    }
    writeToAddress(FPGAAddress, 0x10, *((uint32_t*)&desiredYaw));  // Updates the desired memory module address with current desired yaw value
    vTaskDelay(50 / portTICK_PERIOD_MS);            // Delay for 10 milliseconds
  }
}

static void pitchRead(void *pvParameters) {
  while (1) {
#if READ_SENSOR_I2C_WORKS == 1
    gyroReadX = readFloatFromAddress(FPGAAddress, 0x22);   // Updates the desired memory module address with current gyro reading on x-axis if conditional compiling demand is met
    gyroReadY = readFloatFromAddress(FPGAAddress, 0x24);   // Updates the desired memory module address with current gyro reading on y-axis if conditional compiling demand is met
    gyroReadZ = readFloatFromAddress(FPGAAddress, 0x26);   // Updates the desired memory module address with current gyro reading on z-axis if conditional compiling demand is met
    accelReadX = readFloatFromAddress(FPGAAddress, 0x28);  // Updates the desired memory module address with current accelerometer reading on x-axis if conditional compiling demand is met
    accelReadY = readFloatFromAddress(FPGAAddress, 0x2B);  // Updates the desired memory module address with current accelerometer reading on y-axis if conditional compiling demand is met
    accelReadZ = readFloatFromAddress(FPGAAddress, 0x2D);  // Updates the desired memory module address with current accelerometer reading on z-axis if conditional compiling demand is met
#else
   //Serial.println("pitchRead");                    // Status update to figure out which function is running
    mpu_accel->getEvent(&accel);                    // Makes a new reading from the accelerometer
    mpu_gyro->getEvent(&gyro);                      // Makes a new reading from the gyro
    gyroReadX = gyro.gyro.x;                        // Updates current gyro reading on x-axis
    gyroReadY = gyro.gyro.y;                        // Updates current gyro reading on y-axis
    gyroReadZ = gyro.gyro.z;                        // Updates current gyro reading on z-axis
    accelReadX = accel.acceleration.x;              // Updates current accelerometer reading on x-axis
    accelReadY = accel.acceleration.y;              // Updates current accelerometer reading on y-axis
    accelReadZ = accel.acceleration.z;              // Updates current accelerometer reading on z-axis
    writeToAddress(FPGAAddress, 0x22, gyroReadX);   // Updates the desired memory module address with current gyro reading on x-axis
    writeToAddress(FPGAAddress, 0x24, gyroReadY);   // Updates the desired memory module address with current gyro reading on y-axis
    writeToAddress(FPGAAddress, 0x26, gyroReadZ);   // Updates the desired memory module address with current gyro reading on z-axis
    writeToAddress(FPGAAddress, 0x28, accelReadX);  // Updates the desired memory module address with current accelerometer reading on x-axis
    writeToAddress(FPGAAddress, 0x2B, accelReadY);  // Updates the desired memory module address with current accelerometer reading on y-axis
    writeToAddress(FPGAAddress, 0x2D, accelReadZ);  // Updates the desired memory module address with current accelerometer reading on z-axis
#endif
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void pitchDesired(void *pvParameters) {
  while (1) {
    joystickInputX = analogRead(joystickInputXPin);                // Reading from the joystick saved as input value
    if (joystickInputX >= 3500) {                                  // If the joystick is completely at the top, the drone should go forward fast
      desiredPitch = 3;                                            // Set the desiredPitch value to +3 (forward)
    } else if (joystickInputX >= 3000 && joystickInputX < 3500) {  // If the joystick is somewhat at the top, the drone should go forward
      desiredPitch = 1.5;                                          // Set the desiredPitch value to +1.5 (forward)
    } else if (joystickInputX > 2500 && joystickInputX < 3000) {   // If the joystick is a little at the top, the drone should go forward slowly
      desiredPitch = 0.5;                                          // Set the desiredPitch value to +0.5 (forward)
    } else if (joystickInputX < 1500 && joystickInputX > 1000) {   // If the joystick is a little at the bottom, the drone should go backwards slowly
      desiredPitch = -0.5;                                         // Set the desiredPitch value to -0.5 (backwards)
    } else if (joystickInputX <= 1000 && joystickInputX > 500) {   // If the joystick is somewhat at the bottom, the drone should go backwards
      desiredPitch = -1.5;                                         // Set the desiredPitch value to -1.5 (backwards)
    } else if (joystickInputX <= 500) {                            // If the joystick is completely at the bottom, the drone should go backwards fast
      desiredPitch = -3;                                           // Set the desiredPitch value to -3 (backwards)
    } else {                                                       // If there is no joystick input, the drone should hover
      desiredPitch = 0;                                            // Resets the desiredRoll to 0, to ensure that the drone hovers flat again
    }
   //Serial.println("pitchDesired");  // Status update to figure out which function is running
    //Serial.println(desiredPitch);
    writeToAddress(FPGAAddress, 0x06, *((uint32_t*)&desiredPitch));  // Updates the desired memory module address with current desired pitch value
    vTaskDelay(50 / portTICK_PERIOD_MS);              // Delay for 10 milliseconds
  }
}

static void rollRead(void *pvParameters) {
  while (1) {
#if READ_SENSOR_I2C_WORKS == 1
    gyroReadX = readFloatFromAddress(FPGAAddress, 0x22);   // Updates the desired memory module address with current gyro reading on x-axis if conditional compiling demand is met
    gyroReadY = readFloatFromAddress(FPGAAddress, 0x24);   // Updates the desired memory module address with current gyro reading on y-axis if conditional compiling demand is met
    gyroReadZ = readFloatFromAddress(FPGAAddress, 0x26);   // Updates the desired memory module address with current gyro reading on z-axis if conditional compiling demand is met
    accelReadX = readFloatFromAddress(FPGAAddress, 0x28);  // Updates the desired memory module address with current accelerometer reading on x-axis if conditional compiling demand is met
    accelReadY = readFloatFromAddress(FPGAAddress, 0x2B);  // Updates the desired memory module address with current accelerometer reading on y-axis if conditional compiling demand is met
    accelReadZ = readFloatFromAddress(FPGAAddress, 0x2D);  // Updates the desired memory module address with current accelerometer reading on z-axis if conditional compiling demand is met
#else
   //Serial.println("rollRead");                     // Status update to figure out which function is running
    mpu_accel->getEvent(&accel);                    // Makes a new reading from the accelerometer
    mpu_gyro->getEvent(&gyro);                      // Makes a new reading from the gyro
    gyroReadX = gyro.gyro.x;                        // Updates current gyro reading on x-axis
    gyroReadY = gyro.gyro.y;                        // Updates current gyro reading on y-axis
    gyroReadZ = gyro.gyro.z;                        // Updates current gyro reading on z-axis
    accelReadX = accel.acceleration.x;              // Updates current accelerometer reading on x-axis
    accelReadY = accel.acceleration.y;              // Updates current accelerometer reading on y-axis
    accelReadZ = accel.acceleration.z;              // Updates current accelerometer reading on z-axis
    writeToAddress(FPGAAddress, 0x22, gyroReadX);   // Updates the desired memory module address with current gyro reading on x-axis
    writeToAddress(FPGAAddress, 0x24, gyroReadY);   // Updates the desired memory module address with current gyro reading on y-axis
    writeToAddress(FPGAAddress, 0x26, gyroReadZ);   // Updates the desired memory module address with current gyro reading on z-axis
    writeToAddress(FPGAAddress, 0x28, accelReadX);  // Updates the desired memory module address with current accelerometer reading on x-axis
    writeToAddress(FPGAAddress, 0x2B, accelReadY);  // Updates the desired memory module address with current accelerometer reading on y-axis
    writeToAddress(FPGAAddress, 0x2D, accelReadZ);  // Updates the desired memory module address with current accelerometer reading on z-axis
#endif
    vTaskDelay(50 / portTICK_PERIOD_MS);  // Delay for 10 milliseconds
  }
}

static void rollDesired(void *pvParameters) {
  while (1) {
    joystickInputY = analogRead(joystickInputYPin);                // Reading from the joystick saved as input value
    if (joystickInputY >= 3500) {                                  // If the joystick is completely at the right, the drone should move right quickly
      desiredRoll = 3;                                             // Set the desiredRoll value to +3 (right)
    } else if (joystickInputY >= 3000 && joystickInputY < 3500) {  // If the joystick is somewhat at the right, the drone should move right
      desiredRoll = 1.5;                                           // Set the desiredRoll value to +1.5 (right)
    } else if (joystickInputY > 2500 && joystickInputY < 3000) {   // If the joystick is a little at the right, the drone should move right slowly
      desiredRoll = 0.5;                                           // Set the desiredRoll value to +0.5 (right)
    } else if (joystickInputY < 1500 && joystickInputY > 1000) {   // If the joystick is a little at the left, the drone should move left slowly
      desiredRoll = -0.5;                                          // Set the desiredRoll value to -0.5 (left)
    } else if (joystickInputY <= 1000 && joystickInputY > 500) {   // If the joystick is somewhat at the left, the drone should move left
      desiredRoll = -1.5;                                          // Set the desiredRoll value to -1.5 (left)
    } else if (joystickInputY <= 500) {                            // If the joystick is completely at the left, the drone should move left quickly
      desiredRoll = -3;                                            // Set the desiredRoll value to -3 (left)
    } else {                                                       // If there is no joystick input, the drone should hover
      desiredRoll = 0;                                             // Resets the desiredRoll to 0, to ensure that the drone hovers flat again
    }
   //Serial.println("rollDesired");  // Status update to figure out which function is running
    //Serial.println(desiredRoll);
    writeToAddress(FPGAAddress, 0x0B, *((uint32_t*)&desiredRoll));  // Updates the desired memory module address with current desired roll value
    vTaskDelay(50 / portTICK_PERIOD_MS);             // Delay for 10 milliseconds
  }
}

void stop() {                             // Emergency stop function
                                          //Serial.println("Stop for satan!");      // Status update to figure out which function is running
  digitalWrite(emergencyLightPin, LOW);  // Lights up the emergency lights
  vTaskSuspend(hdlHeightRead);            // Suspends heightRead function
  vTaskSuspend(hdlHeightDesired);         // Suspends heightDesired function
  vTaskSuspend(hdlYawRead);               // Suspends yawRead function
  vTaskSuspend(hdlYawDesired);            // Suspends yawDesired function
  vTaskSuspend(hdlPitchRead);             // Suspends pitchRead function
  vTaskSuspend(hdlPitchDesired);          // Suspends pitchDesired function
  vTaskSuspend(hdlRollRead);              // Suspends rollRead function
  vTaskSuspend(hdlRollDesired);           // Suspends rollDesired function
}

static void MyIdleTask(void *pvParameters) {
  while (1) {
    //Serial.println(F("Idle state"));
    vTaskDelay(50 / portTICK_PERIOD_MS);
  }
}