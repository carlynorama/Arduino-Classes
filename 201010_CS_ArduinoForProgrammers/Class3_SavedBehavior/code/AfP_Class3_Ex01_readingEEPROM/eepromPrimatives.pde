//--------------------------------------------------------------------- eepromClear
void eepromClear() {
  for (int i = 0; i < eepromSize; i++) {
    EEPROM.write(i, 0);
  }
}
//------------------------------------------------------------------ eepromPrintAll
void eepromPrintAll() {
  for (int i = 0; i < eepromSize; i++) {
    eepromPrintValueAtLocation(i);
    //for the humans 
    delay(200);
  }
}

//------------------------------------------------------ eepromPrintValueAtLocation
//Just go get one value at one eeprom address/location/position
//and print it to screen
void eepromPrintValueAtLocation(int address) {
  byte value = EEPROM.read(address);
  Serial.print(address);
  Serial.print("\t");
  Serial.print(value, DEC);
  Serial.println();
}
