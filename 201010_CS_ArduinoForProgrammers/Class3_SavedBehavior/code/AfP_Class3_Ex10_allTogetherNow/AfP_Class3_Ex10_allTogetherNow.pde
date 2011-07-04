/*
  This code starts to combine multiple things we've done in this class,
 * OnPress control of mode
 * blinking without delay while something else is going on
 * Servo Control
 And now... recording!!
 TO EEPROM!
 
 This version was for Class 2 of the Arduino for Programmers course taught at
 CRASH Space in October, 2010. 
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
 (LOW = pressed)
 * Pin 3: momentary button attached, pulled high externally w/ 10k Ohm resistor
 (LOW = pressed)
 * Pin 9: LED, anode to microcontroller, 330 Ohm resistor from cathode to ground
 * Pin 11: Hobby Servo (moved from pin 9 in example code) (see ardx.org/CIRC04)
 * Pin 13: LED, the one that comes on the board. 
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer 
 
 The Behavior:
 When the button is pressed the servo follows the behavior of the sensor. When 
 the button is pressed again it returns to moving from position to position in 
 the recorded array. A second button can be pressed to save the most recent
 recording to eeprom. The arduino will start up playing that pattern the next
 time it boots.
 
 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010
 
 */


//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
#include <Servo.h>

boolean debugFlag = 0;      //controls serial printing of debug statement
int baudRate = 9600;        //just needs to agree with what is listening to you

int runFlag = 0;   //start in playback mode.                      


unsigned long lastMillis= 0;
unsigned long currentMillis = 0;      

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

//-------------------------------------- ANALOG SENSOR
const int sensorPin = A1;  //The Potentiometer
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading


//-------------------------------------------- BUTTONS
const int pushButtonOnePin = 2;    //play/record
int pushButtonOneState = 0;
int lastPushButtonOneState = 0;     
int pushButtonOneTrue = 0;


const int pushButtonTwoPin = 3;    //save to eeprom
int pushButtonTwoState = 0;
int lastPushButtonTwoState = 0;  
int pushButtonTwoTrue = 0;

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


const int lengthOfSequence = 200; 

//just somewhere to start...
byte activeSequenceArray[lengthOfSequence]= { 
  100,12,120,36,149,25,176,27,143,79,100,12,120,36,149,25,176,27,143,79,100,12,120,36,149,25,176,27,143,79,100,12,120,36,149,25,176,27,143,79 } 
;

int servoArrayIndex = 0; 

//--------------------------------------------- LED

const int statusLED = 13;
const int ledPin = 9;

//led timing variables  
int blinkOnPeriod = 200;
int blinkState;
long blinkFlipTime;


//DEFINE: STEP FOUR, SAMPLING VARIABLES
int samplePeriod = 35; // how often.....

const int sampleMaxNumber = lengthOfSequence;
int sampleIndex= 0;                     //what sample number am I on.
boolean samplingBufferFullFlag = false; //have i reached the end of the buffer?

int sampleState;           //am I taking recording right now?
long sampleFlipTime;       //knows the last time it changed

//DEFINE: STEP THREE, eeprom handling

//location in memory where the eeprom will start recording
const int sequenceEEPROMStartAddress = 20; 
//location in memory where the eeprom will end recording
const int sequenceEEPROMEndAddress = sequenceEEPROMStartAddress + lengthOfSequence - 1;

//an older way of determining maxBufferSize
//const int maxBufferSize = abs(sequenceEEPROMEndAddress-sequenceEEPROMStartAddress)+1; 
//maxBufferSize - the longest the recording can be. In our case the ONLY length.
const int maxBufferSize = lengthOfSequence; 

//buffer that mirrors eeprom
byte eepromCacheArray[maxBufferSize];


//------------------------------------------------------------------ START SETUP LOOP
void setup() 
{  
  //SETUP STEP ONE: Attach Serial
  Serial.begin(baudRate);

  //SETUP STEP TWO: LED OUTPUTS & STARTING CONDTIONS
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);
  pinMode(statusLED, OUTPUT);
  digitalWrite(statusLED, LOW);

  //SETUP STEP THREE: Load eeprom into cache and active arrays
  digitalWrite(statusLED, HIGH);
  eepromLoadIntoArray(sequenceEEPROMStartAddress, sequenceEEPROMEndAddress, eepromCacheArray, maxBufferSize);
  cache2active(); //in eeprom handling
  digitalWrite(statusLED, LOW);

  //SETUP STEP FOUR: DECLARE INPUTS & STARTING CONDTIONS
  pinMode(pushButtonOnePin, INPUT);
  pinMode(pushButtonTwoPin, INPUT);
  digitalWrite(pushButtonTwoPin, HIGH);

  //SETUP STEP FIVE: SERVO SETUP & STARTING CONDTION
  myservo.attach(servoPin);  // attaches the servo on pin 11 to the servo object);
  destinationServoLoc = activeSequenceArray[0]; 
  myservo.write(0);
  currentServoLoc = 0;
  arrived = false;


}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes the time

  //LOOP: STEP TWO, SAVE AND UPDATE BUTTONS
  lastPushButtonOneState = pushButtonOneState;  // dumps the button State from the last loop into previous holder
  pushButtonOneState = digitalRead(pushButtonOnePin); // refreshes the button state
  
  lastPushButtonTwoState = pushButtonTwoState;  // dumps the button State from the last loop into previous holder
  pushButtonTwoState = digitalRead(pushButtonTwoPin); // refreshes the button state

  if (pushButtonTwoState != lastPushButtonTwoState && pushButtonTwoState == pushButtonTwoTrue) {
    digitalWrite(statusLED, HIGH);
    Serial.println("Saving To EEPROM");
    eepromSaveAndReloadCache(activeSequenceArray, maxBufferSize, sequenceEEPROMStartAddress, sequenceEEPROMEndAddress, eepromCacheArray);
    digitalWrite(statusLED, LOW);
  }

  //LOOP: STEP THREE, WHAT MODE SHOULD I BE IN?
  if (pushButtonOneState != lastPushButtonOneState && pushButtonOneState == pushButtonOneTrue) {
    runFlag ? runFlag=false : runFlag=true;
  }




  //LOOP: STEP THREE, IF IN RECORD MODE...
  if (runFlag == true) {
    arrived = false;
    servoArrayIndex= 0;
    if (samplingBufferFullFlag == false) {
      samplingBufferFullFlag = liveCapture(sensorPin, ledPin);
      if (!debugFlag) delay(15); // waits for the servo to get there
    } 
    else {
      digitalWrite(ledPin, HIGH);
      sampleIndex = 0;
    }
  } 
  //LOOP: STEP FOUR, ELSE IF IN PLAY BACK MODE... 
  else { 
    digitalWrite(ledPin, LOW); 
    samplingBufferFullFlag = 0;   
    if (arrived) {
      if (servoArrayIndex <= lengthOfSequence) { 
        servoArrayIndex++; 
      } 
      else { 
        servoArrayIndex = 0; 
      } 
      //departureServoLoc = destinationServoLoc;
      destinationServoLoc = activeSequenceArray[servoArrayIndex]; 
      arrived = false;
      if (debugFlag) {
        Serial.print("New Desination: "); 
        Serial.println(destinationServoLoc, DEC); 
      }
    } 
    else {
      if (debugFlag) Serial.println("not yet");
    }


    currentServoLoc = servoEaseTo(myservo, currentServoLoc, destinationServoLoc);
    //___NEED___ EITHER THE DELAY or the debugs! 
    if (debugFlag == false) { 
      delay(abs(currentServoLoc-destinationServoLoc)*2+10);
    } 
    else {
      Serial.print("Current Servo Postition: ");
      Serial.println(currentServoLoc, DEC);
    }

    if (currentServoLoc == destinationServoLoc)
      arrived = true;
  }
  // ---- END PLAY MODE
}


//------------------------------------------------------------------ END MAIN LOOP


///----------------------------------------------------------------- BASIC blinkIt

void blinkIt(int myLED) {
  if ((blinkOnPeriod) < (currentMillis- blinkFlipTime)) {
    blinkState ? blinkState=false : blinkState=true;
    blinkFlipTime = currentMillis;       
  }
  //(moving this line outside the if is what makes it update every time)
  digitalWrite(myLED,blinkState); 
}

///------------------------------------------------------------------ liveCapture
boolean liveCapture(int mySensorPin, int myStatusLED) {
  sensorValue = analogRead(mySensorPin);            // reads the value of the potentiometer (value between 0 and 1023) 
  byte servoCompressedSensorValue = map(sensorValue, 0, 1023, 0, 179);     // scale it to use it with the servo (value between 0 and 180) 
  servoGoTo(myservo, servoCompressedSensorValue);
  boolean sampleFullFlag = saveSample(servoCompressedSensorValue, samplePeriod, activeSequenceArray, lengthOfSequence, myStatusLED);
  return sampleFullFlag;
}

//------------------------------------------------------------------- saveSample

int saveSample(byte sampleValue, int mySamplePeriod, byte * destinationArray, int arrayLength, int myLED) {
  boolean done = false;
  //if the difference between the last time I flipped and the
  //current time is longer than the mySamplePeriod parameter
  //passed to me then...
  //divide by two b/c the LED is on for half the period
  if ((mySamplePeriod/2) < (currentMillis- sampleFlipTime)) {

    //flip me. google "question mark syntax c"
    if (sampleState)  {
      //take reading
      if (debugFlag) { 
        Serial.println(); 
        Serial.print("sampleIndex\t"); 
        Serial.println(sampleIndex,DEC);
      }
      destinationArray[sampleIndex] = sampleValue;
      sampleIndex ++;
      sampleState=false;

      if (sampleIndex >= arrayLength)  {            
        if (debugFlag) arrayPrintAll(destinationArray, arrayLength);
        done = true;
      } 
      else {
        done = false;
      }      

    }
    else {
      sampleState=true;
    }


    //update the sampleFlipTime with the current time.
    sampleFlipTime = currentMillis;       
  }

  digitalWrite(myLED,sampleState);
  return done; 
}

///------------------------------------------------------ START SERVO FUNCTIONS
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

///---------------------------------------------------------------- servoEaseTo
//move the server to new location from old location with ease motion
byte servoEaseTo(Servo aServo, int currentLocation, int targetLocation) {
  int locDiff = (targetLocation - currentLocation);
  int movedToLocation = currentLocation + (locDiff)/servoAcceleration;
  if  (abs(movedToLocation-targetLocation) <= servoSnapTo) {
    movedToLocation = targetLocation;
  }
  aServo.write(movedToLocation);
  return movedToLocation;
}


