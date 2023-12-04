#include "Wire.h"
#define MPU6050_DEVICE_ID 0x08 ///< The correct MPU6050_WHO_AM_I value

void setup(){
		Serial.begin(115200);
		Wire.begin();
}

void loop(){
  Serial.println(ReadByte(0x21));
  delay(50);
}

byte ReadByte(char registerAddr){
		Wire.beginTransmission(MPU6050_DEVICE_ID);
		Wire.write(registerAddr);
		char error = Wire.endTransmission();
		if(error != 0){
				Serial.printf("error %d \n", error);
				return 0;
		}
		Wire.requestFrom(MPU6050_DEVICE_ID,4);

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
