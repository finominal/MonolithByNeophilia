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
        
  ledFactory.clearLedColors();

  for(int i=0; i<ledArray.length; i++)
  {
    float distance = this.dist(ledArray[i].factored);
    
    if(distance<50) ledArray[i].pixelColor = color(brightness-(distance* (brightness/circleDistance)), 0, 0);;
  }
      
  ledFactory.drawLeds();
  
  }
}

 