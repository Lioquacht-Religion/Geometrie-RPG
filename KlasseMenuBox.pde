
class MenuBox{
  int x;
  int y;
  int breite;
  int hoehe;
  String boxText = "";
  color farbe = 255;
  boolean clicked = false;
  
public MenuBox(int xmb, int ymb, int bmb, int hmb){
   this.x = xmb;
   this.y = ymb;
   this.breite = bmb;
   this.hoehe = hmb;
}
  
public MenuBox(int xmb, int ymb, int bmb, int hmb, String boxTxtmb, color f){
  this(xmb, ymb, bmb, hmb);
   this.boxText = boxTxtmb;
   this.farbe = f;
 }

void draw(){
  menuBoxClick();
  displayMenuBox();
}
 
  
void displayMenuBox(){
  
  rectMode(CORNER);
  stroke(0);
  fill(this.farbe);
  rect(x,y, breite, hoehe);
  textSize(40);
  textAlign(CENTER);
  fill(0);
  text(this.boxText,x+breite/2,y+hoehe/2);  
  
  if(x <= mouseX && mouseX <= x + breite && y <=mouseY &&mouseY <= y + hoehe){
    blink(x + breite, y +hoehe/2);
  }
} 

void menuBoxClick(){
  if(clickedDouble && x <= mouseX && mouseX <= x + breite && y <=mouseY &&mouseY <= y + hoehe){
    clicked = true;
  }else clicked = false;
}

void blink(int xb, int yb){
  int xC;
  int yC;
 
    yC = yb;
    xC = xb - (millis() % 10);
    
     triangle(xC,yC,xC+20,yC-10,xC+20,yC+10);
}

void umrandung(){
    rectMode(CORNER);
    fill(0);
    rect(x-breite/10,y-hoehe/10, breite +breite/10*2, hoehe +hoehe/10*2); 
}

}

class SaveGameBox extends MenuBox{
  String datnam = "";
  int curSavData = 0;
  
  SaveGameBox(int xmb, int ymb, int bmb, int hmb, String boxTxtmb, color f, String datnam, int curSavData){
    super(xmb, ymb, bmb, hmb, boxTxtmb, f);
    this.datnam = datnam +".json";
    this.curSavData = curSavData;
  }
  
  void displayMenuBox(){
    rectMode(CORNER);
    fill(0,0, 90);
    rect(x, y, breite, hoehe);
    textSize(20);
    textAlign(CORNER);
    fill(255);
    text(boxText, x, y+cells/2);
    
      JSONObject data = loadJSONObject(datnam);
      text(Rooms.get(data.getInt("savRoom"+curSavData)).name, x, y+cells);
          int sl = 0;
      for(int i = 0; i < Mclist.length; i++){
        if(data.getBoolean(i+"teammatebool")){
        Mclist[i].x = x+breite/2; Mclist[i].y = y+hoehe-hoehe/4;
        pushMatrix();
        translate(cells*2*sl, 0);
        
        Mclist[i].sprite();
        popMatrix();
        sl++;
        }
      }
      if(recPointCol(mouseX, mouseY, x, y, breite, hoehe)){
    blink(x+breite, y+hoehe/2);
      }
  }
  
}

class SliderBox extends MenuBox{
  
  
  SliderBox(int xmb, int ymb, int bmb, int hmb){
    super(xmb, ymb, bmb, hmb);
  }
}


class EintragBox extends MenuBox{
  int count = 0;
  int maxCount;
  
  EintragBox(int xmb, int ymb, int bmb, int hmb, int maxCount){
    super(xmb, ymb, bmb, hmb);
    this.maxCount = maxCount;
  }
  
  void draw(){
    eintragClick();
    displayMenuBox();
  }
  
  void eintragClick(){
    if(mousePressed && mouseX > x && mouseX < x + breite && mouseY > y && mouseY < y+hoehe){
    clicked = true;
  }else if(!(mouseX > x && mouseX < x + breite && mouseY > y && mouseY < y+hoehe)){
    clicked = false;
  }
  if(clicked){
    umrandung();
  }
  }
  
  void keyReleased(){
  if(clicked){
  if(count >= maxCount){
    boxText = "";
    count = 0;
  }
  
    if(keyCode == 8){
   String Wort = "";
   for(int i = 0; i < boxText.length()-1; i++){
     Wort += boxText.charAt(i);
   }
   boxText = Wort;
   count--;
   //Eingabe = Eingabe.replaceFirst(Eingabe.substring(Eingabe.length()-1), "");
 }  else if(keyCode >= 48 && keyCode <= 57){
 
    boxText = boxText + key;
    count++;
 }
}
}
  
}
