/*
  Blink Three External LEDs in Succession, like a traffic light
 
 Behavior:
 Turns on first LED on for one second, then the second one and then the third, repeatedly.
 
 Circuit:
 * Pin 3: red LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin 5: yellow LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 * Pin 6: green LED, anode to microcontroller, 330 Ohm resistor from 
 cathode to ground
 
 (ADVANCED QUESTION: source or sink)
 
  _________
 |	   |
 | Arduino |
 |    	   |    LED     330 Ohm
 |     PIN3|----(>|)----/\/\/\----|l> GND
 |         | 
 |         |    LED     330 Ohm
 |     PIN5|----(>|)----/\/\/\----|l> GND
 |         |     
 |    	   |    LED     330 Ohm
 |     PIN6|----(>|)----/\/\/\----|l> GND
 |_________|   
 
 
 Carlyn Maw 2013
 
 */
//where the led is
int redLedPin = 6;
int yellowLedPin = 5;
int greenLedPin = 3;

// the setup routine runs once when you press reset:
void setup()   {                
  // initialize the digital pins as an output:
  pinMode(redLedPin, OUTPUT); 
  pinMode(yellowLedPin, OUTPUT); 
  pinMode(greenLedPin, OUTPUT);   

  //make sure everyone starts off
  digitalWrite(greenLedPin, LOW);
  digitalWrite(yellowLedPin, LOW);
  digitalWrite(redLedPin, LOW);
}

// the loop() method runs over and over again,
// as long as the Arduino has power
void loop()                     
{
  digitalWrite(greenLedPin, HIGH);   // set the grenn LED on

  delay(1000);                       // wait for a second
  digitalWrite(greenLedPin, LOW);    // set the grenn LED off
  digitalWrite(yellowLedPin, HIGH);  // set the yellow LED on

  delay(1000);                       // wait for a second
  digitalWrite(yellowLedPin, LOW);   // set the yellow LED off
  digitalWrite(redLedPin, HIGH);     // set the red LED on

  delay(1000);                     // wait for a second
  digitalWrite(redLedPin, LOW);    // set the LED off
  // don't wait to turn the greenlight on

}

