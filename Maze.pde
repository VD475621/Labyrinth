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
  
  void generate(ArrayList grids) {
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
  
  ArrayList splitGrid(Grid grid) {
    ArrayList splits = new ArrayList();
    
    int cellSize = grid.getCellSize();
    int gridWidth = grid.getWidth();
    int gridHeight = grid.getHeight();

    if (grid.getWidth() > grid.getHeight()) {
      int xwall = int(random(1, gridWidth-1));
      xwall = xwall % 2 == 0 ? xwall-1 : xwall; // wall should start at even position
      int ywall = 0;

      int xoffset = int(abs(grid.getX()-_mainGrid.getX())/cellSize) + xwall;
      int yoffset = int(abs(grid.getY()-_mainGrid.getY())/cellSize) + ywall;

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
      int ywall = int(random(1, gridHeight-1));
      ywall = ywall % 2 == 0 ? ywall-1 : ywall; // wall should start at even position
      int xwall = 0;

      int xoffset = int(abs(grid.getX()-_mainGrid.getX())/cellSize) + xwall;
      int yoffset = int(abs(grid.getY()-_mainGrid.getY())/cellSize) + ywall;
      
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
  
  ArrayList setVerticalBorder(int x, int y, int h) {
    ArrayList borderCells = new ArrayList(h);
    for (int i = 0; i < h; i++) {
      println("   brick at x="+x+", y="+(y+i)+";");
      Cell cell = _mainGrid.getCell(x, y+i);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }

  ArrayList setHorizontalBorder(int x, int y, int w) {
    ArrayList borderCells = new ArrayList(w);
    for (int i = w-1; i >=0; i--) {
      println("   brick at x="+(x+i)+", y="+y+";");
      Cell cell = _mainGrid.getCell(x+i, y);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }
  
  ArrayList setVerticalBorderInv(int x, int y, int h) {
    ArrayList borderCells = new ArrayList(h);
    for (int i = h-1; i >=0; i--) {
      println("   brick at x="+x+", y="+(y+i)+";");
      Cell cell = _mainGrid.getCell(x, y+i);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }

  ArrayList setHorizontalBorderInv(int x, int y, int w) {
    ArrayList borderCells = new ArrayList(w);
    for (int i = 0; i < w; i++) {
      println("   brick at x="+(x+i)+", y="+y+";");
      Cell cell = _mainGrid.getCell(x+i, y);
      cell.type = TypeCell.WALL;
      borderCells.add(cell);
    }
    return borderCells;
  }
  
  void setGate(ArrayList wallBricks){
    int position = int(random(1, wallBricks.size()-1));
    position = position % 2 == 0 ? position : position-1;
    
    Cell gate = (Cell)wallBricks.get(position);
    gate.type =TypeCell.NONE;
  }

  boolean isOk(Grid grid) {
    return (grid.getWidth() > 1 && grid.getHeight() > 1);
  }
  
  void addBorders(Grid grid) {
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
  
  void draw() {
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