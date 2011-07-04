/*
 
 This is code to demonstrates the use of the function syntax in arduino. 
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 1 (ex 2-6b) of the 
 Intro to Arduino class at Machine Project in April. 
 
 Available: 
 http://23longacre.com/sharedFiles/code/arduino/201004_MP_IntroToArduino/
 
 This code additionally shows passing parameters. 
 
 The Circuit:
 * Pin 9: LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 
  _________
 |	       |
 | Arduino |
 |  	   |    LED     330 Ohm
 |  	   |----(>|)----/\/\/\----|l> GND
 |_________|   
 
 The Behavior:
 LED Pin 9 is hooked up now b/c well if you are sending an SOS, chances are
 you will want to be able to see it so it should be off the board. 
 
 The LED hooked up to Pin 9 will blink out SOS at a rate determined by the
 settings at the top of the code. 
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, OUTPUTS AND THEIR VARIABLES
const int ledPin = 9;

//set the timing ratios for the led blinks.
const int dit = 300;
int dah = 3*dit;
int letterSpace = dit; 
int wordSpace = 7*dit;


//------------------------------------------------------------------ START SETUP LOOP
void setup() {                   
  //SETUP STEP ONE: Set digital pin modes
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output

  //SETUP STEP TWO: Set any initial condtions for outputs
  digitalWrite(ledPin, LOW);
}

//------------------------------------------------------------------ START MAIN LOOP
void loop()     
{

  writeLetter('S');
  writeLetter('O');
  writeLetter('S');

  writeWordSpace();  

}

//------------------------------------------------------------------ END MAIN LOOP

//--------------------------------------------------------------- START PRIMATIVES


//-------------------------------------------------------------- writeDash()
void writeDash(){
  digitalWrite(ledPin, HIGH);   // sets the LED on
  delay(dah);                  // waits for a second  
  digitalWrite(ledPin, LOW);    // sets the LED off
  delay(dit);  
}

//--------------------------------------------------------------- writeDot()
void writeDot(){
  digitalWrite(ledPin, HIGH);   // sets the LED on
  delay(dit);                  // waits  
  digitalWrite(ledPin, LOW);    // sets the LED off
  delay(dit);  
}

//------------------------------------------------------- writeLetterSpace()
void writeLetterSpace() {
  digitalWrite(ledPin, LOW);    // sets the LED off
  delay(letterSpace);   
}

//--------------------------------------------------------- writeWordSpace()
void writeWordSpace(){  
  digitalWrite(ledPin, LOW);    // sets the LED off
  delay(wordSpace);  
}

//----------------------------------------------------------------- END PRIMATIVES

//------------------------------------------------------------ writeLetter()
// there are case statements in Arduino. We'll use them in the next
// class to handle serial strings 
void writeLetter(char letter) {
  if (letter == 'S') {
    writeDash();
    writeDash();
    writeDash();
    writeLetterSpace();
  } 
  else if (letter == 'O') {
    writeDot();
    writeDot();
    writeDot();
    writeLetterSpace();
  } 
  else {
    writeWordSpace();  
  }
}


