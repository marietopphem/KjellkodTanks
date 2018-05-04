class TankHandler{
  
  int lineOfSight = 200;
  
  
  TankHandler(){
   
    if(objectInSight()){
      if(isTank()){
        if(tankInFireSight()){
          
          goHome();
          
        }
      }
      
      addObjectToMap();
      
    }
    
  }
  
  void radar(){
    
    
  }
  
  void scanner(){
    
    
  
    
    
  }
  
  void addObjectToMap(){
    
    
  }
  
  
  boolean objectInSight(){
    
    boolean Object = false;
    
    
    
    return Object;
    
  }
  
  boolean isTank(){
   
    boolean whatObject = false; 
    
    return whatObject;
  }
  
  boolean inEnemyHomeBase(){
    
    boolean inEnemyBase = false;
    
  
    return inEnemyBase;
  }
  
  boolean tankInFireSight(){
    
    boolean inSight = false;
    
    return inSight;
    
  }
  
  void goHome(){
   
    
    
  }
  
}
