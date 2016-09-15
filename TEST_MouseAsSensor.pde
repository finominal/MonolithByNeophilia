class TestMouseAsSensor
{

  void play()
  {
    sensorFactory.DEV_getMouseAsHand();
    sensorFactory.drawSensorsOnSim();
    DEV_LightUpNearestLED();
  }
}