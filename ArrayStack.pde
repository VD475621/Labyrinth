public class ArrayStack extends ArrayList<Cell>{

  /*
   * Gestion d'une "ArrayList" se comportant comme une pile
   */

  public Cell pop(){
    int index = this.size() - 1;
    //if (size==-1) throw new EmptyStackException();
    if(index < 0)
      return null;
    else{
      Cell result = this.get(index);
      this.remove(index); // Eliminate obsolete reference
      return result;
    }
  }
  
  public void push(Cell o){
    this.add(o);
  }
  
  public int position(Cell o){
    return this.indexOf(o);
  }
  
  public Cell top(){
    return this.size() == 0 ? null : this.get(this.size() - 1);
  }
}