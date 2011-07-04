/*
This code updates the SampleIt function to both keep an LED on for the bottom
half of the sample delay and to load the value of a potentiometer into an array
when that period is over.  arrayHandling tab is back! 
 
 The Circuit:
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 The two different sensors were really so we could see how it worked with both
 a potentiomenter and sensor with less of a range.  
 
 The Behavior:
 Sensor values are loaded into an array, a max number determined by 
 sampleMaxNumber. When that number has been reached it prints out those values
 to the serial monitor using functions found on the arrayHandling tab. The sample
 period is actually determined by the sensor, so as the value gets higher the 
 samples get less frequent. wierd little behavior...
 
 Written By: Carlyn Maw
 Created: Oct 25 2010
 Updated: Nov 1 2010
 
 */

//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS

boolean debugFlag = 0;      //controls serial printing of debug statement
int baudRate = 9600;        //just needs to agree with what is listening to you
//used by Serial.begin

unsigned long lastMillis= 0;
unsigned long currentMillis = 0;      

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

const int sensorPin = 1;  //The Pot Sensor
int sensorValue = 0;      //Sensor Value
int sensorMax = 1023;     //Maximum value this sensor will ever have as a reading
int sensorMin = 0;        //Minimum value this sensor will ever have as a reading

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
const int ledPin = 9;

//led timing variables 
int samplePeriod = 1000; // on and off period...
// could you change that?

int sampleShortest = 70;   // shortest sample period
int sampleLongest = 2000;  // longest sample period

const int sampleMaxNumber = 10;
int sampleIndex;

int sampleState;           //knows if the LED is on or off, the pin doesn't.
long sampleFlipTime;       //knows the last time it changed

//AND ADD SAMPLING ARRAY
const int lengthOfSequence = sampleMaxNumber;
byte activeSequence[lengthOfSequence]= { 
  100,78,120,36,49,25,96,27,83,79 } 
;
//int nextIndex = 0;

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
  //Serial.print("SensorReading: ");
  //Serial.println(sensorValue,DEC);

  //LOOP: STEP THREE, DO SOMETHING ABOUT IT
  //same method we used to get a ranged value for PWM in test code
  samplePeriod = map(sensorValue, sensorMin, sensorMax , sampleShortest, sampleLongest);

  //do the actual sampling -- NEW
  byte servoCompressedSensorValue = map(sensorValue, sensorMin, sensorMax, 0, 179);
  
  // CHANGED
  sampleIt(servoCompressedSensorValue, samplePeriod, activeSequence, lengthOfSequence, ledPin);  //------------------------ CAHNGED



  //LOOP STEP THREE: TELL ME WHAT'S GOING ON
  if (debugFlag) {
    Serial.println(sensorValue);
  }


}  

//------------------------------------------------------------------ END MAIN LOOP
//------------------------------------------------------------------------ sampleIt
                                                        // ---------------- CHANGED
void sampleIt(byte sampleValue, int mySamplePeriod, byte * destinationArray, int arrayLength, int myLED) {    

  //if the difference between the last time I flipped and the
  //current time is longer than the mySamplePeriod parameter
  //passed to me then...
  //divide by two b/c the LED is on for half the period
  if ((mySamplePeriod/2) < (currentMillis- sampleFlipTime)) {
    if (sampleState)  {
      //take reading
      Serial.print("sampleIndex\t");
      Serial.println(sampleIndex,DEC);
      destinationArray[sampleIndex] = sampleValue;
      sampleIndex ++;
      sampleState=false;

      if (sampleIndex >= arrayLength)  {            
        // ...wrap around to the beginning: 
        sampleIndex = 0; 
        arrayPrintAll(destinationArray, arrayLength);   
      }       

    }
    else {
      sampleState=true;
    }
    //update the sampleFlipTime with the current time.
    sampleFlipTime = currentMillis;       
  }
  //This line needs to be OUTSIDE the if statement so the LED is
  //always under this function's control, not just at the moment
  //of change (bigger issue when you are using it to toggle between
  //LEDs like in Class One Ex 7(b) Toggle LEDs
  digitalWrite(myLED,sampleState); 
}





