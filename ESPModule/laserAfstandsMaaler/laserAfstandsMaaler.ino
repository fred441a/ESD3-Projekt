#include "Adafruit_VL53L0X.h"

Adafruit_VL53L0X lox = Adafruit_VL53L0X();
VL53L0X_RangingMeasurementData_t measure;

void setup() {
  Serial.begin(115200);
  
  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }
  
  Serial.println("Adafruit VL53L0X test");
  if (!lox.begin()) {
    Serial.println(F("Failed to boot VL53L0X"));
    while(1);
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
}

void loop() {
  
  Serial.print("Reading a measurement... ");
  lox.rangingTest(&measure, false); // pass in 'true' to get debug data printout!
 
  if (measure.RangeStatus != 4) {  // phase failures have incorrect data
    Serial.print("Distance (mm): ");
    Serial.println(measure.RangeMilliMeter);  
  } else {
    Serial.println(" out of range ");
  }
}