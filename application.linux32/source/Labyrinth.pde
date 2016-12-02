//Generateur de labyrinthe
//pathfinding A*, etc

  /*int cellSize = 45;
  int xcount=15;
  int ycount=11;
  */
  
  int cellSize = 12;
  int xcount=123;
  int ycount=61;
  int offsetx = 45;
  int offsety = 65;
  boolean demo=true;
  
  Grid rdMazeGrid1;
  int numberS = 1;
  RdMaze _rdMaze1;
  PathFinding p;
  
void setup(){
  //size(1280, 800);
  fullScreen();
  
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
    text("Vivien Dumont 2016", 50,50);
    if(demo)
        text("Mode demo", 250,50);
    _rdMaze1.draw();
}