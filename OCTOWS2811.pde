
class Octows2811
{
  //NOTE Arrays are not needed for the monolith, only one teensy being used. 

  int octoX = 0; 
  int octoY = 0;
  int ledsPerStrip = 0;
  
  int numPorts=0;  // the number of serial ports in use
  int maxPorts=24; // maximum number of serial ports
  float gamma = 1.7;
  
  Serial[] ledSerial = new Serial[maxPorts];     // each port's actual Serial port
  Rectangle[] ledArea = new Rectangle[maxPorts]; // the area of the movie each port gets, in % (0-100)
  boolean[] ledLayout = new boolean[maxPorts];   // layout of rows, true = even is left->right
  PImage[] ledImage = new PImage[maxPorts];      // image sent to each port //interesting! 
  int[] gammatable = new int[256];
  int errorCount=0;
  float framerate=0;

  Octows2811()
  {
    SetupLedToSerial();
  }

  void SetupLedToSerial()
  {
    displayAvailableSerialPorts();
  
    serialConfigure(octoTeensySerialPort);  // change these to your port names
    
      for (int i=0; i < 256; i++) {
      gammatable[i] = (int)(pow((float)i / 255.0, gamma) * 255.0 + 0.5);
    }
  }

void pushLedArrayToOctows2811()
{
  if (errorCount == 0)
  {
  
  byte[] octoData =  new byte[(octoX * octoX * 3) + 3];
  //get the first pixel from each string. 
  int  mask;
  int offset = 0;
  
  //set the headers of the frame
  octoData[0] = '*';  
  offset++;
  
  octoData[1] = 0;
  offset++;
  
  octoData[2] = 0;
  offset++;
  
  //set one set of 8 pixels at a time, with the first bytes in parallel
  color pixel[] = new color[8];
  int sourceIdx = 0;

    for (int x = 0; x < ledsPerStrip; x++) {
      
      for (int i=0; i < 8; i++) {
        // fetch 8 pixels from the image, 1 for each pin
        
          sourceIdx = (ledsPerStrip * i) + x;
          if (sourceIdx > 2000) //if we are outside the main array, blank fill
          {
            pixel[i] = 0;
          }
          else
          {
             pixel[i] = ledFactory.ledArray[sourceIdx].pixelColor;
             pixel[i] = colorWiring(pixel[i]);
          }
        
      }
      // convert 8 pixels to 24 bytes
      for (mask = 0x800000; mask != 0; mask >>= 1) {
        byte b = 0;
        for (int i=0; i < 8; i++) {
          if ((pixel[i] & mask) != 0) b |= (1 << i);
        }
        octoData[offset++] = b;
      }
    }
    ledSerial[0].write(octoData);
  }//error count
} 

//can bypass alot of if we just go with OCTOWS2811 raw
// ask a Teensy board for its LED configuration, and set up the info for it.
void serialConfigure(String portName) {
  if (numPorts >= maxPorts) {
    println("too many serial ports, please increase maxPorts");
    errorCount++;
    return;
  }
  try {
    ledSerial[numPorts] = newSerial( portName);
    if (ledSerial[numPorts] == null) throw new NullPointerException();
    ledSerial[numPorts].write('?');
  } catch (Throwable e) {
    println("Serial port " + portName + " does not exist or is non-functional");
    errorCount++;
    return;
  }
  delay(50);
  String line = ledSerial[numPorts].readStringUntil(10);
  if (line == null) {
    println("Serial port " + portName + " is not responding.");
    println("Is it really a Teensy 3.0 running VideoDisplay?");
    errorCount++;
    return;
  }
  String param[] = line.split(",");
  if (param.length != 12) {
    println("Error: port " + portName + " did not respond to LED config query");
    errorCount++;
    return;
  }
  
  octoX = Integer.parseInt(param[0]); 
  octoY =Integer.parseInt(param[1]);
  ledsPerStrip = octoX * octoY /8;
  
  // only store the info and increase numPorts if Teensy responds properly
  ledImage[numPorts] = new PImage(Integer.parseInt(param[0]), Integer.parseInt(param[1]), RGB);
  ledArea[numPorts] = new Rectangle(Integer.parseInt(param[5]), Integer.parseInt(param[6]),
                     Integer.parseInt(param[7]), Integer.parseInt(param[8]));
  ledLayout[numPorts] = (Integer.parseInt(param[5]) == 0);
  numPorts++;
  println("Setup usb: " + portName);
  println("Leds per strip: " + ledsPerStrip); 
  }
}