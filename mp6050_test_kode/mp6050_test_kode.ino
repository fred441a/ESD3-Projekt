#include "Wire.h"
#define MPU6050_DEVICE_ID 0x68 ///< The correct MPU6050_WHO_AM_I value

#define MPU6050_SELF_TEST_X   0x0D ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_Y    0x0E ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_Z   0x0F ///< Self test factory calibrated values register
#define MPU6050_SELF_TEST_A  0x10 ///< Self test factory calibrated values register
#define MPU6050_SMPLRT_DIV 0x19  ///< sample rate divisor register
#define MPU6050_CONFIG 0x1A      ///< General configuration register
#define MPU6050_GYRO_CONFIG 0x1B ///< Gyro specfic configuration register
#define MPU6050_ACCEL_CONFIG  0x1C ///< Accelerometer specific configration register
#define MPU6050_INT_PIN_CONFIG 0x37 ///< Interrupt pin configuration register
#define MPU6050_INT_ENABLE 0x38     ///< Interrupt enable configuration register
#define MPU6050_INT_STATUS 0x3A     ///< Interrupt status register
#define MPU6050_WHO_AM_I 0x75       ///< Divice ID register
#define MPU6050_SIGNAL_PATH_RESET 0x68 ///< Signal path reset register
#define MPU6050_USER_CTRL 0x6A         ///< FIFO and I2C Master control register
#define MPU6050_PWR_MGMT_1 0x6B        ///< Primary power/sleep control register
#define MPU6050_PWR_MGMT_2 0x6C ///< Secondary power/sleep control register
#define MPU6050_TEMP_H 0x41     ///< Temperature data high byte register
#define MPU6050_TEMP_L 0x42     ///< Temperature data low byte register
#define MPU6050_ACCEL_OUT 0x3B  ///< base address for sensor data reads
#define MPU6050_MOT_THR 0x1F    ///< Motion detection threshold bits [7:0]
#define MPU6050_MOT_DUR 0x20 ///< Duration counter threshold for motion int. 1 kHz rate, LSB = 1 ms


void setup(){
		Serial.begin(115200);
		Wire.begin();
		reset();

		// set sample rate divisor
		WriteBytes(MPU6050_SMPLRT_DIV,0);
		// set filterBandwith
		WriteBytes(MPU6050_CONFIG,0b00000110);
		//set gyro range
		WriteBytes(MPU6050_GYRO_CONFIG,0b00001000);
		//set Acc range
		WriteBytes(MPU6050_ACCEL_CONFIG, 0);
		//idk what this does, but they do it in the lib so we do it here
		WriteBytes(MPU6050_PWR_MGMT_1,0x01);
				
}

void loop(){
		Serial.println(ReadBytes(0x42));
}

void reset(){
		WriteBytes(MPU6050_PWR_MGMT_1,0b10000000);
		delay(100);
		WriteBytes(MPU6050_SIGNAL_PATH_RESET,0x07);
		delay(100);
}

byte ReadBytes(char registerAddr){
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

bool WriteBytes(char registerAddr, byte data){
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

