/*
Sensor Reader
 Language: Wiring/Arduino
 This code reads two analog inputs and two digital inputs and outputs
 their values via serial to be read by a processing example. We cheat
 on our board and ignore the serve button.
 
 The Processing example is called
 AfP_Class2_Ex07_p_MonskiPong
 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010. Except for the comments,
 it is taken pretty much directly from Chapter Two of:
 
 Making Things Talk
 Practical Methods for Connecting Physical Objects
 ByTom Igoe
 Publisher:O'Reilly Media / MakeReleased: September 2007
 
  The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
   (LOW = pressed) NOTE!! The circuit for this in the book is the 
   opposite of this. A line of code is added to compensate.
 * (Not Used) Pin 9: LED, anode to microcontroller
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer 
 
 Notes by Carlyn Maw for the Arduino for Programmers Class
 Highligted by 
 //----------------------------------------------------  AfP Note!
 
 Question: How would you re-write these examples using Firmata?
 What would you gain? What would you loose?
 
 */
int leftSensor = 0; // analog input for the left arm
int rightSensor = 1; // analog input for the right arm

int resetButton = 2; // digital input for the reset button
int serveButton = 3; // digital input for the serve button

int leftValue = 0; // reading from the left arm
int rightValue = 0; // reading from the right arm

int reset = 0; // reading from the reset button
int serve = 0; // reading from the serve button

void setup() {
  // configure the serial connection:
  Serial.begin(9600);
  // configure the digital inputs:
  pinMode(resetButton, INPUT);
  pinMode(serveButton, INPUT);
}
void loop() {
  // read the analog sensors:
  
   //----------------------------------------------------  AfP Note!
   //flex sensor values need to be cleaned up a bit.   
  //----------------------------------------------- AfP Edit:  
  //tighten it up to the sensor's most common range
  leftValue = constrain(leftSensor, 110, 310);  
  //map it
  leftValue = map(leftValue, 110, 310, 0, 1023);
  //---------------------------------------------- END of AfP Edit
  
  rightValue = analogRead(rightSensor);
  // read the digital sensors:
  reset = digitalRead(resetButton);
  //----------------------------------------------------  AfP Note!
  //we have to flip the value of this b/c our button is pulled high
  //not pulled low. 
  reset ? reset=false : reset=true;

  //----------------------------------------------------  AfP Note!
  //yeah, our pin 3 is just sort of listening to air... it will work
  //much better if we added a second button. 
  //alternatively you can use the button for the serve (don't forget 
  //to add the logic swap) and use some wire to "make your own switch"
  //for the reset since it is less commonly used.
  serve = digitalRead(serveButton);
  
  // print the results:

  Serial.print(leftValue, DEC);
  Serial.print(",");
  Serial.print(rightValue, DEC);
  Serial.print(",");
  Serial.print(reset, DEC);
  Serial.print(",");
  // print the last sensor value with a println() so that
  // each set of four readings prints on a line by itself:
  Serial.println(serve, DEC);
  
  //----------------------------------------------------  AfP Note!
  //commented out debug statements
  //}
  // print the results:
  //Serial.print(leftValue, BYTE);
  //Serial.print(44, BYTE);
  //Serial.print(rightValue, BYTE);
  //Serial.print(44, BYTE);
  //Serial.print(reset, BYTE);
  //Serial.print(44, BYTE);
  //Serial.print(serve, BYTE);
  //Serial.print(13, BYTE);
  //Serial.print(10, BYTE);
}


