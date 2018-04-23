class Tank{
  float heading;
  float rotationSpeed;
  PVector location;
  PVector velocity;
  PVector acceleration;
  int x;
  int y;
  int size;
  int degrees;
  Turret turret;
  State state;
  float direct;
  
  Tank(int x,int y,int s){
    this.x = x;
    this.y = y;
    this.size = s;
    degrees = 0;
    turret = new Turret(s/2);
    heading = radians(0);
    this.location = new PVector(x, y);
   // this.position_temp = new PVector();
    //this.velocity = new PVector();
    this.acceleration = new PVector();
    rotationSpeed = 0.05;
    state = State.SEARCHING;
    direct = 0;
  }
  void action(){
    switch(state){
      case PASSIVE:
        passive();
        break;
      case SEARCHING:
        searching();
        break;
      case FIGHTING:
        fighting();
        break;
      default:
    }
  }
  
  void passive(){
    if(turret.degrees != radians(70))
      rotateTurretLeft();
    else
      turnRight();
      
  }
  
  boolean checkCollision(){
    if(location.x < width && location.x >0 && location.y < height && location.y >0 && !checkCollisions(this))
      return false;
    
    else
    return true;
  }
  void searching(){
    
    if(!checkCollision()){
     direct = heading;
      moveForward();
    }
    else{
      if(heading < (direct+radians(160)))
        turnRight();
      else{
        fire();
      moveForward();
      print("test");
      }
    } 
      
  }
  void fighting(){
  }
  
  void moveForward(){
    if(!checkCollision()){
    //velocity = new PVector(cos(heading),sin(heading));
    velocity = PVector.fromAngle(this.heading);
    velocity.mult(10);
    location.add(velocity);
    }
    else
      location.sub(velocity);
    
  }
  
  void moveBackwards(){
    
  }
  
  void turnLeft(){
    heading -= rotationSpeed;
  }
  
  void turnRight(){
     heading += rotationSpeed;
  }
  
  void moveRight(){
    this.x++;
  }
  
  void moveLeft(){
    this.x--;
  }
  
  void moveUp(){
    this.y--;
  }
  
  void moveDown(){
    this.y++;
  }
  
  void rotateTurretRight(){
    turret.rotateTurretRight();
  }
  
  void rotateTurretLeft(){
    turret.rotateTurretLeft();
  }
  
  void fire(){
    shoot(location,turret.getDegrees());
  }
  
  
 
  
  void draw(){
    ellipse(location.x,location.y,size,size);
    ellipse(location.x,location.y,size/2,size/2);
    turret.draw(location.x,location.y);
    line(location.x,location.y,location.x+cos(heading)*size,location.y+sin(heading)*size);
  }

}
