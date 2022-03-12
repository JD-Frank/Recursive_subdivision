public class Cell{
  PVector a, b, c, d, e, f;
  float w, h;
  int dir;
  float partitions = 4;
  float splitDist;
  String splitMode;
  ArrayList<Cell> offspring = new ArrayList<Cell>();

  Cell(PVector a_, PVector b_, PVector c_, PVector d_){
    a = a_;
    b = b_;
    c = c_;
    d = d_;
    splitMode = "parent";
    w = abs(PVector.dist(a,b));
    h = abs(PVector.dist(a,d));

    setDir();
  }

  void display(){
    strokeWeight(3);
    beginShape();
    vertex(a.x, a.y);
    vertex(b.x, b.y);
    vertex(c.x, c.y);
    vertex(d.x, d.y);
    endShape(CLOSE);
  }

  // Set the splitting direction
  void setDir(){
    dir = round(random(1));
  }

  // Set the splitting distance
  void setSplitDist(){
    switch(splitMode){
      case "parent":
        splitDist = random(1);
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
}
