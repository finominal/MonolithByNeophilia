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
long quitTime =  millis();


 PaintGameState gameState = PaintGameState.NOTPLAYING;
  
  void play()
  {
    ledFactory.clearLedColors();
    ledFactory.drawXYLedsOnSim();
    
   if(gameState == PaintGameState.NOTPLAYING) {
  
      println("New Paint Game Started");  // Does not execute
     gameState = PaintGameState.PLAYING;
   }
   else if(gameState == PaintGameState.PLAYING)
   {
      paintArray();
     //paint where sensor on
   }
   else if(gameState == PaintGameState.FADING) 
   {
    fadeArray();
  }
  
   //finally always check of the game has ended
   HasGameEnded(); 
    
  }
  
  void paintArray()
  {
  
  }
  
  void fadeArray()
  {
    
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