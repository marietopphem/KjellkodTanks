class Tank {
  int id;
  int team_id;
  Team team;
  PImage img;
  float diameter;
  float radius;
  float rotation_speed;
  float maxspeed;
  
  int health;
  
  PVector hitArea;
  
  PVector startpos = new PVector();
  PVector position_temp = new PVector(); //spara temp senaste pos.
  PVector position = new PVector();
  PVector velocity = new PVector();
  PVector acceleration = new PVector();
  
  // Variable for heading!
  float heading;
  
  boolean moving_backward;
  boolean moving_forward;
  
  boolean hasShot;
  CannonBall ball;

  float s = 2.0;
  float image_scale;
  
  Turret turret;
  
  Tank(int id, Team team, PVector startpos, float diameter, CannonBall ball) {
    println("*** NEW TANK(): [" + team.getId()+":"+id+"]");
    this.id = id;
    this.team = team;
    this.team_id = this.team.getId();
    
    this.startpos.set(startpos);
    this.position.set(this.startpos);
    this.position_temp.set(this.position);
    
    if (this.team.getId() == 0) this.heading = radians(0); // Im used to think in degrees.
    if (this.team.getId() == 1) this.heading = radians(180); // Im used to think in degrees.

    this.moving_backward = false;
    this.moving_forward = false;
    
    this.diameter = diameter;
    this.radius = this.diameter/2; // For hit detection.
    this.ball = ball;
    this.hasShot = false;
    this.maxspeed = 3;
    this.rotation_speed = radians(2);// Im used to think in degrees.
    this.image_scale = 0.5;
    
    //this.img = loadImage("tankBody2.png");
    this.turret = new Turret(this.diameter/2);

    this.radius = diameter/2;
    
    this.health = 3;// 3 är bra, 2 är mindre bra, 1 är immobilized, 0 är oskadliggjord.
    
    this.ball.setColor(this.team.getColor());
    
  }
  
  int getId() {
    return this.id; 
  }
  
  // After calling this method, the tank can shoot.
  void loadShot() {
    println("*** Tank[" + team.getId()+":"+id+"].loadShot() and ready to shoot.");
    //println(this.position);
    this.hasShot = true;
    this.ball.loaded();
  }
  
  void fire() {
    println("*** Tank[" + this.team.getId()+":"+this.id+"].fire()");
   
    if (this.hasShot) {
      println("PANG.");
      this.hasShot = false;
      
      PVector force = PVector.fromAngle(this.heading + this.turret.heading);
      force.mult(10);
      this.ball.applyForce(force);
      
      shoot(this.id); // global funktion i huvudfilen
    }
    else {
      println("You have no shot loaded and ready.");
    }
  }
  
  // Newton's law: F = M * A
  void applyForce(PVector force) {
    //PVector f = force.get(); // old style!
    PVector f = new PVector();
    f.set(force);
    //f.div(mass); // ignoring mass right now
    this.acceleration.add(f);
  }
  
  void turnTurretLeft() {
    this.turret.turnLeft();
  }
  
  void turnTurretRight() {
    this.turret.turnRight();
  }
  
  void turnLeft() {
    this.heading -= rotation_speed;
  }
  
  void turnRight() {
    this.heading += rotation_speed;
  }
  void moveForward() {    
    this.moving_backward = false;
    
    if (!moving_forward){
      this.acceleration.set(0,0,0);
      this.velocity.set(0,0,0);
      this.moving_forward = true;
      
    }
    
    // Offset the angle since we drew the ship vertically
    float angle = this.heading; // - PI/2;
    // Polar to cartesian for force vector!
    PVector force = new PVector(cos(angle),sin(angle));
    force.mult(0.1);
    applyForce(force); 
    
    updatePosition();
    
  }
  void moveBackward() {
    this.moving_forward = false;
    
    if (!moving_backward){
      this.acceleration.set(0,0,0);
      this.velocity.set(0,0,0);
      this.moving_backward = true;
      
    }
    
      // Offset the angle since we drew the ship vertically
      float angle = this.heading - PI; // - PI/2;
      // Polar to cartesian for force vector!
      PVector force = new PVector(cos(angle),sin(angle));
      force.mult(0.1);
      applyForce(force); 
    
    updatePosition();
    
  }
  
  void deaccelarate() {
    this.acceleration.set(0,0,0);
    this.velocity.set(0,0,0);
  }
  
  void updatePosition() {

    this.position_temp.set(this.position); // spara senaste pos.
    
    this.velocity.add(this.acceleration);
    //this.velocity.mult(damping);
    this.velocity.limit(this.maxspeed);
    this.position.add(this.velocity);
    this.acceleration.mult(0);
     
  }
  
  void takeDamage() {
    this.health -= 1;
    if (this.health < 0) {
      this.health = 0;    
    }
    println("Tank[" + team.getId()+":"+id+"] has been hit, health is now "+ this.health);
  }
  
  void drawTank(float x, float y) {
  
    if (this.team.getId() == 0) fill((((255/6) * this.health) *40 ), 50* this.health, 50* this.health, 255 - this.health*60);
    if (this.team.getId() == 1) fill(10*this.health, (255/6) * this.health, (((255/6) * this.health) * 3), 255 - this.health*60);
    
    if (tankInFocus == this.id) { strokeWeight(3); }
    else strokeWeight(1);
    
    ellipse(x,y, 50, 50);
    strokeWeight(2);
    line(x, y, x+25, y);    
  }
  
  void updateLogic() {

    if (this.hasShot) {
      this.ball.updateLoadedPosition(this.position);
    }
  }
 
  void checkEnvironment() {
    // Check for collisions with Canvas Boundaries
    float r = this.diameter/2;
    if ((this.position.y+r > height) || (this.position.y-r < 0) ||
      (this.position.x+r > width) || (this.position.x-r < 0)) {
        this.position.set(this.position_temp); // Flytta tillbaka.
    }
  }
  
  void checkCollision(Hinder other) {
    //println("*** Tank.checkCollision(Hinder)");
    // Check for collisions with "no Smart Objects", Obstacles (trees, etc.)

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, this.position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = this.radius + other.radius;

    if (distanceVectMag < minDistance) {
      println("Tank collided with Hinder, probably a Tree.");
      this.position.set(this.position_temp); // Flytta tillbaka.
      if (this.hasShot) {
        this.ball.updateLoadedPosition(this.position_temp);
      }
    }
  }
  
  void checkCollision(Tank other) {
    //println("*** Tank.checkCollision(Tank)");
    // Check for collisions with "Smart Objects", other Tanks.

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, this.position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = this.radius + other.radius;

    if (distanceVectMag < minDistance) {
      println("Tank" + this.team.getId() + ":"+this.id + " collided with another Tank" + other.team_id + ":"+other.id);
     
      this.position.set(this.position_temp); // Flytta tillbaka.
      if (this.hasShot) {
        this.ball.updateLoadedPosition(this.position_temp);
      }
    }
  }
  
  void display() {
    
    imageMode(CENTER);
    pushMatrix();
    translate(this.position.x, this.position.y);
    
    //scale(image_scale);
    rotate(this.heading);
    
    //image(img, 20, 0);
    drawTank(0,0);
    
    fill(this.team.getColor()); 
    this.turret.display();
   
    popMatrix();        
        

  }
  
  void action(){
    moveForward();
  }
  
  void moveTo(){
  }
}
