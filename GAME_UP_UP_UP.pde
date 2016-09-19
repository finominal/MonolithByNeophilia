///When hands touch, colors appear, then goes up into space

// USES XY LED ARRAY


class GameUpUpUp
{
  int scale = 254;
  long lastAllFadeTime = millis();
  long quitTime =  millis()+120000;
  float influenceRadius = 50;
  float hue = 0;
  float decay = 0.99;
  
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
     shiftUp();
     decayPaint();
     addPaint();
     
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
  
     for(int lx=0; lx<xCount; lx++)
      {
          for(int ly=1; ly<yCount; ly++)
          {
              ledFactory.ledArrayXY[lx][ly-1].pixelColor = ledFactory.ledArrayXY[lx][ly].pixelColor;
          }  
          
          ledFactory.ledArrayXY[lx][yCount-1].pixelColor = 0; //clear last row
      } 
  }
  
  
  
  void addPaint()
  {
    hue+=5.3;
    hue = hue % scale;
    
    //foreach sensor
     for(int x=0; x<sensorFactory.sensorsXCount; x++)
     {
        for(int y=0; y<sensorFactory.sensorsYCount; y++)
        {
          //check sensors
          if(sensorFactory.sensorArrayXY[x][y].on)
          {
            
            for(int lx=0; lx<xCount; lx++)
            {
                for(int ly=0; ly<yCount; ly++)
                {
                  float distance = sensorFactory.sensorArrayXY[x][y].worldLocation.dist(ledFactory.ledArrayXY[lx][ly].worldLocation);
                  
                  if(distance < influenceRadius) 
                  {
                    ledFactory.ledArrayXY[lx][ly].pixelColor = addToColor(ledFactory.ledArrayXY[lx][ly].pixelColor, distance);
                  }
                }  
            }
          }
        }
      }
    }
  
  
  color addToColor(color c, float distance)
  {
    
    return color( Math.Avg( , 250, (brightness(c) + ( brightness(c) + (254 - (254 * (distance/influenceRadius) ) ))) /2  );
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