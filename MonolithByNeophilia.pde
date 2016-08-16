Circle c = new Circle();

void setup()
{
 // serialConfigure("/dev/tty.usbmodem1017291");  //Teensy 3.1
  
background(0);
size(300,675);

InitializeLedArray(width / 29);

}


void draw()
{
  

c.play();

}