/*
 Sensor Threshold
 
 Behavior:
 This code reads the ambient light using a photocell and changes the speed
 the
 ligts are blinking through their pattern based on that speed. It makes
 this check
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
 |         |    |
 | Arduino |    |
 |       A0|-----
 |         |    |   10k Ohm
 |         |    |---/\/\/\-----|l> GND
 |         |
 |         |    LED     330 Ohm
 |     PIN3|----(>|)----/\/\/\----|l> GND
 |         |
 |         |    LED     330 Ohm
 |     PIN5|----(>|)----/\/\/\----|l> GND
 |         |
 |         |    LED     330 Ohm
 |     PIN6|----(>|)----/\/\/\----|l> GND
 |_________|
 
 (ADVANCED QUESTION: what happens if you switch the 10kOhm resistor and the
 photocell? )
 
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

const int speedMultiplier = 200; //what the sensor value is multiplied
//by to calculate the delay times

//////////////////////////////////////////////////////////////////////

//variables, value determined by the code

int sensorValue = 0;      // holds the sensor reading, max range 0 to 1023

long speedMillis = 0;         // Amount of time for the delays. Is now a long.
long lastFlipMillis = 0;  // will store last time LED was updated

int redLedState = LOW;       // ledState used to set the LED
int yellowLedState = LOW;
int greenLedState = LOW;


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


  //POLL THE ENVIRONMENT

  //get the time at the start of the loop
  unsigned long currentMillis = millis();
  unsigned long ellapsedMillis = currentMillis - lastFlipMillis;

  // read the analog input and store the value in sensorValue
  sensorValue = analogRead(sensorPin);

  //the lines below compress the sensorValue and then expand 
  //it into something meaningful in terms of milliseconds. The
  //compression helps smooth the behavior. 
  speedMillis =  map(sensorValue, 0, 1023, 1, 10);
  speedMillis = 3 * speedMillis * speedMultiplier;

  //The time beofre the next flip is being dividied into three parts. 
  //The first "bracket" is for when green should be on, the second for yellow, etc. 
  //the math below should mean that we have 3 equal times for each LED. 

  unsigned long bracketOneMillis = speedMillis/3;
  unsigned long bracketTwoMillis = 2*bracketOneMillis;  // same as 2/3 * speedMillis
  unsigned long bracketThreeMillis = speedMillis;       //same as 3/3 * speedMillis

    //just incase needs to be debugged.
  //Serial.println(sensorValue);
  //delay(10);
  //  Serial.print("ellapsedMillis: ");
  //  Serial.print(ellapsedMillis);
  //  Serial.print("\tbracketOneMillis: ");
  //  Serial.print(bracketOneMillis);
  //  Serial.print("\tbracketTwoMillis: ");
  //  Serial.print(bracketTwoMillis);
  //  Serial.print("\tbracketThreeMillis: ");
  //  Serial.println(bracketThreeMillis);


  //CHECK IT AGAINST WHAT YOU ARE LOOKING FOR


  //determines what bracket we're in, lights the LEDS accordingly.
  if (ellapsedMillis <= bracketOneMillis) {
    greenLedState = HIGH;
    yellowLedState = LOW;
    redLedState = LOW;
  }
  else if (ellapsedMillis <= bracketTwoMillis && ellapsedMillis > bracketOneMillis) {
    greenLedState = LOW;
    yellowLedState = HIGH;
    redLedState = LOW;
  }
  else if (ellapsedMillis <= bracketThreeMillis && ellapsedMillis > bracketTwoMillis ) {
    greenLedState = LOW;
    yellowLedState = LOW;
    redLedState = HIGH;
  }
  else {
    lastFlipMillis = currentMillis;
    //if you ever actually SEE all the LEDs out, there may be a problem.
   //that state should never last longer than a millisecond!  
    greenLedState = LOW;
    yellowLedState = LOW;
    redLedState = LOW;
  }

  //Update the LEDs
  digitalWrite(greenLedPin, greenLedState);
  digitalWrite(yellowLedPin, yellowLedState);
  digitalWrite(redLedPin, redLedState);

}

