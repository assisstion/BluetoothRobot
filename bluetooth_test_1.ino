
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include <Servo.h> 

#define RED 3

Servo leftServo;
Servo rightServo;

double leftSpeed = 0;
double rightSpeed = 0;

//Based on https://github.com/scottCheezem/BlueRCSketch/blob/LED_example/BleRC.ino

void setup() {
  
  leftServo.attach(5);
  rightServo.attach(6);
  
  // put your setup code here, to run once:
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  ble_begin();

  Serial.begin(57600);
}

void loop() {
  // put your main code here, to run repeatedly: 


  /*if(ble_connected()){
    digitalWrite(7,255); 

  }*/

   

  
  while(ble_available()){
    
    
    
    
    byte left;
    byte right;
    
    if(right = ble_read()){
      //read the first number for the led to address, and the second for the value...

     //val = ble_read();

      left = ble_read();
      
      
      Serial.print(left);
      Serial.print(", ");
      Serial.print(right);
      Serial.print("\n");
      
      leftSpeed = byteToSpeed(left);
      rightSpeed = byteToSpeed(right);
      
    }  
  }
    
    Serial.print("p");
    Serial.print(leftSpeed);
    Serial.print(", ");
    Serial.print(rightSpeed);
    Serial.print("\n");
    
    leftServo.write((leftSpeed + 1) * 90); 
    rightServo.write(180-((rightSpeed + 1) * 90)); 
   // rightServo.write(90);
  /*if(digitalRead(4) == LOW){
      Serial.println("HI");
       ble_write('1'); 
    }*/
  
  /*if (!ble_connected())
  {
    digitalWrite(7, LOW);

    //analog_enabled = false;
    //digitalWrite(DIGITAL_OUT_PIN, LOW);
  }*/
  
  // Allow BLE Shield to send/receive data
  ble_do_events();
  //digitalWrite(RED, LOW);
}

double byteToSpeed(byte value){
  return (value - 128) / 127.0;
}

int mod180(int value){
  while(value < 0){
    value += 180;
  }
  return value % 180;
}
