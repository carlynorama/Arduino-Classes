//-------------------------------------------------------------------EEPROM WRITING
//--------------------------------------------------------------------- eepromClear
void eepromClear() {
  eepromSetAll(0);
}

//--------------------------------------------------------------------- eepromSetAll
void eepromSetAll(byte setValue) {
  for (int i = 0; i < eepromSize; i++) {
    EEPROM.write(i, setValue);
  }
}

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


  Serial.println();
  Serial.print("large: \t");
  Serial.print(largestAddress, DEC);
  Serial.print("\tsmall: \t");
  Serial.print(smallestAddress, DEC);
  Serial.print("\trangeLength: \t");
  Serial.println(rangeLength, DEC);
  Serial.println();

  for (int a = 0; a < rangeLength; a++) {
    currentAddress = startAddress + (a*directionMultiplier);
    destinationArray[a] = EEPROM.read(currentAddress);
    
    Serial.print("destination array pos ");
    Serial.print(a,DEC);
    Serial.print(" loaded with  ");
    Serial.print(destinationArray[a],DEC);
    Serial.print("  from eeprom address ");
    Serial.print(currentAddress,DEC);
    Serial.println();
  }


}








