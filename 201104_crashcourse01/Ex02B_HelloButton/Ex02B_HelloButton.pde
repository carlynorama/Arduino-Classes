/*

 This is code to demonstrates the use digitalRead and how to set up
 different button circuits. 
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 2 (ex 1) of the 
 Intro to Arduino class at Machine Project in April and if very similar
 to the one provded with the Arduino environment itself.
 
 Available: 
 http://23longacre.com/sharedFiles/code/arduino/201004_MP_IntroToArduino/
 
  The Circuit:
   * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed)
   * Pin 9: LED, anode to arduino, 330 Ohm resistor from cathode to ground
   
                         ___
                       ___|___
                  |----o     o------|l> GND
    _________     |
   |	     |    |     10k Ohm
   |  	   2 |----|----/\/\/\-------| Vcc (+5V) 
   |         | 
   | Arduino |
   |         | 
   |         |    LED     330 Ohm
   |       9 |----(>|)----/\/\/\----|l> GND
   |_________|   
 
   
   
   
  The Behavior:
    When the button is pressed the LED is on. What happens if you change 
    the value of buttonTrue without changing the circuit? 
    
  Written By: Carlyn Maw
  Created: April 2010
  Updated: Nov 1 2010
 */


//DEFINE: STEP ONE, INTPUTS AND THEIR VARIABLES
const int buttonPin = 2;   //the push button
int buttonState = 0;       //what is the push button doing
boolean buttonTrue = LOW;  //when pressed does it see ground or 
                           //sees VCC?

//DEFINE: STEP TWO, OUTPUTS AND THEIR VARIABLES
const int ledPin = 9;    // the output LED


//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Set digital pin mode for inputs and their initial conditions
  pinMode(buttonPin, INPUT);
  
  //SETUP STEP TWO: Set digital pin mode for outputs and their initial conditions
  pinMode(ledPin, OUTPUT);
}

//------------------------------------------------------------------- START MAIN LOOP
void loop() {

  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  buttonState = digitalRead(buttonPin);

  //LOOP: STEP TWO, DO SOMETHING ABOUT IT
  if (buttonState==buttonTrue) {
    digitalWrite(ledPin, HIGH);
  } 
  else {
    digitalWrite(ledPin, LOW); //always turn off what you turn on
  }
}
