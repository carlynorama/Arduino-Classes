/* 
 Happy Kitty
 
 This is a BIG GIANT LEAP from step 5 where our class ended, but it doesn't
 use anthing super fancy you haven't seen before other than boolean flags.
 Boolean flags are true/false variable you can use to keep track of 
 information. Checking a flag with an if-statement can tell your code if
 it is ready to do certain actions that are dependant on the flag. Just
 remember, everytime a flag gets set to true, make sure it is also set to
 false somewhere in your code. Try to follow along. I bet you can do it. 
 
 Behavior:
 When the head of the kitty is pet, the LED heart throbs up and down
 a set number of times.
 The code reads 3 photocells, and if the amount of light reaching them
 goes below a set threshold in a certain order, and LED routine is triggered.
 
 Circuit:
 * Pin 3: LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 FOR PINS A0(blue), A1 (green), A2(yellow)
 * Attach one lead of a photocell to 5V and another to a 10k Ohm resistor
 that is connected to ground.
 * Connect the Arduino sensor pin to the photocell lead that is also 
 attached to the 10k Ohm resistor.
 
  _________         photocell
 |         |    ____(/\/\/\)--|5V+
 | Arduino |    |
 |         |    |
 | A2,A1,A0|-----         
 |         |    |   10k Ohm
 |         |    |---/\/\/\-----|l> GND
 |         |
 |         |    LED     330 Ohm
 |     PIN3|----(>|)----/\/\/\----|l> GND
 |         |
 |_________|
 
 
 by Carlyn Maw 2013
 
 */

//////////////////////////////////////////////////////////////////////

//where the led is
const int ledPin = 3;

//where the sensors are
const int sensor01Pin = A0;
const int sensor02Pin = A1;
const int sensor03Pin = A2;

//these are in case autoThreshold is causing unusual results.
int sensor01Threshold = 0;  
int sensor02Threshold = 0;
int sensor03Threshold = 0;

const boolean autoThreshold = true; //try to autodetect light conditions 
                                    //during setup.
const int sensitivity = 200;        //how sensitive is the kitty to shade

const boolean debug = false;        //are the serial prints running

const int beatsPerPat = 2;          //how many beats per pat
const int pulseRate = 5;            //how fast is it? higher is faster. 
                                    //(an increment, not a real time value)

//////////////////////////////////////////////////////////////////////

//variables, value determined by the code

//what were the sensor readings
int sensor01Value = 0;
int sensor02Value = 0; 
int sensor03Value = 0;  

//flags for when the sensors are below threshold
boolean sensor01TFlag = 0;
boolean sensor02TFlag = 0;
boolean sensor03TFlag = 0;

//flags for when the "conditions have been met" for the next stage of a
//pat gesture.
boolean conditionOne = 0;
boolean conditionTwo = 0;
boolean conditionThree = 0;

//---------------------------------------------------------------------- SETUP
// the setup routine runs once when you press reset
void setup() {
  pinMode(ledPin, OUTPUT); // declare the ledPin as as OUTPUT
  Serial.begin(9600);       // use the serial port

  //if auto threshold is set, get light readings on startup
  //and assume patting is somewhat less than that.
  if (autoThreshold) {
    sensor01Threshold = analogRead(sensor01Pin)-sensitivity; 
    sensor02Threshold = analogRead(sensor02Pin)-sensitivity; 
    sensor03Threshold = analogRead(sensor03Pin)-sensitivity; 
    if (debug) {
      Serial.print("S1T: ");
      Serial.println(sensor01Threshold);
      Serial.print("S2T: ");
      Serial.println(sensor02Threshold);
      Serial.print("S3T: ");
      Serial.println(sensor03Threshold);
    }
  }
}

//----------------------------------------------------------------------- LOOP
void loop() {

  // read the sensors and store them in the corresponding variable
  sensor01Value = analogRead(sensor01Pin);
  sensor02Value = analogRead(sensor02Pin);
  sensor03Value = analogRead(sensor03Pin);  


  //then check all of those reading against their corresponding
  //thresholds. 
  if (sensor01Value <= sensor01Threshold) {
    sensor01TFlag = true;
    if (debug) {
      Serial.print("S1: ");
      Serial.println(sensor01Value);
    }
  }
  else {
    sensor01TFlag = false;
  }

  if (sensor02Value <= sensor02Threshold) {
    sensor02TFlag = true;  
    if (debug) {
      Serial.print("S2: ");
      Serial.println(sensor02Value);
    }
  }
  else {
    sensor02TFlag = false;
  }

  if (sensor03Value <= sensor03Threshold) {
    sensor03TFlag = true; 
    if (debug) {
      Serial.print("S3: ");
      Serial.println(sensor03Value);
    } 
  } 
  else {
    sensor03TFlag = false;
  }

  //now what do all those thresholds mean?

  //if the front of the kitty is being shaded, but the back isn't, the
  //petting has started, but only bother these conditions haven't already
  // been met before. 
  if (conditionOne==false) {
    if ((sensor01TFlag==true) && (sensor02TFlag==false)) {
      conditionOne = true;
      if (debug) {
        Serial.print("ConditionOne");
      } 
    }
  }

  //petting is about halfway done
  if (conditionTwo==false) {
    if ((conditionOne == true) && (sensor02TFlag==true)) {
      if (sensor03TFlag==false) {
        conditionTwo = true;
        if (debug) {
          Serial.print("ConditionTwo");
        } 
      }
    }
  }

  if ((conditionTwo == true) && (sensor03TFlag==true)) {
    conditionThree = true;
    if (debug) {
      Serial.print("ConditionThree");
    } 
  }


  //PPPPUUURRRRR
  if (conditionThree) {
    heartBeat(ledPin, beatsPerPat, pulseRate);
  }


}


//---------------------------------------------------- START heartBeat()
//brings up the light and brings it down again a number of times and at a
//speed determined by parameters. Not interruptible because it uses a 
//"for loop" and delays to create the effect.

//The "Fade" example included with Arduino 1.0.5. is interuptable, but 
//therefore it won't smooth out a jittery sensor. It is also harder to 
//make that fade example a stand alone function. 


void heartBeat(int myPin, int numberOfBeats, int rate) {
  // fade in from min to max in increments of 5 points:
  for (int s = 0 ; s < numberOfBeats; s++) {
    for(int fadeValue = 0 ; fadeValue <= 255; fadeValue += rate) { 
      // sets the value (range from 0 to 255):
      analogWrite(myPin, fadeValue);         
      // wait for 30 milliseconds to see the dimming effect    
      delay(30);                            
    } 

    // fade out from max to min in increments of 5 points:
    for(int fadeValue = 255 ; fadeValue >= 0; fadeValue -= rate) { 
      // sets the value (range from 0 to 255):
      analogWrite(myPin, fadeValue);         
      // wait for 30 milliseconds to see the dimming effect    
      delay(30);                            
    } 
  }
  //---------------------------------------------------------- Add a FALSE
  conditionOne = false; 
  conditionTwo = false; 
  conditionThree = false; 

}





