/*
This code is heavily based on the example to the servo library included 
with the Arduino environment with a few modifications because of the the circuit
and includes moving the servo control into a seperate function

This version was for Class 2 of the Arduino for Programmers course taught at CRASH Space
in October, 2010. 


The Circuit:
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * (Not Used as Written) Analog Pin 0: Flex Sensor
 * Analog Pin 1: Potentiometer  

  The circuit has both types of sensors so folks can see how satifying it is 
  to have movement that begets movement. 
  
The Behavior:
 Servo moves with the movement of the attached sensor. Same as before. 
 
 Written By: Michal Rinott as an example for the library
 Updated by: Carlyn Maw to add servo subfunction //various comments
 Updated: Nov 1 2010

*/

//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <Servo.h> 

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES
int potpin = 1;   // analog pin used to connect the potentiometer
int val;          // variable to read the value from the analog pin 

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
Servo myservo;  // create servo object to control a servo 
int servoPin = 11;

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{ 
  //SETUP STEP ONE: Attach servo
  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
} 

//------------------------------------------------------------------ START MAIN LOOP
void loop() 
{ 
  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  
   //LOOP: STEP TWO, DO SOMETHING ABOUT IT
  // myservo.write(val);               // REMOVED
  servoGoTo(myservo, val);             // ADDED

  delay(15);                           // waits for the servo to get there 
} 


//------------------------------------------------------------------ END MAIN LOOP

//---------------------------------------------------------------------- servoGoTo


void servoGoTo(Servo aServo, int location) {  //NEW FUNCTION!!
  aServo.write(location); 
}

