/*
This code is literally blinking led code from Class 2 Ex 2 with a find/replace
on the word blink to sample and Blink to Sample.  This version was for 
 Class 2 of the Arduino for Programmers course taught at CRASH Space in October, 
 2010.
 
 The Circuit:
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 The two different sensors were really so we could see how it worked with both
 a potentiomenter and sensor with less of a range.  
 
 Written By: Carlyn Maw
 Created: April 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS

boolean debugFlag = 0;      //controls serial printing of debug statement
int baudRate = 9600;        //just needs to agree with what is listening to you
//used by Serial.begin

unsigned long lastMillis= 0;
unsigned long currentMillis = 0;      

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

const int sensorPin = A1;   //Potentiometer
int sensorValue = 0;        //Sensor Value
int sensorMax = 1023;       //Maximum value this sensor will ever have as a reading
int sensorMin = 0;          //Minimum value this sensor will ever have as a reading

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
const int ledPin = 9;

//led timing variables 
int sampleOnPeriod = 1000; // on and off period...
// could you change that?

int sampleShortest = 70;   // shortest sample period
int sampleLongest = 2000;  // longest sample period

int sampleState;           //knows if the LED is on or off, the pin doesn't.
long sampleFlipTime;       //knows the last time it changed

//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate); 

  //SETUP STEP TWO: Set digital pin modes
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
  sampleOnPeriod = map(sensorValue, sensorMin, sensorMax , sampleShortest, sampleLongest);

  //do the actual sampleing
  sampleIt(ledPin, sampleOnPeriod);

  //LOOP STEP THREE: TELL ME WHAT'S GOING ON
  if (debugFlag) {
    Serial.println(sensorValue);
  }


}  

//------------------------------------------------------------------ END MAIN LOOP
//------------------------------------------------------------------------ sampleIt

void sampleIt(int myLED, int mySamplePeriod) {

  //if the difference between the last time I flipped and the
  //current time is longer than the mySamplePeriod parameter
  //passed to me then...
  if ((mySamplePeriod) < (currentMillis- sampleFlipTime)) {

    //flip me. google "question mark syntax c"
    sampleState ? sampleState=false : sampleState=true;
    //update the sampleFlipTime with the current time.
    sampleFlipTime = currentMillis;       
  }
  //This line needs to be OUTSIDE the if statement so the LED is
  //always under this function's control, not just at the moment
  //of change (bigger issue when you are using it to toggle between
  //LEDs like in Class One Ex 7(b) Toggle LEDs
  digitalWrite(myLED,sampleState); 
}

