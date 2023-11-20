#include <Arduino.h>            // Necessary for accessing FreeRTOS via Arduino IDE
#include "Wire.h"               // Necessary for I2C communication
#include <freertos/FreeRTOS.h>  // Necessary for accessing FreeRTOS
#include <freertos/task.h>      // Necessary for using tasks in FreeRTOS
#include <freertos/semphr.h>    // Enables semaphores
#include "Adafruit_VL53L0X.h"   // Library for the range sensor
#include <Adafruit_MPU6050.h>   // Library for gyroscope and accelormeter

#define INCLUDE_vTaskSuspend 1  // Definition of suspend function being active
#define externalEnablePin 0     // The pin to activate the FPGA
#define takeOffPin 0            // Pin to start take off
#define landPin 0               // Pin to land again
#define startHeight 500         // Height to achieve upon power on in mm
#define heightReachedPin 0      // Pin to turn on led indicating desired height is reached within tolerance
#define somethingIsWrongPin 13  // Pin to light up red LED
#define allGoodPin 12           // Pin to light op green LED
#define emergencyButtonPin 27   // Emergency button connection pin
#define emergencyLightPin 26    // LED that signifies an emergency has happened
#define joystickInputXPin 36    // Input for the x axis
#define joystickInputYPin 39    // Input for the y axis
#define joystickInputZPin 34    // Input for the z axis
#define joystickInputYawPin 35  // Input for the yaw

#define configCHECK_FOR_STACK_OVERFLOW 1


TaskHandle_t hdlSafeTakeOff, hdlSafeLand, hdlHeightRead, hdlHeightDesired, hdlYawRead, hdlYawDesired, hdlPitchRead, hdlPitchDesired, hdlRollRead, hdlRollDesired, hdlStop;  // Must be made in order for the handles to works in xTaskCreate

SemaphoreHandle_t avgSem, Mutex;  // Creation of semaphore handles

Adafruit_VL53L0X lox = Adafruit_VL53L0X();  // Instantiates the range sensor
VL53L0X_RangingMeasurementData_t measure;   // Struct to keep measurements from range sensor

Adafruit_MPU6050 mpu;                              // Instantiates MPU module
Adafruit_Sensor *mpu_temp, *mpu_accel, *mpu_gyro;  // Necessary for adafruit library to function

// Global variables:
uint32_t desiredHeight = startHeight;  // Desired height in mm
uint32_t currentHeight;                // Variable to store current height measured by the vl52l0x
uint32_t heightTolerance = 10;         // Tolerance for how much a difference is allowed betwen currentHeight and desiredHeight
float currentYaw = 0;                  // Current yaw measurement. Float to handle values given by MPU6050
float desiredYaw = 0;                  // Desired yaw angle. Float to handle values given by MPU6050
float currentPitch = 0;                // Current pitch measurement. Float to handle values given by MPU6050
float desiredPitch = 0;                // Desired pitch angle. Float to handle values given by MPU6050
float currentRoll = 0;                 // Current roll measurement. Float to handle values given by MPU6050
float desiredRoll = 0;                 // Desired roll angle. Float to handle values given by MPU6050
float gyroReadX = 0;                   // X-axis reading from gyro
float gyroReadY = 0;                   // Y-axis reading from gyro
float gyroReadZ = 0;                   // Z-axis reading from gyro
float accelReadX = 0;                  // X-axis reading from accelerometer
float accelReadY = 0;                  // Y-axis reading from accelerometer
float accelReadZ = 0;                  // Z-axis reading from accelerometer


uint32_t joystickInputX = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputY = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputZ = 0;    // Input value given by the joystick operated by user
uint32_t joystickInputYaw = 0;  // Input value given by the joystick operated by user

sensors_event_t accel;  //
sensors_event_t gyro;




void setup() {
  Serial.begin(115200);   // Initialisation of serial monitor
  Wire.begin();           // Join I2C bus
  Wire.setClock(400000);  // 400khz

  pinMode(externalEnablePin, OUTPUT);    // Enables the pin to be used as a power-source
  pinMode(heightReachedPin, OUTPUT);     // Enables the pin to be used as a power-source
  pinMode(somethingIsWrongPin, OUTPUT);  // Enables the pin to be used as a power-source
  pinMode(allGoodPin, OUTPUT);           // Enables the pin to be used as a power-source
  pinMode(emergencyButtonPin, OUTPUT);   // Enables the pin to be used as a power-source
  pinMode(emergencyLightPin, OUTPUT);    // Enables the pin to be used as a power-source

  while (!Serial) {  // Wait until serial port opens for native USB devices
    delay(10);
  }
  //getData();
  avgSem = xSemaphoreCreateBinary();  // Assigns avgSem to be a binary semaphore
  xSemaphoreGive(avgSem);
  Mutex = xSemaphoreCreateMutex();  // Assigns Mutex to be a mutex semaphore

  Serial.println("Adafruit VL53L0X test");        // Tests if a connection to the sensor has been established
  if (!lox.begin()) {                             // Checks all boolean states for buildin begin function from sensor library
    Serial.println(F("Failed to boot VL53L0X"));  // If no connection is present, this flag will be set high
    while (1) {
      delay(10);
    }
  }

  Serial.println("Adafruit MPU6050 test!");                      // Tests if a connection to the sensor has been established
                                                                 /* if (!mpu.begin()) {                               // Checks all boolean states for buildin begin function from sensor library
    Serial.println("Failed to find MPU6050 chip");  // If no connection is present, this flag will be set high
    while (1) {
      delay(10);
    }
  }*/
  lox.configSensor(Adafruit_VL53L0X::VL53L0X_SENSE_LONG_RANGE);  // Changes sensor config from default (1.2metres) to long range (2.2 metres). Other options could be: VL53L0X_SENSE_DEFAULT, VL53L0X_SENSE_LONG_RANGE, VL53L0X_SENSE_HIGH_SPEED, VL53L0X_SENSE_HIGH_ACCURACY

  Serial.println("MPU init soon");  // Status update to figure out which function is running
  /*mpu_temp = mpu.getTemperatureSensor();     // Do not delete, MPU won't calibrate without for some reason, even though temp is not used
  mpu_temp->printSensorDetails();            // Do not delete, MPU won't calibrate without for some reason, even though temp is not used
  mpu_accel = mpu.getAccelerometerSensor();  // Calibration of accelerometer and figuring out which sensor is connected
  mpu_accel->printSensorDetails();           // Internal update in sensor library
  mpu_gyro = mpu.getGyroSensor();            // Calibration of gyro and figuring out which sensor is connected
  mpu_gyro->printSensorDetails();            // Internal update in sensor library*/

  Serial.println("Task creation");                                                // Status update to figure out which function is running
  xTaskCreate(safeTakeOff, "Safely takes off", 15000, NULL, 3, &hdlSafeTakeOff);  // Safely lifts the drone to 500mm
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(safeLand, "Safely lands", 15000, NULL, 3, &hdlSafeLand);  // Safely lands the drone
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(heightRead, "Reads current height", 18000, NULL, 1, &hdlHeightRead);  // Read current height from range sensor
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(heightDesired, "Desired height", 18000, NULL, 2, &hdlHeightDesired);  // Sets a new desired height
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(yawRead, "Reads current yaw", 15000, NULL, 2, &hdlYawRead);  // Read current yaw from range sensor
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(yawDesired, "Desired yaw", 15000, NULL, 2, &hdlYawDesired);  // Sets a new desired yaw
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(pitchRead, "Reads current pitch", 15000, NULL, 2, &hdlPitchRead);  // Read current pitch from range sensor
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(pitchDesired, "Desired pitch", 15000, NULL, 2, &hdlPitchDesired);  // Sets a new desired pitch
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(rollRead, "Reads current roll", 15000, NULL, 2, &hdlRollRead);  // Read current roll from range sensor
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(rollDesired, "Desired roll", 15000, NULL, 2, &hdlRollDesired);  // Sets a new desired roll
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  xTaskCreate(stop, "Stops everything", 15000, NULL, 4, &hdlStop);  // Emergency stop
  Serial.println("FREE SPACE");
  Serial.println(xPortGetFreeHeapSize());
  Serial.println("Init done");
}

void loop() {
  Serial.println("Der skal ske noget her for at ESP'en er tilfreds");  // #skodMCU
  delay(1000);
}

/*void getData(uint8_t SLAVE_ADDR, uint8_t REGISTER_ADDR, uint32_t DATA) {
  // Write to all registers
  writeToAddress(SLAVE_ADDR, 0x01, 0xffffffff);
  for (int i = 2; i <= 45; i++)
    writeToAddress(SLAVE_ADDR, i, 0x18192021);

  // Read all register values
  for (int i = 1; i <= 45; i++)
    readFromAddress(SLAVE_ADDR, i);
}*/

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
  Wire.beginTransmission(slaveAddress);  // Starts sending data to assigned address
  Wire.write(regAddress);                // Register to read from
  Wire.endTransmission();                // Ends sending data to assigned address
  Wire.requestFrom(slaveAddress, 4);     // Request 4 bytes from slave device
  Serial.print("Reg: 0x");
  Serial.print(regAddress, HEX);
  Serial.print(" value: 0x");
  while (Wire.available()) {  // Slave may send less than requested
    char c = Wire.read();     // Receive a byte as character
    Serial.print(c, HEX);     // Print the character
  }
  Serial.println();
}

void readyFPGA() {
  digitalWrite(externalEnablePin, HIGH);  // Turns on the ready led for visual confirmation
  writeToAddress(0x08, 0x01, 1);          // Updates the external ready bit to a high
}

static void safeTakeOff(void *pvParameters) {
  while (1) {
    //while (takeOffPin == LOW) {                     // While a switch is enabled this function can be called
    Serial.println("Takeoff");                    // Status update to figure out which function is running
    writeToAddress(0x08, 0x01, 1);                // Sets the safe takeoff flag high in memory module
    currentHeight = measure.RangeMilliMeter;      // Updates the currentHeight variable with the newest measured value
    desiredHeight = currentHeight;                // Updates desired height to current height, so current height is taken into account
    for (int i = 0; i <= startHeight; i++) {      // Loops until startheight of 500 mm has been achieved
      desiredHeight += 1;                         // Increments desiredheight with 1mm every iteration for a smooth ascend
      writeToAddress(0x08, 0x02, desiredHeight);  // Updates the memory module with newest desired height
      delay(200);                                 // Delay so that the MCU does not get ahead of the actual drone height
    }
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
    writeToAddress(0x08, 0x01, 1);         // Sets the safe takeoff flag low in memory module
    //}
  }
}

static void safeLand(void *pvParameters) {
  while (1) {
    // while (landPin == LOW) {                        // While a switch is enabled this function can be called
    Serial.println("Land");                       // Status update to figure out which function is running
    writeToAddress(0x08, 0x01, 1);                // Sets the safe land flag high in memory module
    currentHeight = measure.RangeMilliMeter;      // Updates the currentHeight variable with the newest measured value
    desiredHeight = currentHeight;                // Sets desiredheight to current height, so there is no need to suddenly increase altitude before a landing can occur, in the case desired height is much higher than current height.
    for (int i = currentHeight; i >= 0; i--) {    // Loops over until the drone has descended down to 0 mm height
      desiredHeight -= 1;                         // Decrements desired height with 1 mm, so that the drone slowly descends
      writeToAddress(0x08, 0x02, desiredHeight);  // Updates the desired memory module address with a new "desired" height, so that the drone should land safely
      delay(100);                                 // Delay so that the MCU does not get ahead of the actual drone height
    }
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
    writeToAddress(0x08, 0x01, 0);         // Sets the safe land flag low in memory module
    //}
  }
}

static void heightRead(void *pvParameters) {
  while (1) {
    Serial.println("heightRead");  // Status update to figure out which function is running
    Serial.println("Reading a measurement... ");
    lox.rangingTest(&measure, false);  // Pass in 'true' to get debug data printout!

    if (measure.RangeStatus != 4) {  // Phase failures have incorrect data
      Serial.print("Distance (mm): ");
      Serial.println(measure.RangeMilliMeter);
      currentHeight = measure.RangeMilliMeter;  // Updates the currentHeight variable with the newest measured value
    } else {
      Serial.println(" out of range ");
    }
    writeToAddress(0x08, 0x18, currentHeight);  // Updates the desired memory module address with current actual height
    vTaskDelay(100 / portTICK_PERIOD_MS);       // Delay for 100 milliseconds
  }
}

static void heightDesired(void *pvParameters) {
  while (1) {
    Serial.println("heightDesired");                     // Status update to figure out which function is running
    int joystickInputZ = analogRead(joystickInputZPin);  // Reading from the joystick saved as input value
    if (joystickInputZ >= 3500) {                        // If the joystick is completely at the top, the drone should rise quickly
      desiredHeight += 15;                               // Increments desiredHeight by 15mm
      Serial.println("SÅ SKER DER SATME NOGET OPAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
    } else if (joystickInputZ >= 3000 && joystickInputZ < 3500) {  // If the joystick is somewhat at the top, the drone should rise
      desiredHeight += 10;                                         // Increments desiredHeight by 10mm
    } else if (joystickInputZ > 2500 && joystickInputZ < 3000) {   // If the joystick is a little at the top, the drone should rise slowly
      desiredHeight += 5;                                          // Increments desiredHeight by 5mm
    } else if (joystickInputZ < 1500 && joystickInputZ > 1000) {   // If the joystick is a little at the bottom, the drone should descend slowly
      desiredHeight -= 5;                                          // Decrements desiredHeight by 5mm
    } else if (joystickInputZ <= 1000 && joystickInputZ > 500) {   // If the joystick is somewhat at the bottom, the drone should descend
      desiredHeight -= 10;                                         // Decrements desiredHeight by 10mm
    } else if (joystickInputZ <= 500) {                            // If the joystick is completely at the bottom, the drone should descend quickly
      desiredHeight -= 15;                                         // Decrements desiredHeight by 15mm
    }
    if (currentHeight >= (desiredHeight - heightTolerance) && currentHeight <= (desiredHeight + heightTolerance)) {  // Checks if the desired height has been achieved within the given tolerances
      digitalWrite(heightReachedPin, HIGH);                                                                          // Turns on led if height reached
    } else {
      digitalWrite(heightReachedPin, LOW);  // Turns off LED if desired height has not been met.
    }
    writeToAddress(0x08, 0x02, desiredHeight);  // Updates the desired memory module address with current desired height
    Serial.println(desiredHeight);
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
  }
}

static void yawRead(void *pvParameters) {
  while (1) {
    Serial.println("yawRead");  // Status update to figure out which function is running
    // Yaw reading code goes here
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
  }
}

static void yawDesired(void *pvParameters) {
  while (1) {
    Serial.println("yawDesired");                                      // Status update to figure out which function is running
    int joystickInputYaw = analogRead(joystickInputYawPin);            // Reading from the joystick saved as input value
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
    writeToAddress(0x08, 0x10, desiredYaw);  // Updates the desired memory module address with current desired yaw value
    vTaskDelay(100 / portTICK_PERIOD_MS);    // Delay for 100 milliseconds
  }
}

static void pitchRead(void *pvParameters) {
  while (1) {
    Serial.println("pitchRead");  // Status update to figure out which function is running
    /*mpu_accel->getEvent(&accel);        // Makes a new reading from the accelerometer
    mpu_gyro->getEvent(&gyro);          // Makes a new reading from the gyro
    gyroReadX = gyro.gyro.x;            // Updates current gyro reading on x-axis
    gyroReadY = gyro.gyro.y;            // Updates current gyro reading on y-axis
    gyroReadZ = gyro.gyro.z;            // Updates current gyro reading on z-axis
    accelReadX = accel.acceleration.x;  // Updates current accelerometer reading on x-axis
    accelReadY = accel.acceleration.y;  // Updates current accelerometer reading on y-axis
    accelReadZ = accel.acceleration.z;  // Updates current accelerometer reading on z-axis
    //currentPitch = accel.acceleration.pitch; // Should update current pitch angle, but has not been tested yet
    //currentPitch = gyro.gyro.pitch;          // Should update current pitch angle, but has not been tested yet
    writeToAddress(0x08, 0x22, gyroReadX);   // Updates the desired memory module address with current gyro reading on x-axis
    writeToAddress(0x08, 0x24, gyroReadY);   // Updates the desired memory module address with current gyro reading on y-axis
    writeToAddress(0x08, 0x26, gyroReadZ);   // Updates the desired memory module address with current gyro reading on z-axis
    writeToAddress(0x08, 0x28, accelReadX);  // Updates the desired memory module address with current accelerometer reading on x-axis
    writeToAddress(0x08, 0x2B, accelReadY);  // Updates the desired memory module address with current accelerometer reading on y-axis
    writeToAddress(0x08, 0x2D, accelReadZ);  // Updates the desired memory module address with current accelerometer reading on z-axis*/
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
  }
}

static void pitchDesired(void *pvParameters) {
  while (1) {
    Serial.println("pitchDesired");                                // Status update to figure out which function is running
    int joystickInputX = analogRead(joystickInputXPin);            // Reading from the joystick saved as input value
    if (joystickInputX >= 3500) {                                  // If the joystick is completely at the top, the drone should go forward fast
      desiredPitch += 15;                                          // Increments desiredPitch by 15mm
    } else if (joystickInputX >= 3000 && joystickInputX < 3500) {  // If the joystick is somewhat at the top, the drone should go forward
      desiredPitch += 10;                                          // Increments desiredPitch by 10mm
    } else if (joystickInputX > 2500 && joystickInputX < 3000) {   // If the joystick is a little at the top, the drone should go forward slowly
      desiredPitch += 5;                                           // Increments desiredPitch by 5mm
    } else if (joystickInputX < 1500 && joystickInputX > 1000) {   // If the joystick is a little at the bottom, the drone should go backwards slowly
      desiredPitch -= 5;                                           // Decrements desiredPitch by 5mm
    } else if (joystickInputX <= 1000 && joystickInputX > 500) {   // If the joystick is somewhat at the bottom, the drone should go backwards
      desiredPitch -= 10;                                          // Decrements desiredPitch by 10mm
    } else if (joystickInputX <= 500) {                            // If the joystick is completely at the bottom, the drone should go backwards fast
      desiredPitch -= 15;                                          // Decrements desiredPitch by 15mm
    }
    writeToAddress(0x08, 0x06, desiredPitch);  // Updates the desired memory module address with current desired pitch value
    vTaskDelay(100 / portTICK_PERIOD_MS);      // Delay for 100 milliseconds
  }
}

static void rollRead(void *pvParameters) {
  while (1) {
    Serial.println("rollRead");  // Status update to figure out which function is running
    /*mpu_accel->getEvent(&accel);        // Makes a new reading from the accelerometer
    mpu_gyro->getEvent(&gyro);          // Makes a new reading from the gyro
    gyroReadX = gyro.gyro.x;            // Updates current gyro reading on x-axis
    gyroReadY = gyro.gyro.y;            // Updates current gyro reading on y-axis
    gyroReadZ = gyro.gyro.z;            // Updates current gyro reading on z-axis
    accelReadX = accel.acceleration.x;  // Updates current accelerometer reading on x-axis
    accelReadY = accel.acceleration.y;  // Updates current accelerometer reading on y-axis
    accelReadZ = accel.acceleration.z;  // Updates current accelerometer reading on z-axis
    //currentRoll = accel.acceleration.roll; // Should update current roll angle, but has not been tested yet
    //currentRoll = gyro.gyro.roll;          // Should update current roll angle, but has not been tested yet
    writeToAddress(0x08, 0x22, gyroReadX);   // Updates the desired memory module address with current gyro reading on x-axis
    writeToAddress(0x08, 0x24, gyroReadY);   // Updates the desired memory module address with current gyro reading on y-axis
    writeToAddress(0x08, 0x26, gyroReadZ);   // Updates the desired memory module address with current gyro reading on z-axis
    writeToAddress(0x08, 0x28, accelReadX);  // Updates the desired memory module address with current accelerometer reading on x-axis
    writeToAddress(0x08, 0x2B, accelReadY);  // Updates the desired memory module address with current accelerometer reading on y-axis
    writeToAddress(0x08, 0x2D, accelReadZ);  // Updates the desired memory module address with current accelerometer reading on z-axis*/
    vTaskDelay(100 / portTICK_PERIOD_MS);  // Delay for 100 milliseconds
  }
}

static void rollDesired(void *pvParameters) {
  while (1) {
    Serial.println("rollDesired");                                 // Status update to figure out which function is running
    int joystickInputY = analogRead(joystickInputYPin);            // Reading from the joystick saved as input value
    if (joystickInputY >= 3500) {                                  // If the joystick is completely at the right, the drone should move right quickly
      desiredRoll += 15;                                           // Increments desiredRoll by 15mm
    } else if (joystickInputY >= 3000 && joystickInputY < 3500) {  // If the joystick is somewhat at the right, the drone should move right
      desiredRoll += 10;                                           // Increments desiredRoll by 10mm
    } else if (joystickInputY > 2500 && joystickInputY < 3000) {   // If the joystick is a little at the right, the drone should move right slowly
      desiredRoll += 5;                                            // Increments desiredRoll by 5mm
    } else if (joystickInputY < 1500 && joystickInputY > 1000) {   // If the joystick is a little at the left, the drone should move left slowly
      desiredRoll -= 5;                                            // Decrements desiredRoll by 5mm
    } else if (joystickInputY <= 1000 && joystickInputY > 500) {   // If the joystick is somewhat at the left, the drone should move left
      desiredRoll -= 10;                                           // Decrements desiredRoll by 10mm
    } else if (joystickInputY <= 500) {                            // If the joystick is completely at the left, the drone should move left quickly
      desiredRoll -= 15;                                           // Decrements desiredRoll by 15mm
    }
    writeToAddress(0x08, 0x0B, desiredRoll);  // Updates the desired memory module address with current desired roll value
    vTaskDelay(100 / portTICK_PERIOD_MS);     // Delay for 100 milliseconds
  }
}

static void stop(void *pvParameters) {  // Emergency stop function
  while (1) {
    Serial.println("Stop for satan!");             // Status update to figure out which function is running
    if (digitalRead(emergencyButtonPin) == LOW) {  // Checks if the emergency button is pushed
      digitalWrite(emergencyLightPin, HIGH);       // Lights up the emergency lights
      vTaskSuspend(hdlHeightDesired);              // Suspends heightDesired function
      vTaskSuspend(hdlYawRead);                    // Suspends yawRead function
      vTaskSuspend(hdlYawDesired);                 // Suspends yawDesired function
      vTaskSuspend(hdlPitchRead);                  // Suspends pitchRead function
      vTaskSuspend(hdlPitchDesired);               // Suspends pitchDesired function
      vTaskSuspend(hdlRollRead);                   // Suspends rollRead function
      vTaskSuspend(hdlRollDesired);                // Suspends rollDesired function
    } else {                                       // Checks if the emergency button is released
      digitalWrite(emergencyLightPin, LOW);        // Turns off the emergency lights
      vTaskResume(hdlHeightRead);                  // Resumes heightRead function
      vTaskResume(hdlHeightDesired);               // Resumes heightDesired function
      vTaskResume(hdlYawRead);                     // Resumes yawRead function
      vTaskResume(hdlYawDesired);                  // Resumes yawDesired function
      vTaskResume(hdlPitchRead);                   // Resumes pitchRead function
      vTaskResume(hdlPitchDesired);                // Resumes pitchDesired function
      vTaskResume(hdlRollRead);                    // Resumes rollRead function
      vTaskResume(hdlRollDesired);                 // Resumes rollDesired function
    }
    vTaskDelay(500 / portTICK_PERIOD_MS);  // Delays this task from running for the next 500 ms
  }
}