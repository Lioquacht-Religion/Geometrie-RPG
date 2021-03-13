class OwChar{
  int x;
  int y;
  int d = cells; 
  int speed = 4;
  
  
  PVector Force = new PVector(0,0);
  
  ArrayList<BmChar> charlist = new ArrayList<BmChar>();
  boolean alive = true;
  
  OwChar(int x,int y){
    this.x = x;
    this.y = y;
  }
  
  void draw (){
    sprite();
  }
  
  void sprite(){
    stroke(0);
    fill(0,255,0);
    ellipse(x,y,d,d);
  }

}

class OwPlayer extends OwChar{
  ArrayList<BmChar> Allplcharslist = new ArrayList<BmChar>();
  
  Item[] items = {Heiltrank, Manatrank, Maxitrank, Hpplus, Mpplus, Attplus, Defplus, SpAplus,SpDplus, AtAufregern, AtMagman, AtBodycheck, AtManteln, Dreickkey, Blockkey, Trikey};
  int[] itemanzahl = new int[items.length];
  
  
  public Savestation LastSave = new Savestation(width/2, height/2);
 
  
  OwPlayer(int x, int y){
    super(x,y);
      //itemanzahl[items.length-1] = 1;
  //itemanzahl[items.length-2] = 1;
  }
  
  void draw(){
    movement();
    sprite();
  }
  
  void sprite(){
    stroke(0);
    fill(200,20,20);
    ellipse(x,y,d,d);
    fill(255,0, 255);
    ellipse(x, y, d/4, d/4);
  }
  
  void keyReleased(){
    if(key == 'e'){
      for(OwPerson op : CurrentRoom.owpelist){
        if(op instanceof Savestation && dist(op.x, op.y, x, y) < cells){
          LastSave.x = op.x;
          LastSave.y = op.y;
          LastSave.SavedRoom = CurrentRoom;
          
         // println(LastSave.x+"||"+LastSave.y+"||"+CurrentRoom.name);
        }
      }
    }
  }
  
  void movement(){
     
     for(Wall w : CurrentRoom.roomwalllist){
      if(w.bottom){
        up = false;
      }
      if(w.top){
        down = false;
      }
      if(w.rside){
        right = false;
      }
      if(w.lside){
        left = false;
      }
      if(recPointCol(x, y, w.x, w.y, w.br, w.ho)){
        if(x < w.x+w.br/2){
          x--;
        }
        if(x > w.x+w.br/2){
          x++;
        }
        if(y < w.y+w.ho/2){
          y--;
        }
        if(y > w.y+ho/2){
          y++;
        }
      }
    }
    boolean mup = true; 
    boolean mdown = true;
    boolean mright = true;
    boolean mleft = true;
    
    int plXtoW = x/cells;
    int plYtoH = y/cells;
    
    
    for(int i = plXtoW-1; i < plXtoW+2 && i <= w-1; i++){
      for(int j = plYtoH-1; j < plYtoH+2 && j <= h-1; j++){
           
       if(i >= 0 && j >= 0){        
        if(CurrentRoom.wallTab[i][j] != null ){
               Wall w = CurrentRoom.wallTab[i][j];
      if(CurrentRoom.wallTab[i][j].bottom && up){
        for(int yscan = y; yscan > w.y+ w.ho; yscan--){
          y = yscan;
        }
        mup = false;
      }
      if(CurrentRoom.wallTab[i][j].top){
        for(int yscan = y; yscan < w.y; yscan++){
          y = yscan;
        }
        mdown = false;
      }
      if(CurrentRoom.wallTab[i][j].rside){
        for(int xscan = x; xscan > w.x+ w.br; xscan--){
          x = xscan;
        }
        mright = false;
      }
      if(CurrentRoom.wallTab[i][j].lside){
        for(int xscan = x; xscan < w.x; xscan++){
          x = xscan;
        }
        mleft = false;
      }
        

              if(recPointCol(x, y, w.x, w.y, w.br, w.ho)){
        if(x < w.x+w.br/2){
          x--;
        }
        if(x > w.x+w.br/2){
          x++;
        }
        if(y < w.y+w.ho/2){
          y--;
        }
        if(y > w.y+ho/2){
          y++;
        }
      }
        }
    }
    }
    }
    
    if(up && mup){
      transy += speed;
      y-= speed;
    }
    if(down && mdown){
      transy -= speed;
      y+= speed;
    }
    if(left && mleft){
      transx += speed;
      x-= speed;
    }
    if(right && mright){
      transx -= speed;
      x+= speed;
    }
    
  }
  
  
}

class OwPerson extends OwChar{
  String[] Text = {"Position gespeichert.","Team regeneriert."};
  int curLine = 0;
  boolean speakmode = false;
  //boolean alive = true;
  
  Room SavedRoom;
  
   OwPerson(int x, int y){
    super(x, y);
  }
  
  OwPerson(int x, int y, String[] Text){
    super(x, y);
    this.Text = Text;
  }
  
  void sprite(){
    stroke(0);
    fill(200,20,50);
    ellipse(x,y,d,d);
    
  }
  
  void event(){
  }
  
  void sprechBox(){
    if(speakmode && alive){
    textBox(Text[curLine],20, height- height/6-20, width-40,height/6-20);
    }
  }
  
  void keyReleased(){
    if(alive){
    if(key == 'e' && !speakmode &&dist(PlayerOw.x, PlayerOw.y, x, y) < cells){
      speakmode = true;
      cutscene = true;
    }else if(key == 'e' && speakmode && dist(PlayerOw.x, PlayerOw.y, x, y) < cells ){
      if(curLine+1 < Text.length){
      curLine++;
      }else{
        curLine = 0;
        event();
        speakmode = false;
        cutscene = false;
      }
    }
    }
    if(key == 'r'){
      speakmode = false;
      cutscene = false;
    }
  }
}

class OwPersonRec extends OwPerson{
  
  OwPersonRec(int x, int y, String[] Text){
    super(x, y, Text);
  }
  
  void sprite(){
    rectMode(CENTER);
    fill(0,0, 255);
    rect(x, y, cells, cells-4);
  }
  
}

class Gatekeeper extends OwPerson{
  eventWall MyGate = null;
  int item1 = 0;
  int item2 = 0;
  
  Gatekeeper(int x, int y, eventWall MyGate, int item1, int item2){
    super(x, y);
    this.MyGate = MyGate;
    this.item1 = item1;
    this.item2 = item2;
    String[] Text2 = {"Halte ein Reisender!", "Um hier weiter zu können benötigt ihr...", "den BLOCKSCHLÜSSEL sowie den TRISCHLÜSSEL!!!", 
    "Der BLOCKSCHLÜSSEL befindet sich hinter BLOCKSTADT in den Klauen des Quamilitärs."
  , "Der TRISCHLÜSSEL liegt gen NORDEN, im hintersten Eck der DRAWÜSTE."};
    
    this.Text = Text2;
  }
  
  void event(){
    if(PlayerOw.itemanzahl[item1] > 0 && PlayerOw.itemanzahl[item2] > 0){
      MyGate.exist = false;
    }
  }
}

class OwItem extends OwPerson{
  int add = 0;
  boolean picked = false;
  int ItemIndex = 0;
  //Item Inhalt = null;
  
  
  OwItem(int x, int y, int ItemIndex){
    super(x, y);
    //this.Inhalt = Inhalt;
    this.ItemIndex = ItemIndex;
    String[] Text2 = {PlayerOw.items[ItemIndex].name + " erhalten"};
    this.Text = Text2;
  }
  
  void sprite(){
    if(alive){
      stroke(0);
    fill(0,255,0);
    ellipse(x,y, cells, cells);
    textAlign(CENTER);
    fill(0);
    textSize(24);
    text("I", x,y+10);
  }
}



void event(){
  PlayerOw.itemanzahl[ItemIndex] ++;
  
  picked = true;
  alive = false;
}

}


class Savestation extends OwPerson{
  //int savedx = PlayerOw.x;
  //int savedy = PlayerOw.y;
  public Room SavedRoom;
  //Text = {"Position gespeichert.", "Gruppenmitglieder regeneriert."};
  
  Savestation(int x, int y){
    super(x, y);
  }
  
  void sprite(){
    rectMode(CENTER);
    fill(0,200,200);
    rect(x+cells/2, y+cells/2, cells, cells);
       textAlign(CENTER);
    fill(0);
    textSize(24);
    text("S", x+cells/2,y+cells/2+10);
  }
  
  void event(){
    //savedx = PlayerOw.x;
    //savedy = PlayerOw.y;
    SavedRoom = CurrentRoom;
    for(BmChar bc : PlayerOw.Allplcharslist){
      bc.curHP = bc.maxHP;
      bc.curMP = bc.maxMP;
    }
     for(OwEnemy c : CurrentRoom.roomowenlist){
      c.alive = true;
      c.x = c.xp;
      c.y = c.yp;
    }
    int i = 0;
    for(Room r : Rooms){
      if(CurrentRoom == r){
        savedRoom = i;
        break;
      }
      i++;
    }
    
    saveGameData(activerSpielstand);
  }
  
}
  
class OwTeammate extends OwPerson{
  
  BmChar addChar = null;
  IdleAnim Mateanim = new IdleAnim();
  PImage Spr1, Spr2 = null;
  
  OwTeammate(int x, int y, String[] Text, BmChar addChar, PImage Spr1, PImage Spr2){
    super(x, y, Text);
    this.addChar = addChar;
    this.Spr1= Spr1; 
    this.Spr2 = Spr2; 
  }
  
  void sprite(){
    if(alive){
      Mateanim.idlePlay(Spr1, Spr2,60,60, x, y);
    }
  }
  
  void event(){
    PlayerOw.Allplcharslist.add(addChar);
    alive = false;
  }
  
}  
  
class OwBoss extends OwTeammate{
  
  OwBoss(int x, int y, String[] Text, BmChar addChar, PImage Spr1, PImage Spr2){
    super(x, y, Text, addChar, Spr1, Spr2);
    charlist.add(addChar);
    charlist.get(0).setup();

  } 
  
  void event(){
    gamestate = BM;
    Battlestuff.battlestate = Battlestuff.ENTRANCE;
    Battlestuff.encharlist.addAll(charlist);
        Battlestuff.plcharlist.clear();
    Battlestuff.plcharlist.addAll(PlayerOw.charlist);
  }
  
}

class OwEnemy extends OwChar{
  int br = cells;
  int xp, yp = 0;
  
  OwEnemy(int x, int y){
    super(x,y);
    xp = x;
    yp = y;
  }
  
  void draw(){
    render();
  }
    
   void render(){
     //followPlayer();
     col();
    stroke(0);
    fill(0,255,0);
    ellipse(x, y, d,d);
    noStroke();
  for(int i = 5; i > 0; i--){
  fill(10*i,250 - 30* i,10*i, 20+ 20*i);
  ellipse(x,y,br-5*i,br-5*i);
  }
  fill(0);
  ellipse(x,y, br-10,br-10);
  br-= 1;
  if(br < -cells){
    br = cells;
  }
  }
  
  
   void col(){
    x += Force.x;
    y += Force.y;
    
    if(dist(PlayerOw.x,PlayerOw.y, x,y) < 200 && dist(PlayerOw.x,PlayerOw.y, x,y) > cells/2){
      if(PlayerOw.x < x){
        Force.x = -2;
      }else
      if(PlayerOw.x > x){
        Force.x = 2;
      }else{Force.x = 0;  }
      if(PlayerOw.y < y){
        Force.y = -2;
      }else
      if(PlayerOw.y > y){
        Force.y = 2;
      }else{Force.y = 0; }
    }else if(dist(PlayerOw.x, PlayerOw.y, x,y) < cells/2){
      Force.x = 0;
      Force.y = 0;
      
    }else{Force.x = 0; Force.y = 0;}
    
    int enXtoW = x/cells;
    int enYtoH = y/cells;
    
  for(int i = enXtoW-1; i < enXtoW+2 && i < w; i++){
    for(int j = enYtoH-1; j < enYtoH+2 && j < h; j++){
      
      if(i >= 0 && j >= 0){
       Wall w = CurrentRoom.wallTab[i][j];
     if(w != null){
       
    if(dist(w.x + cells/2 ,w.y + cells/2 ,x,y) < cells-6){
      if(w.x +cells/2 < x){
        Force.x += 2;
      }else
      if(w.x +cells/2 > x){
        Force.x -= 2;
      }else{Force.x = 0;  }
      if(w.y +cells/2 < y){
        Force.y += 2;
      }else
      if(w.y +cells/2 > y){
        Force.y -= 2;
      }else{Force.y = 0; }
    }
     }
    }
  }
  }
  }
  

  void followPlayer(){
   if(dist(x,y, PlayerOw.x, PlayerOw.y) < 200){
    if(x < PlayerOw.x){
      x++;
    }
    if(x > PlayerOw.x){
      x--;
    }
if(y> PlayerOw.y){
y--;
}

if(y< PlayerOw.y){
y++;
}
   }

}
}
