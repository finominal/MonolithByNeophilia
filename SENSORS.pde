

class SensorFactory
{
  
  int sensorsXCount = 10;
  int sensorsYCount = 23;
  int numberOfMuxs  = 16;
  int sensorsPerMux = 15;
  
  int muxChannelReadOrderIndex[] = {
                                10, 11, 12, 13, 14, 
                                 5,  6,  7,  8,  9, 
                                 0,  1,  2,  3,  4 
                                };

  int muxInputPinLeft[] = {4, 17, 27, 22, 6, 13, 19, 26};
  int muxInputPinRight[] = {12, 16, 20, 21, 18, 23, 24, 25};
  
  Sensor sensorArrayXY[][] = new Sensor[sensorsXCount][sensorsYCount];
  PVector readSensor[] = new PVector[230];

  SensorFactory()
  {
    initializeGPIO();
    //initializeGpioSerial(); //turned off until needed on Pi
  }


/*
Reading Sensors happens by settint the INPUT of all muxes together using
the PWM servo ontroller breakout chip. This chip is set at 100 Percent PWM, acting as a buffer.
1 - The Pi sends the numeric number of the pin it wants to set (int/byte)
2 - The teensy listens to its serial input for a channel number to set on the PWM chip.
3 - Teensy commands the PWM breakout chip to set pins via i2c using a library. 
4 - The PWM chip output selects the mux's
5 - Pi reads in all 16 Mux Outputs into a big array. 

It reads all the channel threes of the muxes in one speep, and then selected a differeninput pin, repeat. 
*/

  void readAllSensors()
  {
    //itterate through all 16 channels by setting the input selector for all muxes as defined in the sensorReadOrderIndex
    
    for( int s = 0; s <5; s++) //the first 5 SENSORS ON EACH MUX (SKIP THE FIRST ROW OF THE FIRST TWO MUXS - THEY ARE NOT CONNECTED) 
    {
       //select the first sensor (via index)
       gpioSerial.write(muxChannelReadOrderIndex[s]);
       //delayMicroSeconds(10);
      
      //for each mux, starting at SECOND ROW of muxes, skipping the first
      for(int m = 1; m < muxInputPinLeft.length; m++) //8 not 16! 
      {
          int y = ((s/5) + (m*3)) -1; //each 5 sensors advance y by 1, Each mux advance Y by three
          sensorArrayXY[s][y].on = GPIO.digitalRead( muxInputPinLeft[m]  ) == 0; //reversed output
          sensorArrayXY[s+5][y].on = GPIO.digitalRead( muxInputPinRight[m] ) == 0; //reversed output
       }
    }
    
  
    for( int s = 5; s < sensorsPerMux; s++) //the remaining 10 sensors read as normal
    {
       //select the first sensor (via index)
       gpioSerial.write(muxChannelReadOrderIndex[s]);
       //delayMicroSeconds(10);
      
      //for each mux, starting at SECOND ROW of muxes, skipping the first
      for(int m = 0; m < muxInputPinLeft.length; m++) //8 not 16! 
      {
          int y = ((s/5) + (m*3)) -1 ; //each 5 sensors advance y by 1, Each mux advance Y by three. Minus ONE to start at the second row as ZERO Y. Dont ask. 
          sensorArrayXY[s][y].on = GPIO.digitalRead( muxInputPinLeft[m]  ) == 0; //reversed output
          sensorArrayXY[s+5][y].on = GPIO.digitalRead( muxInputPinRight[m] ) == 0; //reversed output
       }
    }
    
    
  }



  void drawSensorsOnSim()
  {
    if(showSim)
    {

    for(int x=0; x<sensorsXCount; x++)
    {
          for(int y=0; y<sensorsYCount; y++)
    {
      Sensor currentSensor = sensorArrayXY[x][y];
      
      if(currentSensor.on)
      {
        fill(color(0,250,0));
      }
      else
      {
        fill(color(0,120,0));
      }
      ellipse(currentSensor.worldLocation.x, currentSensor.worldLocation.y, 2,2);
    }
  
    }
  }
}








  void initializeGPIO()
  {
    //section1 - LEFT UPPER 
    GPIO.pinMode(4,  GPIO.INPUT);
    GPIO.pinMode(17, GPIO.INPUT);
    GPIO.pinMode(27, GPIO.INPUT);
    GPIO.pinMode(22, GPIO.INPUT);
  
    //section2 - RIGHT UPPER 
    GPIO.pinMode(6,  GPIO.INPUT);
    GPIO.pinMode(13, GPIO.INPUT);
    GPIO.pinMode(19, GPIO.INPUT);
    GPIO.pinMode(26, GPIO.INPUT);
    
    //section3 - LEFT LOWER
    GPIO.pinMode(12, GPIO.INPUT);
    GPIO.pinMode(16, GPIO.INPUT);
    GPIO.pinMode(20, GPIO.INPUT);
    GPIO.pinMode(21, GPIO.INPUT);
    
    //Section 4 - RIGHT LOWER
    GPIO.pinMode(18, GPIO.INPUT);
    GPIO.pinMode(23, GPIO.INPUT);
    GPIO.pinMode(24, GPIO.INPUT);
    GPIO.pinMode(25, GPIO.INPUT);
    
    //Output to select I2C PWM Chip will be via serial on pin 14
    //might need to write high for pullup?
  
  }


  void initializeSensorArray()
  {
    int factorX = width/sensorsXCount;
    int factorY = height/sensorsYCount;
     //<>//
    for(int x = 0; x<sensorsXCount;x++)
    {
      for(int y = 0; y<sensorsYCount;y++)
      {
        this.sensorArrayXY[x][y] = new Sensor(x,y, factorX, factorY ); //doubling up on the x/y, but will be useful for calculating distances
      }
    }
  }
}


class Sensor extends PVector
{
  boolean on = false; //is this inversed
  PVector worldLocation; 
  int factorValue;
  
  Sensor(int _x, int _y, int _factorX, int _factorY)
  {
    x = _x;
    y = _y;
    
    worldLocation = new PVector();
    worldLocation.x = (x * (_factorX-1)) + 13;
    worldLocation.y = (y * (_factorY)) + 13;
    
    factorValue = _factorX;
    
  }
}

//was going to be used for correctly getting sensor data as the physical array was topsy turvey, and missing the first/last row. 
class SensorRead extends PVector
{
  boolean read = false;

  SensorRead(int _x, int _y)
  {
    x = _x;
    y = _y;
  }
}