#include "Wire.h"
#define MPU6050_DEVICE_ID 0x68 ///< The correct MPU6050_WHO_AM_I value

#define MPU6050_SELF_TEST_X     0x0D ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_Y      0x0E ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_Z     0x0F ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_A    0x10 ///< Self test factory calibrated values register
#define MPU6050_SMPLRT_DIV 0x19    ///< sample rate divisor register
#define MPU6050_CONFIG 0x1A        ///< General configuration register
#define MPU6050_GYRO_CONFIG 0x1B ///< Gyro specfic configuration register
#define MPU6050_ACCEL_CONFIG    0x1C ///< Accelerometer specific configration register
#define MPU6050_INT_PIN_CONFIG 0x37 ///< Interrupt pin configuration register
#define MPU6050_INT_ENABLE 0x38       ///< Interrupt enable configuration register
#define MPU6050_INT_STATUS 0x3A       ///< Interrupt status register
#define MPU6050_WHO_AM_I 0x75         ///< Divice ID register
#define MPU6050_SIGNAL_PATH_RESET 0x68 ///< Signal path reset register
#define MPU6050_USER_CTRL 0x6A           ///< FIFO and I2C Master control register
#define MPU6050_PWR_MGMT_1 0x6B          ///< Primary power/sleep control register
#define MPU6050_PWR_MGMT_2 0x6C ///< Secondary power/sleep control register
#define MPU6050_TEMP_H 0x41       ///< Temperature data high byte register
#define MPU6050_TEMP_L 0x42       ///< Temperature data low byte register
#define MPU6050_ACCEL_OUT 0x3B    ///< base address for sensor data reads
#define MPU6050_MOT_THR 0x1F      ///< Motion detection threshold bits [7:0]
#define MPU6050_MOT_DUR 0x20 ///< Duration counter threshold for motion int. 1 kHz rate, LSB = 1 ms


void setup(){
                  Serial.begin(115200);
                  Wire.begin();
                  reset();

                  // set sample rate divisor
                  WriteByte(MPU6050_SMPLRT_DIV,0);
                  // set filterBandwith
                  WriteBits(MPU6050_CONFIG,0b00000110,0b00000111);
                  //set gyro range
                  WriteByte(MPU6050_GYRO_CONFIG,0b00001000);
                  //set Acc range
                  WriteByte(MPU6050_ACCEL_CONFIG, 0);
                  //idk what this does, but they do it in the lib so we do it here
                  WriteByte(MPU6050_PWR_MGMT_1,0x01);
                  delay(150);
                  Serial.println(ReadByte(0x3B));
                  writeToAddress32(0x01,0b00000000000000000000000000000001,0b00000000000000000000000000000001)
}

void loop(){

    Serial.println("Printing altitude");
    readFromAddress32(0x18);
    Serial.println("Printing MagnometerX");
    readFromAddress32(0x1B);
    Serial.println("Printing MagnometerY");
    readFromAddress32(0x1D);
    Serial.println("Printing MagnometerZ");
    readFromAddress32(0x1f);
    Serial.println("Printing GyroX");
    readFromAddress32(0x22);
    Serial.println("Printing GyroY");
    readFromAddress32(0x24);
    Serial.println("Printing GyroZ");
    readFromAddress32(0x26);
    Serial.println("Printing AccelX");
    readFromAddress32(0x29);
    Serial.println("Printing AccelY");
    readFromAddress32(0x2B);
    Serial.println("Printing AccelZ");
    readFromAddress32(0x2D);

    delay(50);


}

void reset(){
                  WriteBits(MPU6050_PWR_MGMT_1,0b10000000,0b100000000);
                  delay(200);
                  WriteByte(MPU6050_SIGNAL_PATH_RESET,0x07);
                  delay(100);
}

byte ReadByte(char registerAddr){
                  Wire.beginTransmission(MPU6050_DEVICE_ID);
                  Wire.write(registerAddr);
                  char error = Wire.endTransmission();
                  if(error != 0){
                                  Serial.printf("error %d \n", error);
                                  return 0;
                  }
                  Wire.requestFrom(MPU6050_DEVICE_ID,1);

                  byte data = 0;

                  while(Wire.available()){
                                  data = Wire.read();
                  }
                  return data;
}

bool WriteByte(char registerAddr, byte data){
                  Wire.beginTransmission(MPU6050_DEVICE_ID);
                  Wire.write(registerAddr);
                  Wire.write(data);
                  char Error = Wire.endTransmission();

                  if(Error != 0){
                                  Serial.print("ERROR: ");
                                  Serial.println((int)Error);
                                  return false;
                  }

                  return true;
}

bool WriteBits(char registerAddr, byte data, byte mask){
                  byte preData = ReadByte(registerAddr);
                  return WriteByte(registerAddr, (preData & mask)|data);
}

void writeToAddress32( uint8_t regAddress, uint32_t data, uint32_t mask) {
    Wire.beginTransmission(0x08);  // Starts sending data to assigned address
    Wire.write(regAddress);                // Register to read from
    Wire.endTransmission();                // Ends sending data to assigned address
    Wire.requestFrom(0x08, 4);     // Request 4 bytes from slave device

    char prevWord[4];
    int index = 0;

    while (Wire.available()) {  // Slave may send less than requested
      char prevWord[index] = Wire.read();     // Receive a byte as character
      index ++;
    }

    Wire.beginTransmission(slaveAddress);  // Starts sending data to assigned address
    Wire.write(regAddress);                // Register to write to
    Wire.write( (prevWord[0] & (byte)(mask >> 24)) | (byte)(data >> 24)); 
    Wire.write( (prevWord[1] & (byte)(mask >> 16)) | (byte)(data >> 16)); 
    Wire.write( (prevWord[2] & (byte)(mask >> 8)) | (byte)(data >> 8)); 
    Wire.write( (prevWord[3] & (byte)(mask >> 0)) | (byte)(data >> 0)); 
    Wire.endTransmission();                // Ends sending data to assigned address
}

void readFromAddress32(uint8_t regAddress) {
    Wire.beginTransmission(0x08);  // Starts sending data to assigned address
    Wire.write(regAddress);                // Register to read from
    Wire.endTransmission();                // Ends sending data to assigned address
    Wire.requestFrom(slaveAddress, 4);     // Request 4 bytes from slave device
    //Serial.print("Reg: 0x");               // Current register address being read
    //Serial.print(regAddress, HEX);         // The actual address in hex
    //Serial.print(" value: 0x");            // The value read from the register address
    while (Wire.available()) {  // Slave may send less than requested
      char c = Wire.read();     // Receive a byte as character
      Serial.print(c, BIN);                // Print the character
    }
    //Serial.println();  // Newline for readability
}
