/*
 
 This is code to demonstrate how you'd load a chunk of eeprom into an array
 
 see: http://arduino.cc/en/Tutorial/SwitchCase
 
 This version was for Class 3 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010 based and the examples that came with the eeprom
 library. 
 
 The Circuit:
 *Nothing, It's all Serial. 
 
 The Behavior:
 Prints out the values in an array after the eeprom is loaded into it. 
 
 Written By: Carlyn Maw
 Created: October 25 2010
 Updated: Nov 1 2010
 
 */
//DEFINE: STEP ONE, INCLUDE LIBRARIES
#include <EEPROM.h>

//DEFINE: STEP TWO, GLOBAL STATUS VARS
int baudRate = 9600;
int eepromSize = 512; // 328 has 1k i.e. 1023 but using that
//will make your code incompatible. 

//DEFINE: STEP THREE, Array definitions.                       
//rember the array stuff from class 1?
const int lengthOfSequence = 69;
byte activeSequence[lengthOfSequence];


void setup()
{
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate);

  //SETUP STEP TWO: Load info in eeprom into an array and then print the array. 

  //Call of format 
  //eepromLoadIntoArray(int startAddress, int endAddress, array destinationArray, int arraySize) 
  //can go forwards or backwards (highest eeprom address to lowest or lowest to highest) 
  //always starts at array postion 0 
  eepromLoadIntoArray(128, 196, activeSequence, lengthOfSequence);
}

void loop() 
{
  //again, nada
}




