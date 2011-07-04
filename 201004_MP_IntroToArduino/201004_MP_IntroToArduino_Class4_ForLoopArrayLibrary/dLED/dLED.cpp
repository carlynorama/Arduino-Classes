

#include "WProgram.h"
#include "dLED.h"

dLED::dLED(int pin)
{
  pinMode(pin, OUTPUT);
  _pin = pin;
  _state = 0;
}

void dLED::turnOn(){
	setState(1);
}

void dLED::turnOff(){
	setState(0);
}

bool dLED::getState(){
	return (_state);
}

void dLED::blinkMe(int blinkNum)
{
for (int i=0; i < blinkNum; i++) {
  setState(1);
  delay(200);
  setState(0);
  delay(200);
  }
}



//------------------------------------------------------ PRIVATE
void dLED::setState(bool setValue)
{
  // eventhough this function is public, it can access
  // and modify this library's private variables
  if (setValue == 1) {
  digitalWrite(_pin, HIGH);
  _state = 1;
} else if (setValue == 0){
  digitalWrite(_pin, LOW);
  _state = 0;
  }
}

