/************************************************************
 * RSAMATH
 *   This class is the roots of the RSAkey class. Its more
 *   of the how things work in the background.
 ************************************************************/
class RSAmath
{
  
  // Some local variables.
  BigInteger myP = BigInteger.ZERO;
  BigInteger myQ = BigInteger.ZERO;
  BigInteger myN = BigInteger.ZERO;
  BigInteger myFi = BigInteger.ZERO;
  
  // Keys : public / private
  BigInteger myE;
  BigInteger myD;
  
  // When default calculations are displayed
  boolean def = false;

  /********************************************************
   * Function for calculating keys.
   ********************************************************/
  void calculateKeys()
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
  
  /********************************************************
   * We gave the calculation for D its own function so that
   * we could just have copies of local variables to use.
   ********************************************************/
  BigInteger calcD(BigInteger fi, BigInteger e)
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
  
  /********************************************************
   * Encrypt a file using key myE
   ********************************************************/
  void encryptFile()
  {
    BigInteger BImessage = new BigInteger(message);
    BigInteger thisE = myKeys.get(selectedKey).myE;
    BigInteger thisN = myKeys.get(selectedKey).myN;
    message = BImessage.modPow(thisE, thisN).toByteArray();
  }
  
  /********************************************************
   * Decrypt a file using key myD
   ********************************************************/
  void decryptFile()
  {
    BigInteger BImessage = new BigInteger(message);
    BigInteger thisD = myKeys.get(selectedKey).myD;
    BigInteger thisN = myKeys.get(selectedKey).myN;
    println(thisD);
    message = BImessage.modPow(thisD, thisN).toByteArray();
  }
  
}
