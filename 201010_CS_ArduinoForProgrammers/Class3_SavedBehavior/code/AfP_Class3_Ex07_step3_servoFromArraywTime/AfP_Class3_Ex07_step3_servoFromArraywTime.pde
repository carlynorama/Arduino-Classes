/*
 This code shows controlling an servo motor from a prestored array with a time delay
 dependent on the distance the servo has to travel. 
 
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
 
 */

//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <Servo.h> 

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
Servo myservo;  // create servo object to control a servo 
int servoPin = 11;


const int lengthOfSequence = 10; 

byte activeSequence[lengthOfSequence]= { 
  100,78,120,36,49,25,96,27,83,79 } 
;

int servoArrayIndex = 0; 

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{ 
  //SETUP STEP ONE: Attach servo
  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
} 

//------------------------------------------------------------------ START MAIN LOOP
void loop() 
{ 

  //LOOP: STEP ONE, SAVE LAST POS -- NEW
  lastServoLoc = currentServoLoc; //just like the buttonState tracking. 


  //LOOP: STEP TWO, GET MY NEXT SERVO LOCATION
  if (servoArrayIndex <= lengthOfSequence) { 
    servoArrayIndex++; 
  } 
  else { 
    servoArrayIndex = 0; 
  }
  
  currentServoLoc = activeSequence[servoArrayIndex]; //NEW

  //LOOP: STEP THREE, GO TO IT.
  servoGoTo(myservo, currentServoLoc, lastServoLoc); //CHANGED 

  //delay(115);                          // CHANGED AND MOVED
} 


//------------------------------------------------------------------ END MAIN LOOP

//---------------------------------------------------------------------- servoGoTo

//move the server to new Loaction from oldLocation ----------------- NEW
void servoGoTo(Servo aServo, int newLocation, int oldLocation) {
  aServo.write(location); 
  //the delay it waits to get the next value is now dependant on the
  //distance it needs to go.
  //the two and the 40 are things you might at somepoint want
  //control of from the top of the code
  delayFactor = abs(oldLocation - newLocation)*2 + 40;
  delay(delayFactor);    // waits for the servo to get there
  //THE SUPER EVIL DELAY IN FUNTION!!!
}

//move to new location at full speed
void servoGoTo(Servo aServo, int newLocation) {
  aServo.write(location);
}


