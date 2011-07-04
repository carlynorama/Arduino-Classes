//-------------------------------------------------------------------EEPROM SETUP
#include <EEPROM.h>
int eepromSize = 512; // 328 has 1k i.e. 1023 but using that 
//will make your code incompatible. 

//-------------------------------------------------------------------EEPROM PRINTING

//------------------------------------------------------------------ eepromPrintAll
void eepromPrintAll() {
  //default is decimal
  eepromPrintAll(10);
}

void eepromPrintAll(int outputType) {
  Serial.println();
  for (int i = 0; i < eepromSize; i++) {
    eepromPrintValueAtLocation(i, outputType);
    //for the humans 
    //delay(200);
  }
  Serial.println();


}
//------------------------------------------------------ eepromPrintValueAtLocation
void eepromPrintValueAtLocation(int address) {

  byte value = EEPROM.read(address);

  //default is decimal
  Serial.print(address);
  Serial.print("\t");
  Serial.print(value, DEC);
  Serial.println();
}

void eepromPrintValueAtLocation(int address, int outputType) {

  byte value = EEPROM.read(address);

  Serial.print(address);
  Serial.print("\t");

  switch (outputType) {
  case 2:
    Serial.print(value, BIN);
    break;
  case 10:
    Serial.print(value, DEC);
    break;
  case 16:
    Serial.print(value, HEX);
    break;
  case 8:
    Serial.print(value, OCT);
    break;
  default:
    Serial.print(value, DEC);
    break;
  }

  Serial.println();
}



//------------------------------------------------------------------ EEPROM 2 ARRAY

//------------------------------------------------------------- eepromLoadIntoArray


//presumes length of array is (endLocation-startLocation + 1) 
void eepromLoadIntoArray(int startAddress, int endAddress, byte * destinationArray, int arraySize) {

  int directionMultiplier; 
  int currentAddress; 

  int largestAddress = max(startAddress, endAddress);
  int smallestAddress = min(startAddress, endAddress);
  int rangeLength = (largestAddress - smallestAddress) + 1;

  //error checking.
  if (arraySize != rangeLength) {
    Serial.print("BAD RANGE: keep it within ");
    Serial.print(arraySize,DEC);
    Serial.println(" values");
    return;
  }

  //am I going up or down?
  if (startAddress == smallestAddress) { 
    directionMultiplier = 1; 
  } 
  else { 
    directionMultiplier = -1; 
  }

  if (debugFlag) {
    Serial.println();
    Serial.print("large: \t");
    Serial.print(largestAddress, DEC);
    Serial.print("\tsmall: \t");
    Serial.print(smallestAddress, DEC);
    Serial.print("\trangeLength: \t");
    Serial.println(rangeLength, DEC);
    Serial.println();
  }
  for (int a = 0; a < rangeLength; a++) {
    currentAddress = startAddress + (a*directionMultiplier);
    destinationArray[a] = EEPROM.read(currentAddress);
    if (debugFlag) {
      Serial.print("destination array pos ");
      Serial.print(a,DEC);
      Serial.print(" loaded with  ");
      Serial.print(destinationArray[a],DEC);
      Serial.print("  from eeprom address ");
      Serial.print(currentAddress,DEC);
      Serial.println();
    }
  }


}

//------------------------------------------------------------------- cache2active
//function for startup only really... will never be needed in normal operation
//but have it as a serial command for programming test case scenarios when using
//the u command.
void cache2active() {
  memcpy(activeSequenceArray, eepromCacheArray, maxBufferSize);
}

//see http://www.nongnu.org/avr-libc/user-manual/group__avr__string.html


//------------------------------------------------------------------ EEPROM WRITING



//--------------------------------------------------------------------- eepromClear
void eepromClear() {
  eepromSetAll(0);
}

//-------------------------------------------------------------------- eepromSetAll
void eepromSetAll(byte setValue) {
  for (int i = 0; i < eepromSize; i++) {
    EEPROM.write(i, setValue);
  }
}

//------------------------------------------------------------------ eepromSetValue
void eepromSetValue(int address, byte setValue) {
  EEPROM.write(address, setValue);
}

//--------------------------------------------------------------- eepromUpdateValue
//same as setValue put with a print statement
void eepromUpdateValue(int address, byte setValue) {
  eepromSetValue(address, setValue);
  eepromPrintValueAtLocation(address);
}


//------------------------------------------------------------- eepromWriteFromArray

//presumes length of array is (endLocation-startLocation + 1) 
void eepromWriteFromArray(byte * destinationArray, int arraySize, int startAddress, int endAddress) {

  int directionMultiplier;
  int currentAddress; 

  int largestAddress = max(startAddress, endAddress);
  int smallestAddress = min(startAddress, endAddress);
  int rangeLength = (largestAddress - smallestAddress) + 1;

  //error check
  if (arraySize != rangeLength) {
    Serial.print("BAD RANGE: keep it within ");
    Serial.print(arraySize,DEC);
    Serial.println(" values");
    return;
  }

  //what direction am I going?
  if (startAddress == smallestAddress) { 
    directionMultiplier = 1; 
  } 
  else { 
    directionMultiplier = -1; 
  }

  //if (debugFlag) {
    Serial.println();
    Serial.print("large: \t");
    Serial.print(largestAddress, DEC);
    Serial.print("\tsmall: \t");
    Serial.print(smallestAddress, DEC);
    Serial.print("\trangeLength: \t");
    Serial.println(rangeLength, DEC);
    Serial.println();
 // }
  for (int a = 0; a < rangeLength; a++) {
    currentAddress = startAddress+ (a*directionMultiplier);
    EEPROM.write(currentAddress, destinationArray[a]);

    if (debugFlag) { 
      Serial.print("destination eeprom address ");
      Serial.print(currentAddress,DEC);
      Serial.print(" loaded with  ");
      //don't use this
      //Serial.print(destinationArray[a],DEC);
      //use the below as a real error check
      Serial.print(EEPROM.read(currentAddress),DEC);
      Serial.print(" from destination array pos ");
      Serial.print(a,DEC);
      Serial.println();
    }
  }


}

//------------------------------------------------------------- eepromSaveAndReloadCache
//is a write from the array, but it additionally handles the idea of caching b/c eeprom 
//is sllllooowww
void eepromSaveAndReloadCache(byte * sourceArray, int arraySize, int startAddress, int endAddress, byte * cacheArray) {
  eepromWriteFromArray(sourceArray, arraySize, startAddress, endAddress);
  eepromLoadIntoArray(startAddress, endAddress, cacheArray, arraySize);

}





