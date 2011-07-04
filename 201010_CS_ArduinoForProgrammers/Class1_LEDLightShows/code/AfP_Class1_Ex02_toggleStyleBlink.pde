/*
 
 This is code to demonstrate syntax for if statements.
 
 This version was for Class 1 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010 based. 
 
 The class was based on the SparkFun Arduino Iventors Kit
 
 The Circuit:
 * PIN 13: LED connected from digital to ground

 The Behavior:
 If the LED is on it turns off. If it is off it turns on. The 
 period of the behavior is set by the delayTime variable at the 
 top so with the current setting (delayTime = 1000) it stays on
 for a second and off for a second.
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, OUTPUTS AND THEIR VARIABLES
const int ledPin = 13;

//keep in mind that the program doesn't know anything
//you have to set up variables that you can query later
//that match the state of your outputs. 
boolean ledState = 0;

//its nice to have things that you might want to change
//later at the top of the code.
int delayTime = 1000;


//------------------------------------------------------------------ START SETUP LOOP
void setup() {
    pinMode(ledPin, OUTPUT);
    digitalWrite(ledPin, LOW);
}


//------------------------------------------------------------------ START MAIN LOOP
void loop() {

if (ledState == HIGH) {
  ledState = LOW;
} else {
  ledState = HIGH;  
}

//same as
//(ledState) ? ledState = LOW : ledState = HIGH;

 digitalWrite(ledPin,ledState);

 delay(delayTime);
  
}


