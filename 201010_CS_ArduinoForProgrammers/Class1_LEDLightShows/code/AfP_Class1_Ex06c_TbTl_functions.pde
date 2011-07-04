/*

 This is code to demonstrates the two buttons interacting and yet isolated
 into their own little functions. 
 
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
    A second button determines which one.
    
  Written By: Carlyn Maw
  Created: April 2010
  Updated: Nov 1 2010
    
 */
 
 

//DEFINE: STEP ONE, INPUTS AND THEIR VARIABLES
//(why didn't I move these into the subfunctions?)
const int buttonOnePin = 2;   
const int buttonTwoPin = 3;   

boolean buttonOneState = 0; 
boolean buttonTwoState = 0;  

boolean buttonOneTrue = LOW;  //what do I look like when I'm pressed?
boolean buttonTwoTrue = LOW;  //what do I look like when I'm pressed?

//DEFINE: STEP TWO, OUTPUTS AND THEIR VARIABLES
const int ledOnePin = 13; 
const int ledTwoPin = 9;    

//variables which know which LED you've picked in the
//pickLED() function. 
int currentLED;                         
int otherLED;                  

//------------------------------------------------------------------ START SETUP LOOP
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
 
   //polling the environment now happens in each of the sub fuctions
   //what might be some consequences of the whole loop not operating 
   //on the same snap shot of the enironment? pros and cons of fresh
   //readings...


  //Evaluate the toggle switch and pick your LED
  pickLED();

  //Evaluate the push button and light the selected LED
  lightLED();
       
  
}

//------------------------------------------------------------------- END MAIN LOOP


//--------------------------------------------------------------------- pickLED
void pickLED() {            
  //Poll my tiny corner of the world
  buttonTwoState = digitalRead(buttonTwoPin); 
  
  //Do something about it
  if (buttonTwoState == buttonTwoTrue) {    
    currentLED = ledOnePin;
    otherLED = ledTwoPin;
  } 
  else {
    currentLED = ledTwoPin;
    otherLED = ledOnePin;
  }
}

//------------------------------------------------------------------- lightLED
void lightLED() {            
  //Poll my tiny corner of the world 
  buttonOneState = digitalRead(buttonOnePin);  

  //Do something about it
  if (buttonOneState == buttonOneTrue) { 
       digitalWrite(currentLED, HIGH); 
       digitalWrite(otherLED, LOW);   
  } 
  else {
    // turn everybody off
    digitalWrite(ledOnePin, LOW);
    digitalWrite(ledTwoPin, LOW);
  }   
}
