//Generateur de labyrinthe
//pathfinding A*, etc

  int cellSize = 45;
  int xcount = 25;
  int ycount = 15;
  Grid rdMazeGrid1;
  int numberS = 1;
  RdMaze _rdMaze1;
  boolean path=false;
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
      path=false;
  }
  if(key == 'd' && mousePressed){
      //new start
      _rdMaze1._mainGrid.setStart(mouseX, mouseY);
      _rdMaze1._mainGrid.draw();
      path=false;
  }
  if(key == 'f' && mousePressed){
      //end
      _rdMaze1._mainGrid.setFinish(mouseX, mouseY);
      _rdMaze1._mainGrid.draw();
      path=false;
  }
  if(key == 't'){
      //searcsh path
      if(_rdMaze1._Finished && !path){
          println("Start pathFinding");
          Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
          println(s.type);
          println(e.type);
          path=true;
          PathFinding p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount); 
          p.Astar();
          _rdMaze1._mainGrid.draw();
          println("End pathFinding");
      }
  }
  
  if(key == 's'){
      if(_rdMaze1._Finished){
          println("SAVE_"+numberS);
          //delay(1000);
          save("SAVE_"+numberS+".png");
          numberS++;
      }
  }
}

void draw(){
    _rdMaze1.draw();
}