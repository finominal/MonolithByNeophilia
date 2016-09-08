int circleDistance = 50;

class GameCircle extends PVector
{
   GameCircle()
  {
    x=width/2;
    y=height/2;
  }

void play()
{
  x = mouseX;
  y = mouseY;
        
 // ledFactory. 
  ledFactory.clearLedColors();

  for(int i=0; i<ledFactory.ledArray.length; i++)
  {
    float distance = this.dist(ledFactory.ledArray[i].factored);
    
    if(distance<50) ledFactory.ledArray[i].pixelColor = color(brightness-(distance* (brightness/circleDistance)), 0, 0);;
  }
      
  ledFactory.drawLeds();
  octows2811.pushLedArrayToOctows2811();
  
  }
}

 