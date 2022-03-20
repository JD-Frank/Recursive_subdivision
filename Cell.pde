public class Cell{
  PVector a, b, c, d, e, f, center;
  PVector winDims;
  float w, h, relArea;
  int dir, region;
  float squareness;
  float partitions = round(random(2,4));
  float splitDist;
  float squarenessThrehsold = 0.8;
  String winFile;
  String splitMode;
  ArrayList<Cell> offspring = new ArrayList<Cell>();
  color colour = obama[round(random(4))];

  Cell(PVector a_, PVector b_, PVector c_, PVector d_){
    a = a_;
    b = b_;
    c = c_;
    d = d_;
    splitMode = "parent";
    w = abs(PVector.dist(a,b));
    h = abs(PVector.dist(a,d));
    relArea = h*w/(width*height);
    squareness = w/h;
    getDir();
    getCenter();
    getWinFile();
    getWinDims();
  }

  // Display a cell according to teh display mode dispMode
  void display(String dispMode){
    switch(dispMode){
      case"parent":
        noFill();
        stroke(#000000);
        strokeWeight(6);
        beginShape();
        vertex(a.x, a.y);
        vertex(b.x, b.y);
        vertex(c.x, c.y);
        vertex(d.x, d.y);
        endShape(CLOSE);
        break;
      case"offspring":
        if(offspring.isEmpty()){
          fill(colour);
          stroke(#000000);
          strokeWeight(1);
          beginShape();
          vertex(a.x, a.y);
          vertex(b.x, b.y);
          vertex(c.x, c.y);
          vertex(d.x, d.y);
          endShape(CLOSE);
          break;
        }
      case"snake":
        if(offspring.isEmpty()){
          float weigth = map(relArea, 0, width*height, 1, 3);
          strokeJoin(ROUND);
          strokeWeight(weigth);
          beginShape();
          for(PVector p : getSnakePoints()){
            vertex(p.x, p.y);
          }
          endShape();
          arc(a.x, a.y, w, h, 0, 0);
          //displayCenter();
          noFill();
          break;
        }
      case"windows":
        if(offspring.isEmpty()){
          PShape window = loadShape(winFile);
          window.disableStyle();
          shapeMode(CENTER);
          stroke(colour);
          noFill();
          shape(window, center.x, center.y, winDims.x, winDims.y);
          break;
        }
    }
  }

  // Set the splitting direction
  void getDir(){
    if(squareness > 1 ){
      dir = 0;
    }
    if(squareness < 1 ){
      dir = 1;
    }
    if(squareness == 1 ){
      dir = round(random(1));
    }
  }

  // Set the splitting distance
  void setSplitDist(){
    switch(splitMode){
      case "parent":
        splitDist = random(0.25, 0.75);
        break;
      case "offspring":
        splitDist = 1/partitions;
        break;
    }
  }

  // Set splitting points for the new generation
  void splitPoints(){
    switch(dir){
      case 0:
        e = PVector.lerp(a,b, splitDist);
        f = PVector.lerp(d,c, splitDist);
        break;
      case 1:
        e = PVector.lerp(b,c, splitDist);
        f = PVector.lerp(a,d, splitDist);
        break;
    }
  }

  // Set the splitting mode
  void setSplitMode(String mode){
    splitMode = mode;
  }

  // Create the cells offspring according to the splitmode, distance and direction
  void createOffspring(){
    setSplitDist();
    splitPoints();
    switch(dir){
      case 0:
        offspring.add(new Cell(a.copy(), e.copy(), f.copy(), d.copy()));
        if(splitMode == "parent"){
          offspring.add(new Cell(e.copy(), b.copy(), c.copy(), f.copy()));
        }
        break;
      case 1:
        offspring.add(new Cell(a.copy(), b.copy(), e.copy(), f.copy()));
        if(splitMode == "parent"){
          offspring.add(new Cell(f.copy(), e.copy(), c.copy(), d.copy()));
        }
        break;
    }
  }

  // Recursiveley display all the descendance of the cell
  void displayOffspring(String dispMode){
    for(Cell cell : offspring){

      cell.display(dispMode);
      try{
        cell.displayOffspring(dispMode);
      }
      catch(Exception e){}
    }
  }

  // Get centerpoint of the cell
  void getCenter(){
    center = new PVector(a.x+w/2, a.y+h/2);
  }

  // Set the region attribute according to the cells senterpoint
  void setRegion(int region_){
    region = region_;
  }

  // Diplay a point and the region number in the cell´s centerpoint
  void displayCenter(){
    fill(#000000);
    point(center.x, center.y);
    textSize(10);
    text(str(region), center.x, center.y);
  }

  // Get the number of points needed to display the cell in snake mode
  int getNumSnakePoints(){
    int numSnakePoints;
    if(region%2 == 0){
      numSnakePoints = 4;
    }
    else{
      numSnakePoints = 3;
    }
    return numSnakePoints;
  }

  // Get the inseted and ordered points to display the cell in snake mode
  PVector[] getSnakePoints(){
    int shift = floor((region+1)/2)-1;
    PVector[] shiftedPoints = shiftPVArray(insetPoints(0.2), shift);
    PVector[] newPoints = new PVector[getNumSnakePoints()];
    for(int i = 0; i < newPoints.length ;i++){
      newPoints[i] = shiftedPoints[i];
    }
    return newPoints;
  }

  // Shift an array to the left by (int shift) positions
  PVector[] shiftPVArray(PVector[] array, int shift){
    PVector[] shifted = new PVector[array.length];
    for(int i = 0 ; i < shifted.length; i++){
      int i_ = i+shift;
      if(i_ >= array.length){
        i_= i_- array.length;
      }

      shifted[i] = array[i_];
    }
    return shifted;
  }

  // Inset the cells vertices by a (float scale) factor of the length of it´s shortest side
  PVector[] insetPoints(float scale){
    PVector[] inset = {a.copy(), b.copy(), c.copy(), d.copy()};
    float ref = min(w, h);
    float insetD = ref*scale;
    inset[0] = inset[0].add(new PVector(insetD, insetD));
    inset[1] = inset[1].add(new PVector(-insetD, insetD));
    inset[2] = inset[2].add(new PVector(-insetD, -insetD));
    inset[3] = inset[3].add(new PVector(insetD, -insetD));
    return inset;
  }

  // Set the svg file with a random window according to the squareness parameter
  void getWinFile(){
    if(squareness < squarenessThrehsold){
      winFile = vWindows[round(random(vWindows.length - 1))];
    }
    if(squarenessThrehsold <= squareness && squareness <= 1/squarenessThrehsold){
      winFile = sWindows[round(random(sWindows.length - 1))];
    }
    if(1/squarenessThrehsold < squareness){
      winFile = hWindows[round(random(hWindows.length - 1))];
    }
  }

  // Set the window dimmensions according to the squareness parameter
  void getWinDims(){
    float winScale = 0.7;
    if(squareness < squarenessThrehsold){
      winDims = new PVector(w*winScale, w*winScale*1.75);
    }
    if(squarenessThrehsold <= squareness && squareness <= 1/squarenessThrehsold){
      winDims = new PVector(w*winScale, w*winScale);
    }
    if(1/squarenessThrehsold < squareness){
      winDims = new PVector(h*winScale*1.75, h*winScale);
    }
  }
}
