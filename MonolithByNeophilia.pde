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
GameState gameState = GameState.WAITING;

//Games
GameCircle c;

//global variables
int brightness = 255;
boolean showSim = true;



void setup()
{
  frameRate(25); //???
  
background(0);
size(280,640);

ledFactory = new LedFactory();
octows2811 = new Octows2811();
sensorFactory = new SensorFactory();

InitializeAllTheThings();


gameState = GameState.MOVIE;
}


void draw()
{
 
 //ChooseGame();
 ActionGame();

 sensorFactory.drawSensorsOnSim();
}

void ActionGame()
{
  
  if(gameState == GameState.WAITING)
  {
    println("WaitingState");
    delay(1000);
  }
  else if (gameState == GameState.CIRCLE)
  
  {
    println("Playing Circle");
    c.play();
  }
  else if (gameState == GameState.MOVIE)
  {
    playMovie(movies[0]);
  }
}


void InitializeAllTheThings()
{
  ledFactory.InitializeLedArray();
  sensorFactory.initializeSensorArray();
  InitializeGames();
}


void InitializeGames()
{
  c = new GameCircle();
}