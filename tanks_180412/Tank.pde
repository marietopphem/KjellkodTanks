import java.util.Collections;
import java.util.AbstractQueue;
import java.util.LinkedList;
class Tank {
  Astar a;
  boolean crash;
  boolean wait;
  int waitCount;
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
  PVector goal;
  LinkedList<PVector> goals;
  MapHandler mh;
  
  // Variable for heading!
  float heading;
  float oldHeading;
  
  boolean moving_backward;
  boolean moving_forward;
  
  boolean hasShot;
  CannonBall ball;

  float s = 2.0;
  float image_scale;
  
  Turret turret;
  
  State state = State.Search;
  
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
    //goal = new PVector(200,200);
    goals = new LinkedList<PVector>();
    mh = new MapHandler();
    crash = false;
    wait = false;
    waitCount= 0;
    goal = position;
    
    
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
    force.mult(10);
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
      crash = true;
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
      other.crash = true;
      crash = true;
      if (this.hasShot) {
        this.ball.updateLoadedPosition(this.position_temp);
      }
    }
  }
  
  void display() {
    if(a!=null)
    a.draw();
    
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
  void setGoal(PVector pos){
  goal = pos;
  }
  
  
  void action(){
    if(crash == true){
      System.out.println("tjabba");
      PVector temp = goal;
      goals.clear();
      float newX = -1;
      while (newX < 26 ||newX >774)
      newX = position.x+(int)random(200)-100;
      float newY = -1;
      while (newY < 26 ||newX >774)
      newY = position.x+(int)random(200)-100;
      goal = new PVector(newX,newY);
      
      
    }
    /*if(crash == true){
      System.out.println("tjenna");
      if(oldHeading == null)
      oldHeading = heading;
      oldHeading += radians(140+(int)random(80);
      else if (oldHeading - heading > radians(2))
        turnRight();
      else
        
      
      crash = false;*/
    if(wait && position.x < 150 && position.y<350){
      if(waitCount >= 180){
        wait = false;
        waitCount = 0;
        goals.clear();
        agenda();
      }
      else{
        waitCount++;
      }
    } 
    else {
      if(position.x > (width - 126) && position.y > (height-351) || position.x > (width - 151) && position.y > (height-326)) {
      
      goals.clear();
      aStarMove(new PVector(100,100));
      wait = true;
    }
    float diffx = position.x-goal.x;
    float diffy = position.y-goal.y;
    if(Math.abs(diffx) <= 4 && Math.abs(diffy) <= 4 && !crash){
      if(goals.size() > 0)
        goal = goals.poll();
      else
      agenda();
        
      }
      
    else{
    
    moveTo(goal);
    crash = false;
    }
    }
  }
  void aStar(PVector goal){
    
  }
  GridSquare convertToGrid(PVector p){
    int x = int(p.x);
    x = x/20;
    x = x*20;
    int y = int(p.y);
    y = y/20;
    y = y*20;
    return new GridSquare(x,y);
    
  }
  void agenda(){
    PVector goal = mh.method();
    aStarMove(goal);
  }
    
  void aStarMove(PVector p){
    GridSquare goal = convertToGrid(p);
    GridSquare start = convertToGrid(position);
    
    //GridSquare goal2 = new GridSquare(x,y);
    a = new Astar(goal);
    ArrayList<GridSquare> sequence = a.aStarSearch(start.x,start.y,goal);
    Collections.reverse(sequence);
    for(GridSquare g:sequence)
      goals.add(new PVector(g.x,g.y));
    
  }
  void moveTo2(){
    moveTo(new PVector(200,200));
     moveTo(new PVector(400,400));
      moveTo(new PVector(300,500));
       moveTo(new PVector(800,700));
        moveTo(new PVector(400,200));
         moveTo(new PVector(100,200));
  }
  /*void moveTo(PVector pos){
    
      float x = pos.x-position.x;
      float y = pos.y-position.y;
      float tempHeading = 0;
      float tempangle = ((heading+PI/2) % (2*PI));
      if(tempangle < (0))
        tempangle += 2*PI;
    if(Math.abs(x)>4 || Math.abs(y)>4){
      tempHeading = atan(y/x)+PI/2;
      if(x<0)
        tempHeading += PI;
      
      if(tempangle > (tempHeading+radians(1)))
        if(Math.abs(tempangle-tempHeading) < PI  || Math.abs((tempangle-2*PI)-tempHeading) < PI/8)
        turnLeft();
        else
        turnRight();
      else if (tempangle < (tempHeading-radians(1)))
        if(Math.abs(tempHeading-tempangle) < PI || Math.abs(tempHeading-(tempangle+2*PI)) < PI/8)
        turnRight();
        else
        turnLeft();
      else
      moveForward();
       
        
    }
     println(heading);
         println(heading % (2*PI));
         println(tempangle);
        println(tempHeading);
    
  }*/
  void moveTo(PVector pos){
    
    float x = pos.x-position.x;
      float y = pos.y-position.y;
      float angle = 0;
      float tempHeading = (heading+PI/2)%(2*PI);
      if(tempHeading < 0)
        tempHeading += 2*PI;
      if(Math.abs(x)>4 || Math.abs(y)>4){
      angle = atan(y/x) +PI/2;
      if(x<0)
        angle += PI;
         //println(heading);
         //println((heading+PI/2) % (2*PI));
         //println(tempangle);
        //println(tempHeading);
      if(tempHeading > (angle+radians(1)) && (tempHeading-angle) < (PI+radians(2)) || (angle-tempHeading) > (PI+radians(2)) && (angle-tempHeading) < ((2*PI)-radians(1)))
      turnLeft();
      else if (tempHeading < (angle-radians(1)) && (angle-tempHeading) < (PI+radians(2)) || (tempHeading - angle) > (PI+radians(2)) && (tempHeading - angle) < ((2*PI)-radians(1)))
      turnRight();
      else
      moveForward();
      }
      
  }
}
