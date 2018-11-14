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
  
  void rootToMenuSelect()
  {
    myMenu.selectKey(this);
  }
  
  void rootToWindowDislay()
  {
    myWindow.displayFileUI();
  }
  
  void fileEncrypt()
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
  
  void fileDecrypt()
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
  
  void saveOut()
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
  
