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
  }
  
  void moveForward(){
    if(!checkCollisions(this)){
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
