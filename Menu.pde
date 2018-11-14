/************************************************************
 * MENU
 *   This class is a sidebar for the GUI.
 ************************************************************/
class Menu
{ 
  // Keep track of current key id.
  int keyCount = 0;
  
  /********************************************************
   * Function for setting up menu
   ********************************************************/
  void setup() {
    MenuController.addButton("NEW")
      .setValue(0)
      .setPosition(50,50)
      .setSize(200,50)
      .setFont(createFont("Arial",20))
      .plugTo(myMenu, "addKey")
      ;
  }
  
  /********************************************************
   * Function for linking keys bac to their button objects
   ********************************************************/
  void linkKey(Object k, String name, int pos)
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
  
  /********************************************************
   * Function for adding a button
   ********************************************************/
  void addKey()
  {
    myWindow.createKeyUI();
  }
  
  /********************************************************
   * Function for selecting one of the keys
   ********************************************************/
  void selectKey(RSAkey passedKey)
  {
    myWindow.selectKeyUI(passedKey);
  }
  
}
