    ArrayList<Tank> tanks = new ArrayList<Tank>();
    ArrayList<Shot> shots = new ArrayList<Shot>();
    int currentTank;
    

  void setup(){
  size(800,800);
  tanks.add(new Tank(100,100,100));
  tanks.add(new Tank(100,300,100));
  tanks.add(new Tank(100,500,100));
  currentTank = 0;
  }
  
  void shoot(PVector loc, float degrees){
    Shot s1 = new Shot(loc,degrees);
    //s1.inMotion();
    shots.add(s1);
  }

 

  boolean checkCollisions(Tank tank){
    PVector distance;
    float distanceMag;
    for(Tank t: tanks){
      if(tank != t){
      distance = PVector.sub(tank.location,t.location);
      distanceMag = distance.mag();
      if(distanceMag <= 103)
      return true;
      } 
    }
    return false;
    
    
  }


  void checkCommands(){
    clear();
    background(0,150,0);
    if(keyPressed == true){
      if(keyCode == UP)
         tanks.get(currentTank).moveUp();
      else if(keyCode == DOWN)
         tanks.get(currentTank).moveDown();
      else if(keyCode == LEFT)
         tanks.get(currentTank).moveLeft();
      else if(keyCode == RIGHT)
         tanks.get(currentTank).moveRight();
      else if(key == 'd')
         tanks.get(currentTank).rotateTurretRight();
      else if(key == 'a')
         tanks.get(currentTank).rotateTurretLeft();
      else if(key == 'w')
         tanks.get(currentTank).moveForward();
      else if(key == 's')
         tanks.get(currentTank).moveBackwards();
      else if(key == 'q')
         tanks.get(currentTank).turnLeft();
      else if(key == 'e')
         tanks.get(currentTank).turnRight();
      else if(key == 'f')
         tanks.get(currentTank).fire();
         
      
     
    }
  } 
  
  void keyPressed(){
    if(key == 'h')
      print("YES");
    else if(key == ' '){
         if(currentTank<tanks.size()-1)
         currentTank++;
          else
           currentTank = 0;
    }
  }

void draw() {
  checkCommands();
  //checkCollisions();
  for(int i= 0; i<tanks.size();i++){
    tanks.get(i).draw();
  }
  for(int i= 0; i<shots.size();i++){
    shots.get(i).draw();
  }
    
}
