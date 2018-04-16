class Shot{
  PVector location;
  PVector location2;
  PVector velocity;
  int duration;
  
  Shot(PVector loc,float degrees){
    location = loc;
    location2 = new PVector(location.x,location.y);
    velocity = PVector.fromAngle(degrees);
    velocity.mult(20);
    duration = 20;
    
  }
  void inMotion(){
   location.add(velocity);
  }
    

  
  void draw(){
    if(duration > 0){
    location2.add(velocity);
    duration--;
    
    ellipse(location2.x,location2.y,30,30);
    }
    ellipse(location.x,location.y,30,30);
    
    
  }
  
}
