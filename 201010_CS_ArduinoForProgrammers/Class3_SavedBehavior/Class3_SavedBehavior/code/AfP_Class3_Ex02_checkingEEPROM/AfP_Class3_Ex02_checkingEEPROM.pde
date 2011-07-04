/*
 
 This is code to demonstrate how you'd check your eeprom for errors 
 before you use it. Also shows use of a case statement and overloading
 functions.
 
 see: http://arduino.cc/en/Tutorial/SwitchCase
 
 This version was for Class 3 of the Arduino for Programmers course taught at 
 CRASH Space in October, 2010 based and the examples that came with the eeprom
 library. 
 
 The Circuit:
  *Nothing, It's all Serial. 
  
 The Behavior:
   Prints out everything that is in eeprom to the serial monitor in the format 
   you prefer (base 10, base 2, base 16, base 8) 
   
   First run a print out to see the current state of the eeprom
   then O everything and check again
   then set all to 255/0xFF/b11111111
   
   always write to eeprom in a controlled situation. You have a limited
   number of times to write to any given address (around 100k)
 
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

  //SETUP STEP TWO: DO I write anthing to the eeprom?
  //eepromClear();          // B. Then clear the eeprom, leave A on
  //eepromSetAll(0xFF);     // C. Then write to the eeprom, leave A on turn off B
  
  //SETUP STEP THREE: What's in my eeprom?
  eepromPrintAll(10);        // A. run this first  alone
  
  //and if you find any errors, you can save which 
  //locations are bad in your EEPROM!
}

void loop()
{
  //nothing here...
}




