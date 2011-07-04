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
 
 */
 //----------------------------------------------------  AfP Note!
 //processing also uses a library, but you need to import it.
 //you should look into how your own favorite language handles
 //serial connections. Check the playground...
import processing.serial.*;     // import the Processing serial library

//-----------------------------------------------------  AfP Note!
//Instantiate and example of the Serial Class
Serial myPort;                  // The serial port

float bgcolor;			     // Background color
float fgcolor;			     // Fill color
float xpos, ypos;		             // Starting position of the ball

void setup() {
  size(640,480);

  // List all the available serial ports
  println(Serial.list());

  // I know that the first port in the serial list on my mac
  // is always my  Arduino module, so I open Serial.list()[0].
  // Change the 0 to the appropriate number of the serial port
  // that your microcontroller is attached to.
  myPort = new Serial(this, Serial.list()[0], 9600);
  // -----------------------------------------------------  AfP Note!
  // PCS it tends to by last, most machines have no more than 5
  // so you can get away with trial and error, really.


  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil('\n');
  // -----------------------------------------------------  AfP Note!
  // i.e. look for the end of of one message b/c you know that
  // next byte is going to be the start of the next one.
}

// -----------------------------------------------------  AfP Note!
// This is processing's main loop for putting things on the screen
void draw() {
  background(bgcolor);
  fill(fgcolor);
  // Draw the shape
  ellipse(xpos, ypos, 20, 20);
  // -----------------------------------------------------  AfP Note!
  //the below line writes an ellipse to the screen at a hard postion
  //for trouble shooting. 
 //ellipse(30, 300, 20, 20);
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

    // split the string at the commas
    // and convert the sections into integers:
    int sensors[] = int(split(myString, ','));

    // print out the values you got:
    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t"); 
    }
    // add a linefeed after all the sensor values are printed:
    println();
    
    // -----------------------------------------------------  AfP Note!
    //if I have sensor data, 
    if (sensors.length > 1) {
      // -----------------------------------------------------  AfP Note!
      //if you were going to fix the maping on the processing side
      //you'd do it here. In this case the outside limit for the 
      //ypos is mapped to the processing keyword hieght which holds the
      //value forthe size of the window. xpos to the width.
      ypos = map(sensors[0], 0,1023,0,height);
      xpos = map(sensors[1], 0,1023,0,width);
      // -----------------------------------------------------  AfP Note!
      //when the last byte is 1, the ball is white
      //when the last byte is 0, the ball disappears.
      fgcolor = sensors[2] * 255;
    }
  }
}

