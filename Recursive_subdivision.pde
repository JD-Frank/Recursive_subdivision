int margin = 20;
ArrayList<Cell> cells = new ArrayList<Cell>();
ArrayList<Cell> children = new ArrayList<Cell>();
PVector a,b,c,d,e,f;
int parentGens = 3;

void settings(){
  size(800, 800);

  a = new PVector(margin, margin);
  b = new PVector(width - margin, margin);
  c = new PVector(width - margin, height-margin);
  d = new PVector(margin, height-margin);

  cells.add(new Cell(a,b,c,d));

  for (int gen = 0; gen < parentGens; gen++){
    cells = splitCells(cells);
  }

}

void draw(){
  for(Cell cell : cells){
    cell.display();
  }
}

ArrayList<Cell> splitCells(ArrayList<Cell> cells_){
  ArrayList<Cell> temp = new ArrayList<Cell>();

  for(Cell cell : cells_){
    PVector a = cell.a.copy();
    PVector b = cell.b.copy();
    PVector c = cell.c.copy();
    PVector d = cell.d.copy();
    PVector e = cell.e.copy();
    PVector f = cell.f.copy();
    switch(cell.dir){
      case 0:
        temp.add(new Cell(a, e, f, d));
        temp.add(new Cell(e, b, c, f));
        break;
      case 1:
        temp.add(new Cell(a, b, e, f));
        temp.add(new Cell(f, e, c, d));
        break;
    }
  }
  return temp;
}

void getChildren(){
  ArrayList<Cell> temp = new ArrayList<Cell>();
  for(Cell cell : cells){
    PVector a = cell.a.copy();
    PVector b = cell.b.copy();
    PVector c = cell.c.copy();
    PVector d = cell.d.copy();
    PVector e = cell.e.copy();
    PVector f = cell.f.copy();

    cell.setSplitMode("child");
    cell.setsplitDist();
    switch(cell.dir){
      case 0:
        temp.add(new Cell(a, e, f, d));
        break;
      case 1:
        temp.add(new Cell(a, b, e, f));
        break;
    }
  }
  children = temp;
}
