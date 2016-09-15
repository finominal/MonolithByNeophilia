class TestMouseAsSensor
{

  void play()
  {
    getMouseAsHand();
    lightUpNearestLED();
  }



  void getMouseAsHand()
  {
     PVector mouseLocation = new PVector(mouseX, mouseY);
     for(int x=0; x<sensorFactory.sensorsXCount; x++)
     {
        for(int y=0; y<sensorFactory.sensorsYCount; y++)
        {
           //get the distance to each sensor, if it is less than the threshold, assume the sensor is on, simulatin a hand
          if(mousePressed == true && mouseLocation.dist(sensorFactory.sensorArrayXY[x][y].worldLocation) < sensorFactory.sensorArrayXY[x][y].factorValue*.7)
          {
            sensorFactory.sensorArrayXY[x][y].on = true;
          }
          else
          {
            sensorFactory.sensorArrayXY[x][y].on = false;
          }
        }
     }
  }

 //this adds a color to the ledArray XY depending on the state of the sensor (in the sensor array (buffer only, not a real sensor read))
    void lightUpNearestLED()
    {
        
      
        for(int x=0; x<sensorFactory.sensorsXCount; x++)
        {
          for(int y=0; y<sensorFactory.sensorsYCount; y++)
          {
              Sensor currentSensor = sensorFactory.sensorArrayXY[x][y];
              if(currentSensor.on == true)
              {
                ledFactory.ledArrayXY[(int)currentSensor.nearestLED.x][(int)currentSensor.nearestLED.y].pixelColor = color(128,0,128);//show purple
              }
           }
        }
        
        ledFactory.drawXYLedsOnSim();
        ledFactory.clearLedColors();
    }
}