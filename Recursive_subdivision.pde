int margin = 20;
int pGenerations = 3;
int oGenerations = 3;
int seed = round(random(1000000));
float hatchSep;
ArrayList<Cell> cells = new ArrayList<Cell>();
ArrayList<Cell> offspring = new ArrayList<Cell>();



PVector a,b,c,d,e,f;

void settings(){
  size(800, 800);
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
}

void draw(){

  background(#FFFFFF);



  displayOffspring();

  for(Cell cell : cells){
   cell.display("parent");
  }

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



  noLoop();
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

void  displayOffspring(){
  for(Cell cell : offspring){
    fill(random(255), random(255), random(255), 100);
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
      cell.displayOffspring();
      popMatrix();
    }
  }
}
