class Grid{

int height;
int width;
Astar a;
GridSquare goal;
GridSquare[][] matrix;


Grid(){
 
height = 800;
width = 800;
goal = new GridSquare(540,540);

      
    }
    /*for(int i = 0;i<782;i+=20){
      for(int j= 0;j<782;j+=20)
        matrix[i][j].addNeighbors();
      
    }*/
    
    //a = new Astar(matrix);
    //a.aStarSearch(matrix[200][200],goal);
  
    


void display(){
  
  
  //a.draw();
  
    
}
}
