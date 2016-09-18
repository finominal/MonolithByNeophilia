///When hands touch, colors appear, then goes up into space

// USES XY LED ARRAY


class GameUpUpUp
{
  int scale = 254;
  long lastAllFadeTime = millis();
  long quitTime =  millis()+120000;
  float influenceRadius = 25;
  float hue = 0;
  float decay = 0.9;
  
  PaintGameState gameState = PaintGameState.NOTPLAYING;
  
  void play()
  {

   if(gameState == PaintGameState.NOTPLAYING) 
   {
     colorMode(HSB,scale);
     
     ledFactory.clearLedColors();
     ledFactory.drawXYLedsOnSim();
    
      println("New Paint Game Started");  // Does not execute
      gameState = PaintGameState.PLAYING;
   }
   else if(gameState == PaintGameState.PLAYING)
   {
     checkSensors();
     decayPaint();
     addPaint();
     shiftUp();
   }
   else if(gameState == PaintGameState.FADING) 
   {
    decayPaint();
  }
  
   //finally always check of the game has ended
   HasGameEnded(); 
   ledFactory.drawLedsOnSim();
   octows2811.pushLedArrayToOctows2811();
   
  }
  
  void checkSensors()
  {
    sensorFactory.readSensors();
    if(mouseSensor) testMouseAsSensor.getMouseAsHand();
  }
  
  void shiftUp()
  {
    
  }
  void addPaint()
  {
    hue+=1;
    hue = hue % scale;
    
    //foreach sensor
     for(int x=0; x<sensorFactory.sensorsXCount; x++)
     {
        for(int y=0; y<sensorFactory.sensorsYCount; y++)
        {
          //check sensors
          if(sensorFactory.sensorArrayXY[x][y].on)
          {
            
            for(int lx=0; lx<ledFactory.ledArray.length; lx++)
            {
                for(int ly=0; y<ledFactory.ledArray.length; y++)
                {
                  float distance = sensorFactory.sensorArrayXY[x][y].worldLocation.dist(ledFactory.ledArray[lx][ly].worldLocation);
                  
                  if(distance < influenceRadius) 
                  {
                    ledFactory.ledArraylx][ly].pixelColor = addToColor(ledFactory.ledArraylx][ly].pixelColor, distance);
                  }
                }  
            }
          }
        }
      }
    }
  
  
  color addToColor(color c, float distance)
  {
    return color(hue, 250, (brightness(c) + (254 - (254 * (distance/influenceRadius)))) /2 );
  }
  
  void decayPaint()
  {
      for(int i=0; i<ledFactory.ledArray.length; i++)
      {
        ledFactory.ledArray[i].pixelColor =  
        color(  hue(ledFactory.ledArray[i].pixelColor),
                254,
                brightness(ledFactory.ledArray[i].pixelColor)*decay
                );
      }
  }

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