/*
Carlyn Maw

Serial Out Bar Graph Based on Sensor Data
*/

//Step 1 Define Pins
const int analogReadPin = 0;
//-------------------  No buttons

//Step 2 - value holders
int sensorValue = 0;
int rangedSensorValue = 0; // new value holder. replaces "blinkOnPeriod" as a holder for
// a manipulated sensor value.

//Step 3 - Setup Loop
void setup() {
  Serial.begin(9600);


}


void loop() {

  //Poll the environment
  sensorValue = analogRead(analogReadPin);

  //Do something about it.

  rangedSensorValue = map(sensorValue, 0, 1023 , 0, 500); // Values for potentiometer
  //Serial.println(rangedSensorValue);



  if (rangedSensorValue > 400) {
    Serial.println("---------------|");
  }
  else if (rangedSensorValue <= 400 && rangedSensorValue >= 300 ) {
    Serial.println("------------|");
  }
  else if (rangedSensorValue < 300 && rangedSensorValue >= 200 ) {
    Serial.println("---------|");
  }
  else if (rangedSensorValue < 200 && rangedSensorValue >= 100 ) {
    Serial.println("------|");
  }
    else if (rangedSensorValue < 100 && rangedSensorValue >= 10 ) {
    Serial.println("---|");
  } else if (rangedSensorValue < 10) {  // off
    Serial.println("|");
  }
  
  delay(2);

}


//--------------------------------------------------------------- END MAIN LOOP





