import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Labyrinth extends PApplet {

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
  
public void setup(){
  //size(1280, 800);
  
  cellSize = ((width / height)*10) + 3;
  xcount = (int)((width/cellSize)*0.95f);
  if(xcount%2 == 0)
    xcount--;
  
  ycount = (int)((height/cellSize)*0.85f);
  if(ycount%2 == 0)
    ycount--;
  
  initGrid();
  Cell s = _rdMaze1._mainGrid.getStart(), e = _rdMaze1._mainGrid.getFinish();
  p = new PathFinding(_rdMaze1._mainGrid, s, e, xcount, ycount);
}

public void keyPressed() {
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

public void initGrid(){
      rdMazeGrid1 = new Grid(cellSize, xcount,ycount);
      rdMazeGrid1.setX(offsetx);
      rdMazeGrid1.setY(offsety);
      _rdMaze1 = new RdMaze(rdMazeGrid1);
}

public void update(){
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

public void draw(){
  background(255);
  stroke(0xff303030);
  fill(0xffffffff);
  rect(offsetx-1,offsety-1, xcount*cellSize+1, ycount*cellSize+1);
  
    update();
    fill(0xff000000);
    text("Vivien Dumont 2016", 150,50);
    text("G\u00e9n\u00e9rateur de Maze par division, set du d\u00e9part et de l'arriv\u00e9e de mai\u00e8re randomr et pathfinding avec le A*", 325, 50);
    text("Xcount : " + xcount + ", Ycount : " + ycount + ", CellSize : " + cellSize, 150, 75);
    if(demo)
        text("Mode demo", 50,50);
    _rdMaze1.draw();
}
enum TypeCell {WALL, START, FINISH, WAY, NONE};

class Cell {
  int _width, _height;
  double g,h,f;
  TypeCell type = TypeCell.NONE;
  Cell left = null;
  Cell right = null;
  Cell top = null;
  Cell bottom = null;
  
  Cell(int w, int h) {
    _width = w;
    _height = h;
    g = Double.MAX_VALUE;
    h = 0;
    f = 0;
  }
  
  public void draw(int x, int y) {
    //stroke(#303030);
    noStroke();
    if(this.type == TypeCell.WALL)
        fill(0xff303030);
    else if(this.type == TypeCell.START)
      fill(0xffff0000);
    else if(this.type == TypeCell.FINISH)
      fill(0xff00ffe5);
    else if(this.type == TypeCell.WAY)
      fill(0xff00ff00);
    else
      fill(0xffffffff);
    
    rect(x, y, _width, _height);
  }
  
  public boolean pathClear(PVector v) {
    boolean isClear = false;
    if (v.x != 0 && v.y == 0) {
      isClear = this.type != TypeCell.WALL
                && this.top != null
                && this.top.type != TypeCell.WALL
                && this.bottom != null
                && this.bottom.type != TypeCell.WALL;
    } 
    else {
      isClear = this.type != TypeCell.WALL
                && this.left != null
                && this.left.type != TypeCell.WALL
                && this.right != null
                && this.right.type != TypeCell.WALL;
    }
    return isClear;
  }
  
  public void setBottom(Cell cell) {
    bottom = cell;
    cell.top = this;
  }
  
  public void setLeft(Cell cell) {
    left = cell;
    cell.right = this;
  }
}
class Grid {
  Cell[][] _cells;
  int _x, _y, _w, _h, _cellSize;
  Grid(int cellSize, int xcount, int ycount) {
    _x = 0;
    _y = 0;
    _w = xcount;
    _h = ycount;
    _cellSize = cellSize;
    _cells = new Cell[_h][_w];
    
    
    for (int i = 0; i < _h; i++) {
      for (int j = 0; j < _w; j++) {
        Cell currentCell = new Cell(_cellSize, _cellSize);
        _cells[i][j] = currentCell;
        if (i != 0) {
          currentCell.setBottom(_cells[i-1][j]);
        }
        if (j != 0) {
          currentCell.setLeft(_cells[i][j-1]);
        }
        
        /*if( i==0 && j==0)
          currentCell.type = TypeCell.START;
        if( i==_h-1 && j==_w-1)
          currentCell.type = TypeCell.FINISH;*/
      }
    }
  }
  public void setX(int x) {_x = x;}
  public int getX() {return _x;}
  
  public void setY(int y) {_y = y;}
  public int getY(){return _y;}
  
  public int getCellSize(){return _cellSize;}
  
  public void draw(){
    int dx = _x;
    int dy = _y;
    for (int i = 0; i < _h; i++) {
      dx = _x;
      for (int j = 0; j < _w; j++) {
        Cell cell = _cells[i][j];
        cell.draw(dx, dy);
        dx += _cellSize;
      }
      dy += _cellSize;
    }
  }
  
  
  public Cell[][] getCells() {return _cells;}
  public Cell getCell(int x, int y) {
      return _cells[y][x];
  }
  public int getWidth() {return _w;}
  public int getHeight() {return _h;}
  
  public void setStart(int x, int y){
    int dx = _x;
    int dy = _y;
    for (int i = 0; i < _h; i++) {
      dx = _x;
      for (int j = 0; j < _w; j++) {
        Cell cell = _cells[i][j];
        if(x>=dx && x<=dx+_cellSize &&
          y>=dy && y<=dy+_cellSize && cell.type == TypeCell.NONE){
          Cell old = getStart();
          if(old != null)
            old.type = TypeCell.NONE;
          cell.type = TypeCell.START;
        }
        dx += _cellSize;
      }
      dy += _cellSize;
    }
    
  }
  
  public void setFinish(int x, int y){
    int dx = _x;
    int dy = _y;
    for (int i = 0; i < _h; i++) {
      dx = _x;
      for (int j = 0; j < _w; j++) {
        Cell cell = _cells[i][j];
        if(x>=dx && x<=dx+_cellSize &&
          y>=dy && y<=dy+_cellSize && cell.type == TypeCell.NONE){
          Cell old = getFinish();
          if(old != null)
            old.type = TypeCell.NONE;
          cell.type = TypeCell.FINISH;
        
        }
        dx += _cellSize;
      }
      dy += _cellSize;
    }
  }
  
  public void setStart(){
    int dx = _x;
    int dy = _y;
    
    boolean start_set=false;
    while(!start_set){
      int rx = PApplet.parseInt(random(xcount));
      int ry = PApplet.parseInt(random(ycount));
      Cell cell = _cells[ry][rx];
      if(cell.type == TypeCell.NONE){
        cell.type = TypeCell.START;
        start_set=true;
      }
    }
    
    
    
  }
  
  public void setFinish(){
    int dx = _x;
    int dy = _y;
    boolean finish_set=false;
    
    while(!finish_set){
      int rx = PApplet.parseInt(random(xcount));
      int ry = PApplet.parseInt(random(ycount));
      Cell cell = _cells[ry][rx];
      if(cell.type == TypeCell.NONE){
        cell.type = TypeCell.FINISH;
        finish_set=true;
      }
    }
    
  }
  
  public Cell getStart(){
    for(Cell currents[] : _cells)
      for(Cell cur : currents)
          if(cur.type == TypeCell.START)
            return cur;
    return null;
  }
  
  public Cell getFinish(){
    for(Cell currents[] : _cells)
      for(Cell cur : currents)
          if(cur.type == TypeCell.FINISH)
            return cur;
    return null;
  }
}
class RdMaze {
  ArrayList _walls;
  ArrayList _wallBricks;
  ArrayList _init;
  int _frame = 0;
  boolean _inProcess = false;
  boolean _Finished = false;
  boolean invH=true;
  boolean invV=false;
  
  Grid _mainGrid;
  
  RdMaze(Grid grid){
    _mainGrid = grid;
    _init = new ArrayList();
    int w = grid.getWidth();
    int h = grid.getHeight();
    if ((w >= 3 && w % 2 == 1)&&(h >= 3 && h % 2 == 1)) {
      _walls = new ArrayList();
      _wallBricks = new ArrayList();
      _init.add(_mainGrid);
    } else {
      println("Insufficient ammount of cells or amound is even: w="+w+", h="+h+";");
    }
  }
  
  public void generate(ArrayList grids) {
    println("I have "+grids.size()+" grids to process");
    for (int i = 0; i < grids.size(); i++) {
      Grid grid = (Grid)grids.get(i);
      if (isOk(grid)) {
        println("Splitting grid No "+(i+1)+": w="+grid.getWidth()+", h="+grid.getHeight()+";");
        generate(splitGrid(grid));
      } 
      else {
        println("Cannot process grid w="+grid.getWidth()+", h="+grid.getHeight()+"; further");
      }
    }
  }
  
  public ArrayList splitGrid(Grid grid) {
    ArrayList splits = new ArrayList();
    
    int cellSize = grid.getCellSize();
    int gridWidth = grid.getWidth();
    int gridHeight = grid.getHeight();

    if (grid.getWidth() > grid.getHeight()) {
      int xwall = PApplet.parseInt(random(1, gridWidth-1));
      xwall = xwall % 2 == 0 ? xwall-1 : xwall; // wall should start at even position
      int ywall = 0;

      int xoffset = PApplet.parseInt(abs(grid.getX()-_mainGrid.getX())/cellSize) + xwall;
      int yoffset = PApplet.parseInt(abs(grid.getY()-_mainGrid.getY())/cellSize) + ywall;

      println("Vertical border at: x="+xoffset+",y="+yoffset+", w="+gridWidth+";");
      _walls.add(new Wall(xoffset, yoffset, gridHeight, 'v'));
      
      Grid leftGrid = new Grid(cellSize, xwall, gridHeight);
      leftGrid.setX(grid.getX());
      leftGrid.setY(grid.getY());
      println("Left grid: w="+leftGrid.getWidth()+",h="+leftGrid.getHeight()+";");

      Grid rightGrid = new Grid(cellSize, gridWidth-xwall-1, gridHeight);
      rightGrid.setX(leftGrid.getX()+leftGrid.getWidth()*cellSize+cellSize);
      rightGrid.setY(grid.getY());
      println("Right grid: w="+rightGrid.getWidth()+",h="+rightGrid.getHeight()+";");
      
      splits.add(leftGrid);
      splits.add(rightGrid);
    }
    else {
      int ywall = PApplet.parseInt(random(1, gridHeight-1));
      ywall = ywall % 2 == 0 ? ywall-1 : ywall; // wall should start at even position
      int xwall = 0;

      int xoffset = PApplet.parseInt(abs(grid.getX()-_mainGrid.getX())/cellSize) + xwall;
      int yoffset = PApplet.parseInt(abs(grid.getY()-_mainGrid.getY())/cellSize) + ywall;
      
      println("Horizontal border at: x="+xoffset+",y="+yoffset+", w="+gridWidth+";");
      _walls.add(new Wall(xoffset, yoffset, gridWidth, 'h'));

      Grid topGrid = new Grid(cellSize, gridWidth, ywall);
      topGrid.setX(grid.getX());
      topGrid.setY(grid.getY());
      println("Top grid: w="+topGrid.getWidth()+",h="+topGrid.getHeight()+";");
      
      Grid bottomGrid = new Grid(cellSize, gridWidth, gridHeight-ywall-1);
      bottomGrid.setX(grid.getX());
      bottomGrid.setY(topGrid.getY()+topGrid.getHeight()*cellSize+cellSize);
      println("Bottom grid: w="+bottomGrid.getWidth()+",h="+bottomGrid.getHeight()+";");
      
      splits.add(topGrid);
      splits.add(bottomGrid);
    }
    return splits;
  }
  
  public ArrayList setVerticalBorder(int x, int y, int h) {
    ArrayList borderCells = new ArrayList(h);
    for (int i = 0; i < h; i++) {
      println("   brick at x="+x+", y="+(y+i)+";");
      Cell cell = _mainGrid.getCell(x, y+i);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }

  public ArrayList setHorizontalBorder(int x, int y, int w) {
    ArrayList borderCells = new ArrayList(w);
    for (int i = w-1; i >=0; i--) {
      println("   brick at x="+(x+i)+", y="+y+";");
      Cell cell = _mainGrid.getCell(x+i, y);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }
  
  public ArrayList setVerticalBorderInv(int x, int y, int h) {
    ArrayList borderCells = new ArrayList(h);
    for (int i = h-1; i >=0; i--) {
      println("   brick at x="+x+", y="+(y+i)+";");
      Cell cell = _mainGrid.getCell(x, y+i);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }

  public ArrayList setHorizontalBorderInv(int x, int y, int w) {
    ArrayList borderCells = new ArrayList(w);
    for (int i = 0; i < w; i++) {
      println("   brick at x="+(x+i)+", y="+y+";");
      Cell cell = _mainGrid.getCell(x+i, y);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }
  
  public void setGate(ArrayList wallBricks){
    int position = PApplet.parseInt(random(1, wallBricks.size()-1));
    position = position % 2 == 0 ? position : position-1;
    
    Cell gate = (Cell)wallBricks.get(position);
    gate.type =TypeCell.NONE;
  }

  public boolean isOk(Grid grid) {
    return (grid.getWidth() > 1 && grid.getHeight() > 1);
  }
  
  public void addBorders(Grid grid) {
    for (int i = 0; i < grid.getHeight(); i++) {
      Cell cell;
      cell = grid.getCell(0, i);
      cell.type = TypeCell.WALL;
      
      cell = grid.getCell(grid.getWidth()-1, i);
      cell.type = TypeCell.WALL;
    }
    for (int i = 0; i < grid.getWidth(); i++) {
      Cell cell;
      cell = grid.getCell(i, 0);
      cell.type = TypeCell.WALL;
      
      cell = grid.getCell(i, grid.getHeight()-1);
      cell.type = TypeCell.WALL;
    }
  }
  
  public void draw() {
    if (!_inProcess) {
      _inProcess = true;
      println("Generating maze...");
      generate(_init);
      println("Done.");
    }
    
    if (_walls.size() > 0 || _wallBricks.size() > 0) {
      if (_frame % 2 == 0) { // Even frame - draw wall
        Wall wall = (Wall)_walls.remove(0);
        if (wall.type == 'h') {
          if(invH)
              _wallBricks = setHorizontalBorder(wall.x, wall.y, wall.size);
          else
              _wallBricks = setHorizontalBorderInv(wall.x, wall.y, wall.size);
          invH = !invH;
        }
        else {
          if(invV)
              _wallBricks = setVerticalBorder(wall.x, wall.y, wall.size);
          else
              _wallBricks = setVerticalBorderInv(wall.x, wall.y, wall.size);
          invV = !invV;
        }
      } 
      else { // Odd frame - draw gate
        //if( (int(random(2))%3) == 1)
        //  setGate(_wallBricks);
        setGate(_wallBricks);
        _wallBricks.clear();
      }
      
      if(_walls.isEmpty()){
        _Finished = true;
      }
      
      _mainGrid.draw();
      _frame++;
    }
  }

}
class PathFinding{
    Cell cells[][];
    Cell start, end;
    ArrayList<Cell> chemin = new ArrayList<Cell>();
    int xcount, ycount;
    boolean find=false;
    
    PathFinding(Grid g, Cell s, Cell e, int x, int y){
      cells = g.getCells();
      find=false;
      start = s;
      end = e;
      xcount=x; ycount = y;
      for(int i=0; i<xcount;i++)
        for(int j=0;j<ycount;j++){
            if(cells[j][i].type == TypeCell.WAY)
                cells[j][i].type = TypeCell.NONE;
        }
      Evaluate();
    }
    
    public void Evaluate(){
        double plus_x=0, plus_y=0;
        int i=0,j=0;
        for(int x=0; x<xcount;x++)
          for(int y=0;y<ycount;y++)
            if(cells[y][x].type == TypeCell.FINISH){
              i=y;j=x;
            }
        
        println(i + " " + j);
        Cell onRight, onLeft;
        Cell current = cells[i][j];//end
        println(current.type);
        
        
        while(current != null){
             //audessus
              onLeft = current.left;
              while(current !=null){
                  current.h = plus_x+plus_y;
                  current = current.top;
                  plus_y+=10;
              }
              
              current = cells[i][j].bottom;//end
              plus_y=10;
              //endessous
              while(current !=null){
                  current.h = plus_x+plus_y;
                  current = current.bottom;
                  plus_y+=10;
              }
              current=onLeft;
              plus_x+=10;
        }
        
        plus_x=10;
        plus_y=0;
        current = cells[i][j].right;
        while(current != null){
             //audessus
              onRight = current.right;
              while(current !=null){
                  current.h = plus_x+plus_y;
                  current = current.top;
                  plus_y+=10;
              }
              
              current = cells[i][j].bottom;//end
              plus_y=10;
              //endessous
              while(current !=null){
                  current.h = plus_x+plus_y;
                  current = current.bottom;
                  plus_y+=10;
              }
              current=onRight;
              plus_x+=10;
        }
    }
    
    public boolean Astar(){
      
      ArrayList<Cell> open = new ArrayList<Cell>();
      ArrayList<Cell> close = new ArrayList<Cell>();
      ArrayList<Cell> came_from = new ArrayList<Cell>();
      
      start.g = 0;
      start.f = start.g + start.h;
      open.add(start);
      Cell current;
      
      while(!open.isEmpty()){
        current = open.get(0);
          for(Cell cell : open)
            if(current.f < cell.f)
              current = cell;
              
          if(current.type == TypeCell.FINISH)
          {
              BuildPath(came_from, current);
              return true;
          }
          
          open.remove(current);
          close.add(current);
          
          for(Cell neighbor : getNeighbor(current)){
              if(close.contains(neighbor)){
                 continue;
              }
              
              double tentative_g_score = current.g + 10;
              if(!open.contains(neighbor) || tentative_g_score < neighbor.g){
                  came_from.add(current);
                  neighbor.g = tentative_g_score;
                  neighbor.f = neighbor.g + neighbor.h;
                  if(!open.contains(neighbor))
                     open.add(neighbor);
              }
          }
      }
      return false;
    }
    
    public ArrayList<Cell> getNeighbor(Cell cur){
        ArrayList<Cell> neighbor = new ArrayList<Cell>();
        if(cur.top != null)
          if(cur.top.type != TypeCell.WALL)
            neighbor.add(cur.top);
            
        if(cur.right != null)
          if(cur.right.type != TypeCell.WALL)
            neighbor.add(cur.right);
            
        if(cur.bottom != null)  
          if(cur.bottom.type != TypeCell.WALL)
            neighbor.add(cur.bottom);
            
        if(cur.left != null)    
          if(cur.left.type != TypeCell.WALL)
            neighbor.add(cur.left);
        
        return neighbor;
    }
    
    public void BuildPath(ArrayList<Cell> came_from, Cell end){
        ArrayList<Cell> path = new ArrayList<Cell>();
        path.add(end);
        int i=came_from.size()-1;
        while(i>=0){
            if(path.contains(came_from.get(i).bottom) || path.contains(came_from.get(i).left) || path.contains(came_from.get(i).top) || path.contains(came_from.get(i).right))
              path.add(came_from.get(i));
            i--;
        }
        
        for(Cell cur : path)
          if(cur.type != TypeCell.START && cur.type != TypeCell.FINISH)
          cur.type=TypeCell.WAY;
        find=true;
    }

}
class Wall {
  int x;
  int y;
  int size;
  char type;
  Wall(int x, int y, int size, char type) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.type = type;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#F6FF00", "--stop-color=#FF0000", "Labyrinth" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
