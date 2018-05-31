public class GridSquare implements Comparable<GridSquare>{
  
  int x;
  int y;
  int g;
  int val;
  int gTot;
  double hCost;
  double fCost;
  GridSquare parent;
  GridSquare goal;
  ArrayList<GridSquare> neighbor = new ArrayList<GridSquare>();
  //ArrayList<GridSquare> neighbor2 = new ArrayList<GridSquare>();
  
  GridSquare(int x,int y){
    this.x = x;
    this.y = y;
  }
  GridSquare(int x,int y,int gTot,int g, GridSquare parent,GridSquare goal){
    this.x = x;
    this.y = y;
    //this.gTot = gTot+g;
    //this.g = g;
    this.goal = goal;
    //this.parent = parent;
   
    hCost = Math.sqrt(Math.pow(goal.x-x,2)+Math.pow(goal.y-y,2));
    //hCost = Math.abs(goal.x-x)+Math.abs(goal.y-y);
     newfCost();
     
  }
  void newfCost(){
    
     fCost = hCost + gTot;
  }
  void setgTot(int g){
    gTot = g;
    
    newfCost();
  }
  void addNeighbors(GridSquare[][] matrix){
    if(x>19){
     matrix[x-20][y].g = 20;
     neighbor.add(matrix[x-20][y]);
    }
     if(x<761){
       matrix[x+20][y].g = 20;
   neighbor.add(matrix[x+20][y]);
     }
   if(y>19){
     matrix[x][y-20].g = 20;
   neighbor.add(matrix[x][y-20]);
   }
   if(y<761){
     matrix[x][y+20].g = 20;
    neighbor.add(matrix[x][y+20]);
   }
    if(x>19 && y>19){
      matrix[x-20][y-20].g = 28;
    neighbor.add(matrix[x-20][y-20]);
    }
    if(x>19 && y<761){
      matrix[x-20][y+20].g = 28;
    neighbor.add(matrix[x-20][y+20]);
    }
    if(x<761 && y>19){
      matrix[x+20][y-20].g = 28;
    neighbor.add(matrix[x+20][y-20]);
    }
    if(x<761 && y<761){
      matrix[x+20][y+20].g = 28;
    neighbor.add(matrix[x+20][y+20]);
    }
  }
  
  void setGoal(GridSquare goal){
    if(goal != null){
    //hCost = Math.sqrt(Math.pow(goal.x-x,2)+Math.pow(goal.y-y,2));
    hCost = Math.abs(goal.x-x)+Math.abs(goal.y-y);
    newfCost();
    }
  }
 /* ArrayList<GridSquare> neighbors(){
    ArrayList<GridSquare> n = new ArrayList<GridSquare>();
    
    
    return n;
    //if(x>45)
    // if(x>45 && y>45)
    // if(y>45)
    //  if(y>45 && x<755)
    // if(x<755)
    //if(x<755 && y<755)
    //if(y<755)
    //if(x>45 && y<755)
  }*/
  
  /*double eucDist(GridSquare goal){
    return Math.sqrt(Math.pow(goal.x-x,2)+Math.pow(goal.y-y,2));
  }*/
  /*boolean isValid(){
    return x >0 && x<800 && y>0 && y< 800;
  }*/
  
  /*boolean inBounds(){
   return x>45 && x<755 && y>45 && y<755; 
  }*/
  void setfCost(double f){
    fCost = f;
  }
  
  void setParent(GridSquare p){
    parent = p;
  }
  public int compareTo(GridSquare other){
    int i = (int)(fCost-other.fCost);
    return i;
  }
  
  @Override
  public boolean equals(Object o){
    if(o instanceof GridSquare){
      GridSquare other = (GridSquare)o;
      return other.x == this.x && other.y == this.y;
      
    }
    else
      return false;
  }

}
