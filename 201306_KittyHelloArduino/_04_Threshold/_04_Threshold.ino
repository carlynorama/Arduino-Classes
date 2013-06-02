/* 
  Sensor Threshold
  
  Behavior:
   This code reads the ambient light using a photocell and turns on 
   an LED when the external light drops below a threshold. It reads an
   analog pin and compares the result to a set threshold. If the result
   is less than the threshold, it turns on the LED on pin 3.
  
 Circuit:
  * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
    cathode to ground
  * Pin A0: Attach one lead of a photocell to 5V and another to a 10k Ohm 
    resistor that is connected to ground. Connect the Arduino sensor pin to
    the photocell lead that is also attached to the 10k Ohm resistor.
 
                     photocell
   _________     ____(/\/\/\)--|5V+
  |         |    |
  | Arduino |    |
  |    	  A0|-----         
  |  	    |    |   10k Ohm
  |  	    |    |---/\/\/\-----|l> GND
  |  	    |
  |    	    |    LED     330 Ohm
  |  	PIN3|----(>|)----/\/\/\----|l> GND
  |  	    |
  |_________|
 
 Loosely based on "Knock" Example Code included w/ Arduino 1.0.5.
 Adapted by Carlyn Maw 2013
 
 This example code is in the public domain.

 */

//////////////////////////////////////////////////////////////////////
///////////// USER DEFINED CONSTANTS & STARTING VALUES ///////////////

//where the led is
const int ledPin = 3;

//where the sensor is, and its typical range
const int sensorPin = A0;
const int sensorThreshold = 512; //manual choice.

//////////////////////////////////////////////////////////////////////

//variables, value determined by the code

int sensorValue = 0;      //officialy can range from 0 to 1023, but ours
                          //may be in a smaller range

// the setup routine runs once when you press reset
void setup() {
 pinMode(ledPin, OUTPUT); // declare the ledPin as as OUTPUT
 Serial.begin(9600);       // use the serial port
}


void loop() {
  
  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorValue);

  //just incase threshold needs to be debugged.  
  //Serial.println(sensorValue); 
  //delay(10);
  
  // if the sensor reading is less than the threshold:
  if (sensorValue <= sensorThreshold) {
    // update the LED pin         
    digitalWrite(ledPin, HIGH);  
  } else {
    digitalWrite(ledPin, LOW);
  }
  
}



