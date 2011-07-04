/*

 This is code to demonstrates the two buttons interacting.
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 2 (ex 2-4) of the 
 Intro to Arduino class at Machine Project in April.
 
 Available: 
 http://23longacre.com/sharedFiles/code/arduino/201004_MP_IntroToArduino/
 
  The Circuit:
   * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed)
   * Pin 3: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed)
   * Pin 9: LED, anode to arduino, 330 Ohm resistor from cathode to ground
   * Pin 13: internal LED
   
                     ___
                   ___|___                      ___
                |--o     o---|l> GND          ___|___
    _________   |                          |--o     o---|l> GND
   |	     |  |  10k Ohm                 |   
   |  	   2 |--|---/\/\/\---| Vcc (+5V)   |  10k Ohm
   |  	   3 |-----------------------------|---/\/\/\---| Vcc (+5V) 
   | Arduino |
   |         | 
   |         |    LED     330 Ohm
   |       9 |----(>|)----/\/\/\----|l> GND
   |         | 
   |         |    
   |      13 |---- LED set up for ya.
   |_________|   
 
   See diagram at http://www.oomlout.com/a/products/ardx/circ-07
   
   
  The Behavior:
    When the a button is pressed an LED is on, 
    A second button determines which one. Uses Nested If Statements.
    
 Written By: Carlyn Maw
 Created: April 2010
 Updated: Nov 1 2010
 */
 
 

//DEFINE: STEP ONE, INPUTS AND THEIR VARIABLES
const int buttonOnePin = 2;   
const int buttonTwoPin = 3;   

boolean buttonOneState = 0; 
boolean buttonTwoState = 0;  

boolean buttonOneTrue = LOW;  
boolean buttonTwoTrue = LOW;  

//DEFINE: STEP TWO, OUTPUTS AND THEIR VARIABLES
const int ledOnePin = 13; 
const int ledTwoPin = 9;    


//----------------------------------------------------------------- START SETUP LOOP
void setup() {
  //SETUP STEP TWO: Set digital pin mode for inputs and their initial conditions
  pinMode(buttonOnePin, INPUT);  
  pinMode(buttonTwoPin, INPUT);
  
  //uncomment these to use Arduino's internal pull up resistors
  //in this example we have our own.
  //digitalWrite(buttonOnePin, HIGH);  
  //digitalWrite(buttonTwoPin, HIGH);
  
  //SETUP STEP THREE: Set digital pin mode for outputs and their initial conditions
  pinMode(ledOnePin, OUTPUT);  
  pinMode(ledTwoPin, OUTPUT);  
  
  digitalWrite(ledOnePin, LOW);  
  digitalWrite(ledTwoPin, LOW);  
}
//------------------------------------------------------------------ START MAIN LOOP
void loop() {

  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  buttonOneState = digitalRead(buttonOnePin);  
  buttonTwoState = digitalRead(buttonTwoPin); 

  //LOOP: STEP TWO, EVALUATE & DO SOMETHING ABOUT IT
    /*
     A reminder of what we're trying to do that I hope helps
     
     
      PB1     |         1        |          0        | 
     -------------------------------------------------          
      PB2  1  | LED1: 1, LED2: 0 |  LED1: 0, LED2: 0 |
          ----------------                                                             
           0  | LED1: 0, LED2: 1 |  LED1: 0, LED2: 0 |
     */
  

  //MESHED NESTED IF STYLE
  
  // ---------- if buttonOne is pressed
  // --------------- then look to see what buttonTwo was
  // --------------- if buttonTwo is also presed
  // -------------------- then turn ON LED One  
  // -------------------- making sure LED Two is OFF
  // --------------- if buttonTwo isn't pressed then
  // -------------------- then turn ON LED Two  
  // -------------------- making sure LED One is OFF
  // ---------- otherwise, if buttonOne wasnt pressed in the first place
  // --------------- turn everybody off.

  if (buttonOneState == buttonOneTrue) { 
    if (buttonTwoState == buttonTwoTrue) { 
          digitalWrite(ledOnePin, HIGH);
          digitalWrite(ledTwoPin, LOW);
    } else {
          digitalWrite(ledOnePin, LOW);
          digitalWrite(ledTwoPin, HIGH);      
    } 
  }                                   
  else {                              
    digitalWrite(ledOnePin, LOW);     
    digitalWrite(ledTwoPin, LOW);     
  }   
  
  
}



