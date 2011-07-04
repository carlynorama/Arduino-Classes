/*
 This code reads two analog inputs and one digital input
 and outputs their values via serial to be read by a processing example.
 It is an examplar of using grammar with an added layer of 
 call-and-response to keep your communication protocols clear. Should
 be compared to example 5.
 
 Processing Example is called
 AfP_Class2_Ex06_p_SerialCallResponse
 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010. Except for the comments,
 it is taken pretty much directly from:
 
 http://itp.nyu.edu/physcomp/Labs/SerialDuplex
 
 The Circuit:
 * Pin 2: momentary button attached, pulled high externally w/ 10k Ohm resistor
 (LOW = pressed) NOTE!! The circuit for this on the example site is the 
 opposite of this. How will it change the behavior of the two sketches when they
 are put together?
 * (Not Used) Pin 9: LED, anode to microcontroller
 * Analog Pin 0: Flex Sensor (optional, not in code as written)
 * Analog Pin 1: Potentiometer  
 
 Illustration avalaible: 
 http://23longacre.com/sharedFiles/code/arduino/201010_CS_ArduinoForProgrammers/
 
 Largely the work of Tom Igoe 2008/2009
 
 Notes by Carlyn Maw for the Arduino for Programmers Class
 Highligted by 
 //----------------------------------------------------  AfP Note!
 
 */

int analogOne = 0;       // analog input 
int analogTwo = 1;       // analog input 
int digitalOne = 2;      // digital input 

int sensorValue = 0;     // reading from the sensor

void setup() {
  // configure the serial connection:
  Serial.begin(9600);
  // configure the digital input:
  pinMode(digitalOne, INPUT);

  //----------------------------------------------------  AfP Note!
  // this is new! this is the function that stalls the start up
  //of the main loop until it knows someone is listening.
  establishContact();
}

void loop() {
  //----------------------------------------------------  AfP Note!
  //the loop is getting wrapped in the if statement that checks
  //to see if any new serial is available.
  if (Serial.available() > 0) {
    // read the incoming byte:
    //----------------------------------------------------  AfP Note!
    //this program does nothing with this information. Except
    //acknowledge it exists. See example 8 of this class for 
    //something that uses the actual value to influence what happens next.
    int inByte = Serial.read();
    // read the sensor:
    sensorValue = analogRead(analogOne);
    //----------------------------------------------------  AfP Note!
    //This is the flex sensor on our circit
    //so I'm going to range it on this end so the
    //processing stays "device independant"
    //keeping hardware issues with the hardware 
    //when you can is a good idea if you aren't 
    //going to take too much of a performance hit
    //on it.
    //good suggestion Matt

    //----------------------------------------------- AfP addition:

    //tighten it up to the sensor's most common range
    sensorValue = constrain(sensorValue, 110, 310);

    //map it to the software's expected range
    //(no way to know what the software's expected range
    //is, it isn't some given, YOU decide. In this case
    //it just wants the whole
    sensorValue = map(sensorValue, 110, 310, 0, 1023);

    //---------------------------------------------- END AfP addition
    // print the results:
    Serial.print(sensorValue, DEC);
    Serial.print(",");

    // read the sensor:
    sensorValue = analogRead(analogTwo);
    // print the results:
    Serial.print(sensorValue, DEC);
    Serial.print(",");

    // read the sensor:
    sensorValue = digitalRead(digitalOne);
    // print the last sensor value with a println() so that
    // each set of four readings prints on a line by itself:
    Serial.println(sensorValue, DEC);
  }
}

//----------------------------------------------------  AfP Note!
//until I see SOMETHING come in, hang out saying hello to the
//air. The "while" will hang it here indefinately. 
void establishContact() {
  while (Serial.available() <= 0) {
    Serial.println("hello");   // send a starting message
    delay(300);
  }
}


