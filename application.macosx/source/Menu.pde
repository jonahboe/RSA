class Menu
{ 
  
  int keyCount = 0;
  
  void setup() {
  
    MenuController.addButton("NEW")
      .setValue(0)
      .setPosition(50,50)
      .setSize(200,50)
      .setFont(createFont("Arial",20))
      .plugTo(myMenu, "addKey")
      ;
      
  }
  
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
  
  void addKey()
  {
    myWindow.createKeyUI();
  }
  
  void selectKey(RSAkey passedKey)
  {
    myWindow.selectKeyUI(passedKey);
  }
  
}
