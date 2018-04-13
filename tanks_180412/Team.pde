class Team {
  
  Tank[] tanks = new Tank[3];
  int id; // team red 0, team blue 1.
  int tank_size;
  PVector tank0_startpos = new PVector();
  PVector tank1_startpos = new PVector();
  PVector tank2_startpos = new PVector();
  
  color team_color;
  
  Team (int team_id, int tank_size, color c,
                      PVector tank0_startpos, int tank0_id, CannonBall ball0,
                      PVector tank1_startpos, int tank1_id, CannonBall ball1,
                      PVector tank2_startpos, int tank2_id, CannonBall ball2) 
  {
    this.id = team_id;
    this.tank_size = tank_size;
    this.team_color = c;
    this.tank0_startpos.set(tank0_startpos);
    this.tank1_startpos.set(tank1_startpos);
    this.tank2_startpos.set(tank2_startpos);
    
    tanks[0] = new Tank(tank0_id, this, this.tank0_startpos, this.tank_size, ball0);
    tanks[1] = new Tank(tank1_id, this, this.tank1_startpos, this.tank_size, ball1);
    tanks[2] = new Tank(tank2_id, this, this.tank2_startpos, this.tank_size, ball2);
    
  }
  
  int getId() {
   return this.id; 
  }
  
  color getColor() {
   return this.team_color; 
  }
  
  void updateLogic() {
    for (int i = 0; i < tanks.length; i++) {
      tanks[i].updateLogic();
    } 
  }
  
}
