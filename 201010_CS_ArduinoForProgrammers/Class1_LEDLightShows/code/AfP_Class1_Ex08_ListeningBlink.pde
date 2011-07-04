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
   * Pin 13: internal LED
   
                     ___
                   ___|___
                |--o     o---|l> GND
    _________   |                          
   |	     |  |  10k Ohm                 
   |  	   2 |--|---/\/\/\---| Vcc (+5V)   
   |  	     |
   | Arduino |
   |         | 
   |         |
   |         |
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

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES
//(why didn't I move these into the subfunctions?)
const int buttonOnePin = 2;     
boolean buttonOneState = 0; 
boolean buttonOneTrue = LOW;  //what do I look like when I'm pressed?

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
const int ledOnePin = 13; 
int ledOneOnPeriod = 500;
int ledOneState;
long ledOneFlipTime;
             

//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP TWO: Set digital pin mode for inputs and their initial conditions
  pinMode(buttonOnePin, INPUT);    
  //uncomment these to use Arduino's internal pull up resistors
  //in this example we have our own.
  //digitalWrite(buttonOnePin, HIGH);  
  
  //SETUP STEP THREE: Set digital pin mode for outputs and their initial conditions
  pinMode(ledOnePin, OUTPUT);  
  digitalWrite(ledOnePin, LOW);  
}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
 
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes time constant

  //LOOP: STEP TWO, POLL THE ENVIRONMENT
  buttonOneState = digitalRead(buttonOnePin);

  //LOOP: STEP THREE, DO SOMETHING ABOUT IT
   if (buttonOneState == buttonOneTrue) { 
    //BLINK LED  ------------------------------ START NEW
    if ((ledOneOnPeriod) < (currentMillis- ledOneFlipTime)) {
        ledOneState ? ledOneState=false : ledOneState=true;
        ledOneFlipTime = currentMillis;
        digitalWrite(ledOnePin,ledOneState);
    }  
    //BLINK LED  ----------------------------- END NEW
  } 
  else {
    // turn it off and reset if push button is false
    //Needs ALLLLL of this. Do you remember why?
    digitalWrite(ledOnePin, LOW);   // this is old we've turned people off 
                                    // before
    ledOneState = false; //NEW
    ledOneFlipTime = currentMillis - ledOneOnPeriod; //NEW
    //why not ledOneFlipTime = currentMillis, btw?
  }
       
  
}

//------------------------------------------------------------------- END MAIN LOOP
