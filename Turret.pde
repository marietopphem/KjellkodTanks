class Turret{
  int size;
  float degrees;
  float rotationSpeed;
  
  Turret(int size){
    this.size = size;
    degrees = 0;
    rotationSpeed = 0.05;
  }
  
  void rotateTurretRight(){
   degrees += rotationSpeed;
  }
  
  void rotateTurretLeft(){
   degrees -= rotationSpeed;
  }
  
  float getDegrees(){
    return degrees;
  }
  
  
  void draw(float x,float y){
   // float rad = radians(degrees);
    pushMatrix();
    
    //translate(0,0);
    //rotate(rad);
    stroke(0);
    line(x,y,x+cos(degrees)*size,y+sin(degrees)*size);
    popMatrix();
  }
  
}
