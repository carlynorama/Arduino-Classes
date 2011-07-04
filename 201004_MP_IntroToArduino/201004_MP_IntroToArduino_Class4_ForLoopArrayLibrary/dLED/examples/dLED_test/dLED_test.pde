/*
For Intro to Arduino @ Machine Project April 2010
Carlyn Maw

Code blinks an LED attached to pin 13 3 times and then blinks 
an LED attached to pin 12 2 times. 

*/

#include <dLED.h>

//make two instances of a dLED
dLED myLedEx = dLED(13);
dLED myOtherLed = dLED(12);

void setup()
{
//outputs declaration is handled by the library. 
}

void loop()
{
  myLedEx.blinkMe(3);
  myOtherLed.blinkMe(2);
}

