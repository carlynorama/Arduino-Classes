/*
  Analog In, LED and Serial Out

  Behavior: 
  Reads an analog input on indicated pin, prints the result to the serial 
  monitor.
  
  Circuit:
  * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
    cathode to ground
  * Pin A0: Attach one lead of a photocell to 5V and another to a 10k Ohm 
    resistor that is connected to ground. Connect the Arduino sensor pin to
    the photocell lead that is also attached to the 10k Ohm resistor.
 
                     photocell
   _________     ____(/\/\/\)--|5V+
  |	    |    |
  | Arduino |    |
  |    	  A0|-----         
  |  	    |    |   10k Ohm
  |  	    |    |---/\/\/\-----|l> GND
  |  	    |
  |    	    |    LED     330 Ohm
  |  	PIN3|----(>|)----/\/\/\----|l> GND
  |  	    |
  |_________|
 
 Based on Example Code included w/ Arduino 1.0.5.
 Adaoted by Carlyn Maw 2013
 
 */
 
//////////////////////////////////////////////////////////////////////
///////////// USER DEFINED CONSTANTS & STARTING VALUES ///////////////

//where the led is
const int ledPin = 3;

//where the sensor is, and its typical range
const int sensorPin = A0;
const int sensorMax = 1023; //(controls resting brightness)
const int sensorMin = 0;    //(controls active brightness)

//////////////////////////////////////////////////////////////////////
///////////////////////// INTERNAL VARIABLES /////////////////////////
int sensorValue = 0;
int ledBrightness = 0;

// the setup routine runs once when you press reset
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(9600);
}

// the loop() method runs over and over again,
// as long as the Arduino has power
void loop() {
  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorPin);
  //make sure sensorValue never goes out of bounds
  sensorValue = constrain(sensorValue,sensorMin, sensorMax);
  // print out the value you read
  Serial.println(sensorValue);
  
  //map the sensor value to LED brightness
  ledBrightness = map(sensorValue, sensorMin, sensorMax, 0, 255);
  
  //flip the relationship between the brightness being read and
  //the brightness of the LED (i.e., the less light being read
  //by the sensor, the brigher the LED)
  ledBrightness = 255 - ledBrightness;
  
  //turn on LED at correct brightness
  analogWrite(ledPin, ledBrightness);
  
}
