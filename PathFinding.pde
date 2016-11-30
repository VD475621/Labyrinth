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
          
          open.remove(current); //<>//
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