/*
  Blink
 
Behavior:
Turns on an LED on for one second, then off for one second, repeatedly.
 
 Circuit:
 * Onboard LED connected from digital pin 13 to ground.
 
 * Note: On most Arduino boards, there is already an LED on the board
 connected to pin 13, so you don't need any extra components for this example.
 
 Based on Example Code included w/ Arduino 1.0.5.
 Adapted by Carlyn Maw 2013
 
 */


// the setup routine runs once when you press reset
void setup()   {                
  // initialize the digital pin as an output
  pinMode(13, OUTPUT);     
}

// the loop() method runs over and over again,
// as long as the Arduino has power
void loop()                     
{
  digitalWrite(13, HIGH);   // set the LED on
  delay(1000);                  // wait for a second
  digitalWrite(13, LOW);    // set the LED off
  delay(1000);                  // wait for a second
}
