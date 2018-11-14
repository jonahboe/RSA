/************************************************************
 * RSAKEY
 *   This class is the larger part of the keys, or where
 *   the keys meet the GUI.
 ************************************************************/
class RSAkey extends RSAmath
{
  // A local variable for the key name
  String name = "KEY_" + month() + ":" + day() + "_" +
                hour() + ":" + minute() + ":" + second() + ".k";
  
  // Default constructor
  RSAkey(){}
  // Non Default constructor
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
  
  /********************************************************
   * Root key selections back to the menu
   ********************************************************/
  void rootToMenuSelect()
  {
    myMenu.selectKey(this);
  }
  
  /********************************************************
   * Root file events to the display window
   ********************************************************/
  void rootToWindowDislay()
  {
    myWindow.displayFileUI();
  }
  
  /********************************************************
   * Function for encrypting files
   ********************************************************/
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
  
  /********************************************************
   * Function for decrypting files
   ********************************************************/
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
  
  /********************************************************
   * Function for saving output.
   ********************************************************/
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

/************************************************************
 * FILESELECT
 *   Function for letting the user select a file using native
 *   folder finder.
 ************************************************************/
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
  
