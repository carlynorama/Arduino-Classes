/*
  Blink an External LED
 
 Behavior:
 Turns on an LED on for one second, then off for one second, repeatedly.
 
 Circuit:
 * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 
  _________
 |	   |
 | Arduino |
 |    	   |    LED     330 Ohm
 |     PIN3|----(>|)----/\/\/\----|l> GND
 |_________|   
 
 
 
 Based on Example Code included w/ Arduino 1.0.5.
 Adapted by Carlyn Maw 2013
 
 http://www.arduino.cc/en/Tutorial/BlinkWithoutDelay
 
 */

//////////////////////////////////////////////////////////////////////////
/////////////// USER DEFINED CONSTANTS & STARTING VALUES /////////////////
const int redLedPin = 6;
//////////////////////////////////////////////////////////////////////////
//variables, value determined by the code
long speedMillis = 0;         // Amount of time for the delays. Is now a long.

int redLedState = LOW;       // ledState used to set the LED
long lastFlipMillis = 0;  // will store last time LED was updated

// ----------------------------------------------------------------- SETUP
// the setup routine runs once when you press reset.
void setup()   {                
  // initialize the digital pin as an output:
  pinMode(redLedPin, OUTPUT);    
}

// ------------------------------------------------------------------ LOOP
// the loop() method runs over and over again. 
void loop()                     
{

  //POLL THE ENVIRONMENT

  //get the time at the start of the loop

  unsigned long currentMillis = millis();
  unsigned long ellapsedMillis = currentMillis - lastFlipMillis;


  //CHECK IT AGAINST WHAT YOU ARE LOOKING FOR
  if (ellapsedMillis > speedMillis) {
    
    //DO SOMETHING ABOUT IT
    flipRedLedState();
    lastFlipMillis = currentMillis; 

  }
  
//UPDATE THE OUTPUTS  
digitalWrite(redLedPin,redLedState);  
}
// --------------------------------------------------------------  END LOOP


// ------------------------------------------------------- flipRedLedState()
void flipRedLedState() {
  if (redLedState == HIGH) {
    redLedState = LOW;
  } 
  else{
    redLedState = HIGH;
  }
}

