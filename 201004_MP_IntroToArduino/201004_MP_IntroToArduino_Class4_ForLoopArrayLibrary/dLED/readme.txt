This is an example C++ library for Arduino 0018+, by Carlyn Maw based on the example provided

Installation
--------------------------------------------------------------------------------

To install this library, just place this entire folder as a subfolder in your
~/Documents/Arduino/libraries folder for mac My Documents\Arduino\libraries\ for a
PC.

When installed, this library should look like:

Arduino/libraries/dLED              (this library's folder)
Arduino/libraries/dLED/dLED.cpp     (the library implementation file)
Arduino/libraries/dLED/dLED.h       (the library description file)
Arduino/libraries/dLED/keywords.txt (the syntax coloring file)
Arduino/libraries/dLED/examples     (the examples in the "open" menu)
Arduino/libraries/dLED/readme.txt   (this file)

Building
--------------------------------------------------------------------------------

After this library is installed, you just have to start the Arduino application.
You may see a few warning messages as it's built.

To use this library in a sketch, go to the Sketch | Import Library menu and
select dLED.  This will add a corresponding line to the top of your sketch:
#include <dLED.h>

To stop using this library, delete that line from your sketch.

Geeky information:
After a successful build of this library, a new file named "LED.o" will appear
in "Arduino/libraries/dLED". This file is the built/compiled library
code.

If you choose to modify the code for this library (i.e. "LED.cpp" or "LED.h"),
then you must first 'unbuild' this library by deleting the "LED.o" file. The
new "LED.o" with your code will appear after the next press of "verify"

Public Functions
--------------------------------------------------------------------------------

dLED myInstance = dLED(int pinNumber);

	myInstance = some name
	pinNumber = some int representing what pin the LED is attached to
	
	BEHAVIOR: creates instance of a dLED

myInstance.turnOn();

	myInstance = name of dLED instance
	
	BEHAVIOR: turns on dLED of name myInstance

myInstance.turnOff();

	myInstance = name of dLED instance
	
	BEHAVIOR: turns off dLED of name myInstance
	
myInstance.blinkMe(int numberOfTimes);

	myInstance = name of dLED instance
	numberOfTimes = some int representing the number of times you'd like it to blink.
	
	BEHAVIOR: Turns on and then off an LED with a delay of 200ms for both periods. 
	The parameter controls the number of times it blinks.
	
	
	
	



