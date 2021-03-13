class BmChar{
  int x = 0;
  int y = 0;
  int d = cells;
  int aggro = 3;
  
  boolean korrekt = false;
  
  IdleAnim CharBfSprite = new IdleAnim();
  PImage AMspr;
  
  BmFeld Seat = null;
  PVector CharPos = new PVector(0,0);
  
  float barlength = 100;
  
  public String name = "Bob";
  int level = 20;
  int curExp = 0;
  int expScale = 23;
  int expToNextLvl = expScale*level;
  int expToGive = expScale*level*10;
  int[] baseStat = {40,20, 10, 40, 10, 10};
  
  int maxHP     = getHP(baseStat[0]);       int curHP = maxHP;
  int maxMP     = getHP(baseStat[1]);       int curMP = maxMP;
  int attStat   = getStat(baseStat[2]);     float attMult = 1;
  int defStat   = getStat(baseStat[3]);     float defMult = 1;
  int spAttStat = getStat(baseStat[4]);     float spAttMult = 1;
  int spDefStat = getStat(baseStat[5]);     float spDefMult = 1;
  
  
  boolean alive = true;
  ArrayList<Attack> attlist = new ArrayList<Attack>();
  int[] schwaechen = {5,5,5,5};
  int[] resistent = {5,5,5,5};
  
  
  BmChar(){
  }
  
  void construct(int a, int b, int c, int d, int e, int f){
      baseStat[0] = a;
      baseStat[1] = b;
      baseStat[2] = c;
      baseStat[3] = d;
      baseStat[4] = e;
      baseStat[5] = f;
      maxHP     = getHP(baseStat[0]);       curHP = maxHP;
      maxMP     = getHP(baseStat[1]);       curMP = maxMP;
      attStat   = getStat(baseStat[2]);     attMult = 1;
      defStat   = getStat(baseStat[3]);     defMult = 1;
      spAttStat = getStat(baseStat[4]);     spAttMult = 1;
      spDefStat = getStat(baseStat[5]);     spDefMult = 1;
     
  }
  
  void setup(){
    attlist.add(Fusstups);
  }
  
  void draw(){
    if(curHP > maxHP){
    curHP = maxHP;
  }
  if(curHP < 0){
    curHP = 0;
  }
  if(curMP > maxMP){
    curMP = maxMP;
  }
  if(curMP < 0){
    curMP = 0;
  }
    
    sprite();
    
    if(dist(mouseX, mouseY, x, y) < cells/2){
          textAlign(CORNER);
    textSize(14);
    healthbar(maxHP, curHP, x, y, color(200,20,20)); //max Wert, derzeitiger Wert
    healthbar(maxMP, curMP, x, y+d/4, color(40,20,200));
    fill(0);

    text(name, x,y);
    statusBox();
    }
    
  }
  
  void expLvlUpdate(){
      expToNextLvl = expScale*level;
      expToGive = expScale*level/10;
  }
  
  void statusBox(){
    rectMode(CORNER);
    fill(180,90);
    rect(width-width/4, height/4, width/4, height/4);
    textAlign(CORNER);
    textSize(14);
    fill(0);
    text(name+ " "+curHP+"/"+maxHP+" Exp:"+curExp+"/"+expToNextLvl,width-width/4, height/4);
    text("Ang.:"+attMult,width-width/4, height/4+20);
    text("Ver.:"+defMult,width-width/4, height/4+40);
    text("SpA.:"+spAttMult,width-width/4, height/4+60);
    text("SpV.:"+spDefMult,width-width/4, height/4+80);
    statusBoxextra(attMult, 20);
    statusBoxextra(defMult, 40);
    statusBoxextra(spAttMult, 60);
    statusBoxextra(spDefMult, 80);
  }
  
  private void statusBoxextra(float a, int s){
    if(a > 1){
    for(int i = 1; i < (a-1)/0.2; i++){
      rectMode(CENTER);
      stroke(0);
      fill(0,0,200);
      rect(width-width/4+40+20*i, height/4+s, 20, 20);
    }
    }else if(a < 1){
      for(int i = 0; i < (1-a)/0.2; i++){
        rectMode(CENTER);
        stroke(0);
      fill(200,0,0);
      rect(width-width/4+40+20*i, height/4+s, 20, 20);
    }
    }
  }
  
  void keyReleased(){
    if(key == 'a'){
      //curHP -=  30;
    }
  }
  
  void sprite(){
    stroke(0);
    fill(255,0,0);
    ellipse(x ,y, d,d);
    if(defMult < 1||spDefMult < 1){
      fill(200,40,40);
      triangle(x,y, x + d/2, y ,x + d/2, y + d/2);
    }
    else if(defMult > 1||spDefMult > 1){
      fill(40,200,40);
      triangle(x,y, x + d/2, y ,x - d/2, y - d/2);
    }

  }
  
  void spriteAM(){
    fill(0,255,0);
    rect(width/2,height/2,200,200);
  }
  void UiElements(){
  }
  void getRndValues(){
  }
  
  void aufgabe2(String a, String b, String c, int az, int bz, int cz){
  //int uix = width/2;
   int uiy = width/2;
   korrekt = false;
   String ges = "Nerd";
   switch(Battlestuff.ChoosenAttack.dif){
     case 1:
     ges = a;
     aufgabeKorrekt2(az);
     break;
     
     case 2:
     ges = b;
     aufgabeKorrekt2(bz);
     
     break;
     
     case 3:
     ges = c;
     aufgabeKorrekt2(cz);
     
     break;
     
     default:
     korrekt = false;
     break;
   }
   textAlign(CORNER);
   fill(0);
   text("Gesucht?: " + ges, 0, uiy/2-ho);
  }
  
  boolean aufgabeKorrekt(){
    korrekt = true;
    
    return korrekt;
  }
  
   boolean aufgabeKorrekt2(int ant){
   korrekt = false;
   
   if(int(Battlestuff.AntwortBox.boxText) == ant){
     korrekt = true;
   }
   
   return korrekt;
 }
  
  void healthbar(int maxb, int curb, int xPos, int yPos, color f){
    if(curb > maxb){
    curb = maxb;
  }
  if(curb < 0){
    curb = 0;
  }
  
  float curBarlength = round(curb * (barlength/maxb));
  stroke(0);
  fill(255);
  rectMode(CORNER);
  rect(xPos-d/2,yPos-d/2, barlength, 20);
  noStroke();
  fill(f);
  rectMode(CORNER);
  rect(xPos-d/2, yPos-d/2, curBarlength, 20);
  text(maxb + "/" + curb,xPos-d/4,yPos-d/4);
  
  if(defMult < 1||spDefMult < 1){
      fill(200,40,40);
      triangle(x,y, x + d/2, y ,x + d/2, y + d/2);
    }
    else if(defMult > 1||spDefMult > 1){
      fill(40,200,40);
      triangle(x,y, x + d/2, y ,x + d/2, y - d/2);
    }
}



int getStat(int stat){
    float calcedStat = (2* stat) * level/100 + level + 5;
    
    stat = (int)calcedStat;
    return stat;
  }
  
  int getHP(int stat){
    float calcedStat = (2* stat) * level/100 + level + 10;
    
    stat = (int)calcedStat;
    return stat;
  }
  
void imgp(PImage p){
  if(!Battlestuff.sketchmode){
  int uix = width/2; int uiy = height/2;
  imageMode(CENTER);
  image(p, uix, uiy);
  }
}

void aufgabe(){
  spriteAM();
  UiElements();
  //aufgabeKorrekt();
}



}

class BmCharG extends BmChar{
  BmCharG(String name){
    
    this.name = name;
    //this.attlist = attlist;
  }
}

class Kreisli extends BmChar{
  int r = (int)random(1,11);
  int d = r*2;
  int u = 2*3*r;
  int A = 3*r*r;
  
  Kreisli(){
    name = "Kreisli";
    construct(70, 80,50,50,85,80);
    schwaechen[0]= EIS;
    resistent[0]= PLASMA;
  }
  
  void setup(){
    attlist.add(Magstapf);
    attlist.add(Brenner);
    attlist.add(Pflaster);
    attlist.add(MPSaug);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[14], idles[15], 60,40,x,y);
  }
  
  void aufgabe(){
    spriteAM();
    UiElements();
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
     int uix = width/2; 
     int uiy = height/2;
     fill(200,30,30);
     ellipse(uix,uiy,300, 300);
     stroke(0);
     line(uix, uiy, uix-150, uiy);
    }
     imgp(KreisliAM);
  }
  
  void UiElements(){
   int uix = width/2; int uiy = height/2;
   aufgabe2("d", "u", "A", d, u, A);
   fill(0);
   text("r", uix-cells-4, uiy);
   text("r = "+ r, 0, uiy);
}
  
  void getRndValues(){
   r = int(random(1,11));
   d = r*2;
   u = 2*3*r;
   A = 3*r*r;
 } 

}

class Drach extends BmChar{
      int a = (int)random(1,11);
  int c = (int)random(1,11);
  int u = 2*(a+c);
  int e = 1;
  int f = 1;
  int A = 2/e*f;
  
  Drach(){
    name = "Drach";
    construct(90,50,95,60,95,60);
    schwaechen[0]= EIS;
    schwaechen[1]= PLASMA;
    resistent[0]= ERDE;
   
  }
  
  void setup(){
    
    attlist.add(Steinern);
    attlist.add(Drecker);
    //attlist.add(Fusstups);
    attlist.add(Absturzer);
    attlist.add(Schub);
  }
  

  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","e","A", u, e, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-80, uiy-50);
   text("a", uix+80, uiy-50);
   text("c", uix-80, uiy+120);
   text("c", uix+80, uiy+120);
   text("a = "+ a, 0, uiy);
   text("c = "+c, 0, uiy+40);
  }
  
    void sprite(){
   CharBfSprite.idlePlay(idles[16], idles[17], 40,30,x,y);
  }
  
  void spriteAM(){
       if(Battlestuff.sketchmode){
    int uix = width/2;
    int uiy = height/2;
    fill(250,200,0);
    triangle(uix-100, uiy, uix+100, uiy, uix, uiy-150);
    triangle(uix-100, uiy, uix+100, uiy, uix, uiy+100);
    }
    imgp(DrachAM);
  }
  
  void getRndValues(){
  a = (int)random(1,11);
  c = (int)random(1,11);
  u = 2*(a+c);
  e = 1;
  f = 1;
  A = 2/e*f;
  }
  
  
}

class Blocki extends BmChar{
  int a = (int)random(1,11);
  int A = a*a;
  int u = 4*a;
  
  Blocki(){
    name = "Blocki";
    construct(100,80,48,130,48,130);
    schwaechen[0]= PLASMA;
    resistent[0]= EIS;
  }
  
  void setup(){
    attlist.add(Hageln);
    attlist.add(Frierer);
    attlist.add(Eiszapf);
    attlist.add(Panzern);
    
  }
  
  void sprite(){
   CharBfSprite.idlePlay(BlockiBf1, BlockiBf2, 60,40,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
    int uix = width/2;
   int uiy = height/2;
   rectMode(CENTER);
   fill(25,25,230);
   rect(uix,uiy,br,br);
    }
    imgp(BlockiAM);
  }
  
    void UiElements(){
   int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","A","a", u, A, a);
   textAlign(CORNER);
   fill(0);
   text("a", uix-br, uiy);
   text("a", uix, uiy-br);
   text("a = "+ a, 0, uiy);

 }
 
 void getRndValues(){
   a = (int)random(1,11);
   A = a*a;
   u = 4*a;
 }
 
}

class Dreicki extends BmChar{
    int alph = 60;
  int a = (int)random(1,11);
  int u = a*3;
  int A = int(((a*a)/4)*sqrt(3));
  
   Dreicki(){
    name = "Dreicki";
    construct(40,80,110,45,90,45);
    schwaechen[0]= ERDE;
    resistent[0]= BLITZ;
    
  }
  
  void setup(){
    attlist.add(Elekkick);
    attlist.add(Schocker);
    attlist.add(Fusstups);
    attlist.add(Stacheln);  
    attlist.add(Aufregern);
  }
  
 
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("Winkel","u","A", alph, u, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-150, uiy);
   text("a", uix, uiy+150);
   text("a", uix+150, uiy);
   text("a = "+ a, 0, uiy);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(DreickiBf1, DreickiBf2, 20,40,x,y);
  }
  void spriteAM(){
    if(Battlestuff.sketchmode){
      int uix = width/2;
      int uiy = height/2;
      fill(250,250,0);
      triangle(uix-150,uiy+150,uix+150,uiy+150,uix,uiy-150);
    }
    imgp(DreickiAM);
  }
  
  void getRndValues(){
      alph = 60;
  a = (int)random(1,11);
  u = a*3;
  A = int(((a*a)/4)*sqrt(3));
  }
}

class Quaninchen extends BmChar{
  int a = (int)random(1,11);
  int A = a*a;
  int u = 4*a;
  int e = int(a*sqrt(2));
  
   Quaninchen(){
    name = "Quaninchen";
    construct(80,222,70,60,60,60);
    schwaechen[0]= PLASMA;
    resistent[0]= EIS;
    aggro = 2;
  }
  
  void setup(){
    attlist.add(Hageln);
    attlist.add(Frierer);
  }
  
  void aufgabe(){
    spriteAM();
    UiElements();
    //aufgabeKorrekt();
  }
  
  void UiElements(){
   int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","A","e", u, A, e);
   textAlign(CORNER);
   fill(0);
   text("a", uix-150, uiy);
   text("a", uix, uiy-150);
   text("a = "+ a, 0, uiy);

 }
 
   void sprite(){
   CharBfSprite.idlePlay(idles[6], idles[7], 30,30,x,y);
  }
 
 void spriteAM(){
   if(Battlestuff.sketchmode){
   int uix = width/2;
   int uiy = height/2;
   rectMode(CENTER);
   fill(25,25,230);
   rect(uix,uiy,br,br);
   }
   imgp(QuaninAM);
 }
 

  
 void getRndValues(){
   a = (int)random(1,11);
   u = a*4;
   A = a*a;
   e = int(a*sqrt(2));
 } 
  
}

class Quahase extends BmChar{
  int a = (int)random(1,11);
  int b = (int)random(1,11);
  int A = a*b;
  int u = 2*a +2*b;
  int e = a*a+b*b;
  
   Quahase(){
    name = "Quahase";
    construct(80,222,32,90,60,60);
    schwaechen[0]= PLASMA;
    schwaechen[1]= ERDE;
    resistent[0]= EIS;
    aggro = 4;
  }
  
  void setup(){
    attlist.add(Hageln);
    attlist.add(Panzern);
    attlist.add(Manteln);
  }
  
  void aufgabe(){
    spriteAM();
    UiElements();
    //aufgabeKorrekt();
  }
  
   void sprite(){
   CharBfSprite.idlePlay(idles[8], idles[9], 60,30,x,y);
  }
 
 void spriteAM(){
   if(Battlestuff.sketchmode){
   int uix = width/2;
   int uiy = height/2;
   rectMode(CENTER);
   fill(25,25,230);
   rect(uix,uiy,br,br+br/2);
   }
   imgp(QuahaAM);
 }
 
 void UiElements(){
   aufgabe2("u", "A", "e^2", u, A, e);
   int uix = width/2;
   int uiy = height/2;
   
   fill(0);
   text("a", uix-br, uiy);
   text("b", uix, uiy-br);
   text("a = "+ a, 0, uiy);
   text("b = "+ b, 0, uiy+cells);
 }
  
 void getRndValues(){
   a = (int)random(1,11);
   b = (int)random(1,11);
   u = 2*a + 2*b;
   A = a*b;
   e = a*a+b*b;
 } 
 
 boolean aufgabeKorrekt(){
   korrekt = false;
   if(int(Battlestuff.AntwortBox.boxText) == A){
     korrekt = true;
   }
   
   return korrekt;
 }
 
  
}


class Rhombo extends BmChar{
  int a = (int)random(1,6);
  int u = 4*a;
  int f = a-1;
  int e = 4*a*a - f*f;
  int A = int(sqrt(e)*f/2);
  
  Rhombo(){
    name = "Rh0mb/0id/us";
    construct(100,222, 40, 100, 80, 40);
    schwaechen[0] = PLASMA;
    resistent[0] = ERDE;
    resistent[1] = BLITZ;
    aggro = 2;
  }
  
  void setup(){
    attlist.add(Schocker);
    attlist.add(Panzern);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[4], idles[5], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
      fill(150);
      stroke(0);
      triangle(width/2,height/2-100,width/2,height/2+100,width/2-150,height/2);
      triangle(width/2,height/2-100,width/2,height/2+100,width/2+150,height/2);
    }
    imgp(RhomboAM);
  }
  
  void UiElements(){
   int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u", "e^2", "A", u, e, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-75, uiy-75);
   text("e", uix, uiy);
   text("a = "+ a, 0, uiy);
   text("f = "+ f, 0, uiy+50);
  }
  
  void getRndValues(){
    a = (int)random(1,6);
    u = 4*a;
    f = a-1;
    e = 4*a*a - f*f;
    A = int(sqrt(e)*f/2);
  }
  
}

class Para extends BmChar{
  int a = (int)random(1, 11);
  int b = (int)random(1,11);
  int u = 2*a +2*b;
  int h = (int)random(1,11);
  int A = a*h;
  
  Para(){
    name = "Paralle";
    construct(50, 100, 80, 60, 60,70);
    aggro = 3;
    resistent[0] = BLITZ;
    schwaechen[0] = ERDE;
    schwaechen[1] = BASISCH;
  }
  
  void setup(){
    attlist.add(Donnern);
    attlist.add(Frierer);
    attlist.add(Hageln);
    attlist.add(Schub);
    attlist.add(Manteln);
  }
  
  void UiElements(){
    int uix  = width/2;
    int uiy = height/2;
    aufgabe2("c", "u", "A", b, u, A);
    text("a", uix-150, uiy);
    text("b", uix, uiy-150);
    text("c", uix, uiy+150);
    text("a = "+a, 0, uiy);
    text("b = "+b, 0, uiy+40);
    text("h = "+h, 0, uiy+80);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[18], idles[19], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
      int uix = width/2;
      int uiy = height/2;
      fill(255,255,0);
      triangle(uix-150, uiy+150,uix-100, uiy-150,uix-100,uiy);
      triangle(uix-100,uiy-150,uix-100,uiy,uix+150,uiy+150);
    }
    imgp(ParaAM);
  }
  
  void getRndValues(){
      a = (int)random(1, 11);
      b = (int)random(1,11);
      u = 2*a +2*b;
      h = (int)random(1,11);
      A = a*h;
  }
  
}

class Drari extends BmChar{  
  int a = (int)random(1,11);
  int c = (int)random(1,11);
  int u = 2*(a+c);
  int e = (int)random(1,11);
  int f = (int)random(1,11);
  int A = e*f/2;
  
  Drari(){
    name = "Draritter";
    construct(60,30, 120, 100, 60,60);
    schwaechen[0] = BLITZ;
    schwaechen[1] = PLASMA;
    resistent[0] = EIS;
  }
  
  void setup(){
    attlist.add(Steinern);
    attlist.add(Fusstups);
    attlist.add(Frierer);
    attlist.add(Brenner);
    attlist.add(Schocker);
    attlist.add(Panzern);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","e","A", u, e, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-80, uiy-50);
   text("a", uix+80, uiy-50);
   text("c", uix-80, uiy+120);
   text("c", uix+80, uiy+120);
   text("a = "+ a, 0, uiy);
   text("c = "+c, 0, uiy+40);
   if(Battlestuff.ChoosenAttack.dif == 3){
   text("e = "+e, 0, uiy+40);
   text("f = "+f, 0, uiy+40);
   }
  }
  
 void sprite(){
   CharBfSprite.idlePlay(idles[10], idles[11], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
    int uix = width/2;
    int uiy = height/2;
    fill(150);
    triangle(uix-100, uiy, uix+100, uiy, uix, uiy-100);
    triangle(uix-100, uiy, uix+100, uiy, uix, uiy+150);
    }
    imgp(DrariAM);
  }
  
  void getRndValues(){
      a = (int)random(1,11);
      c = (int)random(1,11);
      u = 2*(a+c);
      e = 1;
      f = 1;
      A = e*f/2;
  }
  
}

class Zomb extends BmChar{
  int a = (int)random(1,11);
  int b = (int)random(1,11);
  int c = a/2;
  int u = a + b*2 +c;
  int m = (a+c)/2;
  int h = int(sqrt( sq(b) - sq((a-c)/2)));
  int A = m*h;
  
  Zomb(){
    name = "Zombdreck";
    construct(80, 20, 80,80, 80,90);
    resistent[0] = ERDE;
    resistent[0] = BLITZ;
    schwaechen[0] = EIS;
  }
  
  void setup(){
    attlist.add(Steinern);
    attlist.add(Drecker);
    attlist.add(MPSaug);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","m","A", u, m, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix, uiy+150);
   text("c", uix, uiy-150);
   text("b", uix-150, uiy);
   text("b", uix+150, uiy);
   text("a = "+ a, 0, uiy);
   text("b = "+b, 0, uiy+40);
   text("c = "+c, 0, uiy+80);
   text("h = "+h, 0, uiy+120);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[2], idles[3], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
    fill(0,100,0);
    rectMode(CORNER);
    rect(width/2-75, height/2-75, 150, 150);
    triangle(width/2-75, height/2-75, width/2-75, height/2+75, width/2-120, height/2+75);
    triangle(width/2+75, height/2-75, width/2+75, height/2+75, width/2+120, height/2+75);
    }
    imgp(ZombAM);
  }
  
  void getRndValues(){
      a = (int)random(1,11);
      b = (int)random(1,11);
      c = a/2;
      u = a + b*2 +c;
      m = (a+c)/2;
      h = int(sqrt( sq(b) - sq((a-c)/2)));
      A = m*h;
  }
}

class Tracar extends BmChar{
  int a = (int)random(1,11);
  int b = (int)random(1,11);
  int d = (int)random(1,11);
  int c = a/2;
  int u = a + b*2 +c;
  int m = (a+c)/2;
  int h = int(sqrt( sq(b) - sq((a-c)/2)));
  int A = m*h;
  
  Tracar(){
    name = "Tracar";
    construct(75, 20, 90, 90, 40, 95);
  }
  
  void setup(){
    attlist.add(Bodycheck);
    attlist.add(Elekkick);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","m","A", u, m, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix, uiy-150);
   text("c", uix, uiy+150);
   text("b", uix-150, uiy);
  // text("d", uix+150, uiy);
   text("a = "+ a, 0, uiy);
   text("b = "+ b, 0, uiy+40);
   text("c = "+ c, 0, uiy+80);
   text("b = "+ b, 0, uiy+120);
   text("h = "+ h, 0, uiy+160);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[0], idles[1], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
    fill(250,0,0);
    rectMode(CORNER);
    rect(width/2-75, height/2-75, 150, 150);
    triangle(width/2-75, height/2-75, width/2-75, height/2+75, width/2-100, height/2+75);
    triangle(width/2+75, height/2-75, width/2+75, height/2+75, width/2+120, height/2+75);
    }
    imgp(TracarAM);
  }
  
  void getRndValues(){
      a = (int)random(1,11);
      b = (int)random(1,11);
      c = a/2;
      u = a + b*2 +c;
      m = (a+c)/2;
      h = int(sqrt( sq(b) - sq((a-c)/2)));
      A = m*h;
  }
}

class OrangeJohn extends BmChar{  //Graphiken müssen noch erstellt werden
   int a = (int)random(1,11);
   int a2 = (int)random(1,8);
   int b2 = (int)random(1,8);
   int u = 4*a;
   int u2 = (2*a2) + (2*b2);
   int A = a*a;
   int A2 = a2*b2;
   
   boolean umgekippt = false;


  OrangeJohn(){
    name = "O-Saft John";
    construct(200, 1000, 100, 90, 110, 90);
    schwaechen[0] = BLITZ;
    resistent[0] = PLASMA;
  }
  
  void setup(){
    attlist.add(Frierer);
    attlist.add(Brenner);
    attlist.add(Panzern);
    attlist.add(Pflaster);
  }
  
  void aufgabe(){
    spriteAM();
    UiElements();
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   if(!umgekippt){
   aufgabe2("u+u2","A+A2","a", u+u2,A, A+A2);
   
   if(int(Battlestuff.AntwortBox.boxText) == A2){
     umgekippt = true;
     int attackenindex = 0;
     for(Attack a : attlist){
       if(a == Pflaster){
         attlist.remove(attackenindex);
         break;
       }
       attackenindex++;
     }
   }
   }else if(umgekippt){
     aufgabe2("u","A","a", u, A, a);
   }
   
   textAlign(CORNER);
   fill(0);
   text("a", uix-br, uiy);
   text("a", uix, uiy-br);
   text("a = "+ a, 0, uiy);
   text("a2 = "+ a2, 0, uiy+40);
   text("b2 = "+ b2, 0, uiy+80);
  }
  
  
  void sprite(){
   CharBfSprite.idlePlay(idles[30], idles[31], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
    int uix = width/2;
    int uiy = height/2;
    rectMode(CENTER);
    fill(200,180,0);
    rect(uix, uiy, 280,280);
    if(!umgekippt){
    rect(uix+170, uiy+40, 40,90);
    }
    }
    imgp(OjohnAM, OkartonAM);
    
  }
  
  void getRndValues(){
     a = (int)random(1,11);
     a2 = (int)random(1,8);
     b2 = (int)random(1,8);
   u = 4*a;
   u2 = (2*a2) + (2*b2);
   A = a*a;
   A2 = a2*b2;
  }
  
  void imgp(PImage p, PImage p2){
  if(!Battlestuff.sketchmode){
  int uix = width/2; int uiy = height/2;
  imageMode(CENTER);
  image(p, uix, uiy);
  if(!umgekippt){
  image(p2, uix+170, uiy+40);
  }
  }
  }

}



class Gleich extends BmChar{
  int alph = 60;
  int a = (int)random(1,11);
  int u = a*3;
  int A = int(((a*a)/4)*sqrt(3));
  
  Gleich(){
    name = "Gleich";
    construct(70,70,70,70,70,70);
    resistent[0] = BASISCH;
    schwaechen[0] = EIS;
  }
  
  void setup(){
    attlist.add(Bodycheck);
    attlist.add(Magman);
    attlist.add(Donnern);
    attlist.add(Hageln);
    attlist.add(Brenner);
    attlist.add(Schocker);
    attlist.add(Frierer);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("Winkel","u","A", alph, u, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-150, uiy);
   text("a", uix, uiy+150);
   text("a", uix+150, uiy);
   text("a = "+ a, 0, uiy);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[28], idles[29], 30,30,x,y);
  }
  
  void spriteAM(){
        if(Battlestuff.sketchmode){
      int uix = width/2;
      int uiy = height/2;
      fill(0,250,0);
      triangle(uix-150,uiy+150,uix+150,uiy+150,uix,uiy-150);
    }
    imgp(GleichAM);
  }
  
  void getRndValues(){
    a = (int)random(1,11);
    u = a*3;
    A = int(((a*a)/4)*sqrt(3));
  }
}

class Trap extends BmChar{
    int winkel = (int)random(95, 170);
  int betha = ((180-winkel)/2);
  int a = (int)random(1, 11);
  int c = a*2;
  int u = a+a+c;
  int h = (int)random(1,6);
  int A = (c*h)/2;
  
  
  Trap(){
    name = "Trapangle";
    construct(60, 100, 80, 100, 80,100);
    schwaechen[0] = EIS;
    resistent[0] = PLASMA;
    resistent[1] = BLITZ;
  }
  
  void setup(){
    attlist.add(Steinern);
    attlist.add(Fusstups);
    attlist.add(MPSaug);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","Betha","A", u, betha, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-150, uiy);
   text("a", uix+150, uiy);
   text("c", uix, uiy+150);
   text("Alpha = "+ winkel, 0, uiy);
   text("a = "+ a, 0, uiy+40);
   text("c = "+ c, 0, uiy+80);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[22], idles[23], 30,30,x,y);
  }
  
  void spriteAM(){
     int uix = width/2;
    int uiy = height/2;
    if(Battlestuff.sketchmode){
      fill(0,40,0);
      triangle(uix, uiy-80, uix-180, uiy+150, uix+180, uiy+150);
    }
    imgp(TrapAM);
  }
  
  void getRndValues(){
       winkel = (int)random(95, 170);
  betha = (180-winkel/2);
  a = (int)random(1, 11);
  c = a*2;
  u = a+a+c;
  h = (int)random(1,6);
  A = (c*h)/2;
  }
}

class Kevin extends BmChar{
  int winkel = (int)random(5, 80);
  int betha = ((180-winkel)/2);
  int a = (int)random(1, 11);
  int c = a/2+1;
  int u = a+a+c;
  int h = (int)random(1,6);
  int A = (c*h)/2;
  
  Kevin(){
    name = "Kevin";
    construct(50, 100, 100, 80, 100,80);
    schwaechen[0] = BLITZ;
    resistent[0] = ERDE;
  }
  
  void setup(){
    attlist.add(Hageln);
    attlist.add(Brenner);
    attlist.add(Stacheln);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("u","Betha","A", u, betha, A);
   textAlign(CORNER);
   fill(0);
   text("a", uix-70, uiy);
   text("a", uix+70, uiy);
   text("c", uix, uiy+150);
   text("a = "+ a, 0, uiy);
   text("c = "+ c, 0, uiy+40);
   text("h = "+h, 0, uiy+80);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[20], idles[21], 30,30,x,y);
  }
  
  void spriteAM(){
    int uix = width/2;
    int uiy = height/2;
    if(Battlestuff.sketchmode){
      fill(0,40,0);
      triangle(uix, uiy-150, uix-100, uiy+150, uix+100, uiy+150);
    }
    imgp(KevinAM);
  }
  
  void getRndValues(){
      winkel = (int)random(5, 80);
  betha = (180-winkel/2);
  a = (int)random(1, 11);
  c = a/2+1;
  u = a+a+c;
  h = (int)random(1,6);
  A = (c*h)/2;
  }
}


class Recht extends BmChar{
  int winkel = 90;
  int a = (int)random(1, 11);
  int b = (int)random(1, 11);
  int c  = (int)random(1, 11);
  int u = a+b+c;
  int A = (a*b)/2;
  
  Recht(){
    name = "Rechtwinkler";
    construct(90, 100, 85, 70, 95, 80);
    schwaechen[0] = ERDE;
    resistent[0] = PLASMA;
    resistent[1] = EIS;
    resistent[2] = BLITZ;
  }
  
  void setup(){
    attlist.add(Schocker);
    attlist.add(Brenner);
    attlist.add(Schub);
    attlist.add(Manteln);
  }
  
  void UiElements(){
    int uix = width/2;
    int uiy = height/2;
    aufgabe2("Winkel"+"°", "u", "A", winkel, u, A);
    text("a = " +a, 0,uiy);
    text("b = " +b, 0, uiy+40);
    text("c = " +c, 0, uiy+80);
    text("a", uix+150, uiy);
    text("b", uix-150, uiy);
    text("c", uix, uiy+150);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[26], idles[27], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
        int uix = width/2;
    int uiy = height/2;
    fill(255);
    ellipse(uix-65, uiy-110, 70, 70);
    fill(0);
    ellipse(uix-60, uiy-90, 10, 10);
    fill(200,250,0,90);
    triangle(uix-150, uiy+150, uix+150, uiy+150, uix-65, uiy-110);
   
    }
    imgp(RechtAM);
  }
  
  void getRndValues(){
      a = (int)random(1, 11);
      b = (int)random(1, 11);
      c  = (int)random(1, 11);
      u = a+b+c;
      A = (a*b)/2;
  }
  
}


class Wgott extends BmChar{
  int a = (int)random(1,8);
  int AM = 4*a*a;
  int AO = 6*a*a;
  int V = a*a*a;
  
  Wgott(){
    name = "Weurfrlgato";
    construct(120, 222, 120,120, 120, 120);
    schwaechen[0] = PLASMA;
    schwaechen[1] = BASISCH;
  }
  
  void setup(){
        attlist.add(Schocker);
    attlist.add(Brenner);
    attlist.add(Schub);
    attlist.add(Manteln);
        attlist.add(Drecker);
    attlist.add(Frierer);
    attlist.add(Stacheln);
    attlist.add(Panzern);
    attlist.add(MPSaug);
    attlist.add(Pflaster);
    attlist.add(Bodycheck);
  }
  
  void UiElements(){
      int uix = width/2;
   int uiy = height/2;
   korrekt = false;
   aufgabe2("AM","AO","V", AM, AO, V);
   textAlign(CORNER);
   fill(0);
   text("a", uix-150, uiy);
   text("a", uix, uiy-150);
   text("a", uix+170, uiy+150);
   text("a = "+ a, 0, uiy);
  }
  
  void sprite(){
   CharBfSprite.idlePlay(idles[24], idles[25], 30,30,x,y);
  }
  
  void spriteAM(){
    if(Battlestuff.sketchmode){
     int uix = width/2;
     int uiy = height/2;
     rectMode(CENTER);
     fill(0,240,255);
     rect(uix, uiy, 250, 250);
     triangle(uix-125, uiy-125,uix-85,uiy-125, uix-85, uiy-165);
     rect(uix+20, uiy-145, 210, 40);
     triangle(uix+125,uiy-125, uix+125, uiy-165, uix+165, uiy-165);
     triangle(uix+125,uiy-125, uix+165, uiy-125, uix+165, uiy-165);
     rect(uix+145, uiy-20, 40, 210);
     triangle(uix+125, uiy+125, uix+125, uiy+85, uix+165, uiy+85);
    }
    imgp(WgottAM);
  }
  
  void getRndValues(){
    a = (int)random(1,8);
    AM = 4*a*a;
    AO = 6*a*a;
    V = a*a*a;
  }
  
}

class Quasol extends BmChar{
  int a = (int)random(1, 11);
  int a2 = a/2;
  int u = 4*a+2*a2;
  int A = a*a+a2*a2;
  
  Quasol(){
    name = "Quadat";
    construct(40, 70, 70,60,60,80);
    schwaechen[0] = PLASMA;
  }
  
  void setup(){
    attlist.add(Bodycheck);
    attlist.add(Steinern);
  }
  
  void UiElements(){
    int uix = width/2;
    int uiy = height/2;
    aufgabe2("A","u","u",A,u,u);
    textAlign(CORNER);
    fill(0);
    text("a = "+a, 0, uiy);
    text("a2 = "+a2, 0, uiy+40);
    text("a", uix-150, uiy);
    text("a2",uix-70 ,uiy-170);
  }
  
    void sprite(){
   CharBfSprite.idlePlay(idles[32], idles[33], 120,60,x,y);
  }
  
  void spriteAM(){
    int uix= width/2;
    int uiy = height/2;
    if(Battlestuff.sketchmode){
      rectMode(CENTER);
      fill(0,50,0);
      rect(uix, uiy, 300, 300);
      rect(uix, uiy-180, 60,60);
    }
    imgp(QuadatAM);
  }
  
  void getRndValues(){
          a = (int)random(1, 11);
  a2 = a/2;
  u = 4*a+2*a2;
  A = a*a+a2*a2;
  }
  
}

class Quakom extends BmChar{
  int a = (int)random(1, 11);
  int b = (int)random(1, 11);
  int a2 = b/2;
  //int b2 = (int)random(1, 11);
  int u = 2*a+2*b+2*a2;
  int A = a*b+a2*a2;
  
  Quakom(){
    name = "Quamander";
    construct(75, 200, 50, 80, 50, 80);
    schwaechen[0] = ERDE;
  }
  
    void setup(){
    attlist.add(Stacheln);
    attlist.add(Panzern);
    attlist.add(Pflaster);
    attlist.add(Brenner);
  }
  
    void UiElements(){
      aufgabe2("A", "u", "u", A, u, u);
    int uix = width/2;
    int uiy = height/2;
    textAlign(CORNER);
    fill(0);
    text("a = "+a, 0, uiy);
    text("a2 = "+a2, 0, uiy+80);
    text("b = "+b, 0, uiy+40);
    //text("b2 = "+a2, 0, uiy+120);
    text("a", uix-150, uiy);
    text("b", uix, uiy+150);
    text("a2",uix-70 ,uiy-170);
  }
  
    void sprite(){
   CharBfSprite.idlePlay(idles[34], idles[35], 30,30,x,y);
  }
  
  void spriteAM(){
       int uix= width/2;
    int uiy = height/2;
    if(Battlestuff.sketchmode){
      rectMode(CENTER);
      fill(0,50,0);
      rect(uix, uiy, 240, 300);
      rect(uix, uiy-180, 60,60);
    }
    imgp(QuamanderAM);
  }
  
  void getRndValues(){
      a = (int)random(1, 11);
  b = (int)random(1, 11);
  a2 = b/2;
 // b2 = (int)random(1, 11);
  u = 2*a+2*b+2*a2;
  A = a*b+a2*a2;
  }
  
}
