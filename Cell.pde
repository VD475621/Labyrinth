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
  
  void draw(int x, int y) {
    //stroke(#303030);
    noStroke();
    if(this.type == TypeCell.WALL)
        fill(#303030);
    else if(this.type == TypeCell.START)
      fill(#ff0000);
    else if(this.type == TypeCell.FINISH)
      fill(#00ffe5);
    else if(this.type == TypeCell.WAY)
      fill(#00ff00);
    else
      fill(#ffffff);
    
    rect(x, y, _width, _height);
  }
  
  boolean pathClear(PVector v) {
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
  
  void setBottom(Cell cell) {
    bottom = cell;
    cell.top = this;
  }
  
  void setLeft(Cell cell) {
    left = cell;
    cell.right = this;
  }
}