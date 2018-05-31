class MapHandler {


  ArrayList<PVector>  unvisitedPositions = new ArrayList<PVector>();

  ArrayList<PVector> visitedPositions = new ArrayList<PVector>();

  int LOS = 200;
  int height = 800;
  int width = 800;

  private PVector tempPos;
  private int tempInt;


  int xBoundLow = (inscribedSquare(LOS)), 
    xBoundHigh = width - inscribedSquare(LOS), 
    yBoundLow = inscribedSquare(LOS), 
    yBoundHigh = height - inscribedSquare(LOS);


  int arrayDepth;

  int insSquareLen = inscribedSquare(LOS);


  MapHandler() {

    createArrayList();
  }


  public int inscribedSquare(int LoS) {


    double inscribedSquare = Math.sqrt((Math.pow(LoS, 2)/2));

    int inscribedTemp = (int) inscribedSquare;

    return inscribedTemp;
  }


  public void createArrayList() {

    for (int i = insSquareLen; i < height; i+=insSquareLen) {
      for (int j = insSquareLen; j < width; j+=insSquareLen) {

        unvisitedPositions.add(new PVector(i, j));
      }
    }

    System.out.println("UnvisitedPositions: " + unvisitedPositions);
  }


  public boolean isEmpty() {

    if (unvisitedPositions.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }


  public PVector getPosition(int i) {

    PVector position = unvisitedPositions.get(i);

    return position;
  }




 /* public void testMethod() {

    createArrayList();

    for (int i = 0; i < 50; i++) {

      if (!isEmpty()) {
        tempPos = getPosition(getRandomInt());

        updateArrayLists();
      } else {
        System.out.println("There are no unvisited positions! The map is explored.");
        break;
      }
    }
  }*/
  
  public PVector method() {

    

   

      if (!isEmpty()) {
        tempPos = getPosition(getRandomInt());

        updateArrayLists();
        return tempPos;
      } else {
        System.out.println("There are no unvisited positions! The map is explored.");
        ArrayList<PVector> temp = unvisitedPositions;
        unvisitedPositions = visitedPositions;
        visitedPositions = temp;
        
        tempPos = getPosition(getRandomInt());

        updateArrayLists();
        return tempPos;
      }
  }

  public void updateArrayLists() {

    System.out.println("tempPos: " + tempPos);

    visitedPositions.add(tempPos);

    System.out.println("visitedPositions: " + visitedPositions);

    unvisitedPositions.remove(tempPos);
  }
  

  public int getRandomInt() {

    System.out.println("unvisitedPositions.size(): " + unvisitedPositions.size());


    tempInt = (int)random(unvisitedPositions.size());

    System.out.println("tempInt: " + tempInt);

    return tempInt;
  }
  
}
