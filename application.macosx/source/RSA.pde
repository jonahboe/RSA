import java.math.BigInteger;  // For big integers
import java.util.Random;      // For random big integers
import java.util.*;           // For map class

import controlP5.*;

ControlP5 MenuController;
ControlP5 WindowController;

Menu myMenu = new Menu();
Window myWindow = new Window();

ArrayList<RSAkey> myKeys = new ArrayList<RSAkey>();
int selectedKey = 0;

boolean selecting;
String file;
byte message[];

void setup()
{
  
  // Setup screen
  size(1200, 900);
  
  // Setup our UI
  WindowController = new ControlP5(this);
  MenuController = new ControlP5(this);
  myMenu.setup();
  myWindow.setup();
  
  // Display the title image
  background(217);
  noStroke();
  fill(40);
  rect(300,0,900,height);
  PImage Title = loadImage("title.png");
  image(Title, width/2 - 50, height/2 - 75);
  
}

void draw()
{
}

void controlEvent(ControlEvent theEvent) {
  int i = theEvent.getController().getId();
  if (i >= 0)
    selectedKey = i;
}
