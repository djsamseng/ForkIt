#include <Arduino.h>
#include <AltSoftSerial.h>
#define BLEMini Serial


int analogPin= 0;
int raw= 0;
int Vin= 5;
float Vout= 0;
float R1= 1000;
float R2= 0;
float buffer= 0;


void setup()
{
    BLEMini.begin(57600); 
    //Serial.begin(57600);
}

void loop()
{
  raw= analogRead(analogPin);
  if(raw) 
  {
    buffer= raw * Vin;
    Vout= (buffer)/1024.0;
    buffer= (Vin/Vout) -1;
    R2= R1 * buffer;
    BLEMini.write("Vout: ");
    BLEMini.print(Vout);
    BLEMini.write("R2: ");
    BLEMini.print(R2);
    delay(1000);
  }
  else
  {
    BLEMini.write("No data");
  }
}
