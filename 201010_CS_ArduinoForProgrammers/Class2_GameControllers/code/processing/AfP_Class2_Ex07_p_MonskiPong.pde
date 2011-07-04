/*
  Monski Pong
  Language: Processing

  Uses the values from four sensors to animate a game of pong.
  Expects a serial string from the serial port in the following format:
    leftPaddle,rightPaddle,resetButton,serveButton,linefeed
    leftPaddle: ASCII numeric string from 0 - 1023
    rightPaddle: ASCII numeric string from 0 - 1023
    resetButton: ASCII numeric string from 0 - 1
    serveButton: ASCII numeric string from 0 - 1

    modified 28 Jan 2009 by Tom Igoe
    "Thanks to anonymous reader for the correction"
    
    from http://www.makingthingstalk.com/chapter2/54/
    
    No notes by Carlyn Maw for Arduino for Programmers
    b/c I made no edits and the serial itself works much like Ex 05

*/

import processing.serial.*;      // import the serial library

int linefeed = 10;                  // Linefeed in ASCII
Serial myPort;                      // The serial port

float leftPaddle, rightPaddle;   // variables for the flex sensor values
int resetButton, serveButton;    // variables for the button values
int leftPaddleX, rightPaddleX;   // horizontal positions of the paddles
int paddleHeight = 50;           // vertical dimension of the paddles
int paddleWidth = 10;            // horizontal dimension of the paddles

float leftMinimum = 250;         // minimum value of the left flex sensor
float rightMinimum = 260;        // minimum value of the right flex sensor
float leftMaximum = 450;         // maximum value of the left flex sensor
float rightMaximum = 460;        // maximum value of the right flex sensor

int ballSize = 10;      // the size of the ball
int xDirection = 1;     // the ball’s horizontal direction.
                        // left is –1, right is 1.
int yDirection = 1;     // the ball’s vertical direction.
                        // up is –1, down is 1.
int xPos, yPos;  // the ball's horizontal and vertical positions

boolean ballInMotion = false; // whether the ball should be moving
int leftScore = 0;
int rightScore = 0;

PFont myFont;
int fontSize = 36;

void setup() {
  // set the window size:
  size(640, 480);

  // initialize the ball in the center of the screen:
  xPos = width/2;
  yPos = height/2;

  // List all the available serial ports
  println(Serial.list());

  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 9600);

  // read bytes into a buffer until you get a linefeed (ASCII 10):
  myPort.bufferUntil(linefeed);

  // initialize the sensor values:
  leftPaddle = height/2;
  rightPaddle = height/2;
  resetButton = 0;
  serveButton = 0;

  // initialize the paddle horizontal positions:
  leftPaddleX = 50;
  rightPaddleX = width - 50;

  // set no borders on drawn shapes:
  noStroke();

  // create a font with the second font available to the system:
  PFont myFont = createFont(PFont.list()[2], fontSize);
  textFont(myFont);

  // use rectMode(CENTER) to make collision detection work
  rectMode(CENTER);
}

void draw() {
  background(0);
  // draw the left paddle:
  rect(leftPaddleX, leftPaddle, paddleWidth, paddleHeight);

  // draw the right paddle:
  rect(rightPaddleX, rightPaddle, paddleWidth, paddleHeight);

  // calculate the ball's position and draw it:
  if (ballInMotion == true) {
    animateBall();
  }
  // if the serve button is pressed, start the ball moving:
  if (serveButton == 1) {
    ballInMotion = true;
  }
  // if the reset button is pressed, reset the scores
  // and start the ball moving:
  if (resetButton == 1) {
    leftScore = 0;
    rightScore = 0;
    ballInMotion = true;
  }
  // print the scores:
  text(leftScore, fontSize, fontSize);
  text(rightScore, width-fontSize, fontSize);
}

// serialEvent  method is run automatically by the Processing applet
// whenever the buffer reaches the  byte value set in the bufferUntil()
// method in the setup():

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil(linefeed);

  // if you got any bytes other than the linefeed:
  if (myString != null) {

    myString = trim(myString);
    // split the string at the commas
    //and convert the sections into integers:
    int sensors[] = int(split(myString, ','));
    // if you received all the sensor strings, use them:
    if (sensors.length == 4) {
      // calculate the flex sensors’ ranges:
      float leftRange = leftMaximum - leftMinimum;
      float rightRange = rightMaximum - rightMinimum;

      // scale the flex sensors’ results to the paddles’ range:
      leftPaddle =  height * (sensors[0] - leftMinimum) / leftRange;
      rightPaddle = height * (sensors[1] - rightMinimum) / rightRange;

      // assign the switches’ values to the button variables:
      resetButton = sensors[2];
      serveButton = sensors[3]; 

      // print the sensor values:
      print("left: "+ leftPaddle + "\tright: " + rightPaddle);
      println("\treset: "+ resetButton + "\tserve: " + serveButton);
    }
  }
}
void animateBall() {
  // if the ball is moving left:
  if (xDirection < 0) {
    //  if the ball is to the left of the left paddle:
    if  ((xPos <= leftPaddleX)) {
      // if the ball is in between the top and bottom
      // of the left paddle:
      if((leftPaddle - (paddleHeight/2) <= yPos) &&
        (yPos <= leftPaddle + (paddleHeight /2))) {
        // reverse the horizontal direction:
        xDirection =-xDirection;
      }
    }
  }
  // if the ball is moving right:
  else {
    //  if the ball is to the right of the right paddle:
    if  ((xPos >= ( rightPaddleX + ballSize/2))) {
      // if the ball is in between the top and bottom
      // of the right paddle:
      if((rightPaddle - (paddleHeight/2) <=yPos) &&
        (yPos <= rightPaddle + (paddleHeight /2))) {

        // reverse the horizontal direction:
        xDirection =-xDirection;
      }
    }
  }

  // if the ball goes off the screen left:
  if (xPos < 0) {
    rightScore++;
    resetBall();
  }
  // if the ball goes off the screen right:
  if (xPos > width) {
    leftScore++;
    resetBall();
  }

  // stop the ball going off the top or the bottom of the screen:
  if ((yPos - ballSize/2 <= 0) || (yPos +ballSize/2 >=height)) {
    // reverse the y direction of the ball:
    yDirection = -yDirection;
  }
  // update the ball position:
  xPos = xPos + xDirection;
  yPos = yPos + yDirection;

  // Draw the ball:
  rect(xPos, yPos, ballSize, ballSize);
}

void resetBall() {
  // put the ball back in the center
  xPos = width/2;
  yPos = height/2;
}
