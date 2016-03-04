
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include <Servo.h> 

//Bluetooth Robot Arduino Code
//The servos on the bluetooth robot
Servo leftServo;
Servo rightServo;

//The speed of the servos
double leftSpeed = 0;
double rightSpeed = 0;

//Based on https://github.com/scottCheezem/BlueRCSketch/blob/LED_example/BleRC.ino

void setup() {
  
  //Attach the servos to their pins
  leftServo.attach(5);
  rightServo.attach(6);
  
  //Setup the Serial Peripheral Interface
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  //Begins scanning for bluetooth
  ble_begin();

  //Begins running the serial port on 57600 bits per second
  Serial.begin(57600);
}

void loop() {
  
  //Read bluetooth data as long as there is remaining unread data
  while(ble_available()){
    
    //The bytes of data for the left and right motors
    byte left;
    byte right;
    
    //If the data is present
    if(right = ble_read()){
      //Read the right and left motor data
      left = ble_read();
      
      //Prints the data
      Serial.print(left);
      Serial.print(", ");
      Serial.print(right);
      Serial.print("\n");
      
      //Converts the left and right speed from the bytes sent
      leftSpeed = byteToSpeed(left);
      rightSpeed = byteToSpeed(right);
      
    }  
  }
    
  Serial.print("p");
  Serial.print(leftSpeed);
  Serial.print(", ");
  Serial.print(rightSpeed);
  Serial.print("\n");
    
  //Writes the left speed to the servo, converting from speed to servo value
  leftServo.write(speedToServoValue(leftSpeed)); 
  //Right servo is reversed
  rightServo.write(180 - speedToServoValue(rightSpeed)); 
  
  // Allow BLE Shield to send/receive data
  ble_do_events();
}

//Converts the byte read from bluetooth to the servo speed 
double byteToSpeed(byte value){
  return (value - 128) / 127.0;
}

//Converting from -1 to 1 (speed) -> 0 to 180 (servo value)
double speedToServoValue(double value){
  return (value + 1) * 90;
}