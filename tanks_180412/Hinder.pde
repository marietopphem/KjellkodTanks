class Hinder {
  PImage img;
  PVector position;
  PVector velocity = new PVector(0, 0);
  PVector hitArea;
  float diameter, radius, m;
  
  Hinder(int posx, int posy) {
    this.img = loadImage("tree01_v2.png");
    this.position = new PVector(posx, posy);
    this.hitArea = new PVector(posx, posy); // Kanske inte kommer att användas.
    this.diameter = this.img.width/2;
    this.radius = diameter/2;
    this.m = radius*.1;
  }
  
  void checkBoundaryCollision() {
    
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }
  
  void checkCollision(Tank other) {
    

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = radius + other.radius;

    if (distanceVectMag < minDistance) {
      println("collision Tank");
      
    }
    
  }
  
  void display() {
    fill(204, 102, 0, 100);
    int diameter = this.img.width/2;
     ellipse(this.position.x, this.position.y, diameter, diameter);
    image(img, this.position.x, this.position.y);
   
    
  }
}
