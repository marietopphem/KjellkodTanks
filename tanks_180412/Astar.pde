import java.util.PriorityQueue;
public class Astar{

   GridSquare goal;
   GridSquare start;
   
  PriorityQueue<GridSquare>  openList;
  ArrayList<GridSquare>  closedList;
  ArrayList<GridSquare>  obs;
  ArrayList<GridSquare> path;
  int gResult;
  GridSquare[][] matrix;
   
   public Astar(GridSquare goal){
     this.goal = goal;
 openList = new PriorityQueue<GridSquare>();
  closedList = new ArrayList<GridSquare>();
  obs = new ArrayList<GridSquare>();
 path = new ArrayList<GridSquare>();
 matrix = new GridSquare[800][800];
    for(int i = 0;i<782;i+=20){
      for(int j= 0;j<782;j+=20)
        matrix[i][j] = new GridSquare(i,j,0,0,null,goal);
    } 
      /*for(int i = 100;i<501;i+=20)
        obs.add(matrix[i][500]);
      for(int i = 40;i<501;i+=20)
        obs.add(matrix[520][i]);
        for(int i = 200;i<501;i+=20)
        obs.add(matrix[100][i]);
        */
        for(Hinder h : allaHinder){
          GridSquare temp = convertToGrid(h.position);
          for(int i = -40;i<41;i+=20)
            for(int j = -40;j<41; j += 20)
          obs.add(matrix[temp.x+j][temp.y+i]);
          
        }
   }
   
 

    //System.out.println("UnvisitedPositions: " + unvisitedPositions);
  ArrayList<GridSquare> aStarSearch(int x,int y,GridSquare goal){
    GridSquare start = matrix[x][y];
    GridSquare res = aStarSearch2(start,goal);
    if(res!=null){
    for(GridSquare g = res; g.parent!=null;g=g.parent){
      path.add(g);
      gResult += g.val;
      //System.out.println(g.val);
      
      
    }
    }
    else{
      System.out.println("sorry");
    }
    System.out.println(gResult);
    System.out.println(path.size());
    return path;
  }
  
  GridSquare aStarSearch2(GridSquare start,GridSquare goal){
    this.goal = goal;
    this.start = start;
    start.setGoal(goal);
    openList.add(start);
    //boolean found = false;
    while(!openList.isEmpty()){
      GridSquare current = openList.poll();
      closedList.add(current);
      if(current.equals(goal)){
        System.out.println("yes");
        
        return current;
        
      }
      current.addNeighbors(matrix);
      for(GridSquare g:current.neighbor){
        //Thread.sleep(1);
        if(g!= null){
        if(!closedList.contains(g) &&!obs.contains(g)){
          
            if(current.gTot+g.g<g.gTot || !openList.contains(g)){
              System.out.print("nino");
              g.setgTot(current.gTot+g.g);
              g.setParent(current);
              g.val = g.g;
              if(!openList.contains(g))
                openList.add(g);
            }
          
       
           
             
           
             
            
            
           
          
        }
        }
      }
       /* for(GridSquare g:current.neighbor2){
        //Thread.sleep(1);
         if(g!= null){
        if(!closedList.contains(g) &&!obs.contains(g)){
          if(openList.contains(g)){
            if(current.gTot+28<g.gTot){
              System.out.print("YESYES");
              g.setgTot(current.gTot+28);
              g.setParent(current);
              openList.remove(g);
              openList.add(g);
            }
          }
         else{
           
           g.g = 28;
           g.setgTot(current.gTot+28);
           g.setParent(current);
           openList.add(g);
             
           }
             
            
            
           
          
        }
       
      }
        }*/
    }
    return null;
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
  void draw(){
    for(GridSquare g:openList){
      fill(255,255,0);
      rect(g.x,g.y,20,20);
    }
    for(GridSquare g:closedList){
      fill(255,0,0);
      rect(g.x,g.y,20,20);
    }
    for(GridSquare g:obs){
      fill(0,0,0);
      rect(g.x,g.y,20,20);
    }
    for(GridSquare g:path){
      fill(0,255,255);
      rect(g.x,g.y,20,20);
    }
    
    fill(0,255,0);
    rect(goal.x,goal.y,20,20);
    fill(255,0,255);
    rect(start.x,start.y,20,20);
    
  }
}
