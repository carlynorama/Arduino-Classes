/*
Intro to Arduino @ Machine Project April 2010
Carlyn Maw

Starts blinking a different LED pin if the value 
of the sensor excedes a certain value. (300, in this example)
Could be used with a dual-color LED, for example.
*/

//Step 1 Define Pins
const int analogReadPin = 0;
const int ledPinOne = 9;
const int ledPinTwo = 10; //-------------------------- new


//Step 2 - value holders
int sensorValue = 0;       

int currentLED;  //-------------------------- new
int otherLED;    //-------------------------- new

//LED TIMING VARIABLES 
int blinkOnPeriod = 1000;
int blinkState;
long blinkFlipTime;

//GENERAL TIMING VARIABLES 
long lastMillis= 0;
long currentMillis = 0;

//Step 3 - Setup Loop
void setup() {
  //3a - no input declare
  //3b - start serial
  Serial.begin(9600);
  pinMode(ledPinOne, OUTPUT);
  pinMode(ledPinTwo, OUTPUT);


}


void loop() {      
  //Check the Time
  lastMillis = currentMillis; // dumps the time from the last loop into previous holder
  currentMillis = millis();  // refreshes the time

  //Poll the environment
  sensorValue = analogRead(analogReadPin);

  //Serial.println(sensorValue);
  blinkOnPeriod = map(sensorValue, 120, 950 , 70, 2000); // changed

  if (blinkOnPeriod < 300) {  //-------------------------- new
    currentLED = ledPinTwo;
    otherLED = ledPinOne;
  } else {
    currentLED = ledPinOne;
    otherLED = ledPinTwo;
  }
  
  blinkIt(currentLED, blinkOnPeriod); //------------------------Changed
  digitalWrite(otherLED, LOW); //-------------------------- new
} 


//--------------------------------------------------------------- END MAIN LOOP


///----------------------------------------------------------------  BLINK IT.

void blinkIt(int myLED, int myBlinkPeriod) {
  if ((myBlinkPeriod) < (currentMillis- blinkFlipTime)) {
    blinkState ? blinkState=false : blinkState=true;
    blinkFlipTime = currentMillis;       
  }
  //(moving this line outside the if is what makes it update every time)
  digitalWrite(myLED,blinkState); 
}





