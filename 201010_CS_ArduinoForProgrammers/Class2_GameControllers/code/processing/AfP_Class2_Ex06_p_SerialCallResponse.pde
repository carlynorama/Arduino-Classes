/*  
 Serial String Reader
 Language: Processing

 Reads in a string of characters from a serial port until 
 it gets a linefeed (ASCII 10).  Then splits the string into 
 sections separated by commas. Then converts the sections to ints, 
 and prints them out.

 created 2 Jun 2005
 modified 6 Aug 2008
 by Tom Igoe
 
 Notes by Carlyn Maw for Arduino for Programmers
 Highligted by 
 //----------------------------------------------------  AfP Note!
 
 please compare it to Ex05, I've only commented on new stuff.
 
 */

import processing.serial.*;     // import the Processing serial library
Serial myPort;                  // The serial port

float bgcolor;			     // Background color
float fgcolor;			     // Fill color
float xpos, ypos;		             // Starting position of the ball

//-----------------------------------------------------  AfP Note!
//this is new, this program is also going to wait and see if it has someone
//to talk to.
boolean firstContact = false; // Whether we've heard from the microcontroller

void setup() {
  size(640,480);

  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino module, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
}

void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil() 
// method in the setup():

void serialEvent(Serial myPort) { 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);

    // -----------------------------------------------------  AfP Note!
    // this is where firstContact is used. The meat of the program is
    //now wrapped in this if/else statement.  At then end of recieving 
    //the correct first contact string it sends 'A' to the Arduino 
    //program to let that sketch move out of it's "establishContact()"
    //holding pattern.
    
    // if you haven't heard from the microncontroller yet, listen:
    if (firstContact == false) {
      if (myString.equals("hello")) { 
        myPort.clear();          // clear the serial port buffer
        firstContact = true;     // you've had first contact from the microcontroller
        myPort.write('A');       // ask for more
      } 
    } 
    
    // if you have heard from the microcontroller, proceed:
    else {
      // split the string at the commas
      // and convert the sections into integers:
      int sensors[] = int(split(myString, ','));

      // print out the values you got:
      for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
        print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
      }
      // add a linefeed after all the sensor values are printed:
      println();
      if (sensors.length > 1) {
        xpos = map(sensors[0], 0,1023,0,width);
        ypos = map(sensors[1], 0,1023,0,height);
        fgcolor = sensors[2] * 255;
      }
    }
    // when you've parsed the data you have, ask for more:
    myPort.write("A");
    // -----------------------------------------------------  AfP Note!
    //it tells the Arduino when it is READY for more.
  }
}
