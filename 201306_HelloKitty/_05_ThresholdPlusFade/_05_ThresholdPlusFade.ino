/* 
  Sensor Threshold with Old School Fade
  
  Behavior:
   This code reads a photocell and trips an LED fade routine when light 
   drops below a threshold. It reads an analog pin and compares the 
   result to a set threshold. If the result is less than the threshold,
   it writes "purr" to the serial port, and toggles the LED on pin 3.
  
 Circuit:
  * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
  cathode to ground
  * Attach one lead of a photocell to 5V and another to a 10k Ohm resistor
    that is connected to ground.
  * Pin A0: Connect the Arduino sensor pin to the photocell lead that is also 
    attached to the 10k Ohm resistor.
 
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
 

 Adapted by Carlyn Maw 2013

 */

 //////////////////////////////////////////////////////////////////////
///////////// USER DEFINED CONSTANTS & STARTING VALUES ///////////////

//where the led is
int ledPin = 3;

//where the sensor is, and its typical range
int sensorPin = A0;
int sensorThreshold = 390;

//////////////////////////////////////////////////////////////////////

//variables, value determined by the code

int sensorValue = 0;      //officialy can range from 0 to 1023, but ours
                          //may be in a smaller range

void setup() {
 pinMode(ledPin, OUTPUT); // declare the ledPin as as OUTPUT
 Serial.begin(9600);       // use the serial port
}

// the setup routine runs once when you press reset
void loop() {
  
  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorValue);
  
  //just incase threshold needs to be debugged.  
  //Serial.println(sensorValue); 
  //delay(10);
  
  // if the sensor reading is greater than the threshold:
  if (sensorValue <= sensorThreshold) {
    //pulse the heart        
    heartBeat();
  }
  
}

//---------------------------------------------------- START heartBeat()
//brings up the light and brings it down again. Not interruptible
//because it uses a "for loop" and delays to create the effect.
//The "Fade" example included with Arduino 1.0.5. is interuptable, but 
//therefore it won't smooth out a jittery sensor. It is also harder to 
//make that fade example a stand alone function. 

void heartBeat() {
  // fade in from min to max in increments of 5 points:
  for(int fadeValue = 0 ; fadeValue <= 255; fadeValue +=5) { 
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue);         
    // wait for 30 milliseconds to see the dimming effect    
    delay(30);                            
  } 

  // fade out from max to min in increments of 5 points:
  for(int fadeValue = 255 ; fadeValue >= 0; fadeValue -=5) { 
    // sets the value (range from 0 to 255):
    analogWrite(ledPin, fadeValue);         
    // wait for 30 milliseconds to see the dimming effect    
    delay(30);                            
  } 
}
//----------------------------------------------------- END heartBeat()


