/*
  Blink an External LED
 
  Behavior:
  Turns on an LED on for one second, then off for one second, repeatedly.
 
  Circuit:
  * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
  cathode to ground
 
   _________
  |	    |
  | Arduino |
  |    	    |    LED     330 Ohm
  |  	PIN3|----(>|)----/\/\/\----|l> GND
  |_________|   
 
  Based on Example Code included w/ Arduino 1.0.5.
 
  (If continuing on with the kitty project, make sure the LED is connected 
  to a pin capable of PWM)
 
  Based on Example Code included w/ Arduino 1.0.5.
  Adapted by Carlyn Maw 2013
 
 */
//where the led is
int ledPin = 3;

// the setup routine runs once when you press reset:
void setup()   {                
  // initialize the digital pin as an output:
  pinMode(ledPin, OUTPUT);     
}

// the loop() method runs over and over again,
// as long as the Arduino has power
void loop()                     
{
  digitalWrite(ledPin, HIGH);   // set the LED on
  delay(1000);                  // wait for a second
  digitalWrite(ledPin, LOW);    // set the LED off
  delay(1000);                  // wait for a second
}
