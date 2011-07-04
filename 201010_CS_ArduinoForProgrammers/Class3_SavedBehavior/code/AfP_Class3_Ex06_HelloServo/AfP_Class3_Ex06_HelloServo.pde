/*
This code is the introduction to the servo library included with the Arduino
environment with a few modifications because of the the circuit.  This version was for 
 Class 2 of the Arduino for Programmers course taught at CRASH Space in October, 
 2010. 


The Circuit:
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * (Not Used as Written) Analog Pin 0: Flex Sensor
 * Analog Pin 1: Potentiometer  

  The circuit has both types of sensors so folks can see how satifying it is 
  to have movement that begets movement. 
  
The Behavior:
 Servo moves with the movement of the attached sensor.

*/

// Controlling a servo position using a potentiometer (variable resistor) 
// by Michal Rinott <http://people.interaction-ivrea.it/m.rinott> 

#include <Servo.h> 
 
Servo myservo;  // create servo object to control a servo 
 
int potpin = 1;  // analog pin used to connect the potentiometer
int val;    // variable to read the value from the analog pin 
 
void setup() 
{ 
  myservo.attach(11);  // attaches the servo on pin 9 to the servo object 
} 
 
void loop() 
{ 
  val = analogRead(potpin);            // reads the value of the potentiometer (value between 0 and 1023) 
  val = map(val, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  myservo.write(val);                  // sets the servo position according to the scaled value 
  delay(15);                           // waits for the servo to get there 
} 
