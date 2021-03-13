/* Programmname: Rpg_Infopojekt_4
 Programminhalt: Softwareentwicklungsprojekt-Geometrie-RPG
 
 Verfasser:    Sebastian Berg, Justin Rast, Maximillian Rymarcyk
 erstellt am:  20.9.2020
 
 
 Fehlende Inhalte:
 - Aufgaben zum allgemeinen Viereck
 
 Anleitung:
 - W,A,S,D -> Bewegung der Hauptfigur in der Oberwelt
 - Q -> öffnen des Menüs in der OW
 - E -> zum Untersuchen, Bestätigen und Ansprechen der Umgebung
 - R -> zum sofortigen Abbrechen eines Gespräches
 - der Rest der Bedienung findet über Maus statt
 
 OW-Gegenstände:
 [I] -> Item
 [S] -> Speicherpunkt
 */




//########################################################################################################################################################################################################
//IMPORT

/*import ddf.minim.*;
Minim minim;
AudioPlayer Battletheme;*/

//########################################################################################################################################################################################################
//Variablen und Konstanten
int activerSpielstand = 0;
int savedRoom = 0;
int br = width/6; int ho = height/10; //konstanten für prozentuale skalierung mit der bildschirmauflösung
int w, h; int w2, h2;

boolean pmode = false;

boolean clickedOnce, clickedTwice, clickedDouble = false;
int mouseClickTimer,buffer = 0;
int f = 150;
final int cells = 40;

String PlayerName = "Kreisli";
String[] DrachText = {"Grrrr", "*Flammenwerfergeräusche*", "Grüüüüü", "Drach ist dir beigetreten!!!"};
String[] PakreisText ={"Pass auf Kreisli, wenn du in die Höhle gehst!", "Dort lauern nämlich gefährliche Rechtecknager", "Nimm am besten Drach mit", "Wenn du Q drückst, kannst du das Menü aufrufen", "und Drach hinzufügen."};
String[] MakreisText ={"Wo ist denn Drach, "+PlayerName +"?", "Er ist bestimmt wieder bei seinem Lieblingsplatz in der Höhle.", "Passt gegenseitig auf euch auf, wenn ihr auf Abenteur seit.", "Wirf ihm den grünen Passball zu falls du Hilfe brauchst.", "Übertreibt es aber nicht und übernehmt Verantwortung, ansonsten kommt nichts zustande."};
String[] DreickText = {"...", "...", "*unangenehmes STARREN*", "...", "*unangenehmes zustimmendes Gefühl*", "...", "Dreicki ist dir beigetreten!!!"};
String[] DreickGate = {"Die Dreiecksmafia hat Dreicki hier eingesperrt", "Du musst ihn befreien!", "Er ist gar kein so schlechter Typ", "Eigentlich sogar ganz ausgeglichen", "*hust* wenn man zumindest seine Seiten und Winkel *hust*"};
String[] BlockText = {"Boah, Mann", "Weißt du, ich dachte in der Stadt würde es besser werden", "Ich fühle mich aber immernoch in den Ecken meines Lebens gefangen", "Weißt du, ich schließ mich dir an", "Ich habe sowieso nichts zu verliern, weißt du", "Blockiu ist dir beigetreten!!!"};
String[] OJohn = {"EY!", "DU!!", "Du hast doch nicht meine Orangen angerührt?!", "Verdammt, dieses Sodbrennen."};
String[] WGott = {"?§$§?", "&&§§%$$#!", "!§&§&§&§&§&§!", "Ihr Zweidimensionalen...", "...SEIT NICHTS WEITER ALS UNWÜRDIGE STÜCKE PAPIER!!!"};
String[] Qua1 = {"Hast du gehört?", "Blocki soll nach Blockstadt gegangen sein", "Ob er dort nicht so deprimiert ist?"};
String[] Qua2 = {"Ja hab ich", "Aber hast du schon gehört dass die Dreiecksmafia Dreicki gefangen genommen hat?", "Der Typ ist zwar verrückt, doch war er die einzige Fläche gleichwinklig genug,", "um der Mafia die Stirn zu bieten."};
String[] Qua3 = {"e = a * Wurzel aus 2", "für ein Quadrat", "Dabei ist die Wurzel aus zwei rund 1,4", "Wenn du die 1,4 aber mit der Seite a multiplizierst merk dir ja das Ergebnis abzurunden!!!", "Jetzt geh die Quanager verprügeln"};




int transy, transx = 0;

//Bilddaten
PImage Titlescreencover, Title;

PImage[] tiles = new PImage[17];
PImage[] idles = new PImage[36]; //Array für kleine Kampffeldsprites
//Battlefieldsprites
PImage KreisliSpr;  PImage KreisliBf1, KreisliBf2; PImage BlockiBf1, BlockiBf2; PImage DreickiBf1, DreickiBf2; 
//AMsprites
PImage KreisliAM, BlockiAM, DreickiAM, DrachAM; PImage QuaninAM, QuahaAM, ParaAM, RhomboAM,DrariAM,TracarAM,ZombAM,GleichAM, TrapAM, WgottAM, RechtAM, KevinAM, OjohnAM, OkartonAM, QuadatAM, QuamanderAM;

//PGraphics pg;


boolean up, down, right, left = false;
boolean cutscene = false;

final int START = 0;
final int OW = 1;
final int BM = 2;
final int MENU = 3;
final int LOSE = 4;
 
 //TYPENELEMENTE FÜR BMCHARS

final int BASISCH = 0;
final int EIS = 1;
final int BLITZ = 2;
final int ERDE = 3;
final int PLASMA = 4;
final int NOTHING = 5;

final int PHYS = 0;
final int SPEZ = 1;
final int STATUS = 2;

int gamestate = START;

ArrayList<Room> Rooms = new ArrayList<Room>();

Room Room1;
Room Room2; 
Room Room3;
Room Room4; 
Room CurrentRoom;

//########################################################################################################################################################################################################
//INSTANZENERZEUGUNG

Battlesystem Battlestuff = new Battlesystem();

MenuBox Startbox;
MenuBox mainBoxBM;
MenuBox attBox;
MenuBox defBox;
MenuBox Movebox;
MenuBox Passbox;
MenuBox Flightbox;
MenuBox attSlctBox;
MenuBox schlagAttBox;
MenuBox Backbox;

MenuBox itemBox;

MenuBox saveBox;
MenuBox loadBox;



OwPlayer PlayerOw;


Kreisli Kreisli = new Kreisli();
Blocki Blocki = new Blocki();
Dreicki Dreicki = new Dreicki();
Drach Drach = new Drach();

BmChar[] Mclist = {Kreisli, Blocki, Dreicki, Drach}; 

Attack Schlag = new Attack("Schlag",PHYS,3000,BASISCH, 1);
Attack Bodycheck = new Attack("Bodycheck",PHYS,60,BASISCH, 2);
Buff Fusstups = new Buff("Fußstups",PHYS,20,ERDE, 3, 0,    0, -0.2, 0, 0);
Buff Elekkick = new Buff("Elekkick",PHYS,20,BLITZ, 3, 0,  -0.2, 0, 0, 0);
Buff Eiszapf = new Buff("Eiszapz",PHYS,20,EIS, 3, 0,       0, 0, -0.2, 0);
Buff Magstapf = new Buff("Magstampf",PHYS,20,PLASMA, 3, 0,    0, 0, 0, -0.2);

Buff Panzern = new Buff("Panzern",STATUS,0,BASISCH,2,10, 0, 0, 0.2 ,0);  //Ang., SpAng., Vert., SpVer.
Buff Stacheln = new Buff("Stacheln",STATUS,0,BASISCH,2,10, 0.2, 0,0,0);
Buff Schub = new Buff("Schub",STATUS,0,BASISCH,2,10, 0, 0.2, 0, 0);
Buff Manteln = new Buff("Manteln",STATUS,0,BASISCH,2,10, 0, 0, 0, 0.2);
Buff Aufregern = new Buff("Aufregern",STATUS,0,BASISCH,2,10, 0.2, 0, -0.4, 0);

Heal Pflaster = new Heal("Pflaster",STATUS,0,BASISCH,1, 4,0.5);
Absorb MPSaug = new Absorb("MP-Saug",SPEZ,30, BASISCH,1, 0.5);
Recoil Absturzer = new Recoil("Abstürzer",PHYS,80, BASISCH,2);

Attack Drecker = new Attack("Drecker",SPEZ, 40, ERDE, 2, 4); 
Attack Brenner = new Attack("Brenner",SPEZ, 400, PLASMA, 2, 4);
Attack Frierer = new Attack("Frierer", SPEZ, 40, EIS, 2, 4);
Attack Schocker = new Attack("Schocker", SPEZ, 40, BLITZ, 2);
Attack Magman = new Attack("Magman", PHYS, 30, PLASMA, 1);
Attack Donnern = new Attack("Donnern", PHYS, 30, BLITZ, 1);
Attack Steinern = new Attack("Steinern", PHYS, 30, ERDE, 1);
Attack Hageln = new Attack("Hageln", PHYS, 30, EIS, 1);

AtItem AtAufregern = new AtItem(Aufregern);
AtItem AtMagman = new AtItem(Magman);
AtItem AtBodycheck = new AtItem(Bodycheck);
AtItem AtManteln = new AtItem(Manteln);

Attack[] Alltacks = {Bodycheck, Fusstups, Elekkick, Eiszapf, Magstapf, Panzern, Stacheln, Schub, Manteln, Aufregern, Pflaster, 
MPSaug, Drecker, Brenner, Frierer, Schocker, Magman, Donnern, Steinern, Hageln};

//ITEMS
Item Heiltrank = new Item("Trank", 40, 0, 0, 0, 0,0,0,0);
Item Manatrank = new Item("Mana", 0,20,0,0,0,0,0,0);
Item Maxitrank = new Item("Maxi",40,20,0,0,0,0,0,0);
Item Hpplus = new Item("HP+",0,0,0,0,0,0,10,0);
Item Mpplus = new Item("MP+", 0,0,0,0,0,0,0,10);
Item Attplus = new Item("Ang+",0,0,6,0,0,0,0,0);
Item Defplus = new Item("Vert+",0,0,0,6,0,0,0,0);
Item SpAplus = new Item("SpA+",0,0,0,0,6,0,0,0);
Item SpDplus = new Item("SpV+",0,0,0,0,0,6,0,0);

KeyItem Blockkey = new KeyItem("Blockschlüssel");
KeyItem Trikey = new KeyItem("Trischlüssel");
KeyItem Dreickkey = new KeyItem("Gefängnisschlüssel");

//########################################################################################################################################################################################################
//SETUP


void setup(){
  //fullScreen(P2D);
  size(1280,720, P2D);
  br = width/6; ho = height/10; //konstanten für prozentuale skalierung mit der bildschirmauflösung
  //pg = createGraphics(1280,720);
 
 //#######################################################################################################################################################################################################
 //LOADING DATA
  Titlescreencover = loadImage("GeometrieRPGcover.png");
  Titlescreencover.resize(width,height);
  image(Titlescreencover,0,0);
  Title = loadImage("Geo-Title.png");
  KreisliSpr = loadImage("KreisliSpritePNG2.png");
  
  for(int i = 0; i < tiles.length; i++){  //einladen der Oberweltgraphikteilen
    String datnam = "Tile" +i+ ".png";
    tiles[i] = loadImage(datnam);
  }
  
  for(int i = 0; i< idles.length; i++){  //einladen der kleinen Kampfeldsprites für die Charaktere
    String datnam = "idles" + i + ".png";
    idles[i] = loadImage(datnam);
    idles[i].resize(60,60);
  }
  
  KreisliBf1 = loadImage("idles14.png"); KreisliBf1.resize(60,60);
  KreisliBf2 = loadImage("idles15.png"); KreisliBf2.resize(60,60);
  BlockiBf1 = loadImage("idles12.png"); BlockiBf1.resize(60,60);
  BlockiBf2 = loadImage("idles13.png"); BlockiBf2.resize(60,60);
  DreickiBf1 = loadImage("Dreicki1.png"); DreickiBf1.resize(60,60);
  DreickiBf2 = loadImage("Dreicki2.png"); DreickiBf2.resize(60,60);

  QuaninAM = loadImage("QuaninchenAM.png");
  QuahaAM = loadImage("QuahaseAM.png");
  KreisliAM = loadImage("KreisliAM.png");
  BlockiAM = loadImage("BlockiAM.png");
  DreickiAM = loadImage("DreickiAM.png");
  DrachAM = loadImage("DrachAM.png");
  RhomboAM = loadImage("RhomboidAM.png");
  ParaAM = loadImage("ParaellogrammiAM.png");
  DrariAM = loadImage("DraritterAM.png");
  TracarAM = loadImage("TracarAM.png");
  ZombAM = loadImage("ZombdreckAM.png");
  GleichAM = loadImage("GleichAM.png");
  TrapAM = loadImage("TrapangleAM.png");
  WgottAM = loadImage("WürfelgottAM.png"); 
  RechtAM = loadImage("RechtwinklerAM.png");
  KevinAM = loadImage("KevinAM.png");
  OjohnAM = loadImage("OsaftjAM.png");
  OkartonAM = loadImage("OsaftkartonAM.png");
  QuadatAM = loadImage("QuasoldAM.png");
  QuamanderAM = loadImage("QuakommanAM.png");
  
  
   // minim = new Minim(this);
  //Battletheme = minim.loadFile("GeoBattletheme1.wav");
  
 //#######################################################################################################################################################################################################
 //STARTWERTE OBJEKTE
Battlestuff.setup(); 
 w = 1280/cells;
  h = 720/cells;
  PlayerOw= new OwPlayer(cells*8,cells*14);

    for(int i = 0; i <27; i++){
      String Roomdat = "TileMapPlacement" + i;
      Rooms.add(new Room("Room"+i, Roomdat));
    }
    
    int[] zens0 = {2,3,4,5,6,7,8,9,10,12, 13, 14};
int[] ro0 = {0,0};
int[] ro1 = {0,0,1};
int[] ro2 = {0,13,13,13,14,14};
int[] ro3 = {5,5,2,2,3, 6};
int[] ro4 = {2,2,4,4,5};
int[] ro5 = {13,13,14,3,4};
int[] ro6 = {6,6,8};
int[] ro7 = {7,10, 10, 10};
int[] ro8 = {7, 9, 9, 9};
int[] ro9 = {7, 7, 8, 8};
int[] ro10 = {8, 8, 9};
int[] ro11 = {10, 7, 9};
int[] ro12 = {11,11};
    
    Rooms.get(0).neighbors("Kreislis Heim",0,0,1,1, ro0, 1);  //oben, unten, rechts, links, gegnerauswahl, gegnermenge
    Rooms.get(1).neighbors("Nagerhöhle",0,0,2,0, ro1, 2);
    Rooms.get(2).neighbors("TempelkomplexA",4,0,3,1, ro1, 2);
    Rooms.get(3).neighbors("TempelkomplexB",5,6,0,2, ro2, 2);
    Rooms.get(4).neighbors("TempelkomplexD", 0, 2, 5, 0, ro2, 3);
    Rooms.get(5).neighbors("TempelkomplexC", 0, 3, 7, 4, ro2, 2);
    Rooms.get(6).neighbors("Orangenkammer", 3, 0, 0, 0, ro0, 3);
    Rooms.get(7).neighbors("Rattenplaza", 0, 0, 8, 5, ro1, 1);
    Rooms.get(8).neighbors("Quadorf", 0, 0, 9, 7, ro0, 3);
    Rooms.get(9).neighbors("Kreuzung", 17, 10, 25, 8, ro1, 3);
    Rooms.get(10).neighbors("BlockstadtA", 9, 11, 0, 0, ro3, 2);
    Rooms.get(11).neighbors("BlockstadtB", 10, 13, 12, 0, ro3, 2);
    Rooms.get(12).neighbors("BlockparkA", 0, 14, 0, 11, ro4, 2);
    Rooms.get(13).neighbors("BlockstadtC", 11, 15, 14, 0, ro3, 2);
    Rooms.get(14).neighbors("BlockparkB", 12, 0, 0, 13, ro4, 3);
    Rooms.get(15).neighbors("Quamilitär", 13, 16, 0, 0, ro5, 2);
    Rooms.get(16).neighbors("Blockruine", 15, 0, 0, 0, ro5, 3);
    Rooms.get(17).neighbors("Abgebrochenes BauprojektA", 18, 9, 0, 0, ro6, 3);
    Rooms.get(18).neighbors("Abgebrochenes BauprojektB", 21, 17, 19, 0, ro6, 3);
    Rooms.get(19).neighbors("Dreickis Gefängnis", 22, 0, 20, 18, ro8, 3);
    Rooms.get(20).neighbors("Oase", 22, 0, 0, 19, ro9, 3);
    Rooms.get(21).neighbors("Mafiaanwesen", 0, 18, 22, 0, ro7, 3);
    Rooms.get(22).neighbors("Gestrandetes Schiff", 0, 19, 23, 21, ro10, 3);
    Rooms.get(23).neighbors("Hölzerische künstlerische Blockade", 24, 20, 0, 22, ro11, 3);
    Rooms.get(24).neighbors("Triruine", 0, 23, 0, 0, ro11, 3);
    Rooms.get(25).neighbors("Dimensionskonverter", 0, 0, 26, 9, zens0, 3);
    Rooms.get(26).neighbors("Invasion der dritten Dimension", 0, 0, 0, 25, ro12, 1);

  
   PlayerOw.LastSave.SavedRoom = Rooms.get(0);
  
 int br = width/6; int ho = height/10; //konstanten für prozentuale skalierung mit der bildschirmauflösung
  Startbox = new MenuBox(width/2- width/9, height-height/5, br, ho, "START" , color(255,0,0));
  mainBoxBM = new MenuBox(0,0,br +20,height-1, "", (255));
  attBox = new MenuBox(10,10,br, ho, "ANGRIFF" , color(255,0,0));
  defBox = new MenuBox(10,ho+15,br,ho, "ITEMS", color(220,255,0));
  Movebox = new MenuBox(10,(ho+10)*2,br,ho, "BEWEGEN" , color(0,100,255));
  Passbox = new MenuBox(10,(ho+10)*3,br,ho, "PASS" , color(0,50,255));
  Flightbox = new MenuBox(10,(ho+10)*4,br,ho, "FLUCHT" , color(0,0,255));
  attSlctBox = new MenuBox(1,1,br,ho, "Auswahl", color(0,0,255));
  schlagAttBox = new MenuBox(1,ho+10,br,ho, "ANGRIFF-N", (255));
  Backbox = new MenuBox(10,height-ho,br,ho, "ZURUECK" , color(200,0,230));

  itemBox = new MenuBox(10,10,br,ho, "ITEMS" , color(255,0,0));

  //saveBox = new MenuBox(10,(ho+10)*5,br,ho, "SAVE" , color(255,0,0));
  //loadBox = new MenuBox(10,(ho+10)*6,br,ho, "LOAD" , color(255,0,0));

 
  PlayerOw.Allplcharslist.add(Kreisli);
 // PlayerOw.Allplcharslist.add(Blocki);
 // PlayerOw.Allplcharslist.add(Dreicki);
 // PlayerOw.Allplcharslist.add(Drach);
  PlayerOw.charlist.add(Kreisli);
  //PlayerOw.charlist.add(new Para());

  

  Rooms.get(0).roomowenlist.get(0).charlist.add(new Quaninchen());

  Rooms.get(0).owpelist.add(new OwTeammate(cells*3, cells*3, DrachText, Drach, idles[16], idles[17]));
  Rooms.get(0).owpelist.add(new OwPerson(cells*7+cells/2, cells*7+cells/2, PakreisText));
  Rooms.get(0).owpelist.add(new OwPerson(cells*6+cells/2, cells*12+cells/2, MakreisText));

  Rooms.get(0).owpelist.add(new Savestation(width/2, height/2));
  Rooms.get(9).roomwalllist.add(new eventWall(width-cells*4, height-cells*12, cells, cells*6, 6));
  
    Rooms.get(8).owpelist.add(new OwPersonRec(cells*6+cells/2, cells*4+cells/2, Qua3));
  Rooms.get(8).owpelist.add(new OwPersonRec(width-cells*11+cells/2, cells*13+cells/2, Qua1));
  Rooms.get(8).owpelist.add(new OwPersonRec(width-cells*9+cells/2, cells*13+cells/2, Qua2));
  
  Rooms.get(9).owpelist.add(new Gatekeeper(width-cells*6, height-cells*9, Rooms.get(9).roomwalllist.get(0), PlayerOw.items.length-1, PlayerOw.items.length-2));
  Rooms.get(11).owpelist.add(new OwTeammate(width-cells*3, cells*3, BlockText, Blocki, BlockiBf1, BlockiBf2));
  Rooms.get(19).owpelist.add(new OwTeammate(width/2+cells, cells*5, DreickText, Dreicki, DreickiBf1, DreickiBf2));
  
    Rooms.get(19).roomwalllist.add(new eventWall(cells*16, height-cells*11, cells, cells, 13));
  Rooms.get(19).owpelist.add(new Gatekeeper(cells*15+cells/2, height-cells*10+cells/2, Rooms.get(19).roomwalllist.get(0), PlayerOw.items.length-3, PlayerOw.items.length-3));
  Rooms.get(21).owpelist.add(new OwItem(cells*7+cells/2, cells*5+cells/2, PlayerOw.items.length-3));
   
   Rooms.get(16).owpelist.add(new OwItem(cells*14+cells/2, cells*11+cells/2, PlayerOw.itemanzahl.length-2));
    Rooms.get(24).owpelist.add(new OwItem(cells*14+cells/2, cells*6+cells/2, PlayerOw.itemanzahl.length-1));
    Rooms.get(26).owpelist.add(new OwBoss(width-(cells*9+cells/2), cells*9, WGott, new Wgott(), idles[24], idles[25] ) );
    Rooms.get(6).owpelist.add(new OwBoss(cells*10, cells*9, OJohn, new OrangeJohn(), idles[30], idles[31] ) );

  //########################################################################################################################################################################################################
  //ATTACK_SETUP
  Kreisli.setup();
  Blocki.setup();
  Dreicki.setup();
  Drach.setup();
  
  BmChar[] Mclist2 = {Kreisli, Blocki, Dreicki, Drach};
  Mclist = Mclist2;
  
  CurrentRoom = Rooms.get(9);
  
}

//########################################################################################################################################################################################################
//DRAW


void draw(){
  
  CurrentRoom.borders();
  doubleClicked();
  background(f);
 
  gamestates();
  
}

/*void stop()
{
// Player Battletheme schließen
//Battletheme.close();
// Minim Object stoppen
minim.stop();
 
super.stop();
}*/

void saveGameData(int curSavData){
  JSONObject data = new JSONObject();
  data.setString("PlayerName"+curSavData, PlayerName);
  data.setInt("savRoom"+curSavData, savedRoom);
  data.setInt("PlayerOw.x"+curSavData, PlayerOw.x);
  data.setInt("PlayerOw.y"+curSavData, PlayerOw.y);
  
  for(int i = 0; i < Mclist.length; i++){
        data.setInt(curSavData+"maxHP"+i, Mclist[i].maxHP);
    data.setInt(curSavData+"curHP"+i, Mclist[i].curHP);
        data.setInt(curSavData+"maxMP"+i, Mclist[i].maxMP);
    data.setInt(curSavData+"curMP"+i, Mclist[i].curMP);
        data.setInt(curSavData+"AttStat"+i, Mclist[i].attStat);
    data.setInt(curSavData+"DefStat"+i, Mclist[i].defStat);
        data.setInt(curSavData+"SpAttStat"+i, Mclist[i].spAttStat);
    data.setInt(curSavData+"SpDefStat"+i, Mclist[i].spDefStat);
  }
  
  for(int i = 0; i < Mclist.length; i++){
            data.setBoolean(i+"teammatebool", false);
    for(int j = 0; j < PlayerOw.Allplcharslist.size(); j++){
      if(PlayerOw.Allplcharslist.get(j) == Mclist[i]){
        data.setBoolean(i+"teammatebool", true);
      }
    }
  }
  
  for(int i = 0; i < Rooms.size(); i++){
    for(int j = 0; j < Rooms.get(i).owpelist.size(); j++){

      if(Rooms.get(i).owpelist.get(j) instanceof OwItem || Rooms.get(i).owpelist.get(j) instanceof OwTeammate){
           data.setBoolean("OwIt" + curSavData +":"+ i +":"+ j, Rooms.get(i).owpelist.get(j).alive);
      }
      
    }
  }
  
  for(int i = 0; i < PlayerOw.items.length; i++){
    data.setInt(curSavData + "item" + i, PlayerOw.itemanzahl[i]);
  }
  
  String datnam = "Spielstand" + curSavData + ".json";
  saveJSONObject(data, datnam);
}

void loadGameData(int curSavData){
  String datnam = "Spielstand" + curSavData + ".json";
  JSONObject data = loadJSONObject(datnam);
  PlayerName = data.getString("PlayerName");
  savedRoom = data.getInt("savRoom"+curSavData);
  CurrentRoom = Rooms.get(savedRoom);
  PlayerOw.x = data.getInt("PlayerOw.x"+curSavData); 
  PlayerOw.y = data.getInt("PlayerOw.y"+curSavData);
  
    for(int i = 0; i < Mclist.length; i++){
    Mclist[i].maxHP = data.getInt(curSavData+"maxHP"+i );
    Mclist[i].curHP = data.getInt(curSavData+"curHP"+i);
    Mclist[i].maxMP = data.getInt(curSavData+"maxMP"+i);
    Mclist[i].curMP = data.getInt(curSavData+"curMP"+i);
    Mclist[i].attStat = data.getInt(curSavData+"AttStat"+i);
    Mclist[i].defStat = data.getInt(curSavData+"DefStat"+i);
    Mclist[i].spAttStat = data.getInt(curSavData+"SpAttStat"+i);
    Mclist[i].spDefStat = data.getInt(curSavData+"SpDefStat"+i);
  }
  
     PlayerOw.Allplcharslist.clear();
  for(int i = 0; i < Mclist.length; i++){
    if(data.getBoolean(i+"teammatebool") == true){
      PlayerOw.Allplcharslist.add(Mclist[i]); 
    }
  }
  
    for(int i = 0; i < Rooms.size(); i++){
    for(int j = 0; j < Rooms.get(i).owpelist.size(); j++){

      if(Rooms.get(i).owpelist.get(j) instanceof OwItem || Rooms.get(i).owpelist.get(j) instanceof OwTeammate){
         Rooms.get(i).owpelist.get(j).alive = data.getBoolean("OwIt"+curSavData +":"+i+":"+j);
      }
    }
  }
  
  for(int i = 0; i < PlayerOw.items.length; i++){
    PlayerOw.itemanzahl[i] = data.getInt(curSavData + "item" + i, PlayerOw.itemanzahl[i]);
  }
  
  
  
}

//########################################################################################################################################################################################################
//KEYPRESSED

void keyPressed(){
  directionInputs();
}

//########################################################################################################################################################################################################
//KEYRELEASED

void keyReleased(){
       if(key == 'p' || key == 'P'){
       if(!pmode){
       pmode = true;
       }else{
         pmode = false;
       }
     }
     
   directionRelease();
   PlayerOw.keyReleased();
  for(OwPerson op : CurrentRoom.owpelist){
    op.keyReleased();
  }
  Battlestuff.keyReleased();
}

//########################################################################################################################################################################################################
//GAMESTATE
int Startmenustate = 0;
boolean[] Spielstandfilled = {false, false, false};

void startmenu(){
  switch(Startmenustate){
    case 0:
        imageMode(CENTER);
    image(Title, width/2, height/4);
    textAlign(CENTER);
    textSize(40);
    fill(0);
    if(second() % 2 != 0){
    text("Drücke E um zu starten",width/2,height-height/8);
  }
    //textAlign(CORNER);
    textSize(20);
       text("Drücke P für Performance-Mode",width/4,height-cells);
    //Startbox.draw();
     if(key == 'e' || key == 'E'){
       Startmenustate = 1;
     }
    break;
    
    case 1:
        fill(255);
    textSize(30);
    text("Wählen Sie einen Spielstand aus!", br, ho*2);
    MenuBox Deletebox = new MenuBox(width/2, height-ho, br, ho, "Löschen", color(160, 255, 0));
    Deletebox.draw();
    Backbox.draw();
         for(int i = 0; i < 3; i++){
       SaveGameBox savdatbox = new SaveGameBox(width/4, height/2 - cells + (ho+cells)*i, br*3, ho, "Spielstand:"+(1+i), color(255), "Spielstand" +i, i);
       savdatbox.draw();
       if(savdatbox.clicked){
         loadGameData(i);
         activerSpielstand = i;
         println("Spielstand:"+i);
         gamestate = OW;
       }
     }
     if(Deletebox.clicked){
       Startmenustate = 2;
     }
     else if(Backbox.clicked){
       Startmenustate = 0;
     }
    break;
    
    case 2:
    fill(255);
    textSize(30);
    text("Welchen Spielstand wollen Sie löschen?", br, ho*2);
    Backbox.draw();
             for(int i = 0; i < 3; i++){
       SaveGameBox savdatbox = new SaveGameBox(width/4, height/2 - cells + (ho+cells)*i, br*3, ho, "Lösche:"+(1+i), color(255), "Spielstand" +i, i);
       savdatbox.draw();
       if(savdatbox.clicked){
         loadGameData(404);
         saveGameData(i);
         activerSpielstand = i;
         println("Spielstand:"+i+" gelöscht");
         Startmenustate = 1;
       }
     }
     if(Backbox.clicked){
       Startmenustate = 1;
     }
    
    break;
  }
}

void gamestates(){
  switch(gamestate){
    case START:
    
    imageMode(CORNER);
    image(Titlescreencover,0,0);
     
     startmenu();
     
     if(keyPressed && key == 'c'){
       //saveGameData(404);
       println("Urgamdat");
     }

    break;
    
    case OW:   //Oberwelt-State
    //translate(transx,transy);
   
  CurrentRoom.colWallTab(); 
  if(!pmode){
  CurrentRoom.drawTiles();
  }
  else{
    CurrentRoom.drawWallTab();
  }
  
  
       for(eventWall w : CurrentRoom.roomwalllist){
    w.render();
  }
  
  for(OwObject i : CurrentRoom.owobjlist){
    i.render();
  }
  for(OwPerson op : CurrentRoom.owpelist){
     op.sprite();
  }
  
   PlayerOw.draw();
  
    for(OwChar c : CurrentRoom.roomowenlist){
      if(c.alive){
      if(dist(c.x,c.y,PlayerOw.x,PlayerOw.y)< PlayerOw.d-10){
        Battlestuff.plcharlist.clear();
        Battlestuff.plcharlist.addAll(PlayerOw.charlist);
        Battlestuff.encharlist.addAll(c.charlist);
        gamestate = BM;
        Battlestuff.battlestate = Battlestuff.ENTRANCE;
        c.alive = false;
      }      
      c.draw();
      }
      enZuEnColCheck();
    
    }
    
    textAlign(CORNER);
    textSize(18);
    fill(0);
    text(CurrentRoom.name,100,50);
    
    for(OwPerson op : CurrentRoom.owpelist){
     op.sprechBox();
  }

    
    break;
    
    case BM: //Im Kampf-State; BATTLEMODE
    
    Battlestuff.battlestate();
   
    
    
    break;
    
    case MENU: //Oberweltmenü
    OwMenu();
    
    break;
    
    case LOSE: //Losestate, reset nach dem Verlieren
    Startbox.draw();
      text("LOSE", width/2,height/2);
      
      int sl = 0;
      for(BmChar bc : PlayerOw.Allplcharslist){
        bc.x = width/2-cells*4; bc.y = height/2+cells*2;
        pushMatrix();
        translate(cells*2*sl, 0);
        
        bc.sprite();
        popMatrix();
        sl++;
      }
      
      Battlestuff.plcharlist.clear();
      Battlestuff.encharlist.clear();
      for(BmFeld f : Battlestuff.fieldlist){
        f.SeatedChar = null;
      }
      
      for(Room r : Rooms){
        for(OwEnemy oe : r.roomowenlist){
          oe.x = oe.xp;
          oe.y = oe.yp;
          oe.alive = true;
      }
      }
      
      for(BmChar bc : PlayerOw.charlist){
        bc.curHP = bc.maxHP;
        bc.curMP = bc.maxMP;
        bc.alive = true;
      }
      CurrentRoom = PlayerOw.LastSave.SavedRoom;
      PlayerOw.x = PlayerOw.LastSave.x;
      PlayerOw.y = PlayerOw.LastSave.y;
      if(Startbox.clicked){
      gamestate = START;
      }
    break;
  }
}

int owmenustates = 1;
ArrayList<BmChar> mactcharlist = new ArrayList<BmChar>();
Item curItem = null;
int merkitemstelle = 0;
void OwMenu(){
  switch(owmenustates){
    case 1:
    MenuBox Teambox = new MenuBox(20, br, br, ho, "Team", color(200,0,0));
    MenuBox MainMenubox = new MenuBox(20,ho*4, br, ho, "Start", color(200, 0, 200) );
  itemBox.draw();
    Teambox.draw();
    MainMenubox.draw();
      Backbox.draw();
      //saveBox.draw();
      //loadBox.draw();
      if(itemBox.clicked){
        owmenustates = 3;
      }
      if(Teambox.clicked){    
        PlayerOw.charlist.clear();
        for(BmChar bc : PlayerOw.Allplcharslist){
        mactcharlist.add(bc);
        }
        owmenustates = 2;
      }
      if(MainMenubox.clicked){
        gamestate = START;
      }
      for(int i = 0; i < PlayerOw.charlist.size(); i++){
        BmChar p = PlayerOw.charlist.get(i);
        fill(100,20,230);
        textSize(20);
        text(p.name +" Lv."+ p.level +" HP:"+ p.maxHP +"/"+ p.curHP +" MP:"+ p.maxMP +"/"+ p.curMP +" Exp:"+p.curExp+"/"+p.expToNextLvl,1000,50+200*i );
        text("Ang.: "+p.attStat+" |Sp.Ang.: "+p.spAttStat,1000,100+200*i);
        text("Vert.: "+p.defStat+" |Sp.Vert.: "+p.spDefStat ,1000,150+200*i);
      }
      if(Backbox.clicked){
        gamestate = OW;
      }
      
      /*if(saveBox.clicked){
        save();
      }
      if(loadBox.clicked){
        load();
      }*/
      break;
      
      case 2: // Menu :: Teamkonstellation einstellen
      //MenuBox Setbox = new MenuBox(br*2,height-ho, br, ho);
      
      Backbox.draw();
      ArrayList<MenuBox> Boxlist = new ArrayList<MenuBox>();  // Liste für alle aktiven Charaktere :: charlist :: Max.Anzahl -> 3!!!  beachten!
      ArrayList<MenuBox> Boxlist2 = new ArrayList<MenuBox>(); // Liste für alle verfügbaren Charaktere :: Allplcharslist
      for(int i = 0; i < PlayerOw.charlist.size() && PlayerOw.charlist.size() < 4; i++){
        Boxlist.add(new MenuBox(br*4, ho* i+ho, br, ho, PlayerOw.charlist.get(i).name, color(200,60,90)));
        
        Boxlist.get(i).draw();
        
        if(Boxlist.get(i).clicked){  //Fügt beim ancklicken Charas zur allgemeinen Liste und entfernt aus der anderen
          mactcharlist.add(PlayerOw.charlist.get(i));
          PlayerOw.charlist.remove(PlayerOw.charlist.get(i));
        }
      }
      for(int i = 0; i < mactcharlist.size(); i++){
        Boxlist2.add(new MenuBox(br*2, ho* i+ho, br, ho, mactcharlist.get(i).name, color(30,50,205)));
        Boxlist2.get(i).draw();
        
        if(Boxlist2.get(i).clicked && PlayerOw.charlist.size() < 3){  //Fügt beim ancklicken Charas zur aktiven Liste
          PlayerOw.charlist.add(mactcharlist.get(i));
          mactcharlist.remove(mactcharlist.get(i));
        }
      }
      
      if(Backbox.clicked){
        if(PlayerOw.charlist.size() == 0){
          PlayerOw.charlist.add(Kreisli);
          
        }
        mactcharlist.clear();
        owmenustates = 1;
      }
      
      break;
      
      case 3:
            MenuBox Atslidebox = new MenuBox(br, ho, br, ho, "ATs", color(230,0,0) );
      MenuBox Itemslidebox = new MenuBox(br*2, ho, br, ho, "Items", color(200,255,0) );
            Atslidebox.draw();
      Itemslidebox.draw();
      int j = 0;
      for(int i = 0; i< PlayerOw.items.length; i++){
        Item it = PlayerOw.items[i];
        if(!(it instanceof AtItem) && !(it instanceof KeyItem)){
      MenuBox Itembox = new MenuBox(br*4, ho*j, br, ho,it.name+ ":" + PlayerOw.itemanzahl[i], color(200,255,0) );

      Itembox.draw();
      Backbox.draw();

      if(Itembox.clicked && PlayerOw.itemanzahl[i] > 0){
        curItem = it;
        merkitemstelle = i;
        owmenustates = 5;
      }
      j++;
        }
      if(Atslidebox.clicked){
        owmenustates = 4;
      }else
        
      if(Backbox.clicked){
        owmenustates = 1;
      }
    }
      
      break;
      
            case 4:
            MenuBox Atslidebox2 = new MenuBox(br, ho, br, ho, "ATs", color(220,0,0) );
      MenuBox Itemslidebox2 = new MenuBox(br*2, ho, br, ho, "Items", color(200,255,0) );
      Backbox.draw();
      Atslidebox2.draw();
      Itemslidebox2.draw();
      
            int k = 0;
      for(int i = 0; i< PlayerOw.items.length; i++){
        Item it = PlayerOw.items[i];
        if(it instanceof AtItem){
      MenuBox Itembox = new MenuBox(br*4, ho*k, br, ho,it.name+ ":" + PlayerOw.itemanzahl[i], color(220,0,0) );

      Itembox.draw();

      if(Itembox.clicked && PlayerOw.itemanzahl[i] > 0){
        curItem = it;
        merkitemstelle = i;
        owmenustates = 5;
      }
      k++;
        }
      
      if(Itemslidebox2.clicked){
        owmenustates = 3;
      }else if(Backbox.clicked){
        owmenustates = 1;
      }
      }
      
      break;
      
      case 5:
      for(int i = 0; i < PlayerOw.Allplcharslist.size(); i++){
        BmChar curChar = PlayerOw.Allplcharslist.get(i);
        MenuBox Charbox = new MenuBox(br*4, ho*i, br, ho,curChar.name, color(0,255,0) );
        MenuBox Itembox = new MenuBox(br, ho, br, ho,curItem.name + ": " + PlayerOw.itemanzahl[merkitemstelle], color(240,180,0) );
        Charbox.draw();
        Itembox.draw();
        if(Charbox.clicked && PlayerOw.itemanzahl[merkitemstelle] > 0){
          curItem.User = curChar;
          curItem.use();
        PlayerOw.itemanzahl[merkitemstelle]--;
          
        }
        Backbox.draw();
        if(Backbox.clicked){
        owmenustates = 3;
      }
        
      }
      break;
      

      
      default:
      owmenustates = 1;
  }
}

//OW-Gegner drücken sich gegenseitig weg
void enZuEnColCheck(){
for(OwChar e : CurrentRoom.roomowenlist){
  
for(OwChar ea : CurrentRoom.roomowenlist){
      if(ea != e && dist(ea.x,ea.y,e.x,e.y) < 40 && ea.alive){
        if(e.x < ea.x){
        e.Force.x -= 2;
      }else
      if(e.x > ea.x){
        e.Force.x += 2;
      }else{e.Force.x = 0;  }
      if(e.y < ea.y){
        e.Force.y += 2;
      }else
      if(e.y > ea.y){
        e.Force.y -= 2;
      }else{e.Force.y = 0; }
      }
    }
    
}
}

  void textBox(String t, int x, int y, int br, int ho){ // Allgemeine Textboxfunktion
    
    rectMode(CORNER);
    stroke(0);
    fill(100,100,255);
    rect(x, y, br, ho);
    textAlign(CORNER);
    fill(0);
    text(t,x, y+40 );
    
  }
  
  void protBox(String[] protText, int x, int y, int br, int ho){
    
    fill(100,100,255, 80);
    rect(x, y, br, ho);
    textAlign(CORNER);
    textSize(20);
    fill(0);
    
    for(int i = 0; i < protText.length; i++){
      if(protText[i] != null){
      text(protText[i], x, y+20+40*i);
      }
    }
  }
  
  void addProtBox(String addStr){
    for(int i = Battlestuff.lastActions.length-2; i > 0; i--){
      Battlestuff.lastActions[i] = Battlestuff.lastActions[i-1];
    }
    
    Battlestuff.lastActions[0] = addStr;
  }
  
  boolean recPointCol(int x, int y, int x2, int y2, int br, int ho){
    
    return x >= x2 && x <= x2 + br && y >= y2 && y <= y2 + ho;
  }


//########################################################################################################################################################################################################
//PLAYERINPUTS


void doubleClicked(){
  if(mousePressed){
    mouseClickTimer = 2;
    clickedOnce = true;
    //println("once");
  }
  if( mouseClickTimer > 0){
    buffer++;
    mouseClickTimer--;
    if( mousePressed && clickedOnce && buffer > 1){
      clickedTwice = true;
      //println("twice");
      if(clickedOnce && clickedTwice){
    clickedDouble = true;
    //println("double");
    mousePressed = false;
  }  
    }    
  }  
  if(mouseClickTimer <= 0){
    clickedOnce = false;
    clickedTwice = false;
    clickedDouble = false;
    mousePressed = false;
    buffer = 0;  
  }
}

void directionInputs(){
  if(key == 'a'){
    left = true;
    }
    if(key == 'd'){
      right = true;
    }
    if(key == 'w'){
     up = true;
    }
    if(key == 's'){
     down = true;
    }
    if(key == 'q' && gamestate == OW){
      gamestate = MENU;
    }
    
   
}

void directionRelease(){
   if(key == 'a'){
    left = false;
    }
    if(key == 'd'){
      right = false;
    }
    if(key == 'w'){
     up = false;
    }
    if(key == 's'){
     down = false;
    }
    
}

//########################################################################################################################################################################################################
//Dev-Tools

void converttodata(int[][] n, String dataName){
  JSONObject data = new JSONObject();
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      data.setInt( i + ":TileNum:" + j, n[i][j]);
    }
  }
  saveJSONObject(data, dataName);
}

void loadData(int[][] n, String dataName){
  JSONObject data = loadJSONObject(dataName);
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      n[i][j] = data.getInt( i + ":TileNum:" + j);
    }
  }
}

void convert(int[][] n, Wall[][] obj, ArrayList<OwEnemy> enlist){
  for(int i = 0; i < w; i++){
    for(int j = 0; j < h; j++){
      if(n[i][j] == 1){
        obj[i][j] = new Wall(cells*i, cells*j, cells, cells);
      }
      if(n[i][j] == 2){
        enlist.add(new OwEnemy(cells*i,cells*j));
      }
      else{
        obj[i][j] = null;
      }
    }
  }
}
