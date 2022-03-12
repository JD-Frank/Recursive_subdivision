int margin = 20;
int pGenerations = 3;
int oGenerations = 2;
ArrayList<Cell> cells = new ArrayList<Cell>();
ArrayList<Cell> offspring = new ArrayList<Cell>();



PVector a,b,c,d,e,f;

void settings(){
  size(800, 800);
  randomSeed(10);

  a = new PVector(margin, margin);
  b = new PVector(width - margin, margin);
  c = new PVector(width - margin, height-margin);
  d = new PVector(margin, height-margin);

  cells.add(new Cell(a,b,c,d));

  cells = subdivide(pGenerations, cells, "parent");

  offspring = subdivide(1, cells, "offspring");

  printCoords(cells);
  printCoords(offspring);
}

void draw(){

  for(Cell cell : cells){
    cell.display();
  }
  fill(#004488, 100);
  for(Cell cell : offspring){
    cell.display();
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
