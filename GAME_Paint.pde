///When hands touch, colors appear, then fad away

// USES XY LED ARRAY

enum PaintGameState {
  NOTPLAYING,
  PLAYING,
  FADING
}

class GamePaint
{
  long lastAllFadeTime = millis();
  long quitTime =  millis()+120000;
  
  PaintGameState gameState = PaintGameState.NOTPLAYING;
  
  void play()
  {
    ledFactory.clearLedColors();
    ledFactory.drawXYLedsOnSim();
    
   if(gameState == PaintGameState.NOTPLAYING) 
   {
      println("New Paint Game Started");  // Does not execute
     gameState = PaintGameState.PLAYING;
   }
   else if(gameState == PaintGameState.PLAYING)
   {
     checkSensors();
     decayPaint();
     addPaint();
   }
   else if(gameState == PaintGameState.FADING) 
   {
    decayPaint();
  }
  
   //finally always check of the game has ended
   HasGameEnded(); 
    
  }
  
  void checkSensors()
  {
    sensorFactory.readSensors();
    if(mouseSensor) testMouseAsSensor.getMouseAsHand();
  }
  
  void addPaint()
  {
    //foreach sensor
     for(int x=0; x<sensorFactory.sensorsXCount; x++)
     {
        for(int y=0; y<sensorFactory.sensorsYCount; y++)
        {
          Sensor currentSensor = sensorFactory.sensorArrayXY[x][y];
          for(int i=0; i<ledFactory.ledArray.length; i++)
          {
            float distance = currentSensor.dist(ledFactory.ledArray[i].worldLocation);
            
            if(distance<50) ledFactory.ledArray[i].pixelColor = color(brightness-(distance* (brightness/circleDistance)), 0, 0);;
          }
        }
     }
      //get distance. Inverse
  }
   
  void decayPaint()
  {}

  
  boolean AreAllLEDsFaded()
  {
     for(int x=0; x<xCount; x++)
    {
      for(int y=0; y<yCount; y++)
      {
        if(ledFactory.ledArrayXY[x][y].pixelColor >0)
        {
          return false;
        }
      }
    }
    return true;
  }
  
  
  void HasGameEnded()
  {

     if(AreAllLEDsFaded())
     {
        lastAllFadeTime = millis();
     } 
     
     
     
   }
  
}