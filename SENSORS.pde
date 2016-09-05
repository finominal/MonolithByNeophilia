



void InitializeGPIO()
{
  //input for all mux's
  GPIO.pinMode(5, GPIO.INPUT);
  GPIO.pinMode(6, GPIO.INPUT);
  GPIO.pinMode(7, GPIO.INPUT);
  GPIO.pinMode(4, GPIO.INPUT);
  GPIO.pinMode(8, GPIO.INPUT);
  GPIO.pinMode(9, GPIO.INPUT);
  GPIO.pinMode(10, GPIO.INPUT);
  GPIO.pinMode(11, GPIO.INPUT);
  GPIO.pinMode(12, GPIO.INPUT);
  GPIO.pinMode(13, GPIO.INPUT);
  GPIO.pinMode(14, GPIO.INPUT);
  GPIO.pinMode(15, GPIO.INPUT);
  GPIO.pinMode(16, GPIO.INPUT);
  GPIO.pinMode(17, GPIO.INPUT);
  GPIO.pinMode(18, GPIO.INPUT);
  
  //Output for mux select
  GPIO.pinMode(1, GPIO.OUTPUT);
  GPIO.pinMode(2, GPIO.OUTPUT);
  GPIO.pinMode(3, GPIO.OUTPUT);
  GPIO.pinMode(4, GPIO.OUTPUT);

}