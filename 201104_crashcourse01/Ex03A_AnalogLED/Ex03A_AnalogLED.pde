/*
Intro to Arduino @ Machine Project April 2010
Carlyn Maw

analogRead -> analogWrite
A sensor value to the brightness of an led... or the speed of a motor... etc.
remember this is an int to a byte, a range of 0-1023 to a range of 0-255

*/

//Step 1 Define Pins
const int analogReadPin = 1;
const int ledPin = 10;


//Step 2 - value holders
int sensorValue = 0; 
int rangedSensorValue = 0;

//Step 3 - Set Up
void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
}


void loop() {      
  //Step 4 Poll the environment
  sensorValue = analogRead(analogReadPin);

  //Step 5 - Do something about it. 
  rangedSensorValue = map(sensorValue, 0, 1023 , 0, 255); // Values for potentiometer
  //Serial.println(rangedSensorValue);

  analogWrite(ledPin, rangedSensorValue); 
} 
//--------------------------------------------------------------- END MAIN LOOP
