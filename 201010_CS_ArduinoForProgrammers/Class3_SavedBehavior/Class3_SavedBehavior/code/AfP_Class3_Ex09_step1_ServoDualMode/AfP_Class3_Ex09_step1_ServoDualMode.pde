/*
  This code starts to combine multiple things we've done in class,
      * OnPress control of mode
      * blinking without delay while something else is going on
      * Servo Control
  It doesn't record... yet
 
 This version was for Class 2 of the Arduino for Programmers course taught at
  CRASH Space in October, 2010. 
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
 (LOW = pressed)
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer 
 
 The Behavior:
 When the button is pressed the Servo follows the behavior of the sensor. When 
 the button is pressed again it returns to moving from position to position in 
 the hard coded array.
 
 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010
 
 */


//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
#include <Servo.h>

boolean debugFlag = 0;      //controls serial printing of d//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
#include <Servo.h>

boolean debugFlag = 0;      //controls serial printing of debug statement
int baudRate = 9600;        //just needs to agree with what is listening to you

int runFlag = 0;                      


unsigned long lastMillis= 0;
unsigned long currentMillis = 0;      

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

//-------------------------------------- ANALOG SENSOR
const int sensorPin = A1;  //The Potentiometer
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading


//--------------------------------------------- BUTTON
const int pushButtonPin = 2;    //the push button
int pushButtonState = 0;
int lastPushButtonState = 0;     


//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES

//--------------------------------------------- SERVO 
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

//--------------------------------------------- LED

const int ledPin = 9;

//led timing variables  
int blinkOnPeriod = 200;
int blinkState;
long blinkFlipTime;


ebug statement
int baudRate = 9600;        //just needs to agree with what is listening to you

int runFlag = 0;                      


unsigned long lastMillis= 0;
unsigned long currentMillis = 0;      

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

//-------------------------------------- ANALOG SENSOR
const int sensorPin = A1;  //The Potentiometer
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading


//--------------------------------------------- BUTTON
const int pushButtonPin = 2;    //the push button
int pushButtonState = 0;
int lastPushButtonState = 0;     


//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES

//--------------------------------------------- SERVO 
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

//--------------------------------------------- LED

const int ledPin = 9;

//led timing variables  
int blinkOnPeriod = 200;
int blinkState;
long blinkFlipTime;



//------------------------------------------------------------------ START SETUP LOOP
void setup() 
{  
  //SETUP STEP ONE: Attach Serial
  Serial.begin(baudRate);

  //SETUP STEP TWO: DECLARE INPUTS & STARTING CONDTIONS
  pinMode(pushButtonPin, INPUT);


  //SETUP STEP THREE: DECLARE OUTPUTS & STARTING CONDTIONS
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);

  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
  destinationServoLoc = activeSequence[0]; 
  myservo.write(0);
  currentServoLoc = 0;
  arrived = false;
}
//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes the time

  //LOOP: STEP TWO, SAVE AND UPDATE BUTTON
  lastPushButtonState = pushButtonState;  // dumps the buttpn State from the last loop into previous holder
  pushButtonState = digitalRead(pushButtonPin); // refreshes the button state

  //LOOP: STEP THREE, WHAT MODE SHOULD I BE IN?
  if (pushButtonState != lastPushButtonState && pushButtonState == HIGH) {
    runFlag ? runFlag=false : runFlag=true;
  }


  //LOOP: STEP THREE, IF IN RECORD MODE... 
  if (runFlag == true) {
    arrived = false;      //reset arrived
    blinkIt(ledPin);      //blink the led as a ui feature
    liveCapture();        //live capture: just moves the servo with the pot, for now.
    delay(15);            //live capture has a servoGoTo in it... needs a tiny delay
  } 
  //LOOP: STEP FOUR, ELSE IF IN PLAY BACK MODE... 
  else {    
    digitalWrite(ledPin, LOW); 
    blinkState = false;           
    blinkFlipTime = currentMillis - blinkOnPeriod;

    if (arrived) {
      if (servoArrayIndex <= lengthOfSequence) { 
        servoArrayIndex++; 
      } 
      else { 
        servoArrayIndex = 0; 
      } 
      //departureServoLoc = destinationServoLoc;
      destinationServoLoc = activeSequence[servoArrayIndex]; 
      arrived = false;
      if (debugFlag) {                               
        Serial.print("New Desination: ");              
        Serial.println(destinationServoLoc, DEC);      
      }

    } 
    else {
      if (debugFlag) Serial.println("not yet");
    }


    //move and then tell me where I am. 
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
}


//---------------------------------------------------------- END MAIN LOOP


///--------------------------------------------------------- BASIC blinkIt

void blinkIt(int myLED) {
  if ((blinkOnPeriod) < (currentMillis- blinkFlipTime)) {
    blinkState ? blinkState=false : blinkState=true;
    blinkFlipTime = currentMillis;       
  }
  //(moving this line outside the if is what makes it update every time)
  digitalWrite(myLED,blinkState); 
}

///----------------------------------------------------------- liveCapture
void liveCapture() {
  sensorValue = analogRead(sensorPin);            // reads the value of the potentiometer (value between 0 and 1023) 
  byte servoCompressedSensorValue = map(sensorValue, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  servoGoTo(myservo, servoCompressedSensorValue);
  // waits for the servo to get there
}

///------------------------------------------------- START SERVO FUNCTIONS
///------------------------------------------------------------- servoGoTo
//move the server to new Loaction from oldLocation
void servoGoTo(Servo aServo, int newLocation, int oldLocation) {
  aServo.write(newLocation); 
  //the two and the 4 are things you might at somepoint want
  //control of from the top of the code
  int delayFactor = abs(oldLocation - newLocation)*2 + 40;
  delay(delayFactor);              // waits for the servo to get there
  //THE SUPER EVIL DELAY IN FUNTION!!!
}

//move to new location at full speed
void servoGoTo(Servo aServo, int newLocation) {
  aServo.write(newLocation);
}

///----------------------------------------------------------- servoEaseTo
//move the server to new Loaction from oldLocation
byte servoEaseTo(Servo aServo, int currentLocation, int targetLocation) {
  int locDiff = (targetLocation - currentLocation);
  int movedToLocation = currentLocation + (locDiff)/servoAcceleration;
  if  (abs(movedToLocation-targetLocation) <= servoSnapTo) {
    movedToLocation = targetLocation;
  }
  aServo.write(movedToLocation);
  return movedToLocation;
}






