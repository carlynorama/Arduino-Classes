//DEFINE: STEP ONE, INTPUTS AND THEIR VARIABLES
const int buttonPin = 2;   //the push button
int buttonState = 0;       //what is the push button doing

//DEFINE: STEP TWO, OUTPUTS AND THEIR VARIABLES
const int ledPin = 9;    // the output LED


//------------------------------------------------------------------ START SETUP LOOP
void setup() {
  //SETUP STEP ONE: Set digital pin mode for inputs and their initial conditions
  pinMode(buttonPin, INPUT);
  
  //SETUP STEP TWO: Set digital pin mode for outputs and their initial conditions
  pinMode(ledPin, OUTPUT);
}

//------------------------------------------------------------------- START MAIN LOOP
void loop() {

  //LOOP: STEP ONE, POLL THE ENVIRONMENT
  buttonState = digitalRead(buttonPin);

  //LOOP: STEP TWO, DO SOMETHING ABOUT IT
  digitalWrite(ledPin, buttonState);
}
