int sensorPin = A0;    // analog input pin to hook the sensor to
int sensorValue = 0;  // variable to store the value coming from the sensor
 
void setup() { 
  Serial.begin(9600); // initialize serial communications 
}
 
void loop() {
  sensorValue = analogRead(sensorPin)/4; // read the value from the sensor
  Serial.write(sensorValue); // print bytes to serial
  delay(10);
}
