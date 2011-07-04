/*
 This is code to demonstrates using buttons to trigger certain events
 it also highlights how delays are a bad idea when writing code
 with any kind of input because it won't listen to the pushbuttons. 
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 2 (ex 6) of the 
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
 |	       |  |  10k Ohm                 |   
 |    2 |--|---/\/\/\---| Vcc (+5V)      |  10k Ohm
 |       3 |-----------------------------|---/\/\/\---| Vcc (+5V) 
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
    Sends an SOS out on a pin once when button is pressed.
    Which LED is determined by a second button which must be in the correct
    position when the first button is pressed to get the right effect. 
 
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

//SOS Timing
const int dit = 200;           //--------------------- NEW
const int dah = 3*dit;         //--------------------- NEW
const int letterSpace = dit;   //--------------------- NEW
const int wordSpace = 7*dit;   //--------------------- NEW

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

//----------------------------------------------------------------- START MAIN LOOP
void loop() {

  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  buttonOneState = digitalRead(buttonOnePin);  

  //Evaluate the first one button
  if (buttonOneState == buttonOneTrue) { 
    //if it's true read the second one and 
    //select which LED i'm gonna sos out on
    pickLED();  // ------------- MOVED (more like nested if ex. now.)

    //turn the unused LED off
    digitalWrite(otherLED, LOW);
    
    //send the message
    writeSOS(currentLED);
  } 
  else {
    // turn everybody off is push button is false
    digitalWrite(ledOnePin, LOW);
    digitalWrite(ledTwoPin, LOW);
  }
}


//---------------------------------------------------------------- END MAIN LOOP


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


//------------------------------------------ALL THE BELOW IS NEW
// different than class 1 examples b/c they have local variables.
// makes them more portable. can use the same name if different ones if you
// want b/c they are all only relevant to their own functions.

//--------------------------------------------------------------- START PRIMATIVES

//-------------------------------------------------------------- writeDash()
void writeDash(int myLED){
  digitalWrite(myLED, HIGH);   // sets the LED on
  delay(dah);                  // waits for a second  
  digitalWrite(myLED, LOW);    // sets the LED off
  delay(dit);  
}

//--------------------------------------------------------------- writeDot()
void writeDot(int myLED){
  digitalWrite(myLED, HIGH);   // sets the LED on
  delay(dit);                  // waits  
  digitalWrite(myLED, LOW);    // sets the LED off
  delay(dit);  
}

//------------------------------------------------------- writeLetterSpace()
void writeLetterSpace(int myLED) {
  digitalWrite(myLED, LOW);    // sets the LED off
  delay(letterSpace);   
}

//--------------------------------------------------------- writeWordSpace()
void writeWordSpace(int myLED){  
  digitalWrite(myLED, LOW);    // sets the LED off
  delay(wordSpace);  
}

//----------------------------------------------------------------- START LETTERS

//------------------------------------------------------------ writeLetter()
// there are case statements in Arduino. We'll use them in the next
// class to handle serial strings 
void writeLetter(char letter, int myLED) {
  if (letter == 'S') {
    writeDash(myLED);
    writeDash(myLED);
    writeDash(myLED);
    writeLetterSpace(myLED);
  } 
  else if (letter == 'O') {
    writeDot(myLED);
    writeDot(myLED);
    writeDot(myLED);
    writeLetterSpace(myLED);
  } 
  else {
    writeWordSpace(myLED);  
  }
}

void writeSOS(int myLED) {
  writeLetter('S', myLED);
  writeLetter('O', myLED);
  writeLetter('S', myLED);
  writeWordSpace(myLED);
}












