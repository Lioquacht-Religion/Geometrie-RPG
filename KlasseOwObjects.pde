abstract class OwObject{
  int x = 0;
  int y = 0;
  
  OwObject(){
  }
  
  OwObject(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  void render(){
  }
  
}



class Item extends OwObject{
  String name = "Item";
  BmChar User = null;
  int a, b, c, d, e, f, g, h =0;
  int anzahl = 0;
  
  
  Item(){
  }
  
  Item(String name, int a, int b, int c, int d, int e, int f, int g, int h
  ){
    this.name = name;
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.e = e;
    this.f = f;
    this.g = g;
    this.h = h;
  }
  
  void use(){
    User.curHP += a;
    User.curMP += b;
    User.attStat += c;
    User.defStat += d;
    User.spAttStat += e;
    User.spDefStat += f;
    User.maxHP += g;
    User.curHP += h;
  }

}

class AtItem extends Item{
  Attack Teach = null;
  
  AtItem(Attack Teach){
    this.Teach = Teach;
    this.name = Teach.name;
  }
  
  void use(){
    if(User.attlist.size() < 6){
      User.attlist.add(Teach);
    }else {
      User.attlist.remove(6);
      User.attlist.add(Teach);
    }
  }
  
}

class KeyItem extends Item{
  
  KeyItem(String name){
    this.name = name;
  }
  
  void use(){
  }
  
}



class Wall extends OwObject{
  int br;
  int ho;
  
  boolean top, bottom, lside, rside = false;
  
  Wall(int x, int y, int br, int ho){
    super(x,y);
    this.br =br;
    this.ho = ho;
  }
  
  void render(){
    rectMode(CORNER);
    fill(0,0,255,90);
    rect(x,y,br,ho);
   
    //colDetect();
  }
  
  void colDetect(){
     if(PlayerOw.x >= x && PlayerOw.x <= x +br && PlayerOw.y+PlayerOw.speed >= y && PlayerOw.y <= y + ho){
      top = true;
    }else{ top = false;}
    
     if(PlayerOw.x >= x && PlayerOw.x <= x +br && PlayerOw.y >= y && PlayerOw.y-PlayerOw.speed <= y + ho){
      bottom = true;
    }else{ bottom = false;}
    
     if(PlayerOw.x+PlayerOw.speed >= x && PlayerOw.x <= x +br && PlayerOw.y >= y && PlayerOw.y <= y + ho){
      rside = true;
    }else{ rside = false;}
    
     if(PlayerOw.x >= x && PlayerOw.x-PlayerOw.speed <= x +br && PlayerOw.y >= y && PlayerOw.y <= y + ho){
      lside = true;
    }else{ lside = false;}
  }
}

class eventWall extends Wall{
  boolean exist = true;
  int tileindex = 0;
  
  eventWall(int x, int y, int br, int ho, int tileindex){
    super( x, y, br, ho);
    this.tileindex = tileindex;
  }
  
  void render(){
    if(exist){
    for(int i = 0; i < br/cells; i++){
      for(int j = 0; j < ho/cells; j++){
        image(tiles[tileindex], x+cells*i, y+cells*j);
      }
    }  
      colDetect();    
  }
  }
  
}

class Roof extends Wall{
  
  Roof(int x, int y, int br, int ho){
    super( x, y, br, ho);
  }
  
  void render(){
   if(!( recPointCol(PlayerOw.x, PlayerOw.y, x, y, br, ho) ) ){
    rectMode(CORNER);
    fill(200,100,80);
    rect(x,y,br,ho);
  }
  
  }
  
}
