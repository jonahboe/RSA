/************************************************************
 * RSA 
 *   This is a project for our CS237 class at Brigham Young
 *   University - Idaho. We have created a GUI for encrypting
 *   and decrypting messages using calculated RSA keys.
 *
 * Authors
 *   Jonah Boe
 *   Josh Carmen
 *   Darren Kersey
 ************************************************************/

import java.math.BigInteger;  // For big integers
import java.util.Random;      // For random big integers
import java.util.*;           // For map class
import controlP5.*;           // For the GUI

// Set up some controllers for the GUI
ControlP5 MenuController;
ControlP5 WindowController;

// Set up a side bar and main window
Menu myMenu = new Menu();
Window myWindow = new Window();

// This will hold our keys and track if one is selected.
ArrayList<RSAkey> myKeys = new ArrayList<RSAkey>();
int selectedKey = 0;

// File name, message container, and thread controll.
boolean selecting;
String file;
byte message[];

/************************************************************
 * SETUP
 *   Setup for display size and controller groups.
 ************************************************************/
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

/************************************************************
 * DRAW
 *   As all operations are threaded through the GUI
 *   controllers, a main was not needed.
 ************************************************************/
void draw()
{
}

/************************************************************
 * CONTROLEVENT
 *   Due to problems with knowing which key was selected,
 *   this event listener keeps that data in the "selected"
 *   variable.
 ************************************************************/
void controlEvent(ControlEvent theEvent) {
  int i = theEvent.getController().getId();
  if (i >= 0)
    selectedKey = i;
}
