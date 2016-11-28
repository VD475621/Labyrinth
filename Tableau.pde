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
        if( i==0 && j==0)
          currentCell.type = TypeCell.START;
        if( i==_h-1 && j==_w-1)
          currentCell.type = TypeCell.FINISH;
      }
    }
  }
  void setX(int x) {_x = x;}
  int getX() {return _x;}
  
  void setY(int y) {_y = y;}
  int getY(){return _y;}
  
  int getCellSize(){return _cellSize;}
  
  void draw(){
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
  
  
  Cell[][] getCells() {return _cells;}
  Cell getCell(int x, int y) {
      return _cells[y][x];
  }
  int getWidth() {return _w;}
  int getHeight() {return _h;}
}