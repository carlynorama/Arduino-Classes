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





