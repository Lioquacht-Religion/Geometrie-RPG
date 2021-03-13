class Battlesystem{
  boolean playerturn, Enemyturn = false;
  int turncountpl = 0;
  int turncounten = 0;
  int teamnumpl = 0;
  int teamnumen = 0;
  
  int teamExp = 0;
  
  float weaknessMult = 1.0;
  boolean halfturn = false;
  boolean sketchmode = false;
  boolean animmode = false;
  
  String[] lastActions = new String[10];
  
  ArrayList<BmFeld> fieldlist = new ArrayList<BmFeld>();
  ArrayList<BmChar> plcharlist = new ArrayList<BmChar>();
  ArrayList<BmChar> encharlist = new ArrayList<BmChar>();
  
  BmFeld[][] fieldTab;
  
  BmChar ActiveChar = null;
  Attack ChoosenAttack = null;
  
  EintragBox PosX = new EintragBox(20,300,200,60,1);
  EintragBox PosY = new EintragBox(20,500,200,60,1);
  EintragBox AntwortBox = new EintragBox(width/4, height/4, 80,80, 2);
  
  int menuStateBM = 1;
  int battlestate = -1;
  final int NOTHING = -1;
  final int ENTRANCE = 0;
  final int DECIDE = 1;
  final int BATTLEEXEC = 2;
  final int BATTLEEND = 3;
  
  void setup(){
    setupBattlefield(6,6,width/2,height/2);
    
  }
  
  void battlestate(){
    stroke(0);
    fill(0);

    switch(battlestate){
      case NOTHING:
      
      break;
      
      //Setup für Kampfbeginn
      case ENTRANCE:
      playerturn = true;
      halfturn = false;
      animmode = false;
      menuStateBM = 1;
      
      //Hintergrundmusikstart und loop
      /* Battletheme.cue(0);
       Battletheme.play();
       Battletheme.loop();*/
       
       if(encharlist.size() == 0){
       
         CurrentRoom.addRndEns();
         
         for(int i = 0; i < encharlist.size(); i++){
         encharlist.get(i).setup();
         }
       }
       
       //Startfeldzuordnung für für aktive BmChars
         for(int i= 0; i<plcharlist.size(); i++){
         fieldlist.get(i*2).SeatedChar = plcharlist.get(i);
         plcharlist.get(i).Seat = fieldlist.get(i*2);
       } 
        for(int i= 0; i <encharlist.size(); i++){
         fieldlist.get((fieldlist.size()-1)-2*i).SeatedChar = encharlist.get(i);
         encharlist.get(i).Seat = fieldlist.get((fieldlist.size()-1)-i*2);
       }
       
       

       
       ActiveChar = plcharlist.get(0);
       teamnumpl = 0;
       
       turncountpl = plcharlist.size();
       turncounten = encharlist.size();
       battlestate = DECIDE;
      break;
      
      case DECIDE: 
  //println(Battlestuff.ActiveChar.attlist.size());
  //println(Battlestuff.ActiveChar.name);
  
  //Zeichne Kampffeld
     for(BmFeld f : fieldlist){
       f.draw();
     } 
     for(int i = 0; i < 6; i++){
       textAlign(CENTER);
       textSize(40);
       fill(0);
       text(i, br+br/2, height-cells-cells*2*i);
       text(i, br+br/2+((cells*2+20)*i), height-cells);
     }
     
     for(BmChar Pl : Battlestuff.plcharlist){
      Pl.draw();     
    }
    for(BmChar En : Battlestuff.encharlist){
      En.draw();
    }
     
     //Entfernen von besiegten Gegnern aus Liste
     for(int i = encharlist.size()-1; i > -1; i--){
       if(encharlist.get(i).curHP <= 0){
         teamExp += encharlist.get(i).expToGive;
         encharlist.remove(i);
       }
     }
     
     //RESET NACH GEGNER-LOSE, VERBESSERUNG: IMPLEMENTIERUNG AN DIESER STELLE UNSINNIG, BESSER IN BATTLEENDSTATE, UND NICHT ÜBER KOLLISION MIT EINZELNENEn GEGNER; 
     //ERINNERUNG: ZUFÄLLIGE GEGNERAUFSTELLUNG IMPLEMENTIREN
     if(encharlist.size() <= 0){
        for(OwChar c : CurrentRoom.roomowenlist){
      if(dist(c.x,c.y,PlayerOw.x,PlayerOw.y)< cells*2){ 
        for(BmChar bc : c.charlist){
          bc.curHP = bc.maxHP;
        }
        c.alive= false;
      }
       } 
       battlestate = BATTLEEND;
     }
     
    //"Am-Leben"-Check für Spielercharaktere
     int alivecount = plcharlist.size();
     for(BmChar bc : plcharlist){
     if(bc.curHP <= 0){
       bc.alive = false;
       alivecount--;
     }else{
       bc.alive = true;
     }
     }
   
    //Check: Verlierbedingung Spieler 
     if(alivecount <= 0){
       battlestate = BATTLEEND;
       gamestate = LOSE;
     }
     
    //wenn alive falsch, nächster Spielercharakter in der Liste dran
    //WARNUNG: BEI MEHREREN ERLEDIGTEN SPIELERCHARAKTEREN KANN IM NÄCHSTEN FRAME VIELLEICHT NOCH DER NÄCHSTE TOTE CHARACTER BENUTZT WERDEN, UNWAHRSCHEINLICH; ABER THEORETISCH MÖGLICH
     if(!ActiveChar.alive){
       teamnumpl++;
     }
     
     //Zeichnen des "Wer-am-Zug-Balles" 
      if(ActiveChar != null){
      fill(40,255,0, 98);
      int xpass = ActiveChar.x;
      int ypass = ActiveChar.y;
      ellipse(xpass+cells/2, ypass+cells/2, cells, cells);
      //triangle(xpass+ cells, ypass, xpass, ypass+ cells, xpass+cells, ypass+cells);
    }
       
    //PLAYERTURN 
       if(playerturn){
              //Null-Check, aktiver Spielercharakterindex wird im definierten Rahmen gehalten
         if(teamnumpl >= plcharlist.size()){
           teamnumpl = 0;
         }
       //Updatet, welcher Charakter am Zug ist
         ActiveChar = plcharlist.get(teamnumpl);
       //Check und Reset für Ende des Spielerzuges
         if(turncountpl <= 0 && encharlist.size() != 0){
           halfturn = false;
           ActiveChar = encharlist.get(0);
           teamnumen = 0;
           turncounten = encharlist.size();
           playerturn = false;
         }
         
         
         menuStatesBM(); //Zeichnet und checkt Menuinterface
       }
   //ENEMYTURN
       if(!playerturn){
         if(teamnumen >= encharlist.size()){
           teamnumen = 0;
         }
       //Updatet, welcher Charakter am Zug ist  
         ActiveChar = encharlist.get(teamnumen);
         gegnerPrototypAI(); //zufälliger Gegnerangriff
       //Check für Ende des Spielerzuges
         if(turncounten <= 0 && plcharlist.size() != 0){
           halfturn = false;
           ActiveChar = plcharlist.get(0);
           teamnumpl = 0;
           turncountpl = plcharlist.size();
           playerturn = true;
         }
         
       }
      
       
      break;
      
      case BATTLEEXEC:
      break;
     
    //Reset und Rückehr zur Oberwelt  
      case BATTLEEND:
      //println("BATTLEEND");
        //Battletheme.pause();
        for(BmChar bc : plcharlist){
          bc.attMult = 1;
          bc.defMult = 1;
          bc.spAttMult = 1;
          bc.spDefMult = 1;
        }
        for(BmChar bc : encharlist){
          bc.attMult = 1;
          bc.defMult = 1;
          bc.spAttMult = 1;
          bc.spDefMult = 1;
        }
        
        plcharlist.clear();
        encharlist.clear();
        for(BmFeld f : fieldlist){
          f.SeatedChar = null;
        }
       for(BmChar bc : PlayerOw.Allplcharslist){
         bc.curExp += teamExp/PlayerOw.Allplcharslist.size();
         while( bc.curExp >= bc.expToNextLvl ){
           bc.level++;
           bc.curExp -= bc.expToNextLvl;
           bc.expLvlUpdate();
         }
       }
       teamExp = 0;
       
        battlestate = NOTHING;
        gamestate = OW;
      break;
    }
     
  }
  
  void menuStatesBM(){
    int br = width/6; int ho = height/10; //konstanten für prozentuale skalierung mit der bildschirmauflösung
  mainBoxBM.draw();
  Backbox.draw();

    switch(menuStateBM){
     case 1: //Aktionsauswahl
      attBox.draw();
      defBox.draw();
      Movebox.draw();
      Passbox.draw();
      Flightbox.draw();
    if(attBox.clicked){
      menuStateBM = 2;
    }
    if(defBox.clicked){
      menuStateBM = 8;
    }
    if(Movebox.clicked){
      menuStateBM = 7;
    }
    if(Passbox.clicked){
      teamnumpl++;
     
      if(halfturn){
      turncountpl--;
      halfturn = false;
    }else if(!halfturn){
      halfturn = true;
    }
    }
    if(Flightbox.clicked){
      float rndflightchance = random(0, 4);
      if(rndflightchance < 1){
       for(OwChar c : CurrentRoom.roomowenlist){
      if(dist(c.x,c.y,PlayerOw.x,PlayerOw.y)< PlayerOw.d-20){ 
        c.alive= false;
      }
       }      
      Battlestuff.plcharlist.clear();
      Battlestuff.encharlist.clear();
      
      Battlestuff.battlestate = Battlestuff.BATTLEEND;
      }else{
        teamnumpl++;
        turncountpl--;
        addProtBox("Flucht fehlgeschlagen");
      }
      
    }
   
    break;
    
     case 2: //Attackenauswahlliste
      attSlctBox.draw();
      schlagAttBox.draw(); 
     
    //Zeichnet Attackenliste und checked Auswahl
    pushMatrix();
    translate(0, 0);
      for(int i = 0; i<ActiveChar.attlist.size(); i++){
        MenuBox cBox = ActiveChar.attlist.get(i).Attackbox;
      ActiveChar.attlist.get(i).Attackbox.x = 0;
      ActiveChar.attlist.get(i).Attackbox.y = 2*ho+15+(ho+10)*i;
      ActiveChar.attlist.get(i).Attackbox.breite = br;
      ActiveChar.attlist.get(i).Attackbox.hoehe = ho;
      ActiveChar.attlist.get(i).Attackbox.boxText = ActiveChar.attlist.get(i).name;
      color f = color(255);
      if(ActiveChar.attlist.get(i).element == PLASMA){
        f = color(230,30,50);
      }
      else if(ActiveChar.attlist.get(i).element == EIS){
        f = color(60,80,240);
      }
      else if(ActiveChar.attlist.get(i).element == BLITZ){
        f = color(200,200,20);
      }
      else if(ActiveChar.attlist.get(i).element == ERDE){
        f = color(200,80,10);
      }
      ActiveChar.attlist.get(i).Attackbox.farbe = f;
      ActiveChar.attlist.get(i).Attackboxdraw();
      if(recPointCol(mouseX, mouseY, cBox.x, cBox.y, cBox.breite, cBox.hoehe )){
        textAlign(CORNER);
        fill(0);
        text(ActiveChar.attlist.get(i).descr, br, 50);
      }
      if(ActiveChar.attlist.get(i).Attackbox.clicked && ActiveChar.attlist.get(i).ressourceCheck()){
        ChoosenAttack = ActiveChar.attlist.get(i);
        menuStateBM = 3;
      }
    }
    popMatrix();
      
  //Normaler Standard Angriff    
    if(schlagAttBox.clicked){
      ChoosenAttack = Schlag;
      menuStateBM = 3;
       }
         if(Backbox.clicked){
    menuStateBM = 1;
  }
      break;
      
     case 3: //Zielauswahlliste
     attSlctBox.draw();
   //Gegnerauswahlliste
   for(BmFeld f : fieldlist){
     if(clickedDouble && dist(mouseX, mouseY, f.x, f.y) < cells+cells/2 && f.SeatedChar != null){
       ChoosenAttack.User = ActiveChar;
       ChoosenAttack.Target = f.SeatedChar;
        menuStateBM = 4;
     }
   }
   
    for(int i = 0; i<encharlist.size(); i++){
      MenuBox EnCharbox = new MenuBox(0, 2*ho+15+(ho+10)*i, br, ho, encharlist.get(i).name, color(255));
      EnCharbox.draw();
      if(EnCharbox.clicked){
        ChoosenAttack.User = ActiveChar;
        ChoosenAttack.Target = encharlist.get(i);
        
        menuStateBM = 4;
      }
    }
    for(int i = 0; i<plcharlist.size(); i++){
      MenuBox PlCharbox = new MenuBox(1100, 2*ho+15+(ho+10)*i, br, ho, plcharlist.get(i).name, color(255));
      PlCharbox.draw();
      if(PlCharbox.clicked){
        ChoosenAttack.User = ActiveChar;
        ChoosenAttack.Target = plcharlist.get(i);
        menuStateBM = 4;
      }
    }
     sketchmode = false;
       if(Backbox.clicked){
    menuStateBM = 2;
  }
     break;
     
     case 4:  //Aufgabenlösebildschirm
     BmChar cChar = ChoosenAttack.Target;
     rectMode(CENTER);
     fill(255);
     rect(width/2, height/2, width/2, width/2);
     if(!sketchmode){
     bgAnim();
     }
     
     MenuBox SubmitBox = new MenuBox(width/2,width/2, br, ho, "Bestätigen", color(200,200,30));
     MenuBox SwitchSketch = new MenuBox(width/2-150, height/2+300, br-br/4, ho, "Skizze", color(20,250,30));
     
     
       ChoosenAttack.Target.aufgabe();
       textAlign(CORNER);
       fill(250,0,0);
       text(cChar.name+ "|HP"+ cChar.curHP+"/"+ cChar.maxHP, width/2-300, height/2-300);
       
     
     AntwortBox.draw();
     SwitchSketch.draw();
     if(SwitchSketch.clicked){
       if(sketchmode){
         sketchmode = false;
       }else{ sketchmode = true;}
     }
     
     SubmitBox.draw();
     
     if(SubmitBox.clicked && !animmode){
       ChoosenAttack.AttackenAnim.t = 0;
       
       if(ChoosenAttack.Target.korrekt){
        ChoosenAttack.weaknessCheck();
        
        ChoosenAttack.action();
          addProtBox(ActiveChar.name + " hat " + ChoosenAttack.name +" benutzt");
          addProtBox("Ziel: "+ChoosenAttack.Target.name);
         ChoosenAttack.Target.getRndValues();
         animmode = true;
         
       }else{
         addProtBox("falsche Lösung");
         //animmode = false;
           weaknessMult = 1.0;
        turncountpl--;
        teamnumpl++;
       menuStateBM = 1;
         
       } 
     
       
     }
     //PRoBLEME
       if(animmode){
         /*if(ChoosenAttack.AttackenAnim.t < ChoosenAttack.AttackenAnim.maxt){
           ChoosenAttack.anim();
         }*/
         ChoosenAttack.anim();
         if(ChoosenAttack.AttackenAnim.t >= ChoosenAttack.AttackenAnim.maxt){
           animmode = false;
           weaknessMult = 1.0;
        turncountpl--;
        teamnumpl++;
       menuStateBM = 1;
           
         }
         
       }
       
         if(Backbox.clicked){
    menuStateBM = 3;
  }
     break;
     
     case 7:  //Bewegung auf dem Spielfeld
     //VERBESSERN, VORHER GESPEICHERTE CHARS BLEIBEN IN LETZTEN FELDERN GESPEICHERT
     //Gefixt, aber immernoch ohne Funktionalität im eigentlichen Spiel
     //Funktionaöität nun enthalten, je höher der abstand von angriffsziel, desto niedriger ist der Schaden
      MenuBox SubBox = new MenuBox(width/2,width/2, br, ho, "Bestätigen", color(200,200,30));
     
      for(BmFeld f : fieldlist){
        if(f.clicked && f.SeatedChar == null){
          addProtBox(ActiveChar.name+" hat sich bewegt");
          ActiveChar.Seat.SeatedChar = null;
          f.SeatedChar = ActiveChar;
          ActiveChar.Seat = f;
          turncountpl--;
          teamnumpl++;
          halfturncheck();
          menuStateBM = 1;
        }
        }
        PosX.draw();
        PosY.draw();
        SubBox.draw();
        if(SubBox.clicked){
          String korpos = "Besetzt oder nicht definiert";
          for(BmFeld f : fieldlist){
            if(int(PosX.boxText) == f.plpos.x && int(PosY.boxText) == f.plpos.y && f.SeatedChar == null){
              ActiveChar.Seat.SeatedChar = null;            
              f.SeatedChar = ActiveChar;
              ActiveChar.Seat = f;
              korpos = ActiveChar.name+" hat sich bewegt";
            }
            

          }
             addProtBox(korpos);
             turncountpl--;
          teamnumpl++;
          halfturncheck();
          menuStateBM = 1;
        }
        textAlign(CORNER);
        textSize(20);
        fill(0);
        text("x-Pos.?", 20,50);
        text("y-Pos.?", 20, 100);
        
          if(Backbox.clicked){
    menuStateBM = 1;
  }
        
     break;
     
           case 8:
           int s8 = 0;
      for(int i = 0; i< PlayerOw.items.length; i++){
        Item it = PlayerOw.items[i];
        if(!(it instanceof AtItem) && !(it instanceof KeyItem)){
      MenuBox Itembox = new MenuBox(br*3, ho*s8, br, ho,it.name+ ":" + PlayerOw.itemanzahl[i], color(0,255,0) );
      Itembox.draw();
      
      if(Itembox.clicked && PlayerOw.itemanzahl[i] > 0){
        curItem = it;
        merkitemstelle = i;
        menuStateBM = 9;
      }
      s8++;
        }
      Backbox.draw();
      if(Backbox.clicked){
        menuStateBM = 1;
      }
    }
      
      break;
      
      case 9:
      for(int i = 0; i < PlayerOw.Allplcharslist.size(); i++){
        BmChar curChar = PlayerOw.Allplcharslist.get(i);
        MenuBox Charbox = new MenuBox(br*3, ho*i, br, ho,curChar.name, color(0,255,0) );
        Charbox.draw();
        if(Charbox.clicked && PlayerOw.itemanzahl[merkitemstelle] > 0){
          curItem.User = curChar;
          curItem.use();
        PlayerOw.itemanzahl[merkitemstelle]--;
        addProtBox(curItem.User+" hat "+curItem.name+" benutzt");
          turncountpl--;
          teamnumpl++;
          menuStateBM = 1;
        }
        Backbox.draw();
        if(Backbox.clicked){
        menuStateBM = 8;
      }
        
      }
      break;

    }
    
    protBox(lastActions, width-width/4, height/2, width/4, height/2);
    turncounter();
}

void keyReleased(){
  switch(menuStateBM){
    case 4:
    AntwortBox.keyReleased();
    
    break;
    
    case 7:
    PosX.keyReleased();
    PosY.keyReleased();
    break;
  }
}

void setupBattlefield(int breite, int laenge, int addtoY, int addtoX){
  int xc = 0;
  int yc = 0;
  for(int i = 0; i<(breite*laenge); i++){
      fieldlist.add(new BmFeld());
      
        if(xc == breite){
          xc = 0;
          yc--;
        }
      fieldlist.get(i).x += addtoX + (cells*2+10)*xc;
      fieldlist.get(i).plpos.x = xc;
      fieldlist.get(i).y += addtoY + cells*2*yc;
      fieldlist.get(i).plpos.y = -yc;
      xc++;
    }
}

void setupBattlefieldchars(){
  for(int i= 0; i<plcharlist.size(); i++){
         fieldlist.get(i*2).SeatedChar = plcharlist.get(i);
         plcharlist.get(i).Seat = fieldlist.get(i*2);
       } 
        for(int i= 0; i <encharlist.size(); i++){
         fieldlist.get((fieldlist.size()-1)-2*i).SeatedChar = encharlist.get(i);
         encharlist.get(i).Seat = fieldlist.get((fieldlist.size()-1)-i*2);
       }
}

void setupBattlefield2(int breite, int laenge, int addtoX, int addtoY){
  BmFeld [][] Tab = new BmFeld[breite][laenge];
  for(int i = 0; i <breite ; i++){
    for(int j = 0; j < laenge; j++){
      Tab[i][j] = new BmFeld();
      Tab[i][j].x = addtoX + (cells*2+10)*i;
      Tab[i][j].y = addtoY + (cells*2)*j;
    }
  }
  fieldTab = Tab;
}

void setupBattlefield2chars(){
  for(int i= 0; i<plcharlist.size(); i++){
    for(int j = 0; j< 1; j++){
         fieldTab[i*2][j].SeatedChar = plcharlist.get(i); 
         plcharlist.get(i).Seat = fieldTab[i*2][j];
       } 
  }
        for(int i= 0; i <encharlist.size(); i++){
          for(int j = 0; j < 1; j++){
         fieldlist.get((fieldlist.size()-1)-2*i).SeatedChar = encharlist.get(i);
         encharlist.get(i).Seat = fieldlist.get((fieldlist.size()-1)-i*2);
          }
       }
        
}

void gegnerPrototypAI(){
  int Handlung = 0;
  
  int rndAtt = (int)random(0, ActiveChar.attlist.size());
  if(ActiveChar.attlist.size() == 0){
    ChoosenAttack = Schlag;
  }else{
  ChoosenAttack = ActiveChar.attlist.get(rndAtt);
  }
  ChoosenAttack.User = ActiveChar;
  if(ChoosenAttack.kind == PHYS || ChoosenAttack.kind == SPEZ){
  
  ChoosenAttack.Target = searchclosetarget();
  BmChar targ = ChoosenAttack.Target;
  if(dist(targ.Seat.plpos.x, targ.Seat.plpos.y, ActiveChar.Seat.plpos.x, ActiveChar.Seat.plpos.y) > ActiveChar.aggro){
    Handlung = 1; //MOVE
  }
  
  }
  else if(ChoosenAttack.kind == STATUS){
    int rndZiel = (int)random(0,encharlist.size());
  ChoosenAttack.Target = encharlist.get(rndZiel);
  }
  
  switch(Handlung){
    case 0: //Ziel angreifen
    ChoosenAttack.weaknessCheck();
    ChoosenAttack.action();
    addProtBox(ActiveChar.name + "hat"+ ChoosenAttack.name +"benutzt");
    addProtBox("Ziel: "+ChoosenAttack.Target.name);
  break;
  
  case 1: //Ziel verfolgen
  //BmFeld curFeld = ActiveChar.Seat;
  BmChar targ = ChoosenAttack.Target;
    for(BmFeld f : fieldlist){
      if(f == ActiveChar.Seat){
      }
      if(f.SeatedChar != null ){
        continue;
      }else     
      if(dist(f.plpos.x, f.plpos.y, targ.Seat.plpos.x, targ.Seat.plpos.y) < ActiveChar.aggro){ //hier könnte ein potentielles aggressivitäts attribut eingefügt werden
       
        ActiveChar.Seat.SeatedChar = null;
        ActiveChar.Seat = f;
        f.SeatedChar = ActiveChar;
      }  
     
    }
    addProtBox(ActiveChar.name + " hat sich bewegt");
   
  break;
  }
  turncounten--;
  teamnumen++;
}

BmChar searchclosetarget(){  //Gegner sucht sich das nächstgelegene ziel aus
  BmChar Ziel = plcharlist.get(0);
  
  for(int i = 0; i< plcharlist.size()-1; i++){
    if(!Ziel.alive || (dist(ActiveChar.Seat.plpos.x, ActiveChar.Seat.plpos.y, Ziel.Seat.plpos.x,Ziel.Seat.plpos.y) > dist(ActiveChar.Seat.plpos.x, ActiveChar.Seat.plpos.y,plcharlist.get(i+1).Seat.plpos.x, plcharlist.get(i+1).Seat.plpos.y))){
    
      Ziel = plcharlist.get(i+1);
 
    }
  }
  if(plcharlist.get(plcharlist.size()-1) == Ziel && !Ziel.alive){
        for(int i = 0; i < plcharlist.size(); i++){
      Ziel = plcharlist.get(i);
      if(Ziel.alive){
        break;
      }
    }
  }
  
    
  return Ziel;
}

void halfturncheck(){
if(!halfturn){
         halfturn = true;
      }else if(halfturn){
          halfturn = false;
        }
}

private int aniTimer = 0;
private int s = 0;

void bgAnim(){
  int w = width/2; int h = height/2;
  rectMode(CENTER);
  fill(0,0,60);
  rect(w, h, w, w);
  if(aniTimer >= 60){
    s = (int)random(-10,11);
    aniTimer = 0;
  }
  
  fill(40,250,70,90);
  ellipse(w-w/4, h-w/4, 60, 60);
  stroke(250,60,80);
  fill(40,250,70,0);
  ellipse(w-w/4+s, h-w/4+s, 60+s, 60+s);
  for(int i = 0; i < 6; i++){
    stroke(250,250,0);
    line(w, h, w-w/2+128*i, h+w/2);
    line(w-w/2, h+w/2- 64*i, w+w/2, h+w/2- 64*i);
    stroke(0,250,0);
    line(w+s, h+s, w-w/2+128*i+s, h+w/2+s);
    line(w-w/2+s, h+w/2- 64*i+s, w+w/2+s, h+w/2- 64*i+s);
  }
  stroke(0,250,250);
  line(w-w/2, h, w+w/2 ,h);
  
  aniTimer++;
}

void turncounter(){
  int turnc = 0;
  color f = color(255);
  if(playerturn){
    turnc = turncountpl;
    f = color(20,40,240);
  }else{
    turnc = turncounten;
    f = color(240,40,20);
  }
  rectMode(CORNER);
  if(halfturn){
    fill(200,0,0);
    textAlign(CORNER);
    text("Halfturn",width-100,70);
  }else{
  fill(90,90,90);
  }
  rect(width-77, 0, 85, 90);
  fill(f);
  for(int i = 0; i< turnc; i++){
    
    rect(width-80-60*i,0,40, 80);
  }
}

}
