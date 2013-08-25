/* 
 Sensor Threshold
 
 Behavior:
 This code reads the ambient light using a photocell and changes the speed the 
 ligts are blinking through their pattern based on that speed. It makes this check
 only right before the green light turns on.
 
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

const int speedMultiplier = 10; //what the sensor value is multiplied
                                //by to calculate the delay times 

//////////////////////////////////////////////////////////////////////

//variables, value determined by the code

int sensorValue = 0;      // holds the sensor reading, max range 0 to 1023
int speedVar = 0;         // Amount of time for the delays. Holds the result of 
                          // multiplying the speedMultiplierby the sensorValue. 

// ------------------------------------------------------------------- SETUP
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

// -------------------------------------------------------------------- LOOP
void loop() {

  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorValue);

  //just incase needs to be debugged.  
  //Serial.println(sensorValue); 
  //delay(10);
  
  speedVar = sensorValue * speedMultiplier;

  digitalWrite(greenLedPin, HIGH);   // set the grenn LED on
  digitalWrite(redLedPin, LOW);      //MOVED to prevent an ALL OFF scenario

  delay(speedVar);                       // wait for a second
  digitalWrite(greenLedPin, LOW);    // set the grenn LED off
  digitalWrite(yellowLedPin, HIGH);  // set the yellow LED on

  delay(speedVar);                       // wait for a second
  digitalWrite(yellowLedPin, LOW);   // set the yellow LED off
  digitalWrite(redLedPin, HIGH);     // set the red LED on

  delay(speedVar);                     // wait for a second
   // set the LED off
  // don't wait to turn the greenlight on


}




