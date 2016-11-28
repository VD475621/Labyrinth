//Generateur de labyrinthe
//pathfinding A*, etc

  int cellSize = 12;
  int xcount = 105;
  int ycount = 65;
  Grid rdMazeGrid1;
  int numberS = 1;
RdMaze _rdMaze1;
void setup(){
  frameRate(60);
  size(1280, 800);

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
  if(key == 'd'){
      //new start
  }
  if(key == 'f'){
      //end
  }
  if(key == 't'){
      //search path
  }
  
  if(key == 's'){
      if(_rdMaze1._Finished){
          println("SAVE_"+numberS);
          save("SAVE_"+numberS+".png");
          numberS++;
      }
  }
}

void draw(){
    _rdMaze1.draw();
}