#ifndef dLED_h
#define dLED_h

#include "WProgram.h"

class dLED
{
  public:
    dLED(int pin);
    void turnOn();
    void turnOff();
    void blinkMe(int);
    bool getState();
  private:
    int _pin;
    bool _state;
    void setState(bool);
};

#endif

