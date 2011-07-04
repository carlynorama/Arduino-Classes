/*
This code moves away from the included Servo Library example because it
shows how to control the motor by stepping through an array.

This version was for Class 2 of the Arduino for Programmers course taught at CRASH Space
in October, 2010. 


The Circuit:
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * (Not Used as Written) Analog Pin 0: Flex Sensor


  The circuit has both types of sensors so folks can see how satifying it is 
  to have movement that begets movement. 
  
The Behavior:
 Servo moves from to position to position to postition as determined by values stored in an
 array. 

 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010

*/

//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <Servo.h> 

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES -- REMOVED!
//int potpin = 1;   // analog pin used to connect the potentiometer
//int val;          // variable to read the value from the analog pin 

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
Servo myservo;  // create servo object to control a servo 
int servoPin = 11;


const int lengthOfSequence = 10; // NEW, how many postions in my routine

byte activeSequence[lengthOfSequence]= {  //NEW, the postions in the routine
  100,78,120,36,49,25,96,27,83,79 } 
;

int servoArrayIndex = 0; //NEW, where am I in the array global index

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{ 
  //SETUP STEP ONE: Attach servo
  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
} 

//------------------------------------------------------------------ START MAIN LOOP
void loop() 
{ 
  //LOOP: STEP ONE, POLL THE ENVIRONMENT -- REMOVED!
  //val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  //val = map(val, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  
  //LOOP: STEP ONE, GET MY NEXT SERVO LOCATION
  if (servoArrayIndex <= lengthOfSequence) {  
    servoArrayIndex++; 
  } 
  else { 
    servoArrayIndex = 0; 
  }
  
  //LOOP: STEP TWO, GO TO IT.
  servoGoTo(myservo, activeSequence[servoArrayIndex]);    // CHANGED

  delay(115);                          // CHANGED, longer because going further
                                       //waits for the servo to get there 
} 


//------------------------------------------------------------------ END MAIN LOOP

//---------------------------------------------------------------------- servoGoTo


void servoGoTo(Servo aServo, int location) {
  aServo.write(location); 
}

