/*

 This is code to demonstrates the two buttons interacting via a global variable
 
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
const int buttonOnePin = 2;   
const int buttonTwoPin = 3;   

boolean buttonOneState = 0; 
boolean buttonTwoState = 0;  

boolean buttonOneTrue = LOW;  //what do I look like when I'm pressed?
boolean buttonTwoTrue = LOW;  //what do I look like when I'm pressed?

//DEFINE: STEP TWO, OUTPUTS AND THEIR VARIABLES
const int ledOnePin = 13; 
const int ledTwoPin = 9;    

//have variables which know which LED you've picked
int currentLED;                         //-------------------NEW
int otherLED;                           //-------------------NEW

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
   
 
   //UNMESHED, isolates each part of the situation by passing
   //information between the two if's with a global variable

  //Evaluate the toggle switch and pick your LED
  
  //---------------------------------------- MOVED
    if (buttonTwoState == buttonTwoTrue) {
          currentLED = ledOnePin; //-----CHANGED/NEW
          otherLED = ledTwoPin;   //-----CHANGED/NEW
    } else {
          currentLED = ledTwoPin; //-----CHANGED/NEW
          otherLED = ledOnePin;   //-----CHANGED/NEW
    }
 //----------------------------------------  END MOVED


  //Evaluate the push button and light the selected LED

  if (buttonOneState == buttonOneTrue) { 
       digitalWrite(currentLED, HIGH); //-----CHANGED/NEW
       digitalWrite(otherLED, LOW);    //-----CHANGED/NEW
  } 
  else {
    // turn everybody off
    digitalWrite(ledOnePin, LOW);
    digitalWrite(ledTwoPin, LOW);
  }          
  
}



