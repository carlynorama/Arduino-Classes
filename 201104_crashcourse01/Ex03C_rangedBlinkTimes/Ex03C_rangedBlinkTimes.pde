/*
 
 This is code to demonstrates another use for non-delay blinking code by altering 
 how fast the LED blinks as the analog sensor is changed. This version was for 
 Class 2 of the Arduino for Programmers course taught at CRASH Space in October, 
 2010 based on code in Class 3 (ex 6) of the Intro to Arduino class at 
 Machine Project in April. 
 
 The class was based on the SparkFun Arduino Iventors Kit
 
 The Circuit:
 * (Not Used) Pin 2: momentary button attached to, pulled high externally
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 The Behavior:
 If the analogReadPin is set to one, LED blinks faster as the potentiometer is 
 turned. Again uses a map() function, where the slowert blink time is determined 
 by blinkShortest and slowest by blinkLongest.  Another way to handle this would
 have been to simply multiply the readings from the sensor by some factor. What 
 would have been the main consequnce of doing it that way?
 
 Slowest blink time is determined by lengths. Changing from an potentiometer (analog pin 1) to a flex sensor 
 in our circuit (anaolog pin 0) meant we wanted to use the map() function to make our blink times match the data we were getting
 from the new sensor. 
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: October 23 2010
 
 */

//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
 
//boolean debugFlag = 0;      //controls serial printing of debug statement
//int baudRate = 9600;        //just needs to agree with what is listening to you
                            //used by Serial.begin
                            
unsigned long lastMillis= 0;
unsigned long currentMillis = 0;                            

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

const int sensorPin = 1;  //The Flex Sensor
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES

const int ledPin = 9;

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
  //Serial.begin(baudRate); 
  
  //SETUP STEP TWO: Set digital pin modes
  pinMode(pushButtonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  
  //SETUP STEP THREE: Set any initial condtions for outputs
  digitalWrite(ledPin, LOW);
}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  
  //LOOP: STEP ONE, CHECK THE TIME 
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes the time

  //LOOP: STEP TWO, POLL THE ENVIRONMENT
  sensorValue = analogRead(sensorPin);

  //LOOP: STEP THREE, DO SOMETHING ABOUT IT
  //same method we used to get a ranged value for PWM in test code
  blinkOnPeriod = map(sensorValue, sensorMin, sensorMax , blinkShortest, blinkLongest);
  
  //do the actual blinking
  blinkIt(ledPin, blinkOnPeriod);
  
  //LOOP STEP THREE: TELL ME WHAT'S GOING ON
  //if (debugFlag) {
  //  Serial.println(sensorValue);
  //}
  

} 


//------------------------------------------------------------------ END MAIN LOOP


//------------------------------------------------------------------------ blinkIt

void blinkIt(int myLED, int myBlinkPeriod) {
  
  //if the difference between the last time I flipped and the
  //current time is longer than the myBlinkPeriod parameter
  //passed to me then...
  if ((myBlinkPeriod) < (currentMillis- blinkFlipTime)) {
    
    //flip me. like in Ex01C (google "question mark syntax c")
    blinkState ? blinkState=false : blinkState=true;
    //update the blinkFlipTime with the current time.
    blinkFlipTime = currentMillis;       
  }
  //This line needs to be OUTSIDE the if statement so the LED is
  //always under this function's control, not just at the moment
  //of change (bigger issue when you are using it to toggle between
  //LEDs like in Class One Ex 7(b) Toggle LEDs
  digitalWrite(myLED,blinkState); 
}






