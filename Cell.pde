public class Cell{
  PVector a, b, c, d, e, f;
  float w, h;
  int dir;
  int partitions = 4;
  float splitDist;
  String splitMode;

  Cell(PVector a_, PVector b_, PVector c_, PVector d_){
    a = a_;
    b = b_;
    c = c_;
    d = d_;
    splitMode = "parent";
    w = abs(PVector.dist(a,b));
    h = abs(PVector.dist(a,d));

    setDir();
    setsplitDist();
    split();
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

  // Set splitting points for the new generation
  void split(){
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

  // Set the splitting distance
  void setsplitDist(){
    switch(splitMode){
      case "parent":
        splitDist = random(1);
        break;
      case "child":
        splitDist = cDist();
        break;
    }
  }

  // Calculate splitting distance for child generation
  float cDist(){
    float dist = 0.5;
    switch(dir){
      case 0:
        dist =  w/partitions;
        break;
      case 1:
        dist =  h/partitions;
        break;
    }
    return dist;
  }

  // Set the splitting mode
  void setSplitMode(String mode){
    splitMode = mode;
  }
}
