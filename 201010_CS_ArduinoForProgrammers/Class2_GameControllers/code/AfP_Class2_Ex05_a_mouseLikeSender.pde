/*
  
 This code reads two analog inputs and one digital input
 and outputs their values via serial to be read by a processing example.
 It is an examplar of using grammar as way to keep your 
 communication protocols clear.
 
 Processing Example is called
 AfP_Class2_Ex05_p_mouseLikeReciever
 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010. Except for the comments,
 it is taken pretty much directly from:
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed) NOTE!! The circuit for this on the example site is the 
   opposite of this. How will it change the behavior of the two sketches when they
   are put together?
 * (Not Used) Pin 9: LED, anode to microcontroller
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 Largely the work of Tom Igoe 2008/2009
 Updated: Carlyn Maw
 Updated On: October 23 2010
 
 Notes by Carlyn Maw for the Arduino for Programmers Class
 Highligted by 
 //----------------------------------------------------  AfP Note!
 
 */

//----------------------------------------------------  AfP Note!
// NOTE: Can just set the pins b/c this code never knows what 
// it's doing. If it wasn't so simple you might consider using 
// the Firmata Library when you just need an Arduino-As-Zombie.

int analogOne = 0;       // analog input 
int analogTwo = 1;       // analog input 
int digitalOne = 2;      // digital input 

int sensorValue = 0;     // reading from the sensor

void setup() {
  // configure the serial connection:
  Serial.begin(9600);  // is matched in processing

  // configure the digital input:
  pinMode(digitalOne, INPUT);
}

void loop() {
  // read the sensor:
  sensorValue = analogRead(analogOne);
   //----------------------------------------------------  AfP Note!
  //This is the flex sensor on our circit
  //so I'm going to range it on this end so the
  //processing stays "device independant"
  //keeping hardware issues with the hardware 
  //when you can is a good idea if you aren't 
  //going to take too much of a performance hit
  //on it.
  //good suggestion Matt
  
  //----------------------------------------------- AfP addition:
  
  //tighten it up to the sensor's most common range
  sensorValue = constrain(sensorValue, 110, 310);
  
  //map it to the software's expected range
  //(no way to know what the software's expected range
  //is, it isn't some given, YOU decide. In this case
  //it just wants the whole
  sensorValue = map(sensorValue, 110, 310, 0, 1023);
 
  //---------------------------------------------- END AfP addition
  
  // print the results:
  Serial.print(sensorValue, DEC);
  Serial.print(","); 
  //----------------------------------------------------  AfP Note!
  //NOTE: Remember that a comma is picked for 
  //our comfort. From a machine's point of view 
  //any non-numeric character would have done the job
  //Like with the baud rate, the receiver just need to have 
  //the same protocol definitions
  
  //QUESTION: What ADVANTAGE does sending these
  //values as DEC rather than BYTE confer as a protocol
  //redundance measure?

  // read the sensor:
  sensorValue = analogRead(analogTwo);
  // print the results:
  Serial.print(sensorValue, DEC);
  Serial.print(",");

  // read the sensor:
  sensorValue = digitalRead(digitalOne);
  // print the last sensor value with a println() so that
  // each set of four readings prints on a line by itself:
  Serial.println(sensorValue, DEC);
  
  //----------------------------------------------------  AfP Note!
  //NOTE: The println at the end gives us two non-numerics as
  //end of line delimeters. again, its nice for people for
  //it be someting as visual as line breaks
}

