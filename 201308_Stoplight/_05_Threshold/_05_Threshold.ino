/* 
 Sensor Threshold
 
 Behavior:
 This code reads the ambient light using a photocell and turns on 
 an different LED depending on threshold values set by hand in the code. 
 
 Circuit:
 * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin 3: red LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin 5: yellow LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin 6: green LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin A0: Attach one lead of a photocell to 5V and another to a 10k Ohm 
 resistor that is connected to ground. Connect the Arduino sensor pin to
 the photocell lead that is also attached to the 10k Ohm resistor.
 
 photocell
  _________     ____(/\/\/\)--|5V+
 |	   |    |
 | Arduino |    |
 |    	 A0|-----         
 |  	   |    |   10k Ohm
 |  	   |    |---/\/\/\-----|l> GND
 |         |
 |    	   |    LED     330 Ohm
 |     PIN3|----(>|)----/\/\/\----|l> GND
 |         | 
 |         |    LED     330 Ohm
 |     PIN5|----(>|)----/\/\/\----|l> GND
 |         |     
 |         |    LED     330 Ohm
 |     PIN6|----(>|)----/\/\/\----|l> GND
 |_________|
 
 (ADVANCED QUESTION: what happens if you switch the 10kOhm resistor and the photocell? )
 
 Loosely based on "Knock" Example Code included w/ Arduino 1.0.5.
 Adapted by Carlyn Maw 2013
 
 */

//////////////////////////////////////////////////////////////////////
///////////// USER DEFINED CONSTANTS & STARTING VALUES ///////////////

//where the led is
const int redLedPin = 6;
const int yellowLedPin = 5;
const int greenLedPin = 3;

//where the sensor is, and its typical range
const int sensorPin = A0;
const int yellowThreshold = 100; //manual choice.
const int redThreshold = 400;  //manual choice.

//////////////////////////////////////////////////////////////////////
//variables, value determined by the code
int sensorValue = 0;      // holds the sensor reading, max range 0 to 1023

// the setup routine runs once when you press reset
void setup() {
  
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
  
  // initialize the digital pin as an output:
  pinMode(redLedPin, OUTPUT); 
  pinMode(yellowLedPin, OUTPUT); 
  pinMode(greenLedPin, OUTPUT);   

  //make sure everyone starts off
  digitalWrite(greenLedPin, LOW);
  digitalWrite(yellowLedPin, LOW);
  digitalWrite(redLedPin, LOW);
}


void loop() {

  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorValue);

  //just incase threshold needs to be debugged.  
  //Serial.println(sensorValue); 
  //delay(10);

  // if the sensor reading is less than the threshold:
  if (sensorValue <= yellowThreshold) {
    // update the LED pin         
    digitalWrite(greenLedPin, HIGH);
    digitalWrite(yellowLedPin, LOW);
    digitalWrite(redLedPin, LOW);  
  } 
  else if ((sensorValue > yellowThreshold) && (sensorValue < redThreshold)) {
    digitalWrite(greenLedPin, LOW);
    digitalWrite(yellowLedPin, HIGH);
    digitalWrite(redLedPin, HIGH); 
  } 
  else if (sensorValue >= redThreshold) {
    digitalWrite(greenLedPin, LOW);
    digitalWrite(yellowLedPin, HIGH);
    digitalWrite(redLedPin, HIGH); 
  }

}




