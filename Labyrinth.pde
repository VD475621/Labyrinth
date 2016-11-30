//Generateur de labyrinthe
//pathfinding A*, etc

  /*int cellSize = 45;
  int xcount=15;
  int ycount=11;
  */
  int cellSize = 15;
  int xcount=83;
  int ycount=51;
  
  
  Grid rdMazeGrid1;
  int numberS = 1;
  RdMaze _rdMaze1;
  boolean path=false;
void setup(){
  frameRate(60);
  size(1280, 800);
  
    
  rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
  rdMazeGrid1.setX(cellSize);
  rdMazeGrid1.setY(cellSize);
  _rdMaze1 = new RdMaze(rdMazeGrid1);
}

void keyPressed() {
  if (key == 'r') {
      rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
      rdMazeGrid1.setX(cellSize);
      rdMazeGrid1.setY(cellSize);
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
  if(key == '1'){
      //searcsh path
      if(_rdMaze1._Finished && !path){
          println("Start pathFinding Astar");
          Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
          PathFinding p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount);
          p.Astar();
          _rdMaze1._mainGrid.draw();
          println("End pathFinding");
      }
  }
  if(key == '0'){
      if(_rdMaze1._Finished && !path){
          println("Init");
          Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
          PathFinding p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount); 
          _rdMaze1._mainGrid.draw();
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