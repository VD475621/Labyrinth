//Generateur de labyrinthe
//pathfinding A*, etc

  /*int cellSize = 45;
  int xcount=15;
  int ycount=11;
  */
  
  int cellSize = 13;
  int xcount=83;
  int ycount=61;
  int offsetx = 50;
  int offsety = 100;
  boolean demo=true;
  
  Grid rdMazeGrid1;
  int numberS = 1;
  RdMaze _rdMaze1;
  PathFinding p;
  
void setup(){
  //size(1280, 800);
  fullScreen();
  cellSize = ((width / height)*10) + 3;
  xcount = (int)((width/cellSize)*0.95);
  if(xcount%2 == 0)
    xcount--;
  
  ycount = (int)((height/cellSize)*0.85);
  if(ycount%2 == 0)
    ycount--;
  
  initGrid();
  Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
  p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount);
}

void keyPressed() {
  if (key == 'r') {
      initGrid();
  }
  if(key == 'd' && mousePressed){
      //new start
      _rdMaze1._mainGrid.setStart(mouseX, mouseY);
      _rdMaze1._mainGrid.draw();
  }
  if(key == 'f' && mousePressed){
      //end
      _rdMaze1._mainGrid.setFinish(mouseX, mouseY);
      _rdMaze1._mainGrid.draw();
  }
  if(key == '1'){
      //searcsh path
      if(_rdMaze1._Finished){
          println("Start pathFinding Astar");
          p.Astar();
          _rdMaze1._mainGrid.draw();
          println("End pathFinding");
      }
  }
  if(key == '0'){
      if(_rdMaze1._Finished){
          println("Init");
          Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
          p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount); 
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
  if(key == 'a')
    demo = !demo;
}

void initGrid(){
      rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
      rdMazeGrid1.setX(offsetx);
      rdMazeGrid1.setY(offsety);
      _rdMaze1 = new RdMaze(rdMazeGrid1);
}

void update(){
  if(p.find){
    delay(5000);
    initGrid();
    Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
    p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount);
  }
  if(demo){
    if(_rdMaze1._Finished){
       _rdMaze1._mainGrid.setStart();
       _rdMaze1._mainGrid.setFinish();
      println("Start pathFinding Astar");
      Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
      p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount);
      p.Astar();
      _rdMaze1._mainGrid.draw();
      println("End pathFinding");
    }
  }
}

void draw(){
  background(255);
  stroke(#303030);
  fill(#ffffff);
  rect(offsetx-1,offsety-1, xcount*cellSize+1, ycount*cellSize+1);
  
    update();
    fill(#000000);
    text("Vivien Dumont 2016", 150,50);
    text("Générateur de Maze par division, set du départ et de l'arrivée de maière randomr et pathfinding avec le A*", 325, 50);
    text("Xcount : " + xcount + ", Ycount : " + ycount + ", CellSize : " + cellSize, 150, 75);
    if(demo)
        text("Mode demo", 50,50);
    _rdMaze1.draw();
}