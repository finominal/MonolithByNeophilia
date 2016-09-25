Serial sensorSerial; 
int baudRate = 115200;

//String sensorTeensySerialPort = "/dev/tty.usbmodem416271";
String sensorTeensySerialPort = "/dev/tty.usbmodem1895901";
String octoTeensySerialPort = "/dev/tty.usbmodem1017291";

// /dev/tty.usbmodem1895901 <--  sensor teensy
// /dev/tty.usbmodem1017291   <---- octo teensy

//  /dev/tty.usbmodem416271   <---- spare teensy

void serialRequestSensorUpdate()
{
  if(sensorSerial != null)
  {
   
    sensorSerial.write("!");
  }
}

int serialRecieveSensorUpdate()
{
  if(sensorSerial!= null && sensorSerial.available()>0)
  {
    int howManyBytesWereSent = sensorSerial.readBytes(sensorFactory.sensorDataRecieved);
    if(howManyBytesWereSent != sensorFactory.sensorsYCount*2)// double because the array splits x=10 over two bytes.
    {
      return -1; //errror
    }
    return 1; //success, go ahead and use the results
  }
  return 0; //nothing to recieve
  
}

void initializeSensorSerial()
{
  setupSensorSerial(sensorTeensySerialPort);
}

void setupSensorSerial(String portName)
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
  return new Serial(this, name, baudRate);
}


void  displayAvailableSerialPorts()
  {
  String[] list = Serial.list();
  delay(20);
  println("Serial Ports List:");
  println(list);
  
  }