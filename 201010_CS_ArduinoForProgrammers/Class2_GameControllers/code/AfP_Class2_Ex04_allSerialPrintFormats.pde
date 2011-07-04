/*
 This code demonstrates the different options for Serial.print before
 transitioning to code examples which talk to other code examples rather 
 than just using serial to send debug messages to people.

 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010. Except for some of the comments,
 it is taken pretty much directly from:
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 The Circuit:
  * (Not Used) Pin 2: momentary button
  * (Not Used) Pin 9: LED, anode to microcontroller
  * Analog Pin 0: Flex Sensor (optional, not in code as written)
  * Analog Pin 1: Potentiometer  
  
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 The Behavior
 When the user runs the program and opens the Serial Monitor they will
 see a table. The current value being read off of the analogPin is 
 shown on the screen as its ASCII equivalent, and then its binary, 
 decimal, hexidecmal and octal ASCII encoded notations. 
 
 From wikipedia's aricle on numbers "Numbers should be distinguished 
 from numerals, the symbols used to represent numbers. " i.e. there is
 the concept of a certain quantity and then we have different ways of
 talking about it ( III, 3, 11, "I'm this many!")
 
 Largely the work of Tom Igoe 2008/2009
 Updated: Carlyn Maw
 Updated On: October 23 2010

*/ 
//No debugflag, no global status vars

//DEFINE: STEP ONE, INPUTS AND THEIR VARIABLES
const int analogPin = 1;            // pot is on 1, flex is on 0 
int analogValue = 0;                // sensor reading goes into this variable

 void setup() {
   // open serial communications at 9600 bps
   Serial.begin(9600);
 }

 void loop() {
   // read the analog input, divide by 4 in order to bring it within byte range
   // i.e. 1023/4 = 255
   // how will you want to change this for use with the flex sensor?
   analogValue = analogRead(analogPin) /4;

   // print in many formats:
   Serial.print(analogValue, BYTE);     // Print the raw binary value analogValue
   Serial.print('\t');                  // print a tab
                                        // could also use Serial.print(9, BYTE);
                                        // or Serial.write(9);
   
   Serial.print(analogValue, BIN);      // print the ASCII encoded binary analogValue
   Serial.print('\t');                  // print a tab
   
   Serial.print(analogValue, DEC);      // print the ASCII encoded decimal analogValue
   Serial.print('\t');                  // print a tab
   
   Serial.print(analogValue, HEX);      // print the ASCII encoded hexadecimal analogValue
   Serial.print('\t');                  // print a tab
   
   Serial.print(analogValue, OCT);      // print the ASCII encoded octal analogValue
   Serial.println();                    // prints carriage return and a line feed after 
                                        // whatever is in the parens. 
                                        // same as Serial.print('\n\r');
    

   delay(10);                           //so it goes closer to people speed
 }
