class Attack{
  String name;
  int attPow;
  int element;
  int dif = 0;  //Aufgabenschwierigkeitswert
  int MPcost = 0;
  int kind = PHYS;  //Art des Angriffs, ob er die spez oder normalen statuswerte für die schadensberechnung verwendet
  color f = color(20,200,10);
  
  String descr = "|Pow:"+ attPow +"||Normaler Angriff|";
  
  MenuBox Attackbox = new MenuBox(0,0,width/6,100,name,255);
  
  AttAnim AttackenAnim = new AttAnim(180);
  
  BmChar User = null;
  BmChar Target = null;
  
  Attack(String name, int kind, int attPow, int element, int dif){
    this.name = name;
    this.kind = kind;
    this.attPow = attPow;
    this.element = element;
    this.dif = dif;
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|Normaler Angriff|";
    elementConstructCheck();

  }
  
  Attack(String name, int kind, int attPow, int element, int dif, int MPcost){
    this(name, kind, attPow, element, dif);
    this.MPcost = MPcost;
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|Normaler Angriff|";
    elementConstructCheck();
  }
  
  void weaknessCheck(){
    boolean effective = false;
    for(int i = 0; i<Target.schwaechen.length;i++){
      
      if(Target.schwaechen[i] == element){
        Battlestuff.weaknessMult += 0.2;
       //VERBESSERN: WENN DAS ZIEL MEHRMALS EINE SCHWÄCHE VOM SELBEN TYP HAT; WIRD AUCH DER TURNCOUNT MEHRMALS ERHÖHT 
        if(!Battlestuff.halfturn){
         if(Battlestuff.playerturn){
          Battlestuff.turncountpl++;
          Battlestuff.halfturn = true;
        }else if(!Battlestuff.playerturn){
          Battlestuff.turncounten++;
          Battlestuff.halfturn = true;
        }
        }else if(Battlestuff.halfturn){
          Battlestuff.halfturn = false;
        }
        addProtBox(Battlestuff.ChoosenAttack.Target.name +": WEAK!");
        effective = true;
      }
           
      if(Target.resistent[i] == element){
        Battlestuff.weaknessMult -= 0.2;
        if(!Battlestuff.halfturn){
         if(Battlestuff.playerturn){
          Battlestuff.turncountpl--;
        }else if(!Battlestuff.playerturn){
          Battlestuff.turncounten--;
        }
        }
        addProtBox(Battlestuff.ChoosenAttack.Target.name +" :RESIST!");
      }
        
      }
    
    if(!effective){
    if(!Battlestuff.halfturn){
         Battlestuff.halfturn = true;
      }else if(Battlestuff.halfturn){
          Battlestuff.halfturn = false;
        }
  }
  }
  
  int getDmg(){
    int dmg = 1;
    if(kind == PHYS){
    dmg = int((((User.attStat*User.attMult*attPow)/((Target.defStat*Target.defMult)+1)) * Battlestuff.weaknessMult));
    }
    else{
      dmg = int((((User.spAttStat*User.spAttMult*attPow)/((Target.spDefStat*Target.defMult)+1)) * Battlestuff.weaknessMult));
    }
    if(dist(Target.Seat.plpos.x, Target.Seat.plpos.y, User.Seat.plpos.x, User.Seat.plpos.y) != 0){
    dmg /= dist(Target.Seat.plpos.x, Target.Seat.plpos.y, User.Seat.plpos.x, User.Seat.plpos.y);
    }
    //println(dist(Target.Seat.plpos.x, Target.Seat.plpos.y, User.Seat.plpos.x, User.Seat.plpos.y));
    //println(dmg);
    return dmg;
  }
  
  boolean ressourceCheck(){
    if(Battlestuff.ActiveChar.curMP - MPcost < 0){
      addProtBox("Nicht genug MP!");
      return false;
    }else{
    return true;
  }
  }
  
  protected void elementConstructCheck(){
              if(element == PLASMA){
        f = color(230,30,50);
      }
      else if(element == EIS){
        f = color(60,80,240);
      }
      else if(element == BLITZ){
        f = color(200,200,20);
      }
      else if(element == ERDE){
        f = color(240,140,10);
      }
  }
  
  void action(){
    Target.curHP-= getDmg();
    User.curMP -= MPcost;
  }
  
  void anim(){
    if(kind == PHYS){
   AttackenAnim.slashanim(width/2, height/2, f);
    }else if(kind == SPEZ){
      AttackenAnim.absorbanim(width/2, height/2, 20, 300, f);
    }else if(kind == STATUS){
      AttackenAnim.healanim(width/2, height/2, 300, f);
    }
  }
  
  void Attackboxdraw(){
    Attackbox.draw();
  }
}

class Recoil extends Attack{
  
  Recoil(String name, int kind, int attPow, int element, int dif){
    super(name, kind, attPow, element, dif);
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|Erhalte Hälfte des Schadens|";
  }
  
  void action(){
    Target.curHP -= getDmg();
    User.curHP -= getDmg()/2;
    User.curMP -= MPcost;
  }
   
}

class Kick extends Attack{
  float defMult;
  
  Kick(String name, int kind, int attPow, int element, int dif, float defMult){
    super(name, kind, attPow, element, dif);
    this.defMult = defMult;
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|Senkt Zielvert. um " + defMult +"|";
  }
  void action(){
    Target.curHP -= getDmg();
    if(Target.defMult != 0){
    Target.defMult -= defMult;
  }
  }
}

class Buff extends Attack{
  float attMult;
  float spAttMult;
  float defMult;
  float spDefMult;
 
  
  Buff(String name, int kind, int attPow, int element, int dif, int MPcost, float attMult, float spAttMult, float defMult, float spDefMult){
    super(name, kind, attPow, element, dif, MPcost);
    this.attMult = attMult;
    this.spAttMult = spAttMult;
    this.defMult = defMult;
    this.spDefMult = spDefMult;
    f = color(200,10,10);
    
    String statn = "Werte ";
    String statn2 = "Steigert ";
    float savWert = 0;
    if(attMult != 0){
      statn = "Angriff ";
      savWert = attMult;
    }else if(spAttMult != 0){
      statn = "Sp.Angriff ";
      savWert = spAttMult;
    }else if(defMult != 0){
      statn = "Verteidigung ";
      savWert = defMult;
    }else if(spDefMult != 0){
      statn = "Sp.Vert. ";
      savWert = spDefMult;
    }
    if(savWert < 0){
      statn2 = "Senkt ";
      f = color(10,10,200);
    }
    elementConstructCheck();
    savWert = savWert*100;
    savWert = round(sqrt(sq(savWert)));
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|" +statn2+  statn+ "um "+ int(savWert) +"%|";
  }
 
  void action(){
    User.curMP -= getDmg();
    User.curMP -= MPcost;
    Target.attMult += attMult;
    Target.spAttMult += spAttMult;
    Target.defMult += defMult;
    
    Target.spDefMult += spDefMult;
  }
} 

class Heal extends Attack{
  float healMult;
  
  Heal(String name, int kind, int attPow, int element, int dif, int MPcost, float healMult){
    super(name, kind, attPow, element, dif, MPcost);
    this.healMult = healMult;
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|regeneriert Ziel HP um "+ healMult +"%|";
  }
 
  void action(){
    Target.curHP += Target.maxHP*healMult;
    User.curMP -= MPcost;
   
  }
  
  void anim(){
    AttackenAnim.healanim(width/2, height/2, 300, color(40,200,20));
  }
  
} 

class Absorb extends Attack{
  float absorbMult;
  
  Absorb(String name, int kind, int attPow, int element, int dif, float absorbMult){
    super(name, kind, attPow, element, dif);
    this.absorbMult = absorbMult;
    descr = "|Pow:"+ attPow +"|MP:"+ MPcost+"|regeneriert " +absorbMult+"% des Schadens in MP|";
    f = color(20,20,230);
  }
  
  void action(){
    int add = int(getDmg()*absorbMult);
    Target.curHP -= getDmg();
    User.curMP += add;
    Target.curMP -= add;
  }
  
  void anim(){
    AttackenAnim.absorbanim(width/2, height/2,300, 300, f);
  }
  
}
  
  
  
  
  
  
