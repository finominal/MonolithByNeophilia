 //<>//
//import processing.io.*;
import processing.serial.*;
import processing.video.*;
import java.awt.Rectangle;

int worldWidth = 300;
int worldHeight = 675;

LedFactory ledFactory;
Octows2811 octows2811;
SensorFactory sensorFactory;

//global objects
MasterGameState masterGameState;

//Games
GameCircle circleGame;
GamePaint paintGame;
GameUpUpUp upUpUpGame;

//tests
TestMouseAsSensor testMouseAsSensor;
boolean mouseSensor = true;

//global variables
int brightness = 255;
boolean showSim = true;

void setup()
{
  frameRate(60); //???
  
  background(0);
  size(280,640);
   // size(400,900);
    
  ledFactory = new LedFactory();
  octows2811 = new Octows2811();
  sensorFactory = new SensorFactory();
  
  InitializeAllTheThings();

  masterGameState = MasterGameState.UPUPUP;
 //  masterGameState = MasterGameState.MOVIE;
}


void draw()
{
 
 //ChooseGame();
 ActionGame();

 sensorFactory.drawSensorsOnSim();

}



void ActionGame()
{
  
  if(masterGameState == MasterGameState.WAITING)
  {
    println("WaitingState");
    delay(1000);
  }
  else if (masterGameState == MasterGameState.CIRCLE)
  {
    println("Playing Circle");
    circleGame.play();
  }
  else if (masterGameState == MasterGameState.MOVIE)
  {
    playMovie(movies[0]);
  }
  else if (masterGameState == MasterGameState.PAINT)
  {
    paintGame.play();
  }
  else if (masterGameState == MasterGameState.TESTMOUSESENSOR)
  {
    testMouseAsSensor.play();
  }  
  else if (masterGameState == MasterGameState.UPUPUP)
  {
    upUpUpGame.play();
  }  

}


void InitializeAllTheThings()
{
  InitializeGames();
  InitializeTests();
 
}


void InitializeGames()
{
  circleGame = new GameCircle();
  paintGame = new GamePaint();
  upUpUpGame = new GameUpUpUp();
}

void InitializeTests()
{
  testMouseAsSensor = new TestMouseAsSensor();
}