class Room{
  String name;
  String Dateiname;
  Room ObenRoom = null;
  Room UntenRoom = null;
  Room RechtsRoom = null;
  Room LinksRoom = null;
  
  int[] rndEnemies = {0,1};
  int engroupsize = 3;
  
  int[][] numTab;
  Wall[][] wallTab;
  int[][] tileTab;
  
    ArrayList<OwEnemy> roomowenlist = new ArrayList<OwEnemy>();
  ArrayList<OwPerson> owpelist = new ArrayList<OwPerson>();
  ArrayList<eventWall> roomwalllist = new ArrayList<eventWall>();
  ArrayList<OwObject> owobjlist = new ArrayList<OwObject>();
  
  
  Room(String name, String Dateiname){
    this.name = name;
    this.Dateiname = Dateiname;
    numTab = new int[w][h];
    wallTab = new Wall[w][h];
    tileTab = new int[w][h];
    rloadData(Dateiname);
    rconvert();
  }
  
   Room(String name, String Dateiname, int[] rndEnemies, int engroupsize){
    this.name = name;
    this.Dateiname = Dateiname;
    this.rndEnemies = rndEnemies;
    this.engroupsize = engroupsize;
    numTab = new int[w][h];
    wallTab = new Wall[w][h];
    tileTab = new int[w][h];
    rloadData(Dateiname);
    rconvert();
  }
  
  void drawTiles(){
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      if(tileTab[i][j] != -1){
        imageMode(CORNER);
        image(tiles[tileTab[i][j]], cells*i, cells*j);
      }
    }
  }
}

  
  void rconvert(){
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      if(numTab[i][j] == 1){
        wallTab[i][j] = new Wall(cells*i, cells*j, cells, cells);
      }else
      if(numTab[i][j] == 2){
        roomowenlist.add(new OwEnemy(cells*i+cells/2,cells*j+cells/2));
      }else if(numTab[i][j] == 3){
        owpelist.add(new Savestation(cells*i, cells*j));
      }
      else if(numTab[i][j] == 0){
        //wallTab[i][j] = null;
      }else if(numTab[i][j] > 3){
        owpelist.add(new OwItem(cells*i+cells/2, cells*j+cells/2, numTab[i][j]-4));
      }
    }
  }
}

void rloadData( String dataName){
  JSONObject data = loadJSONObject(dataName);
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      numTab[i][j] = data.getInt( i + ":TileNum:" + j);
      tileTab[i][j] = data.getInt( i + "pic" + j);
    }
  }
}
  
  void neighbors(String name,int a, int b, int c, int d, int[] rndEn, int engrs){
    this.name = name;
    ObenRoom = Rooms.get(a);
    UntenRoom = Rooms.get(b);
    RechtsRoom = Rooms.get(c);
    LinksRoom = Rooms.get(d);
    rndEnemies = rndEn; 
    engroupsize = engrs;
  }
  
  void addRndEns(){
    int egs2 = (int)random(1, engroupsize+1);
    ArrayList<BmChar> Blist = Battlestuff.encharlist;
    
    for(int i = 0; i < egs2; i++){
      int rndz = (int)random(1, rndEnemies.length);
      BmChar rndC = new Kreisli();
      
      if(rndEnemies[rndz] == 0){
        rndC = new Quaninchen();
      }else if(rndEnemies[rndz] == 1){
        rndC = new Quahase();
      }else if(rndEnemies[rndz] == 2){
        rndC = new Para();
      }else if(rndEnemies[rndz] == 3){
        rndC = new Rhombo();
      }else if(rndEnemies[rndz] == 4){
        rndC = new Drari();
      }else if(rndEnemies[rndz] == 5){
        rndC = new Tracar();
      }else if(rndEnemies[rndz] == 6){
        rndC = new Zomb();
      }else if(rndEnemies[rndz] == 7){
        rndC = new Kevin();
      }else if(rndEnemies[rndz] == 8){
        rndC = new Trap();
      }else if(rndEnemies[rndz] == 9){
        rndC = new Gleich();
      }else if(rndEnemies[rndz] == 10){
        rndC = new Recht();
      }else if(rndEnemies[rndz] == 11){
        rndC = new Wgott();
      }else if(rndEnemies[rndz] == 12){
        rndC = new OrangeJohn();
      }else if(rndEnemies[rndz] == 13){
        rndC = new Quasol();
      }else if(rndEnemies[rndz] == 14){
        rndC = new Quakom();
      }
       else{
        rndC = new Kreisli();
      }
      
      Blist.add(rndC);
    }
    
  }
  
  void drawWallTab(){
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        if(wallTab[i][j] != null){
          wallTab[i][j].render();
        }
    }
  }
  }
  
  void colWallTab(){
        for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        if(wallTab[i][j] != null){
          wallTab[i][j].colDetect();
        }
    }
  }
  }
  
  void borders(){
  if(PlayerOw.y < 0){
    changeCurRoom(ObenRoom);
    PlayerOw.y = 720;
  }
  if(PlayerOw.y > 720){
    changeCurRoom(UntenRoom);
    PlayerOw.y = 0;
  }
  if(PlayerOw.x < 0){
    changeCurRoom(LinksRoom);
    PlayerOw.x = 1280;
  }
  if(PlayerOw.x > 1280){
    changeCurRoom(RechtsRoom);
    PlayerOw.x = 0;
  }
}

private void changeCurRoom(Room r){
  if(r != null){
    
     for(Room rl : Rooms){
        for(OwEnemy oe : rl.roomowenlist){
          oe.x = oe.xp;
          oe.y = oe.yp;
          //oe.alive = true;
      }
      }

     CurrentRoom = r;
  }
  
}
}
