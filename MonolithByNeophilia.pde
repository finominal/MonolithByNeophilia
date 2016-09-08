import processing.io.*;
import processing.serial.*;
import processing.video.*;
import java.awt.Rectangle;

LedFactory ledFactory;
Octows2811 octows2811;

//global objects
GameCircle c;



//global variables
int brightness = 255;

void setup()
{
  frameRate(60);
 // serialConfigure("/dev/tty.usbmodem1017291");  //Teensy 3.1
  
  
background(0);
size(300,675);

ledFactory = new LedFactory();
 octows2811 = new Octows2811();

InitializeAllTheThings();

octows2811.SetupLedToSerial();

}


void draw()
{
  
//c.play();
playMovie(movies[3]);

println(this.frameRate);
}

void InitializeAllTheThings()
{
  ledFactory.InitializeLedArray(width / 29);
  InitializeGPIO();
  InitializeGameObjects();
}


void InitializeGameObjects()
{
  c = new GameCircle();
}