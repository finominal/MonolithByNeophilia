Serial sensorSerial; 

String sensorTeensySerialPort = "ttyAMA0";
String octoTeensySerialPort = "/dev/tty.usbmodem1017291";

void initializeSensorSerial()
{
  setupSerial(sensorTeensySerialPort);
}

void setupSerial(String portName)
{
  try {
     sensorSerial = newSerial( portName);
    if (sensorSerial != null) 
    {
      println("Serial port " + portName + " setup and good to go!");
    }
  } catch (Throwable e) {
    println("Serial port " + portName + " does not exist or is non-functional");
    //errorCount++;
    return;
  }
}

Serial newSerial(String name)
{
  return new Serial(this, name);
}

void  displayAvailableSerialPorts()
  {
  String[] list = Serial.list();
  delay(20);
  println("Serial Ports List:");
  println(list);
  
  }