///When hands touch, colors appear, then fad away

// USES XY LED ARRAY

enum PaintGameState {
  NOTPLAYING,
  PLAYING,
  FADING
}

//class GamePaint
//{
  int scale = 254;
  
  long lastAllFadeTime = millis();
  long quitTime =  millis()+120000;
  
  float influenceRadius = 30;
  
  float hue = 0;
  
  PaintGameState gameState = PaintGameState.NOTPLAYING;
  
  void paintGameplay()
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
  
  void addPaint()
  {
    hue+=2;
    hue = hue % scale;
    
    //foreach sensor
     for(int x=0; x<sensorFactory.sensorsXCount; x++)
     {
        for(int y=0; y<sensorFactory.sensorsYCount; y++)
        {
          if(sensorFactory.sensorArrayXY[x][y].on)
          {

            for(int i=0; i<ledFactory.ledArray.length; i++)
            {
              float distance = sensorFactory.sensorArrayXY[x][y].worldLocation.dist(ledFactory.ledArray[i].worldLocation);
              
              if(distance < influenceRadius) 
              {
                color ccc =  addToColor(ledFactory.ledArray[i].pixelColor, distance); //<>//
                ledFactory.ledArray[i].pixelColor = ccc;
              }
            }
            
          }
        }
     }
      //get distance. Inverse
    
      
  }
  
  
  color addToColor(color c, float distance)
  {
   //add to the hue value, and also to the brightness? 
   color cc = color(hue, 250, constrain( brightness(c) + (distance / 5 / (distance/influenceRadius) ),0,254) );
   
   return cc; //<>//
   //return color(hue(c)+1, 255, brightness(c)+2);
  }
  
   
  void decayPaint()
  {
      for(int i=0; i<ledFactory.ledArray.length; i++)
      {
     
        
        ledFactory.ledArray[i].pixelColor =  
        color(  hue(ledFactory.ledArray[i].pixelColor),
                254,
                brightness(ledFactory.ledArray[i].pixelColor)*.98
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
  
//}