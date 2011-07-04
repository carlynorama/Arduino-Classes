/*
 
 This is code to demonstrate both eeprom and using a second file as part 
 of a sketch.
 
 This version was for Class3 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010 based and the examples that came with the eeprom
 library. 
 
 The Circuit:
  *Nothing, It's all Serial. 
  
 The Behavior:
   Prints out everything that is in eeprom to the serial monitor. 
 
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


void setup()
{
  //SETUP STEP ONE: Attach hardware serial functions
  Serial.begin(baudRate);
}

void loop()
{
  //this function lives on another page!
  //it's portable!
  eepromPrintAll();

}




