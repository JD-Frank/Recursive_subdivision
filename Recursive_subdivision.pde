import processing.pdf.*;

int margin = 20;
int pGenerations = 4;
int oGenerations = 2;
int seed = round(random(1000000));
float hatchSep;
ArrayList<Cell> cells = new ArrayList<Cell>();
ArrayList<Cell> offspring = new ArrayList<Cell>();
PVector[][] regions;

PVector a,b,c,d,e,f;

void settings(){
  size(1080, 1080, PDF, str(seed)+".pdf");
  randomSeed(seed);

  a = new PVector(margin, margin);
  b = new PVector(width - margin, margin);
  c = new PVector(width - margin, height-margin);
  d = new PVector(margin, height-margin);

  cells.add(new Cell(a,b,c,d));

  cells = subdivide(pGenerations, cells, "parent");

  offspring = subdivide(1, cells, "offspring");

  subdivide(oGenerations, offspring, "parent");

  println(seed);

  getRegions();

  for(Cell cell : offspring){
    setOffspringRegions(cell);
  }
}

void draw(){

  background(#DDDDDD);

  // displayOffspring("offspring");
  displayOffspring("windows");

  // for(Cell cell : cells){
  //  cell.display("parent");
  // }

  // PShape xx = loadShape("horizontal1.svg");
  // shape(xx, 50, 50);


  //hatch();
  strokeWeight(1);
  //displayRegions();


  noLoop();
  exit();
}

ArrayList<Cell> subdivide(int generations, ArrayList<Cell> cellArray, String mode){
  for (int gen = 0; gen < generations; gen++){
    ArrayList<Cell> accumulator = new ArrayList<Cell>();
    for(Cell cell : cellArray){
        cell.setSplitMode(mode);
        cell.createOffspring();{
        for(int i = 0; i < cell.offspring.size(); i++)
        accumulator.add(cell.offspring.get(i));
        }
    }
    cellArray = accumulator;
  }
  return cellArray;
}

void printCoords(ArrayList<Cell> cellArray){
  for(Cell cell : cellArray){
    print("--------------------\r\n");
    print(cell.a.x + " , " + cell.a.y + "\r\n");
    print(cell.b.x + " , " + cell.b.y + "\r\n");
    print(cell.c.x + " , " + cell.c.y + "\r\n");
    print(cell.d.x + " , " + cell.d.y + "\r\n");
    print("w: " + cell.w + " h: " + cell.h +  " dist: " + cell.splitDist +"\r\n");
    try{
    print(cell.e.x + " , " + cell.e.y + "\r\n");
    print(cell.f.x + " , " + cell.f.y + "\r\n");
    }
    catch(Exception e){}
  }
}

void  displayOffspring(String dispMode){
  for(Cell cell : offspring){
    int i = offspring.indexOf(cell);
    int dir = cells.get(i).dir;
    int reps = (int) cells.get(i).partitions;
    for(int rep = 0; rep < reps; rep++){
      pushMatrix();
      if(dir == 0){
        translate(cell.w*rep, 0);
      }
      if(dir == 1){
        translate(0, cell.h*rep);
      }
      cell.displayOffspring(dispMode);
      popMatrix();
    }
  }
}

void hatch(){
  hatchSep = height*0.005;
  for(int i = 0; i < 2*height; i+=hatchSep){
    strokeWeight(2);
    stroke(#FFFFFF);
    pushMatrix();
    rotate(-PI/4.0);
    translate(0,i);
    line(-width,0,width,0);
    popMatrix();
  }
}

void getRegions(){
  PVector center = new PVector(width*0.5, height*0.5);
  PVector p1 = new PVector(margin, margin);
  PVector p2 = new PVector(margin + (width-2*margin)/3, margin);
  PVector p3 = new PVector(margin + 2*(width-2*margin)/3, margin);
  PVector p4 = new PVector(width - margin, margin);
  PVector p5 = new PVector(width - margin, margin + (height-2*margin)/3);
  PVector p6 = new PVector(width - margin, margin + 2*(height-2*margin)/3);
  PVector p7 = new PVector(width - margin, height-margin);
  PVector p8 = new PVector(margin + 2*(width-2*margin)/3, height-margin);
  PVector p9 = new PVector(margin + (width-2*margin)/3, height-margin);
  PVector p10 = new PVector(margin, height-margin);
  PVector p11 = new PVector(margin, margin + 2*(height-2*margin)/3);
  PVector p12 = new PVector(margin, margin + (height-2*margin)/3);

  PVector[] r1 = {p9, p10, p11, center};
  PVector[] r2 = {p11, p12, center};
  PVector[] r3 = {p1, p2, center, p12};
  PVector[] r4 = {p2, p3, center};
  PVector[] r5 = {p3, p4, p5, center};
  PVector[] r6 = {p5, p6, center};
  PVector[] r7 = {p6, p7, p8, center};
  PVector[] r8 = {p8, p9, center};

  PVector[][] regions_ = {r1, r2, r3, r4, r5, r6, r7, r8};

  regions = regions_;
}

void displayRegions(){
  for(PVector[] region : regions){
    beginShape();
    for(PVector v : region){
      vertex(v.x, v.y);
    }
    endShape();
  }
}

int[] getCoords(PVector[] vertices, char axis){
  int[] coords = new int[vertices.length];
  for(int i = 0; i < vertices.length; i++){
    switch(axis){
      case 'x':
        coords[i] = (int) vertices[i].x;
        break;
      case 'y':
        coords[i] = (int) vertices[i].y;
        break;
    }
  }
  return coords;
}

void setCellRegion(Cell cell){
  int cx = (int) cell.center.x;
  int cy = (int) cell.center.y;
  for(int r = 0; r < regions.length; r++){
    if(polygonContainsPoint(getCoords(regions[r], 'x'), getCoords(regions[r], 'y'), cx, cy)){
      cell.setRegion(r+1);
    }
  }
}

public static boolean polygonContainsPoint(int[] polygonXPoints, int[] polygonYPoints, int testX, int testY){
    int numVerts = polygonXPoints.length;
    boolean c = false;
    int j = numVerts - 1;
    for (int i = 0; i < numVerts; i++)
    {
        double deltaX = polygonXPoints[j] - polygonXPoints[i];
        double ySpread = testY - polygonYPoints[i];
        double deltaY = polygonYPoints[j] - polygonYPoints[i];
        if (((polygonYPoints[i] > testY) != (polygonYPoints[j] > testY)) &&
            (testX < (((deltaX * ySpread) / deltaY) + polygonXPoints[i])))
        {
            c = !c;
        }

        j = i;
    }
    return c;
}

void setOffspringRegions(Cell parent){
  for(Cell cell : parent.offspring){
    setCellRegion(cell);
    try{
      setOffspringRegions(cell);
    }
    catch(Exception e){

    }
  }
}
