// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class CannonBall { 
  // Explosion
  ArrayList<Particle> particles;
  
  PVector position_temp; //spara temp senaste pos.
  // All of our regular motion stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  PVector hitArea;
  float diameter, radius;

  boolean isLoaded;  // The shot is loaded and ready to shoot (visible on screen.)
  boolean isInMotion; // The shot is on its way.
  boolean isExploding;
  boolean isVisible; 

  // Size
  float r = 8;
  
  color my_color;

  float topspeed = 10;
  int savedTime;
  int passedTime;
  boolean isCounting;

  CannonBall() {
    //println("New CannonBall()");
    this.position = new PVector();
    this.position_temp = new PVector();
    this.velocity = new PVector();
    this.acceleration = new PVector();
    this.isInMotion = false;
    this.isCounting = false;
    this.isVisible = true;
    
    //this.diameter = this.img.width/2;
    this.radius = this.r;
    this.isExploding = false;
  }
  
  void setColor(color c) {
    this.my_color = c;
  }

  // Called by tank object.
  void updateLoadedPosition(PVector pvec) {
    //println("*** CannonBall.updateLoadedPosition()");

    this.position.set(pvec);
    this.position_temp.set(this.position);
    if (!this.isVisible) {
      this.isVisible = true;
    }
  }

  // Called by tank object.
  void loaded() {
    println("*** CannonBall.loaded()");
    this.isLoaded = true;
  }

  // Called by tank object, when shooting.
  void applyForce(PVector force) {
    this.acceleration.add(force);
  }
  
  void startTimer() {
    //println("*** CannonBall.startTimer()");
    this.isCounting = true;
    this.savedTime = millis();
    this.passedTime = 0;
    
  }
  
  
  void resetTimer() {
    //println("*** CannonBall.resetTimer()");
    this.isCounting = false;
    this.savedTime = 0;
    this.passedTime = 0;
    
    this.isInMotion = false;
    this.isLoaded = false;
        
    this.velocity.set(0,0,0);
    this.acceleration.set(0,0,0);
  }
  
  void displayExplosion() {
    this.isExploding = true;
    this.isInMotion = false;
    this.isVisible = false;
    
    
    this.particles = new ArrayList<Particle>();
    this.particles.add(new Particle(new PVector(0,0)));
    this.particles.add(new Particle(new PVector(0,0)));
    this.particles.add(new Particle(new PVector(0,0)));
  }
  
    // Standard Euler integration
  void update() { 
    if (this.isInMotion) {
      this.position_temp.set(this.position); // spara senaste pos.
      
      this.velocity.add(this.acceleration);
      this.velocity.limit(this.topspeed);
      this.position.add(this.velocity);
      this.acceleration.mult(0);
      
    }
    
    if (isCounting) {
      this.passedTime = millis() - this.savedTime;
    }
  }
  
  void checkCollision() {
    if (this.isInMotion) {
    }
  }
  
  void checkCollision(Hinder other) {
     if (this.isInMotion) {
        //println("*** Tank.checkCollision(Hinder)");
    
        // Get distances between the balls components
        PVector distanceVect = PVector.sub(other.position, this.position);
    
        // Calculate magnitude of the vector separating the balls
        float distanceVectMag = distanceVect.mag();
    
        // Minimum distance before they are touching
        float minDistance = this.radius + other.radius;
    
        if (distanceVectMag <= minDistance) {
          println("collision Hinder");
          this.position.set(this.position_temp); // Flytta tillbaka.
          //this.acceleration.set(0,0,0);
          //this.velocity.set(0,0,0);
          
          displayExplosion();
          
        }
      }
    }
  
  
  void checkCollision(Tank other) {
    if (this.isInMotion) {
      //println("*** CannonBall.checkCollision(Tank): " + other);
  
      // Get distances between the balls components
      PVector distanceVect = PVector.sub(other.position, this.position);
  
      // Calculate magnitude of the vector separating the balls
      float distanceVectMag = distanceVect.mag();
  
      // Minimum distance before they are touching
      float minDistance = this.radius + other.radius;
  
      if (distanceVectMag < minDistance) {
        println("CannonBall collision Tank");
        this.position.set(this.position_temp); // Flytta tillbaka.
        //this.acceleration.set(0,0,0);
        //this.velocity.set(0,0,0);
        //explosion(this.position);
        other.takeDamage();
        displayExplosion();
        
      }
    }
  }

  void display() { 
      imageMode(CENTER);
      stroke(0);
      strokeWeight(2);
      fill(this.my_color);
      
      pushMatrix();
      translate(this.position.x,this.position.y);
      
      if (this.isExploding) {
        for(int i=0; i < this.particles.size(); i++){
          this.particles.get(i).run();
          if (this.particles.get(i).isDead()) {
            this.isExploding = false;
          }
        }
      }
      else {
        if (!(this.isCounting && !this.isInMotion) && this.isVisible) {
          ellipse(0, 0, this.r*2, this.r*2);
        }
      }
      popMatrix();
      
      // Nedan är bara en nödlösning för att återställa vissa varabler som ändrats i particles.
      fill(this.my_color);
      stroke(0);
      strokeWeight(1);
  }
}
