
//-------------------------------------------------------------------- BYTE ARRAYS
//------------------------------------------------------------------ arrayPrintAll
void arrayPrintAll(byte * sourceArray, int arrayLength) {
  arrayPrintAll(sourceArray, arrayLength, 10);
}

void arrayPrintAll(byte * sourceArray, int arrayLength, int outputType) {
  Serial.println();
  for (int i = 0; i < arrayLength; i++) {
    arrayPrintValueAtLocation(sourceArray, i, outputType);
    //for the humans 
    //delay(200);
  }
  Serial.println();
}

//------------------------------------------------------ arrayPrintValueAtLocation
void arrayPrintValueAtLocation(byte * sourceArray, int address) {
  arrayPrintValueAtLocation(sourceArray, address, 10);
}

void arrayPrintValueAtLocation(byte * sourceArray, int address, int outputType) {

  byte value = sourceArray[address];

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



