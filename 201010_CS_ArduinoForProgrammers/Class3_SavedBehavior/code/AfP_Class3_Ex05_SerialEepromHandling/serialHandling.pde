

//----------------------------------------- VALID VALUES FOR SERIAL IN

//since all these values are going to be used in a case statement
//they must be CONSTANTS.
const byte recordSerialCommand = 'r';        // send "r" record to live buffer
const byte doneRecordingSerialCommand = 100; // send "d" done recording to live buffer
const byte playBackSerialCommand = 112;      // send "p" play tune from live buffer
const byte saveSerialCommand = 115;          // send "s" save to write to eeprom and load into eeprom cache buffer
const byte memoryCachePlaySerialCommand = 109;    // send "m" plays eeprom cache buffer
const byte eepromReloadPlaySerialCommand = 101;    // send "e" to reload eeprom to cache buffer
const byte checkValueSerialCommand = 99;     // send "c" followed by a nuumber to get the value at that location
const byte updateValueSerialCommand = 117;   // send "u" followed by a nuumber to update value at that location
// with the current value of the analog sensor 
const byte overwriteActiveSerialCommand = 'o';  //calls

const byte helpSerialCommand = 104;     // "h" for help. see sendSerialHelp() for reply
const byte sysQuerySerialCommand = 113; // "q" to query for board info 

  //this is the variable that the "c" and "u" conditions use to hold the value
  //that is after the command. Variables cannot be defied within case statements
  //so a local holding var can't be defined on the fly.
  int myParameter; //address location, so int

//------------------------------------------ WHAT TO SAY IF IT IS INVALID
const char serialInvalidReply[] = {
  "invalid command"};


//--------------------------------------------------------- START SERIAL FUNCTIONS

////------------------------------------------------------------ respondToSerial()
void respondToSerial()
{
  //get the first byte in the serial buffer
  int incomingByte = Serial.read();

  //do different things based on it's value..
  switch (incomingByte) {

  case recordSerialCommand:
    recordFlag = true;
    break;

  case doneRecordingSerialCommand:
    recordFlag = false;
    break;

  case playBackSerialCommand:
    playFlag = true;
    break;

  case saveSerialCommand:
    Serial.println("saving active sequence to eeprom and eeprom cache buffer...");
    eepromSaveAndReloadCache(activeSequenceArray, maxBufferSize, sequenceEEPROMStartAddress, sequenceEEPROMEndAddress, eepromCacheArray);
    break;

  case memoryCachePlaySerialCommand:
    Serial.println();
    Serial.println("playing eeprom cache buffer");
    playSequence(eepromCacheArray, maxBufferSize);

    break;

  case eepromReloadPlaySerialCommand:
    Serial.println();
    Serial.println("reloading the cache buffer from eeprom and then will play it...");
    eepromLoadIntoArray(sequenceEEPROMStartAddress, sequenceEEPROMEndAddress, eepromCacheArray, maxBufferSize);
    playSequence(eepromCacheArray, maxBufferSize);
    break;


  case checkValueSerialCommand:

    //getParameter() takes the characters following the c,
    //turns them in to a numeric value (base 10)
    //and hands it back. 

    myParameter= getParameter();
    eepromPrintValueAtLocation(myParameter);

    break;

  case updateValueSerialCommand:

    //getParameter() takes the characters following the i,
    //turns them in to a numeric value (base 10)
    //and hands it back. 

    myParameter= getParameter();   
    eepromUpdateValue(myParameter, currentSensorByteValue);  

    break;

  case overwriteActiveSerialCommand: 
    cache2active();
    break; 

    //"if the value of the incomingByte is 104 (user typed lowercase h)"  
  case helpSerialCommand:
    sendSerialHelp();
    break;

    //"if the value of the incomingByte is 113 (user typed lowercase q)"  
  case sysQuerySerialCommand:
    sendQueryReply();
    break;

    //"if the value of the incomingByte is not any of the above" 
  default:
    Serial.println(serialInvalidReply);
    break;
  }

  //clear out the serial buffer because now all the rest is garbage. 
  Serial.flush();
}

////--------------------------------------------------------END respondToSerial()

////------------------------------------------------------------ sendSerialHelp()
void sendSerialHelp()
{
  Serial.println("");
  //normally you'd put something here about what type of commads were possible
  Serial.println("r_ecord, d_one recording, p_play, s_ave to memory\n"
    "m_emory cache playback, e_pprom load to cache then play\n"
    "c_heck the value of a memory location\nu_pdate the value of a memory locaton from current analog reading"
    "h_elp, q_uery  system values");
  Serial.println("");
}

////---------------------------------------------------------END sendSerialHelp()

////------------------------------------------------------------ sendQueryReply()
//this is a good place to return information about the circuit 
//(what is attached to it, etc) and their states/values
void sendQueryReply()
{
  Serial.println("");
  Serial.println("Serial controlled Proto recording engine");
}
////---------------------------------------------------------END sendQueryReply()

////-------------------------------------------------------------- getParameter()
//this function is designed to get the bytes following the 
//the first byte (up to a number defined by "longestParameter" 
//i.e. shorter than the Serial objects, possible buffer which is 128)

//It turns the characters recieved into a number and then 
//Does something with it...

int getParameter()
{
  //array the length of the message you're expecting. 
  const int longestParameter = 5;
  char serialBuffer[longestParameter];

  // the returned variable that should be holding the str -> int info
  int myInfo; 

  //gimme a sec to make sure I've got everyone... 
  //this delay is needed so the case statement sees the i, 
  //and then waits for the rest of the information before 
  //it analyzes it. If you don't have it, it punts the new
  //bytes back to the case statement and throws an error. 
  delay(100);

  //how many more bytes (characters) are in the Serial Buffer?
  int serialChars = Serial.available();

  //in case you got more than the function can chew - a value longer than 5 characters
  if (serialChars > longestParameter) {
    Serial.println("I can't count that high... I'm gonna give you garbage in a minute...");
    //really should do a return at this point passing some 
    //value that would be understood as an error to the 
    //function's caller. 
  }

  // for each byte of available serial
  for (byte i = 0; i <= (serialChars - 1); i ++) { 

    //goes ahead and puts it in the buffer   
    serialBuffer[i] = Serial.read();

    //if it is not a space or a number (avr-libc functions) or the negative sign
    //white space /neg sign at the begining is okay by the strtol that we 
    //will be using later.
    if (!(isdigit(serialBuffer[i]) || isspace(serialBuffer[i]) || serialBuffer[i] == 45)) {
      //error message
      Serial.println(" --- NUMBERS ONLY, Please");
      //AGAIN: should do a return at this point passing some 
      //value that would be understood as an error to the 
      //function's caller. 
    } 
  }

  //turn your char array into a string by adding a null character 
  //at the very end.
  serialBuffer[serialChars] = NULL;

  //strol = C function to convert the string into an integer. 
  //"On success, the function returns the converted integral number as a long int value.
  //If no valid conversion could be performed, a zero value is returned."
  //the big problem: 0 is a valid value for our parameter which is why we checked
  //for valid digit characters before. 
  myInfo = strtol(serialBuffer, NULL, 10);

  //echoing back what I got
  //Serial.print("I heard: ");
  //Serial.println(myInfo, DEC);

  //pass the int back to the calling function.
  return myInfo;

}

////-----------------------------------------------------------END getParameter()



