
//global objects
GameCircle c;
LEDFactory ledFactory;

//global variables
int brightness = 255;

void setup()
{
 // serialConfigure("/dev/tty.usbmodem1017291");  //Teensy 3.1
  
background(0);
size(300,675);

ledFactory = new LEDFactory();
ledFactory.InitializeLedArray(width / 29);

InitializeGameObjects();


}


void draw()
{
  
c.play();

}

void InitializeGameObjects()
{
  c = new GameCircle();
}