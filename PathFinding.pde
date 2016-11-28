class PathFinding{
    Grid grid;
    Cell start, end;
    ArrayList<Cell> chemin = new ArrayList<Cell>();
    
    PathFinding(Grid g, Cell s, Cell e){
      this.grid = g;
      start = s;
      end = e;
      Evaluate();
    }
    
    public void Evaluate(){
    
    }
    
    public boolean Find(){
      ArrayList<Cell> open = new ArrayList<Cell>();
      open.add(start);
      ArrayList<Cell> close = new ArrayList<Cell>();
      
      return false;
    }
    
    public void BuildPath(){
    
    }

}