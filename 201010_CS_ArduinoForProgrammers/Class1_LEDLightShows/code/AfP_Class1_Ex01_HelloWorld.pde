/*
  Blink
 
 Turns on an LED on for one second, then off for one second, repeatedly.
 
 This version was for Class 1 of the Arduino for Programmers course 
 taught at CRASH Space in October. The code itself is identical to the blink 
 example:
 
 Created 1 June 2005
 By David Cuartielles
 
 http://arduino.cc/en/Tutorial/Blink
 
 based on an orginal by H. Barragan for the Wiring i/o board
 
 Additional comments have been added by Carlyn Maw Oct 2010
 
 The Circuit:
 * LED connected from digital pin 13 to ground
 
 * Note: On most Arduino boards, there is already an LED on the board
 connected to pin 13, so you don't need any extra components for this example.
 
 
 */

//DEFINE: STEP ONE, What is connected to you?
int ledPin =  13;    // LED connected to digital pin 13

//example uses a variable to hold the postion of LED. in the future
//we will be using the below line because what pin our led is on will
//not change while the program is running. use const when you can in
//microcontroller programming. Saves a lot of space while still providing
//type information.

//const int ledPin = 13; 

//Also valid is

//#define ledPin 13

//notice no equal sign or semi colon. 
//it's use can cause some strange errors later on so const is prefered. 

//for more discussion on this see:
//http://www.arduino.cc/en/Reference/Define
//http://arduino.cc/en/Reference/Const

// The setup() method runs once, when the sketch starts
void setup()   {                
  // initialize the digital pin as an output:
  pinMode(ledPin, OUTPUT);     
}

// the loop() method runs over and over again,
// as long as the Arduino has power

void loop()                     
{
  digitalWrite(ledPin, HIGH);   // set the LED on 
                                //(HIGH can be replaced by 1 or true)
  delay(1000);                  // wait for a second
  digitalWrite(ledPin, LOW);    // set the LED off -- ALWAYS HAVE TO TURN IT OFF!
                                //(HIGH can be replaced by 1 or true)
  delay(1000);                  // wait for a second
}
