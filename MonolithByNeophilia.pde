import processing.io.*;
import processing.serial.*;
import processing.video.*;
import java.awt.Rectangle;

int worldWidth = 300;
int worldHeight = 675;

LedFactory ledFactory;
Octows2811 octows2811;
SensorFactory sensorFactory;

//global objects
GameCircle c;

//global variables
int brightness = 255;
boolean showSim = true;



void setup()
{
  frameRate(60);
  
background(0);
size(300,675);

ledFactory = new LedFactory();
octows2811 = new Octows2811();
sensorFactory = new SensorFactory();

InitializeAllTheThings();

}


void draw()
{
  
//c.play();
playMovie(movies[3]);

println(this.frameRate);
}

void InitializeAllTheThings()
{
  ledFactory.InitializeLedArray();
  sensorFactory.initializeSensorArray(worldWidth, worldHeight);
  InitializeGames();
}


void InitializeGames()
{
  c = new GameCircle();
}