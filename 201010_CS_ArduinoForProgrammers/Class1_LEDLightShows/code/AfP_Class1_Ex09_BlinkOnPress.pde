/*

 This is code to demonstrates the a non-delay style blink.
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 2 (ex 7) of the 
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
    When the a button is pressed an LED blinks. 
    
  Written By: Carlyn Maw
  Created: April 2010
  Updated: Nov 1 2010
    
 */
 
//DEFINE: STEP ONE, GLOBAL STATUS VARS
long lastMillis= 0;
long currentMillis = 0;

int runFlag = false;  

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES
//(why didn't I move these into the subfunctions?)
const int buttonOnePin = 2;     
boolean buttonOneState = 0; 
boolean buttonOneTrue = LOW;  //what do I look like when I'm pressed?
boolean lastButtonOneState = 0; 

const int buttonTwoPin = 3;     
boolean buttonTwoState = 0; 
boolean buttonTwoTrue = LOW;  //what do I look like when I'm pressed?
//boolean lastButtonTwoState = 0; //not used in this code

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
const int ledOnePin = 13; 
const int ledTwoPin = 9; 

int currentLED;
int otherLED;


//GENERIC LED TIMING VARIABLES 
int blinkOnPeriod = 1000;
int blinkState;
long blinkFlipTime;
             

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
  
  //runFlag = true; // VERSION C part-2
}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
 
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes time constant

  //LOOP: STEP TWO, SAVE LAST STATES & POLL THE ENVIRONMENT
  lastButtonOneState = buttonOneState;         //NEW
  buttonOneState = digitalRead(buttonOnePin);

 //LOOP: STEP THREE, SHOULD I RUN?
/*
  //Version A
  //runFlag = buttonOneState;


  //VERSION B
  // Doesn't work for this code, would for SOS trigger
  if (buttonOneState != lastbuttonOneState) {
    runFlag = true;
  }
  else {
    runFlag = false;
  }

  //VERSION C - part 1
  if (buttonOneState != lastbuttonOneState) {
    runFlag ? runFlag=false : runFlag=true;
  }

*/                                                                    

  //VERSION D (dont forget to recomment C-part 2)
  //two conditions joined by a boolean opperator for AND
  //on press (buttonOneState == false would be on release)
  if (buttonOneState != lastButtonOneState && buttonOneState == buttonOneTrue) {
    runFlag ? runFlag=false : runFlag=true;
  }

//Hopefully this reminder picture will help. The if will true where there are *'s
/*
         *---------------         *---------------                                                       
         |              |         |              |                                         
         |              |         |              |                                         
         |              |         |              |                                          
         |              |         |              |                                         
_________|              |_________|              |__________ etc.                                                          

*/ 


   //LOOP: STEP FOUR, run the lights!
  //Then the usual suspects, but with the runFlag rather than the 
  //buttonState variable.
  if (runFlag == true) {      //------------------------------ CHANGED!
    pickLED(); 
    digitalWrite(otherLED, LOW);
    blinkIt(currentLED);  //just the code from the prev. example as function.
  } 
  else {
    digitalWrite(ledOnePin, LOW); 
    digitalWrite(ledTwoPin, LOW);
    blinkState = false; // needs to be told it's off       
    blinkFlipTime = currentMillis - blinkOnPeriod;
  }
}


//------------------------------------------------------------------- END MAIN LOOP

// ------------------------------------------------------------------------ pickLED
void pickLED() {
  int buttonTwoState = digitalRead(buttonTwoPin);
  if (buttonTwoState == buttonTwoTrue) {
    currentLED = ledOnePin;
    otherLED = ledTwoPin;
  } 
  else {
    currentLED = ledTwoPin;
    otherLED = ledOnePin;
  }
}


///----------------------------------------------------------------------  blinkIt

void blinkIt(int myLED) {
  if ((blinkOnPeriod) < (currentMillis- blinkFlipTime)) {
    blinkState ? blinkState=false : blinkState=true;
    blinkFlipTime = currentMillis;       
  }
  //(moving this line outside the if is what makes it update every time)
  digitalWrite(myLED,blinkState); 
}


