

// To configure this program, edit the following sections:
//
//  1: change myMovie to open a video file of your choice    ;-)
//
//  2: edit the serialConfigure() lines in setup() for your
//     serial device names (Mac, Linux) or COM ports (Windows)
//
//  3: if your LED strips have unusual color configuration,
//     edit colorWiring().  Nearly all strips have GRB wiring,
//     so normally you can leave this as-is.
//
//  4: if playing 50 or 60 Hz progressive video (or faster),
//     edit framerate in movieEvent().


String[] movies = 
{
"/Users/finbot/Documents/Projects/Monolith/Video/FireMonolith.mov",
"/Users/finbot/Documents/Projects/Monolith/Video/ThanksCityBuilders.mov",
"/Users/finbot/Documents/Projects/Monolith/Video/ThanksCityBuilders2.mov",
"/Users/finbot/Documents/Projects/Monolith/Video/ThanksCityBuilders_1.mov",
"/Users/finbot/Documents/Projects/Monolith/Video/Trip1.mov"
};

Movie myMovie; // = new Movie(this, "/Users/finbot/Desktop/Sequence 01.mov");

boolean playingMovie =  false;

void playMovie(String movieFile) {
  
if(!playingMovie)
{
  println("Playing Movie: " + movieFile);
  myMovie = new Movie(this, movieFile);
  myMovie.play();  // start the movie :-)
  playingMovie= true;

  
  //for debugging, force values
  if(octows2811.errorCount > 0)
  {
    octows2811.ledImage[0] = new PImage(yCount,xCount, RGB);
    octows2811.ledArea[0] = new Rectangle(0, 0,yCount,xCount );
  }
}

  if(myMovie.time() ==  myMovie.duration()) //this will stop a second short of the end. 
  {
    gameState = GameState.WAITING;
    println("EndedMovie");
    println("GameState=" + gameState);
    ledFactory.clearLedColors();
    myMovie.stop();
    playingMovie=false;
  }
  
    ledFactory.drawLedsOnSim();
    octows2811.pushLedArrayToOctows2811();
  
}

void movieEvent(Movie m)
{
  //newFrame = true;
   movieToLedFactory( m);
}


 void movieToLedFactory(Movie m)
 {
    m.read();

     //scale the image
    octows2811.ledImage[0].copy(m, 0, 0, m.width, m.height,0, 0, octows2811.ledImage[0].width, octows2811.ledImage[0].height);
                     
    //push to leds
    for(int j = 0; j<ledFactory.ledArray.length;j++)
    {
      int idx = (int)(((xCount -1 - ledFactory.ledArray[j].x) * yCount)+(ledFactory.ledArray[j].y));
       ledFactory.ledArray[j].pixelColor = octows2811.ledImage[0].pixels[idx];
    }

 }

void movieToOcto(Movie m) {
  //this requires that the octo was found on startup, cant debug.
  // read the movie's next frame
  m.read();
  
  //if (framerate == 0) framerate = m.getSourceFrameRate();
  octows2811.framerate = 30.0; // TODO, how to read the frame rate???
  
  for (int i=0; i < octows2811.numPorts; i++) {    
    // copy a portion of the movie's image to the LED image
    int xoffset = percentage(m.width, octows2811.ledArea[i].x);
    int yoffset = percentage(m.height, octows2811.ledArea[i].y);
    int xwidth =  percentage(m.width, octows2811.ledArea[i].width);
    int yheight = percentage(m.height, octows2811.ledArea[i].height);
    octows2811.ledImage[i].copy(m, xoffset, yoffset, xwidth, yheight,
                     0, 0, octows2811.ledImage[i].width, octows2811.ledImage[i].height);
    // convert the LED image to raw data
    byte[] ledData =  new byte[(octows2811.ledImage[i].width * octows2811.ledImage[i].height * 3) + 3];
    image2data(octows2811.ledImage[i], ledData, octows2811.ledLayout[i]);
    if (i == 0) {
      ledData[0] = '*';  // first Teensy is the frame sync master
      int usec = (int)((1000000.0 / octows2811.framerate) * 0.75);
      ledData[1] = (byte)(usec);   // request the frame sync pulse
      ledData[2] = (byte)(usec >> 8); // at 75% of the frame time
    } else {
      ledData[0] = '%';  // others sync to the master board
      ledData[1] = 0;
      ledData[2] = 0;
    }
    // send the raw data to the LEDs  :-)
    octows2811.ledSerial[i].write(ledData); 
  }
}

// image2data converts an image to OctoWS2811's raw data format.
// The number of vertical pixels in the image must be a multiple
// of 8.  The data array must be the proper size for the image.
void image2data(PImage image, byte[] data, boolean layout) {
  int offset = 3;
  int x, y, xbegin, xend, xinc, mask;
  int linesPerPin = image.height / 8;
  int pixel[] = new int[8];
  
  for (y = 0; y < linesPerPin; y++) {
    if ((y & 1) == (layout ? 0 : 1)) {
      // even numbered rows are left to right
      xbegin = 0;
      xend = image.width;
      xinc = 1;
    } else {
      // odd numbered rows are right to left
      xbegin = image.width - 1;
      xend = -1;
      xinc = -1;
    }
    for (x = xbegin; x != xend; x += xinc) {
      for (int i=0; i < 8; i++) {
        // fetch 8 pixels from the image, 1 for each pin
        pixel[i] = image.pixels[x + (y + linesPerPin * i) * image.width];
        pixel[i] = colorWiring(pixel[i]);
      }
      // convert 8 pixels to 24 bytes
      for (mask = 0x800000; mask != 0; mask >>= 1) {
        byte b = 0;
        for (int i=0; i < 8; i++) {
          if ((pixel[i] & mask) != 0) b |= (1 << i);
        }
        data[offset++] = b;
      }
    }
  } 
}

// translate the 24 bit color from RGB to the actual
// order used by the LED wiring.  GRB is the most common.
int colorWiring(int c) {
  int red = (c & 0xFF0000) >> 16;
  int green = (c & 0x00FF00) >> 8;
  int blue = (c & 0x0000FF);
  red = octows2811.gammatable[red];
  green = octows2811.gammatable[green];
  blue = octows2811.gammatable[blue];
  return (green << 16) | (red << 8) | (blue); // GRB - most common wiring
}

// draw runs every time the screen is redrawn - show the movie...
//Not really required for the monolith

void drawMovie() {
  // show the original video
  image(myMovie, 0, 80);
  
  // then try to show what was most recently sent to the LEDs
  // by displaying all the images for each port.
  for (int i=0; i <octows2811. numPorts; i++) {
    // compute the intended size of the entire LED array
    int xsize = percentageInverse(octows2811.ledImage[i].width, octows2811.ledArea[i].width);
    int ysize = percentageInverse(octows2811.ledImage[i].height, octows2811.ledArea[i].height);
    // computer this image's position within it
    int xloc =  percentage(xsize,octows2811.ledArea[i].x);
    int yloc =  percentage(ysize, octows2811.ledArea[i].y);
    // show what should appear on the LEDs
    image(octows2811.ledImage[i], 240 - xsize / 2 + xloc, 10 + yloc);
  } 
}

// scale a number by a percentage, from 0 to 100
int percentage(int num, int percent) {
  double mult = percentageFloat(percent);
  double output = num * mult;
  return (int)output;
}

// scale a number by the inverse of a percentage, from 0 to 100
int percentageInverse(int num, int percent) {
  double div = percentageFloat(percent);
  double output = num / div;
  return (int)output;
}

// convert an integer from 0 to 100 to a float percentage
// from 0.0 to 1.0.  Special cases for 1/3, 1/6, 1/7, etc
// are handled automatically to fix integer rounding.
double percentageFloat(int percent) {
  if (percent == 33) return 1.0 / 3.0;
  if (percent == 17) return 1.0 / 6.0;
  if (percent == 14) return 1.0 / 7.0;
  if (percent == 13) return 1.0 / 8.0;
  if (percent == 11) return 1.0 / 9.0;
  if (percent ==  9) return 1.0 / 11.0;
  if (percent ==  8) return 1.0 / 12.0;
  return (double)percent / 100.0;
}