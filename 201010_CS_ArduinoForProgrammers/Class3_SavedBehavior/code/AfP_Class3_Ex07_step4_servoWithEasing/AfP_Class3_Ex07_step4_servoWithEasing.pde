/*
This code shows some more if statements, and the idea of easing in movement control
 
 This version was for Class 2 of the Arduino for Programmers course taught at CRASH Space
 in October, 2010. 
 
 
 The Circuit:
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * (Not Used as Written) Analog Pin 0: Flex Sensor

 
 The circuit has both types of sensors so folks can see how satifying it is 
 to have movement that begets movement. 
 
 The Behavior:
 Servo from position to postion as indicated by an array... in hopefully a 
 more fluid manner than the examples before it. 
 
 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <Servo.h> 

//DEFINE: STEP TWO, SYSTEM GLOBALS
const int baudRate = 9600;
boolean debugFlag = true;

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
Servo myservo;  // create servo object to control a servo 
int servoPin = 11;

byte lastServoLoc;
byte currentServoLoc;
byte destinationServoLoc;
//byte departureServoLoc;

boolean arrived;
const int servoSnapTo = 1;
const int servoAcceleration = 2;


const int lengthOfSequence = 10; 

byte activeSequence[lengthOfSequence]= { 
  100,12,120,36,149,25,176,27,143,79 } 
;

int servoArrayIndex = 0; 

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{ 
  //SETUP STEP ONE: Attach hardware objects
  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
  Serial.begin(baudRate);

  //SETUP STEP TWO: OUTPUTS TO START CONDITIONS
  destinationServoLoc = activeSequence[0]; 
  myservo.write(0);
  currentServoLoc = 0;
  arrived = false;
} 

//------------------------------------------------------------------ START MAIN LOOP
void loop() 
{ 

  //LOOP: STEP ONE, SAVE LAST POS 
  lastServoLoc = currentServoLoc; //just like the buttonState tracking. 


  //LOOP: STEP TWO, IF I'VE ARRIVED GET MY NEXT SERVO LOCATION //--- CHANGED!!
  if (arrived) { //-------------- NEW
    if (servoArrayIndex <= lengthOfSequence) { 
      servoArrayIndex++; 
    } 
    else { 
      servoArrayIndex = 0; 
    } 
    //departureServoLoc = destinationServoLoc;       //can use later if need to
    destinationServoLoc = activeSequence[servoArrayIndex];  //------- NEW
    arrived = false;                                 //-------------- NEW
    if (debugFlag) {                                 //-------------- NEW
      Serial.print("New Desination: ");              //-------------- NEW
      Serial.println(destinationServoLoc, DEC);      //-------------- NEW
    }
  } 
  else {                                          
    if (debugFlag) Serial.println("not yet");        //-------------- NEW
  }

  //LOOP: STEP THREE, MOVE AND RETURN WEHRE I AM NOW
  currentServoLoc = servoEaseTo(myservo, currentServoLoc, destinationServoLoc);

  //___NEED___ EITHER THE DELAY or the debugs! 
  if (debugFlag) {
    Serial.print("Current Location: ");
    Serial.println(currentServoLoc, DEC);
  } 
  else {
    //moved this out of the function b/c I hate delays in functions.
    //again the 2 and the 10 may be values you want to give names to and
    // put at the top.  
    delay(abs(currentServoLoc-destinationServoLoc)*2+10);
  }
  
  //check to see is where you are is where you need to be. 
  if (currentServoLoc == destinationServoLoc)    //yet another way to if
    arrived = true;

} 


//------------------------------------------------------------------ END MAIN LOOP

//-------------------------------------------------------------------- servoEaseTo

//move the server to new Loaction from oldLocation  ------------------------- NEW
byte servoEaseTo(Servo aServo, int currentLocation, int targetLocation) {
  int locDiff = (targetLocation - currentLocation);
  int movedToLocation = currentLocation + (locDiff)/servoAcceleration;
  if  (abs(movedToLocation-targetLocation) <= servoSnapTo) {
    movedToLocation = targetLocation;
  }
  aServo.write(movedToLocation);
  return movedToLocation;
}

//---------------------------------------------------------------------- servoGoTo

//move to new location at full speed  ------------------------------------ CHANGED
boolean servoGoTo(Servo aServo, int newLocation) {
  aServo.write(newLocation);
  return true;
}





