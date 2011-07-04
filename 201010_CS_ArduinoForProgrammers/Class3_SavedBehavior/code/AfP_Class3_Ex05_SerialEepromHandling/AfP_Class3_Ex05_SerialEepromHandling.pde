/*
 
 This is code to demonstrate how you do some advanced manipulation of both
 eeprom and serial handling. 
 
 This version was for Class 3 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010. See also Class 2 (ex 08)
 
 The Circuit:
 *Nothing, It's all Serial. 
 
 The Behavior:
 Prints out the values in eeprom after the values from an array have been 
 written into it. 
 
 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010
 
 */
 
//DEFINE: STEP ONE, INCLUDE LIBRARIES
//#include <EEPROM.h> //--- MOVED TO eepromHandling 

//DEFINE: STEP TWO, GLOBAL STATUS VARS
int baudRate = 9600;
//int eepromSize = 512; //--- MOVED TO eepromHandling 
boolean serialListenerFlag = true;


boolean recordFlag;
boolean playFlag;

//DEFINE: STEP TWO, INPUTS AND THEIR VARIABLES

//place holder for what couldbe a sensor reading in the future
byte currentSensorByteValue= 0x55;

//DEFINE: STEP THREE, eeprom handling
const int sequenceEEPROMStartAddress = 20;
const int sequenceEEPROMEndAddress = 29;

const int maxBufferSize = abs(sequenceEEPROMEndAddress-sequenceEEPROMStartAddress)+1; 

//buffer that mirrors eeprom
//byte eepromMirrorLength; //(The REAL length ofwhat's in EEPROM)
byte eepromCacheArray[maxBufferSize];

//DEFINE: STEP FOUR, define active sequence and its initial values just for kicks.
//buffer that holds the most recent recording
byte activeSequenceArray[maxBufferSize]= { 
  0,1,2,3,4,5,6,7,8,9 } 
;

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate);

  //SETUP STEP TWO: Load eeprom into cache and active arrays
  eepromLoadIntoArray(sequenceEEPROMStartAddress, sequenceEEPROMEndAddress, eepromCacheArray, maxBufferSize);
  cache2active(); //in eeprom handling
}

//-------------------------------------------------------------------- START MAIN LOOP
void loop()
{
  //LOOP: STEP ONE if I'm supposed to listen and there is something to 
  //listen to, do something about it. All in the SerialHandling tab
  if (serialListenerFlag && Serial.available() > 0) respondToSerial();

  //LOOP: STEP TWO if I'm supposed to play, play and then turn me off
  //playFlag set by respondToSerial
  if (playFlag) {
    playSequence(activeSequenceArray, maxBufferSize);
    playFlag = false;
  }

  //LOOP: STEP THREE if I'm supposed to record, turn of playing and
  //listen  
  //set AND RESET by respondToSerial
  if (recordFlag) {
    playFlag = false;
    recordSequence(activeSequenceArray, maxBufferSize, 300);
  }

}

//---------------------------------------------------------------------- END MAIN LOOP

//----------------------------------------------------------------------- playSequence
//for now a test behavior, printing what we'll "play" later
void playSequence(byte * sourceArray, int arraySize) {
        arrayPrintAll(sourceArray, arraySize);
}

//--------------------------------------------------------------------- recordSequence
//for now a test behavior, printing what we'll use later
//in conjunction with sensor data to create a record function
void recordSequence(byte * destinationArray, int arraySize, int sampleRate) {
        Serial.print("Shhh... I'm recording up to ");
        Serial.print(arraySize, DEC);
        Serial.print(" items over the course of up to ");
        Serial.print((arraySize*sampleRate),DEC);
        Serial.print(" milliseconds.");
        Serial.println("\tPress d when done.");
}
