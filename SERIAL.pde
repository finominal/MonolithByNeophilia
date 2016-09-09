Serial gpioSerial; 

String gpioSerialPort = "gpidSerial";
String teensySerialPort = "/dev/tty.usbmodem1017291";

void initializeGpioSerial()
{
  gpioSerial = newSerial(gpioSerialPort);
}

Serial newSerial(String portName)
{
  return new Serial(this, portName);
}

void  displayAvailableSerialPorts()
  {
  String[] list = Serial.list();
  delay(20);
  println("Serial Ports List:");
  println(list);
  
  }