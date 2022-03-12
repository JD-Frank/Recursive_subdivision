public class Cell{
  PVector a, b, c, d, e, f;
  float w, h;
  int dir;
  float squareness;
  float partitions = 4;
  float splitDist;
  String splitMode;
  ArrayList<Cell> offspring = new ArrayList<Cell>();
  color colour = indigo[round(random(4))];

  Cell(PVector a_, PVector b_, PVector c_, PVector d_){
    a = a_;
    b = b_;
    c = c_;
    d = d_;
    splitMode = "parent";
    w = abs(PVector.dist(a,b));
    h = abs(PVector.dist(a,d));
    squareness = w/h;
    setDir();
  }

// Display a cell according to teh display mode dispMode
  void display(String dispMode){
    switch(dispMode){
      case"parent":
        noFill();
        strokeWeight(3);
        beginShape();
        vertex(a.x, a.y);
        vertex(b.x, b.y);
        vertex(c.x, c.y);
        vertex(d.x, d.y);
        endShape(CLOSE);
        break;
      case"offspring":
        fill(colour);
        strokeWeight(1);
        beginShape();
        vertex(a.x, a.y);
        vertex(b.x, b.y);
        vertex(c.x, c.y);
        vertex(d.x, d.y);
        endShape(CLOSE);
        break;
    }
  }

  // Set the splitting direction
  void setDir(){
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
  void displayOffspring(){
    for(Cell cell : offspring){

      cell.display("offspring");
      try{

        cell.displayOffspring();
      }
      catch(Exception e){}
    }
  }
}
