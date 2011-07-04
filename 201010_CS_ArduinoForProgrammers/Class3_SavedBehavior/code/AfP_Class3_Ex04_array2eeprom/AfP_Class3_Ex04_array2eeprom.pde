/*
 
 This is code to demonstrate how you load an array into eeprom
 
 This version was for Class 3 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010
 
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
#include <EEPROM.h>

//DEFINE: STEP TWO, GLOBAL STATUS VARS
int baudRate = 9600;
int eepromSize = 512; // 328 has 1k i.e. 1023 but using that
//will make your code incompatible. 

//DEFINE: STEP THREE, Array definitions.                       
//rember the array stuff from class 1?
const int lengthOfSequence = 10;
byte activeSequence[lengthOfSequence] = { 
  0,1,2,3,4,5,6,7,8,9 } 
;

//------------------------------------------------------------------ START SETUP LOOP
void setup()
{
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate);

  //SETUP STEP TWO: Load info in eeprom into an array and then print the array. 

  //Call of format 
  //eepromWriteFromArray(array destinationArray, int arraySize, int startAddress, int endAddress)
  //can go forwards or backwards (highest eeprom address to lowest or lowest to highest) 
  //always starts at array postion 0 
  eepromWriteFromArray(activeSequence, lengthOfSequence, 83, 74);
}

//-------------------------------------------------------------------- START MAIN LOOP
void loop()
{
  //again, nada
}
