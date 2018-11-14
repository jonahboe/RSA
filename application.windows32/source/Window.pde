class Window
{
  
  RSAkey newRSA;
  RSAkey selected = new RSAkey();
  int newPos = 150;
  
  Textfield name;
  Textfield p;
  Textfield q;
  
  Textarea out;
  
  void setup()
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
  
  void createKeyUI()
  {
    clearWindow();
    WindowController.getGroup("newKeyWindow").show();
  }
  void addKey()
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
  
  
  
  void selectKeyUI(RSAkey passedKey)
  {
    selected = passedKey;
    clearWindow();
    WindowController.getGroup("selectKeyWindow").show();
  }
  
  void displayFileUI()
  {
    clearWindow();
    out.setText(new String(message));
    WindowController.getGroup("displayFileWindow").show();
  }
  
  void clearWindow()
  {
    WindowController.getGroup("newKeyWindow").hide();
    WindowController.getGroup("selectKeyWindow").hide();
    WindowController.getGroup("displayFileWindow").hide();

    fill(40);
    rect(300,0,900,height);
  }
  
}
