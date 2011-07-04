/*
 This is code to test the board design for the Class 2 of the Arduino 
 for Programmers class taught at CRASH Space in October, 2010.
 
 The class was based on the SparkFun Arduino Iventors Kit
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed)
 * Pin 9: LED, anode to microcontroller, 330 Ohm restor from cathode to ground
 * Analog Pin 0: Flex Sensor
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 
 The Behavor:
 At start up the brightness of the LED is controlled by the flex sensor.
 The more it is flexed the brighter the LED. When the button is pressed
 the brightness of the LED is controlled by the Potentiometer.
 
 Written By: Carlyn Maw
 Created: October 22 2010
 Updated: October 23 2010
 
 */
 
//DEFINE: STEP ONE, IS YOUR DEBUG ON
//controls serial printing of debug statement 
boolean debugFlag = 0;
int baudRate = 9600;        //just needs to agree with what is listening to you
                            //used by Serial.begin

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

const int sensorPinOne = 0;  //The Flex Sensor
int sensorValueOne = 0;      //Sensor Value
int sensorOneMax = 309;      //Maximum value this sensor will ever have as a reading
int sensorOneMin = 110;      //Minimum value this sensor will ever have as a reading

const int sensorPinTwo = 1; //The Potentiometer
int sensorValueTwo = 0;     //Sensor Value
int sensorTwoMax = 1023;    //Maximum value this sensor will ever have as a reading
int sensorTwoMin = 0;       //Minimum value this sensor will ever have as a reading

int pushButtonPin = 2;      //Push Button Pin    

//DEFINE: STEP THREE, OUTPUTS AND THEIR VARIABLES
int ledPin = 9;


//------------------------------------------------------------------ START SETUP LOOP

void setup() {
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate); 
  
  //SETUP STEP TWO: Set digital pin modes
  pinMode(pushButtonPin, INPUT);
  pinMode(ledPin, OUTPUT);
  
  //SETUP STEP THREE: Set any initial condtions for outputs
  digitalWrite(ledPin, LOW);
}


//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  
  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  
  // read the analog input into a variable:
  sensorValueOne = analogRead(sensorPinOne);
  sensorValueTwo = analogRead(sensorPinTwo);


  //LOOP STEP TWO: DO SOMETHING ABOUT IT
  int ledBrightness = getValueForPWM();
  analogWrite(ledPin, ledBrightness);

  //LOOP STEP THREE: TELL ME WHAT'S GOING ON
  if (debugFlag) {
    Serial.print("ONE: \t");
    Serial.println(sensorValueOne);
    Serial.print("TWO: \t");
    Serial.println(sensorValueTwo);
    Serial.print("PWM: \t");
    Serial.println(ledBrightness);
    Serial.println();

    delay(200);
  }

}

//------------------------------------------------------------------ END MAIN LOOP


//----------------------------------------------------------------- getValueForPWM

//function that looks at button, and based on button's state chooses which sensor
//to use to pass a byte back for the brightness of the LED

byte getValueForPWM() { 

  //FUNCTION DEFINE & SETUP
  
  boolean pushButtonState;    //"buffer" for button pin
  byte returnedValue;         //byte that will be returned

  //FUNCTION "LOOP" 
  
  //Step One: Poll the Environment
  pushButtonState = digitalRead(pushButtonPin); 

  //Step Two: Do Something With it
  
  //if the button is NOT pressed (remember it is pulled high)
  if (pushButtonState == HIGH) {      
    //use the flex sensors value, mapped to a byte from its defined useable range
    //FLIPPED so that deforming it increase the brightness rather than decreases    
    returnedValue  = map(sensorValueOne, sensorOneMin, sensorOneMax, 255, 0);
  } 
  else {
    //use the potentiometer value, mapped to a byte from its defined useable range 
    returnedValue = map(sensorValueTwo, sensorTwoMin, sensorTwoMax, 0, 255);
  }

  //Step Three: tell me whats going on 
  //(pass manipulated sensor data to the requestor)
  return(returnedValue);
}



