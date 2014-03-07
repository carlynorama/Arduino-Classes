import processing.serial.*;
Serial myPort;        // The serial port
float xPos = 0;             // horizontal position of the graph
 
void setup () {
  size(800, 600);        // window size
 
  // List all the available serial ports
  println(Serial.list());
 
  //String portName = Serial.list()[0];
  String portName = "/dev/tty.usbserial-A800eviD";
  myPort = new Serial(this, portName, 9600);
 
  background(#EDA430);
}
 
void draw () {
  // nothing happens in draw.  It all happens in SerialEvent()
}
 
void serialEvent (Serial myPort) {
  // get the byte:
  int inByte = myPort.read();
  // print it:
  println(inByte);
 
  float yPos = height - inByte;
  // draw the line in a pretty color:
  stroke(#A8D9A7);
  line(xPos, height, xPos, height - inByte);
 
  // at the edge of the screen, go back to the beginning:
  if (xPos >= width) {
    xPos = 0;
    // clear the screen by resetting the background:
    background(#081640);
  }
  else {
    // increment the horizontal position for the next reading:
    xPos++;
  }
}
