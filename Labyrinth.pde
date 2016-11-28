//Generateur de labyrinthe
//pathfinding A*, etc

  int cellSize = 12;
  int xcount = 51;
  int ycount = 41;
  Grid rdMazeGrid1;

RdMaze _rdMaze1;
void setup(){
  frameRate(15);
  size(636, 516);

  rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
  rdMazeGrid1.setX(12);
  rdMazeGrid1.setY(12);
  _rdMaze1 = new RdMaze(rdMazeGrid1);
}

void keyPressed() {
  if (key == 'r') {
      rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
      rdMazeGrid1.setX(12);
      rdMazeGrid1.setY(12);
      _rdMaze1 = new RdMaze(rdMazeGrid1);
  }
}

void draw(){
    _rdMaze1.draw();
}