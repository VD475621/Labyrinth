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
  
  void setStart(int x, int y){
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
  
  void setFinish(int x, int y){
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
  
  void setStart(){
    int dx = _x;
    int dy = _y;
    
    boolean start_set=false;
    while(!start_set){
      int rx = int(random(xcount));
      int ry = int(random(ycount));
      Cell cell = _cells[ry][rx];
      if(cell.type == TypeCell.NONE){
        cell.type = TypeCell.START;
        start_set=true;
      }
    }
    
    
    
  }
  
  void setFinish(){
    int dx = _x;
    int dy = _y;
    boolean finish_set=false;
    
    while(!finish_set){
      int rx = int(random(xcount));
      int ry = int(random(ycount));
      Cell cell = _cells[ry][rx];
      if(cell.type == TypeCell.NONE){
        cell.type = TypeCell.FINISH;
        finish_set=true;
      }
    }
    
  }
  
  Cell getStart(){
    for(Cell currents[] : _cells)
      for(Cell cur : currents)
          if(cur.type == TypeCell.START)
            return cur;
    return null;
  }
  
  Cell getFinish(){
    for(Cell currents[] : _cells)
      for(Cell cur : currents)
          if(cur.type == TypeCell.FINISH)
            return cur;
    return null;
  }
}