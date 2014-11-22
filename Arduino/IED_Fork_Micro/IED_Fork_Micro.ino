#include <stdio.h>
#include <SPI.h>
#include <boards.h>
#include <RBL_nRF8001.h>
#include "Adafruit_MAX31855.h"

#define D0 8
#define CS 9
#define CLK 10
Adafruit_MAX31855 thermocouple(CLK, CS, D0);
#define analogPin A0
#define analogPin2 A1

int raw= 0;
float Vin= 5.0;
float Vout= 0;
float R1= 1000;
int R2= 0;
int R3 = 0;
float buffer= 0;

void setup()
{

  // Init. and start BLE library.
  ble_begin();
  
  // Enable serial debug
  Serial.begin(57600);
}

unsigned char buf[16] = {0};
unsigned char len = 0;



void loop()
{
  //Serial.println("Hello");
  if ( ble_connected() )
  {
    /*ble_write('H');
    ble_write('e');
    ble_write('l');
    ble_write('l');
    ble_write('o');
    ble_write(' ');
    ble_write('W');
    ble_write('o');
    ble_write('r');
    ble_write('l');
    ble_write('d');
    ble_write('!');*/
    //
    
    //
    raw= analogRead(analogPin);
    if(raw) 
    {
      buffer= raw * 5;
      Vout= (buffer)/1024.0;
      buffer= (Vin/Vout) -1;
      R2= R1 * buffer;
      String R2str(R2);
      for (int i = 0; i < R2str.length(); i++) {
        ble_write(R2str[i]);
      }
    
    }
    ble_write('R');
    ble_do_events();
    delay(100);
    raw = analogRead(analogPin2);
    if (raw)
    {
      buffer = raw * 5;
      Vout = (buffer)/1024.00;
      buffer = (Vin/Vout) - 1;
      R3 = R1 * buffer;
      String R3str(R3);
      for (int i = 0; i < R3str.length(); i++) {
        ble_write(R3str[i]);
      }
    }
    ble_write('S');
    ble_do_events();
    delay(100);
    double c = thermocouple.readCelsius();
    if (!isnan(c)) {
      String tempStr((int)(c*10));
      for (int i = 0; i < tempStr.length(); i++) {
        ble_write(tempStr[i]);
      }
    }
    ble_write('T');
  }

  ble_do_events();
 
  delay(1000);  
}
