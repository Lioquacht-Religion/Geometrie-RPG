abstract class Animation{
}


class AttAnim extends Animation{
  int t = 0;
  int maxt = 10;
  
  AttAnim(int maxt){
    this.maxt = maxt;
    this.t = maxt;
  }
  
  void healanim(int x, int y, int wa, color f){
  wa += (int)random(-10,11);
  for(int i = x-wa/2; i< x+wa; i++){
    for(int j = y-wa/2; j< y+wa; j++){
      if(dist(x,y,i,j) < wa/2){
        set(i,j, get(i,j)+f );
      }
    }
  }
  for(int i = 0; i<wa/4; i++){
    fill(f);
  ellipse(x+(int)random(-wa/2,wa/2), y+(int)random(-wa/2,wa/2), 30,30);
  }
  t++;
}

void absorbanim(int x, int y, int wa, int ha, color f){
  fill(f);
  int[] zz = new int[ha/10];
  int s = 0;
  if(millis() % 2 == 0){
    s = -40;
  }else{s = 0;}
  for(int i = 0; i < zz.length; i++){
    zz[i] = y+(ha/10*i)+s;
    int xr = (int)random(x-wa/2+10*i,x+wa/2-10*i);
    int d = (int)random(20,60);
    ellipse(xr, zz[i], d,d);
  }
  t++;
}

 
void slashanim(int x, int y, color f){
  if(t > maxt){
    t=0;
    background(230,20,20);
  }
  noStroke();
  fill(f);
  triangle(x-300,y+300, x-290, y+280, x-300+10*t*1.2, y+300-10*t*1.2 );
  triangle(x-300,y+300, x-290, y+280, x-x/8, height );
  t+=4;
}

}




class IdleAnim extends Animation{
  PImage firstSpr;
  PImage secondSpr;
  int frameDeC, frameDuC = 0;
  
  IdleAnim(){
  }
  
  IdleAnim(PImage firstSpr, PImage secondSpr){
    this.firstSpr = firstSpr;
    this.secondSpr = secondSpr;
  }
  
  void idlePlay(PImage firstSpr, PImage secondSpr, int delay, int duration, int xi, int yi){
    imageMode(CENTER);
    
    if(frameDuC > 0)
    {
    image(secondSpr, xi,yi);
    frameDuC--;
    }
    else
  {
  image(firstSpr, xi,yi);
}
    
    if(frameDeC > delay){
      frameDuC = duration;
    }
    
    if(frameDuC == 0)
    {
    frameDeC++;
    }
    else
  {
  frameDeC = 0;
}

  }
}
