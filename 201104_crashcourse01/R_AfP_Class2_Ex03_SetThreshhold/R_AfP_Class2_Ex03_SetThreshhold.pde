/*
 This code to demonstrates capturing a sensor reading on a button release. 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010 based on code in Class 3 (ex 8) of 
 the Intro to Arduino class at Machine Project in April. 
 
 The class was based on the SparkFun Arduino Iventors Kit
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed)
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 The Behavior:
 If the analogReadPin is set to one, LED blinks faster as the potentiometer is 
 turned. If it is below a threshold defined by the int variable thresholdValue
 it blinks calmly on the board. The sensor readings exceed that value the LED on 
 Pin 9 becomes the indicator. If the button is pressed the current sensor reading
 is printed by a debug statement. When the button is released, the last polled
 value of the analog sensor is put into thresholdValue making that the new
 begining for the "Alarm State"
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: October 23 2010
 */
 
//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS

//how does the "normal user" experience change if you turn this off?
boolean debugFlag = 1;      //controls serial printing of debug statement
int baudRate = 9600;        //just needs to agree with what is listening to you
                            //used by Serial.begin
                            
unsigned long lastMillis= 0;
unsigned long currentMillis = 0;

//what determines the sensativity of the system.
//the lower it is the sooner the LEDs switches
//as the potentiometer is turned from 0 to 1023
int thresholdValue = 700;  //------------------ new

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

const int sensorPin = 1;  //The Flex Sensor
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading

const int pushButtonPin = 2; //------------------ new from ex(2)

int pushButtonState = 0;     //------------------ new from ex(2)
int lastPushButtonState = 0; //------------------ new from ex(2)

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES

//pin for LED used to demonstrate alarm
const int ledPinOne = 9;  //------------------ changed from ex(2)

//pin for LED used to demonstrate calm
const int ledPinTwo = 13; //------------------ new from ex(2)

//holder for LED currently blinking
int currentLED = ledPinOne; //------------------ new from ex(2)

//holder for LED not blinking (so it can be turned off)
int otherLED = ledPinTwo;   //------------------ new from ex(2)
        

//led timing variables 
int blinkOnPeriod = 1000; // on and off period...
                          // could you change that?

int blinkShortest = 70;   // shortest blink period
int blinkLongest = 2000;  // longest blink period

int blinkState;           //knows if the LED is on or off, the pin doesn't.
long blinkFlipTime;       //knows the last time it changed



//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate); 
  
  //SETUP STEP TWO: Set digital pin modes
  pinMode(pushButtonPin, INPUT);
  pinMode(ledPinOne, OUTPUT);
  pinMode(ledPinTwo, OUTPUT);
  
  //SETUP STEP THREE: Set any initial condtions for outputs
  digitalWrite(ledPinOne, LOW);
  digitalWrite(ledPinTwo, LOW);
}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {      
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes the time

  //LOOP: STEP TWO, POLL THE ENVIRONMENT
  
  //Sensor: get the new value
  sensorValue = analogRead(sensorPin);

  //Button: Save last state  & check new values   ---------------------------------- new from ex (2)
  //similar behavior in Class One ex (11)
  lastPushButtonState = pushButtonState;  // dumps the button State from the last loop into previous holder
  pushButtonState = digitalRead(pushButtonPin); // refreshes the button state


  //LOOP: STEP THREE, DO SOMETHING ABOUT IT
  //range the sensor value to the right blink time
  blinkOnPeriod = map(sensorValue, sensorMin, sensorMax , blinkShortest , blinkLongest);

  //Button state dependant behaviors   ---------------------------------- new from ex (2)
  //similar behavior in Class One ex (11)
  
  //if the button is PRESSED and I'm supposed to be printing things print them now
  if (pushButtonState == LOW && debugFlag == true) {    
    Serial.print(sensorValue);
    Serial.print(" is being translated into ");
    Serial.println(blinkOnPeriod);
    digitalWrite(ledPinOne, LOW);
    digitalWrite(ledPinTwo, HIGH);    // ledPinTwo is serving a status light
  } 
  
  //Under ALL other circumstances
  else{
    //If the button is not in the same state it was the last time I checked
    //and that state is UNPRESSED (so an onRelease style behavior)
    if (pushButtonState != lastPushButtonState && pushButtonState == HIGH) {
      //set the thresholdValue to the sensorValue
      thresholdValue = sensorValue;  
      delay(50);  //a little debounce cheat. 
    }

    //Separately from what's going on with the threshold being updated
    //keep choosing what LED to use based on the most current thresholdValue
    if (sensorValue > thresholdValue) { 
      currentLED = ledPinTwo;
      otherLED = ledPinOne;
    } 
    else {
      currentLED = ledPinOne;
      otherLED = ledPinTwo;
    }

    //then blinkIt while setting the other one to off
    blinkIt(currentLED, blinkOnPeriod);
    digitalWrite(otherLED, LOW);
  }

} 


//--------------------------------------------------------------- END MAIN LOOP

//------------------------------------------------------------------ END MAIN LOOP


//------------------------------------------------------------------------ blinkIt

void blinkIt(int myLED, int myBlinkPeriod) {
  
  //if the difference between the last time I flipped and the
  //current time is longer than the myBlinkPeriod parameter
  //passed to me then...
  if ((myBlinkPeriod) < (currentMillis- blinkFlipTime)) {
    
    //flip me. google "question mark syntax c"
    blinkState ? blinkState=false : blinkState=true;
    //update the blinkFlipTime with the current time.
    blinkFlipTime = currentMillis;       
  }
  //This line needs to be OUTSIDE the if statement so the LED is
  //always under this function's control, not just at the moment
  //of change - think about what happens when you toggle between
  //the LEDs...
  digitalWrite(myLED,blinkState); 
}






