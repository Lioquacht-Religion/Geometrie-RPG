class BmFeld{
  int x;
  int y;
  int fr= 255;
  PVector plpos = new PVector();
  boolean clicked = false;
  
  BmChar SeatedChar = null;
  
  BmFeld(){
   
  }
  
  void draw(){
    fieldboxclick();
    sprite();
  }
  
  void sprite(){
    if(SeatedChar != null){
      SeatedChar.x = x;
      SeatedChar.y = y;
    }
    rectMode(CENTER);
    //strokeWeight(8);
    stroke(0);
    fill(fr);
    if(SeatedChar != null){
      fill(0,240,0);
    }
    rect(x,y,cells*2+10,cells*2);
    textSize(8);
    fill(0);
    //text((int)plpos.x, x+(cells+10)/4, y+cells/4);
    //text((int)plpos.y, x+(cells+10)-(cells+10)/4, y+cells-cells/4);
  }
  
  void fieldboxclick(){
    if(dist(mouseX, mouseY, x, y) < cells){
      fr = color(255,0,0);
    }else{fr = 255;}
    if(clickedDouble && dist(mouseX, mouseY, x, y) <= cells){
      clicked = true;
    }else{ clicked = false;}
  }
}
