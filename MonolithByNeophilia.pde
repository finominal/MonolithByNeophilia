import processing.io.*;
import processing.serial.*;
import processing.video.*;
import java.awt.Rectangle;


//global objects
GameCircle c;
//LEDFactory ledFactory;

//global variables
int brightness = 255;

void setup()
{
  frameRate(30);
 // serialConfigure("/dev/tty.usbmodem1017291");  //Teensy 3.1
  
  
background(0);
size(300,675);

//ledFactory = new LEDFactory();

InitializeAllTheThings();

//LED_TOSerial
setupLedToSerial();

}


void draw()
{
  
//c.play();
playMovie(movies[0]);
   // drawLeds();
    //image(ledImage[0], 0,0);
   
}

void InitializeAllTheThings()
{
  InitializeLedArray(width / 29);
  InitializeGPIO();
  InitializeGameObjects();
}


void InitializeGameObjects()
{
  c = new GameCircle();
}