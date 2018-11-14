import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.math.BigInteger; 
import java.util.Random; 
import java.util.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class RSA extends PApplet {

  // For big integers
      // For random big integers
           // For map class



ControlP5 MenuController;
ControlP5 WindowController;

Menu myMenu = new Menu();
Window myWindow = new Window();

ArrayList<RSAkey> myKeys = new ArrayList<RSAkey>();
int selectedKey = 0;

boolean selecting;
String file;
byte message[];

public void setup()
{
  
  // Setup screen
  
  
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

public void draw()
{
}

public void controlEvent(ControlEvent theEvent) {
  int i = theEvent.getController().getId();
  if (i >= 0)
    selectedKey = i;
}
class RSAkey extends RSAmath
{
  String name = "KEY_" + month() + ":" + day() + "_" +
                hour() + ":" + minute() + ":" + second() + ".k";
  
  RSAkey(){}
  
  RSAkey(String n, int l, BigInteger p, BigInteger q)
  {
    myP = p;
    myQ = q;
    if (n.length() != 0)
      name = n + ".k";
    // Create a button linked to this.
    myMenu.linkKey(this, name, l);
    // Calculate keys
    this.calculateKeys();
  }
  
  public void rootToMenuSelect()
  {
    myMenu.selectKey(this);
  }
  
  public void rootToWindowDislay()
  {
    myWindow.displayFileUI();
  }
  
  public void fileEncrypt()
  {
    // Open the file
    file = null;
    selecting = true;
    selectInput("Select a file to encrypt:", "fileSelect");
    while (selecting) delay(100);
    println(file);
    
    if (file != null)
    {
      message = loadBytes(file);
      // Encrypt file
      this.encryptFile();
      // Display output
      this.rootToWindowDislay();
    }   
    
    
  }
  
  public void fileDecrypt()
  {
    // Open the file
    file = null;
    message = null;
    selecting = true;
    selectInput("Select a file to decrypt:", "fileSelect");
    while (selecting) delay(100);
    println(file);
    
    if (file != null)
    {
      message = loadBytes(file);
      // Decrypt file
      this.decryptFile();
      // Display output
      this.rootToWindowDislay();
    }   
  }
  
  public void saveOut()
  {
    // Select file
    selecting = true;
    selectOutput("Select a location to save:", "fileSelect");
    while (selecting) delay(100);
    println(file);
    
    // Save it
    saveBytes(file, message);
  }
  
}


public void fileSelect(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  }
  else
  {
    println("User selected " + selection.getAbsolutePath());
    file = selection.getAbsolutePath();
  }
  selecting = false;
}
  
class RSAmath
{
  
  BigInteger myP = BigInteger.ZERO;
  BigInteger myQ = BigInteger.ZERO;
  BigInteger myN = BigInteger.ZERO;
  BigInteger myFi = BigInteger.ZERO;
  
  // Keys : public / private
  BigInteger myE;
  BigInteger myD;
  
  // When default calculations are displayed
  boolean def = false;

  public void calculateKeys()
  {
    // If these are defaults 
    if (myP.equals(new BigInteger("11")) && myQ.equals(new BigInteger("5")))
      def = true;
    // Calculate N
    myN = myP.multiply(myQ);
    // Calculate Fi
    myFi = (myP.subtract(BigInteger.ONE)).multiply(myQ.subtract(BigInteger.ONE));
    
    if (def)
      myE = new BigInteger("7");   
    else
    {
      // Calculate public key
      Random randSeed = new Random();
      do 
      {
        myE = new BigInteger(myFi.bitLength(), randSeed);
      }
      // We need 0 < E < Fi who is coprime with Fi
      while (myE.compareTo(BigInteger.ONE) <= 0 || 
             myE.compareTo(myFi) >= 0 || 
            !myE.gcd(myFi).equals(BigInteger.ONE));
      
      // Calculate private key
    }
    
    println("\nCalculating Keys...");
    print(" P: ");println(myP);
    print(" Q: ");println(myQ);
    print(" N: ");println(myN);
    print(" Fi: ");println(myFi);
    print(" E: ");println(myE);
    if (def)
    {  
      println(" Calculating D...");
      println("  Euclidean Algorithm:");
    }
    
    myD = calcD(myFi, myE);
   
  }
  
  
  public BigInteger calcD(BigInteger fi, BigInteger e)
  { 
    // We'll use this at the end
    BigInteger fiConst = fi;
    // Setup a map and vars
    Map<BigInteger, MapSet> EAmap = new HashMap<BigInteger, MapSet>();
    BigInteger EAx, EAy = new BigInteger("0");
    // Euclidean Algorithem
    while (!EAy.equals(new BigInteger("1")))
    {
      // Do the math.
      EAx = fi.divide(e);
      EAy = fi.mod(e);  
      if (def)
      {
        print("   ");print(fi);print(" = ");print(EAx);print("(");print(e);print(") + ");println(EAy);
      }
      
      // Save for later
      MapSet s = new MapSet(fi, e, EAx.multiply(new BigInteger("-1")));
      EAmap.put(EAy, s);
      
      // Swap if needed
      if (!EAy.equals(new BigInteger("1")))
      {
        fi = e;
        e = EAy;
      }
    }
    
    if (def)
      println("  Extended Euclidean Algorithm:");
    
    // Setup a vars
    BigInteger EEAa = EAmap.get(BigInteger.ONE).B;
    BigInteger EEAa2 = EAmap.get(BigInteger.ONE).B2;
    BigInteger EEAb = EAmap.get(BigInteger.ONE).A;
    BigInteger EEAb2 = BigInteger.ONE;
    // Extended Euclidean Algorithem
    for (int i = 0; i < EAmap.size()-1; i++)
    {
      if (def)
      {
        print("   1 = ");print(EEAa2);print("(");print(EEAa);print(") + ");print(EEAb2);print("(");print(EEAb);println(")");
      }
      
      EEAb2 = (EEAa2.multiply(EAmap.get(EEAa).B2)).add(EEAb2);
      EEAa = EAmap.get(EEAa).A;
      
      BigInteger temp = EEAa;
      BigInteger temp2 = EEAa2;
      EEAa = EEAb;
      EEAa2 = EEAb2;
      EEAb = temp;
      EEAb2 = temp2;
    }
    
    // Calculate D
    BigInteger dec = EEAa2.mod(fiConst);
    if (def)
    {
      print("   1 = ");print(EEAa2);print("(");print(EEAa);print(") + ");print(EEAb2);print("(");print(EEAb);println(")");
      println("  Solve For D:");
      print("   D = ");print(EEAa2);print(" mod ");println(fiConst);
      print("   D: ");println(dec);
      println(" Done");
      println("Done\n");
    }
    else
    {
      print(" D: ");println(dec);
      println("Done\n");
    }
    
    // Return value
    return dec;
  }
  
  public void encryptFile()
  {
    BigInteger BImessage = new BigInteger(message);
    BigInteger thisE = myKeys.get(selectedKey).myE;
    BigInteger thisN = myKeys.get(selectedKey).myN;
    message = BImessage.modPow(thisE, thisN).toByteArray();
  }
  
  public void decryptFile()
  {
    BigInteger BImessage = new BigInteger(message);
    BigInteger thisD = myKeys.get(selectedKey).myD;
    BigInteger thisN = myKeys.get(selectedKey).myN;
    println(thisD);
    message = BImessage.modPow(thisD, thisN).toByteArray();
  }
  
}
class Menu
{ 
  
  int keyCount = 0;
  
  public void setup() {
  
    MenuController.addButton("NEW")
      .setValue(0)
      .setPosition(50,50)
      .setSize(200,50)
      .setFont(createFont("Arial",20))
      .plugTo(myMenu, "addKey")
      ;
      
  }
  
  public void linkKey(Object k, String name, int pos)
  {
    MenuController.addButton(name)
       .setValue(0)
       .setPosition(0, pos)
       .setSize(301, 20)
       .setId(keyCount)
       .setFont(createFont("Arial", 12))     
       .plugTo(k, "rootToMenuSelect")
       ;
    keyCount++;
  }
  
  public void addKey()
  {
    myWindow.createKeyUI();
  }
  
  public void selectKey(RSAkey passedKey)
  {
    myWindow.selectKeyUI(passedKey);
  }
  
}
class MapSet
{
  BigInteger A;
  BigInteger B;
  BigInteger B2;
  
  MapSet(BigInteger a, BigInteger b, BigInteger b2)
  {
    A = a;
    B = b;
    B2 = b2;
  }
}
class Window
{
  
  RSAkey newRSA;
  RSAkey selected = new RSAkey();
  int newPos = 150;
  
  Textfield name;
  Textfield p;
  Textfield q;
  
  Textarea out;
  
  public void setup()
  {
    // Tools for adding a key
    Group newKeyWindow = WindowController.addGroup("newKeyWindow");
    name = WindowController.addTextfield("Name")
      .setPosition(350,50)
      .setSize(200,30)
      .setGroup(newKeyWindow)
      .setFont(createFont("Arial", 18))
      .setFocus(true)
      .setColor(color(255))
      ;
    p = WindowController.addTextfield("P")
      .setPosition(350,160)
      .setSize(200,30)
      .setGroup(newKeyWindow)
      .setFont(createFont("Arial", 18))
      .setFocus(false)
      .setColor(color(255))
      ;
    q = WindowController.addTextfield("Q")
      .setPosition(350,270)
      .setSize(200,30)
      .setGroup(newKeyWindow)
      .setFont(createFont("Arial", 18))
      .setFocus(false)
      .setColor(color(255))
      ;
    WindowController.addButton("Add")
      .setValue(0)
      .setPosition(350, 380)
      .setSize(100, 30)
      .setGroup(newKeyWindow)
      .setFont(createFont("Arial", 18))
      .plugTo(myWindow, "addKey")
      ;      
    WindowController.getGroup("newKeyWindow").hide();
    
    // Tools for encryption and decryption
    Group selectKeyWindow = WindowController.addGroup("selectKeyWindow");
    WindowController.addButton("Encrypt")
      .setValue(0)
      .setPosition(width/2 + 15, height/2 - 25)
      .setSize(110, 50)
      .setGroup(selectKeyWindow)
      .setFont(createFont("Arial", 18))
      .plugTo(selected, "fileEncrypt")
      ;
    WindowController.addButton("Decrypt")
      .setValue(0)
      .setPosition(width/2 + 175, height/2 - 25)
      .setSize(110, 50)
      .setGroup(selectKeyWindow)
      .setFont(createFont("Arial", 18))
      .plugTo(selected, "fileDecrypt")
      ;
    WindowController.getGroup("selectKeyWindow").hide();
    
    // Tools for dispalying
    Group displayFileWindow = WindowController.addGroup("displayFileWindow");
    WindowController.addButton("Save")
      .setValue(0)
      .setPosition(width - 120, height - 45)
      .setSize(100, 25)
      .setGroup(displayFileWindow)
      .setFont(createFont("Arial", 18))
      .plugTo(selected, "saveOut")
      ;
    out = WindowController.addTextarea("Output")
      .setPosition(320, 20)
      .setSize(width-340,height-85)
      .setGroup(displayFileWindow)
      .setFont(createFont("arial",12))
      .setLineHeight(14)
      .setColor(color(128))
      .setColorBackground(color(0,100))
      .setColorForeground(color(0,100))
      ;
    WindowController.getGroup("displayFileWindow").hide();
  }
  
  public void createKeyUI()
  {
    clearWindow();
    WindowController.getGroup("newKeyWindow").show();
  }
  public void addKey()
  {
    String newName = name.getText();
    String pp = p.getText();
    String qq = q.getText();
    if (pp.length() == 0)
      pp = "11";
    if (qq.length() == 0)
      qq = "5";
    BigInteger newP = new BigInteger(pp);
    BigInteger newQ = new BigInteger(qq);
    // Reset variables
    name.setText("");
    p.setText("");
    q.setText("");
    // Add key to the list
    if (myKeys.size() < 30)
    {
      RSAkey newRSA = new RSAkey(newName, newPos, newP, newQ);
      newPos += 25;
      myKeys.add(newRSA);
    }
    // Clear the window
    clearWindow();
  }
  
  
  
  public void selectKeyUI(RSAkey passedKey)
  {
    selected = passedKey;
    clearWindow();
    WindowController.getGroup("selectKeyWindow").show();
  }
  
  public void displayFileUI()
  {
    clearWindow();
    out.setText(new String(message));
    WindowController.getGroup("displayFileWindow").show();
  }
  
  public void clearWindow()
  {
    WindowController.getGroup("newKeyWindow").hide();
    WindowController.getGroup("selectKeyWindow").hide();
    WindowController.getGroup("displayFileWindow").hide();

    fill(40);
    rect(300,0,900,height);
  }
  
}
  public void settings() {  size(1200, 900); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "RSA" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
