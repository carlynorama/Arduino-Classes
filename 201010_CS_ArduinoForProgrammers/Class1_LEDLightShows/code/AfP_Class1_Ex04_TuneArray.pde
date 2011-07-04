/*

 This is code to demonstrates the use of arrays and for loops in arduino. 
 It shows multiple arrays working together to create a complex pattern
 of behavior.
 
 This version was for Class 1 of the Arduino for Programmers course taught
 at CRASH Space in October 2010 based on code in Class 4 (ex 1-3b) of the 
 Intro to Arduino class at Machine Project in April. 
 
 Available: 
 http://23longacre.com/sharedFiles/code/arduino/201004_MP_IntroToArduino/
 
 It is called play a "tune" because it introduces the idea of behavior
 envelopes. (like with the letters in morse code how do you know there is
 a change if the same LED is played twice? Do you want to?) 
 
 More here:
 http://en.wikipedia.org/wiki/ADSR_envelope
 
 * Attack time 
 * Decay time
 * Sustain level
 * Release time
 
 
 The Circuit:
 * Pin 9: LED, anode to arduino, 330 Ohm resistor from cathode to ground
 * Pin 8: LED, anode to arduino, 330 Ohm resistor from cathode to ground
 * Pin 7: LED, anode to arduino, 330 Ohm resistor from cathode to ground
 * Pin 6: LED, anode to arduino, 330 Ohm resistor from cathode to ground
 * Pin 5: LED, anode to arduino, 330 Ohm resistor from cathode to ground
 
  _________
 |	       |
 | Arduino |
 |  	   |    LED     330 Ohm
 |  	 9 |----(>|)----/\/\/\----|l> GND
 |  	   |
 |  	   |    LED     330 Ohm
 |  	 8 |----(>|)----/\/\/\----|l> GND
 |  	   |
 |  	   |    LED     330 Ohm
 |  	 7 |----(>|)----/\/\/\----|l> GND
 |  	   |
 |  	   |    LED     330 Ohm
 |  	 6 |----(>|)----/\/\/\----|l> GND
 |  	   |
 |  	   |    LED     330 Ohm
 |  	 5 |----(>|)----/\/\/\----|l> GND
 |_________|   
 
 The Behavior:
    5 LEDs "play a tune" that is 22 "notes" long.
    Loops indefinately with no pause. Like with morse code example
    speed is hard coded at the begining with variables that are dependant
    on each other.
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, OUTPUTS AND THEIR VARIABLES

//number of leds, must be a constant because it will
//be an array length. 
const int numberOfLEDs = 5;

//an array that holds the LED what we're going to use.
//better that using them individually in the tune order
//array b/c then they can updated just here if the circuit changes.
int ledPinArray[numberOfLEDs] = { 
  9,8,7,6,5 } 
;


//DEFINE: STEP TWO, WHAT ARE OUR PATTERNS

// like dots and dashes in Morese Code example
// these will become time periods in ms. 
const int note = 1000;
const int h_note = note/2;
const int q_note = note/4;

//length of tune in terms of number of notes, NOT TIME
//will use this later in for loops
const int tuneLength = 25;

//list of LEDs in sequence
//zero becomes our null value for all off. 
//Keep in mind this means you CAN'T USE PIN 0!!!
int ledSequence[tuneLength] =  {
  ledPinArray[0],   
  ledPinArray[1], 
  ledPinArray[2],  
  ledPinArray[0],  
  ledPinArray[1],  
  ledPinArray[2],  
  ledPinArray[0],  
  ledPinArray[1],  
  ledPinArray[2],  
  ledPinArray[0],  
  ledPinArray[4],  
  ledPinArray[0], 
  ledPinArray[3],  
  ledPinArray[0], 
  ledPinArray[2], 
  ledPinArray[0], 
  ledPinArray[1], 
  ledPinArray[4], 
  ledPinArray[3], 
  ledPinArray[2], 
  ledPinArray[1], 
  ledPinArray[0],
  0, 
  ledPinArray[0],
  0};

//The amount of time each LED is lit
int timeSequence[tuneLength] =   {
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  q_note, 
  h_note, 
  q_note, 
  h_note, 
  q_note, 
  h_note, 
  q_note, 
  h_note, 
  q_note, 
  h_note, 
  q_note,
  q_note,
  q_note,
  q_note,  
  q_note,
  q_note,
  q_note};


//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Set digital pin modes & original condition.
  //another reason why it is nice to have pins in an array....
  for (int l = 0; l < numberOfLEDs ; l++) {
    pinMode(l, OUTPUT);
    digitalWrite(l, LOW);
  }
}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {      


  //----------------------------------------------------------- Play the tune. 
   
  // ----- for as many times as there are notes in the tuneLength variable
  //       where "b" is the stand in for the note we're on
  // ---------- if ledSequence[b] is a value greater than 0
  // --------------- light the led on the pin equal to the value retrieved.
  // --------------- for the amount of time at timeSequence[b]
  // --------------- then turn it off.  
  // ---------- otherwise, if ledSequence[b] is 0
  // --------------- then turn everybody off.
  // --------------- for the amount of time at timeSequence[b]
  
  
  for (int b = 0;  b < tuneLength ; b ++) {   
    if (ledSequence[b] > 0) { 
      digitalWrite(ledSequence[b], HIGH);
      delay(timeSequence[b]);
      digitalWrite(ledSequence[b], LOW);
    } 
    else {       
      for  (int l = 0; l < numberOfLEDs ; l++) {
        digitalWrite(l, LOW);
      }
      delay(timeSequence[b]);
    }
  }

} 

//--------------------------------------------------------------- END MAIN LOOP

