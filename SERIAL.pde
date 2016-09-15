Serial gpioSerial; 

String gpioSerialPort = "ttyAMA0";
String teensySerialPort = "/dev/tty.usbmodem1017291";

void initializeGpioSerial()
{
  setupGPIOSerial(gpioSerialPort);
}

void setupGPIOSerial(String portName)
{
  try {
     gpioSerial = newSerial( portName);
    if (gpioSerial != null) 
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