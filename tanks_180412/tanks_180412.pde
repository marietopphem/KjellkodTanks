/*
* JUST NU:
*
* KOMMENTARER:
* Kollisionsytan finns kvar under träden, fast de syns inte.
* De tre träden har centrerats något.
* Flyttat ut en del kod från Draw() till egna funktioner istället.
* Ritat ut "hembaser" för tanksen.
* Alla tanks är nu instanser av Tanks
* Klassen Team har tillkommit
* Lagt samlingarna som Array istället för ArrayList, vilket var onödigt de har fast längd.
* Det går nu att manuellt ta över valfri tanks, genom siffertangenterna, markör visar aktuell.
*/

// för ljud
import ddf.minim.*;



// Ljud
Minim minim;
Audio myAudio;
Audio myTank_snd;
AudioPlayer audioBlast;

// Boolean variables connected to keys
boolean left, right, up, down;
boolean fire;
boolean alt_key; // Turning turret, alt+LEFT/RIGHT

color team0Color = color(204, 50, 50, 50);
color team1Color = color(0, 150, 200, 50);

//ArrayList<CannonBall> myShots;
CannonBall[] myShots = new CannonBall[6];

Tank[] team1Tanks = new Tank[3];
Tank[] team2Tanks = new Tank[3];
Tank[] allTanks = new Tank[6]; //6

Team[] teams = new Team[2];

Hinder[] allaHinder = new Hinder[3];//5

Tank myTank1;

int savedTime;
int wait = 3000; //wait 3 sec (reload)
boolean tick;

int tank_size = 50;
// Team0
PVector team0_tank0_startpos;
PVector team0_tank1_startpos;
PVector team0_tank2_startpos;

// Team1
PVector team1_tank0_startpos;
PVector team1_tank1_startpos;
PVector team1_tank2_startpos;

int tankInFocus;


void setup(){
  size(800, 800);
  minim = new Minim(this);
  myAudio = new Audio();
  myTank_snd = new Audio();
  
  //fill(204, 50, 50, 50);
  
  // kommentar: de tre hindren(träden) har centrerats något.
  allaHinder[0] = new Hinder(230, 600);
  allaHinder[1] = new Hinder(280, 220);
  allaHinder[2] = new Hinder(530, 520);
  
  //allaHinder[3] = new Hinder(width-60, 400); // Kom. Detta träd kan eventuellt tillkomma.
  //allaHinder[4] = new Hinder(60, height-400); // Kom. Detta träd kan eventuellt tillkomma.
  
  for (int i = 0; i < myShots.length; i++) {
    myShots[i] = new CannonBall();
  }
  
  // Team0
  team0_tank0_startpos = new PVector(40, 50);
  team0_tank1_startpos = new PVector(40, 150);
  team0_tank2_startpos = new PVector(40, 250);

  // Team1
  team1_tank0_startpos = new PVector(width-40, height-250);
  team1_tank1_startpos = new PVector(width-40, height-150);
  team1_tank2_startpos = new PVector(width-40, height-50);
 
  // nytt Team: id, color, tank0pos, id, shot
  teams[0] = new Team(0, tank_size, team0Color, 
                      team0_tank0_startpos, 0, myShots[0],
                      team0_tank1_startpos, 1, myShots[1],
                      team0_tank2_startpos, 2, myShots[2]);
  
  allTanks[0] = teams[0].tanks[0];
  allTanks[1] = teams[0].tanks[1];
  allTanks[2] = teams[0].tanks[2];
  
  teams[1] = new Team(1, tank_size, team1Color, 
                      team1_tank0_startpos, 3, myShots[3],
                      team1_tank1_startpos, 4, myShots[4],
                      team1_tank2_startpos, 5, myShots[5]);
  
  allTanks[3] = teams[1].tanks[0];
  allTanks[4] = teams[1].tanks[1];
  allTanks[5] = teams[1].tanks[2];
 
  loadShots();
  
  tankInFocus = 0;
  
  savedTime = millis(); //store the current time.
}

void displayHinder() {
  for (int i = 0; i<allaHinder.length; i++) {
    allaHinder[i].display(); 
  }
}

// call to updateLogic() is dispatched to the teams.
void updateTankLogic() {
  teams[0].updateLogic();
  teams[1].updateLogic();
}

void updateShotsLogic() {
  for (int i = 0; i < myShots.length; i++) {
    if ((myShots[i].passedTime > wait) && (!allTanks[i].hasShot)) {
      myShots[i].resetTimer();
      allTanks[i].loadShot();
    }
    myShots[i].update();
  }
}

void checkForCollisionsShots() {
  for (int i = 0; i < myShots.length; i++) {
    if (myShots[i].isInMotion) {
      for (int j = 0; j<allaHinder.length; j++) {
        myShots[i].checkCollision(allaHinder[j]);
      }
     
      for (int j = 0; j < allTanks.length; j++) {
        if (j != allTanks[i].getId()) {
          myShots[i].checkCollision(allTanks[j]);
        }
      }
    }
  }
}

void checkForCollisionsTanks() {
  // Check for collisions with Canvas Boundaries
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].checkEnvironment();
    
    // Check for collisions with "no Smart Objects", Obstacles (trees, etc.)
    /*for (int j = 0; j < allaHinder.length; j++) {
      allTanks[i].checkCollision(allaHinder[j]);
    }
    
    // Check for collisions with "Smart Objects", other Tanks.
    for (int j = 0; j < allTanks.length; j++) {
      if (allTanks[i].getId() != j) {
        allTanks[i].checkCollision(allTanks[j]);
      }
    }*/
  }
}

void updateTanksDisplay() {
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].display();
  }
}

void updateShotsDisplay() {
  for (int i = 0; i < myShots.length; i++) {
    myShots[i].display();
  }
}

void updateStatus() {
  
}

void displayHomeBaseTeam1() {
  strokeWeight(1);
  fill(204, 50, 50, 15);
  rect(0, 0, 150, 350);
}

void displayHomeBaseTeam2() {
  strokeWeight(1);
  fill(0, 150, 200, 15);
  rect(width - 151, height - 351, 150, 350);
}

void draw() {
  // Kommentar: flyttat ut en del i egna funktioner istället.
  background(200);
  ellipse(700,550,20,20);
  
  
  int passedTime = millis() - savedTime;
  
  //check the difference between now and the previously stored time is greater than the wait interval
  if (passedTime > wait){
    
    //savedTime = millis();//also update the stored time
  }
  
  displayHomeBaseTeam1(); 
  displayHomeBaseTeam2();
  displayHinder();
  
  
  checkForKeys();
  
  // UPDATE LOGIC
  updateTankLogic();
  updateShotsLogic();
 
  // CHECK FOR COLLISIONS
  checkForCollisionsShots(); 
  checkForCollisionsTanks();  
  
  // UPDATE DISPLAY
  updateTanksDisplay();  
  updateShotsDisplay();
  
  
  updateStatus();
}

void loadShots() {
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].loadShot();
  }
}

void drawPlayers1(float x, float y) {
  fill(204, 50, 50, 50);
  ellipse(x,y, 50, 50);
  strokeWeight(2);
  line(x, y, x+25, y);
  strokeWeight(1);
  fill(204, 50, 50, 100);
  ellipse(x, y, 25, 25);
  strokeWeight(2);
  line(x, y, x+25, y);
  strokeWeight(1);
}

void displayPlayers2(float x, float y) {
  fill(0, 150, 200, 50);
  ellipse(x,y, 50, 50);
  strokeWeight(2);
  line(x, y, x-25, y);
  strokeWeight(1);
  fill(0, 150, 200, 100);
  ellipse(x, y, 25, 25);
  strokeWeight(2);
  line(x, y, x-25, y);
  strokeWeight(1);
}

void shoot(int id) {
  myAudio.blast();
  myShots[id].isInMotion = true;
  myShots[id].startTimer();
}


void checkForKeys() {
  
  if (alt_key) {
    if (left) {
      allTanks[tankInFocus].turnTurretLeft();
    }
    else if (right) {
      allTanks[tankInFocus].turnTurretRight();
    }
  }
  else if (!alt_key) {
  
    if (left) {
      allTanks[tankInFocus].turnLeft();
    } else if (right) {
      allTanks[tankInFocus].turnRight();
    }
    
    if (up) {
      allTanks[tankInFocus].moveForward();
    } else if (down) {
      allTanks[tankInFocus].moveBackward();
    }
    
   /* if(!(up || down)) {
       allTanks[tankInFocus].deaccelarate();
    }*/
  }
    allTanks[tankInFocus].action();
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode) {
      case LEFT:
        //myTank1_snd.engineStart();
        left = true;
        break;
      case RIGHT:
        //myTank_snd.engineStart();
        right = true;
        break;
      case UP:
        //myTank_snd.engineStart();
        up = true;
        break;
      case DOWN:
        //myTank_snd.engineStart();
        down = true;
        break;
      case ALT:
        // turret.
        alt_key = true;
        break;
    }
  }
  if (key == ' ') {
    allTanks[tankInFocus].fire();
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
      case LEFT:
        //myTank_snd.engineStop();
        left = false;
        break;
      case RIGHT:
        //myTank_snd.engineStop();
        right = false;
        break;
      case UP:
        //myTank_snd.engineStop();
        up = false;
        break;
      case DOWN:
        //myTank_snd.engineStop();
        down = false;
        break;
      case ALT:
        // turret.
        alt_key = false;
    }
  }
}

public void keyTyped() {
  int selectedHint = -1;
  
  switch(key) {
  case '1':
    tankInFocus = 1;
    break;
  case '2':
    tankInFocus = 2;
    break;
  case '3':
    tankInFocus = 3;
    break;
  case '4':
    tankInFocus = 4;
    break;
  case '5':
    tankInFocus = 5;
    break;
  case '0':
    tankInFocus = 0;
    break;
  }
  //println(selectedHint);
  
}
public void mouseClicked(){
   allTanks[tankInFocus].setGoal(new PVector(mouseX,mouseY));
}
