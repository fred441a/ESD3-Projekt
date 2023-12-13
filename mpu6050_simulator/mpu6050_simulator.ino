#include <Wire.h>

byte counter = 0;

void request_handler(void){
    counter ++;
    Wire.write(counter);

}

void setup (){
    Wire.begin(0x68);
    Wire.onRequest(request_handler);

}

void loop(){}
