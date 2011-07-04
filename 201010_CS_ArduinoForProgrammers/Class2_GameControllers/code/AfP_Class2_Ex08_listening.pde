/* 
 
 This code to demonstrates conditional responding to messages recieved
 serially. 
 
 This version was for Class 2 of the Arduino for Programmers course 
 taught at CRASH Space in October, 2010 expanded  from code by Robert 
 Hutchins designed for radio control of servo motors. 
 ( http://www.hutchfx.com/ )
 
 It could be reimplemented with String objects and PROGMEM
 but that could be overkill at this stage, as there is not extensive string
 manipulation going on and we aren't doing anything else with our RAM
 
 See: http://arduino.cc/en/Reference/StringObject 
 And: http://arduino.cc/en/Reference/String
 And: http://arduino.cc/en/Reference/PROGMEM
 
 The Circuit:
 Really, nothing attached but the USB cable so you can use the 
 serial monitor
 
 The Behavior:
 Sketch kicks back various messages depending on what you send it.
 
 Written By: Carlyn Maw based on code by Robert Hutchins
 Updated: October 23 2010
 
 */

//DEFINE: STEP ONE, IS YOUR DEBUG ON AND GLOBAL STATUS VARS
boolean serialListenerFlag = true;
int baudRate = 9600;

//no debug flag since this is pretty much all debug.

//----------------------------------------- VALID VALUES FOR SERIAL IN

//since all these values are going to be used in a case statement
//they must be CONSTANTS.
const byte upSerialCommand = 117;       // send "u" to do up button
const byte downSerialCommand = 100;     // send "d" to do down button
const byte leftSerialCommand = 108;     // send "l" to do left button
const byte rightSerialCommand = 114;    // send "r" to do right button
const byte centerSerialCommand = 99;    // send "c" to do center button
const byte infoSerialCommand = 105;     // send "i" followed by a nuumber to get 
// that number back as ascii.
// see "getParameter() below"

const byte helpSerialCommand = 104;     // "h" for help. see sendSerialHelp() for reply
const byte sysQuerySerialCommand = 113; // "q" to query for board info 

//--------------------------- what do I say if it isn't one of the above?
// board to host serial replies
const char serialInvalidReply[] = {
  "Yeah, no. Try to make some sense next time, will ya?"};

//this is the variable that the "i" condition uses to hold the value
//that will be printed. You cannot define variables within case statements
int printableCharacter;

//------------------------------------------------------------------ START SETUP LOOP

void setup() {
  Serial.begin(baudRate);

}

//------------------------------------------------------------------ START MAIN LOOP
void loop() {
  //Yup. One line in the main loop.
  //If I'm supposed to and it's there, respond to any serial messages
  //that have come in.
  if (serialListenerFlag && Serial.available() > 0) respondToSerial();


}

//------------------------------------------------------------------ END MAIN LOOP

//--------------------------------------------------------- START SERIAL FUNCTIONS

////------------------------------------------------------------ respondToSerial()
void respondToSerial()
{
  //get the first byte in the serial buffer
  int incomingByte = Serial.read();

  //do different things based on it's value..
  switch (incomingByte) {

    //"if the value of the incomingByte is 117 (user typed lowercase u)"  
  case upSerialCommand:
    Serial.println("              _____");
    Serial.println("           __|*****");
    Serial.println("        __|********");
    Serial.println("     __|***********");
    Serial.println("____|**************");
    break;

    //"if the value of the incomingByte is 100 (user typed lowercase d)"   
  case downSerialCommand:
    Serial.println("_____");
    Serial.println("*****|__");
    Serial.println("********|__");
    Serial.println("***********|__");
    Serial.println("**************|____");
    break;

    //"if the value of the incomingByte is 108 (user typed lowercase l)"  
  case leftSerialCommand:
    Serial.println("<-------");
    break;

    //"if the value of the incomingByte is 114 (user typed lowercase r)"  
  case rightSerialCommand:
    Serial.println("-------->");
    break;

    //"if the value of the incomingByte is 99 (user typed lowercase c)"  
  case centerSerialCommand:
    Serial.println("--------> you are here <-------");
    break;

    //"if the value of the incomingByte is 105 (user typed lowercase i)"  
  case infoSerialCommand:

    //getParameter takes the characters following the i,
    //turns them in to a numeric value (base 10)
    //and hands it back. 

    //printAsASCII then prints out a visable ASCII character
    //numbers below the visible range display as !
    //nubers above display as ~
    printAsASCII(getParameter());

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
  Serial.println("");
  Serial.println("Don't know much about History");
  Serial.println("Don't know much Biology");
  Serial.println("Don't know much about a science book");
  Serial.println("Don't know much about the French I took");
  Serial.println("But I do know I've fun things I do");
  Serial.print("And if you type: ");
  Serial.print(upSerialCommand);
  Serial.print(", ");
  Serial.print(downSerialCommand);
  Serial.print(", ");
  Serial.print(leftSerialCommand);
  Serial.print(", ");
  Serial.print(rightSerialCommand);
  Serial.print(", ");
  Serial.print(centerSerialCommand);
  Serial.print(", ");
  Serial.print(infoSerialCommand);
  Serial.print(", ");
  Serial.print(helpSerialCommand);
  Serial.print(" or ");
  Serial.println(sysQuerySerialCommand);
  Serial.println("What a wonderful world this would be");
  Serial.println("");
}

////---------------------------------------------------------END sendSerialHelp()

////------------------------------------------------------------ sendQueryReply()
//this is a good place to return information about the circuit 
//(what is attached to it, etc) and their states/values
void sendQueryReply()
{
  Serial.println("");
  Serial.println("I yam what I yam.. and I don't have anything thing interesting attached to me to\ntell you about yet. You should maybe do someting about that. I'm an ARDUINO! I can\ndo LOTS of neat stuff!");
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
  Serial.print("I heard: ");
  Serial.println(myInfo, DEC);

  //pass the int back to the calling function.
  return myInfo;

}

////-----------------------------------------------------------END getParameter()

////-------------------------------------------------------------- printAsASCII()
void printAsASCII(int myRawValue) {

  int printableCharacter = myRawValue;
  printableCharacter = constrain(printableCharacter,33,126);

  // what happens when you change it to DEC? BIN?
  Serial.println(printableCharacter, BYTE);
}
////-----------------------------------------------------------END printAsASCII()

