
class Sensor extends PVector
{
  boolean on = false;
  PVector factored; 
  
  Sensor(int _x, int _y, int _factorX, int _factorY)
  {
    x = _x;
    y = _y;
    
    factored.x = _x * _factorX;
    factored.y = _y * _factorY;
  }
}

class SensorFactory
{

int sensorsXCount = 10;
int sensorsYCount = 23;
int sensorsPerMux = 15;

int sensorReadOrderIndex[] = {
                              10, 11, 12, 13, 14, 
                               5,  6,  7,  8,  9, 
                               0,  1,  2,  3,  4 
                              };

Sensor sensorArrayXY[][] = new Sensor[sensorsXCount][sensorsYCount];

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
  for( int s = 0; s <sensorsPerMux; s++)
  {
   //send  
  }
  
  
  
}

void InitializeGPIO()
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
  int sensorsXCount = 10;
  int sensorsYCount = 23;
  
  for(int x = 0; x<sensorsXCount;x++)
  {
    for(int y = 0; x<sensorsYCount;y++)
    {
      this.sensorArrayXY[x][y] = new Sensor(x,y, width/sensorsXCount, height/sensorsYCount ); //doubling up on the x/y, but will be useful for calculating distances
    }
  }
}

}