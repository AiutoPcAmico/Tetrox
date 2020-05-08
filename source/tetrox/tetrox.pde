// //<>//
//                            TETROX
//
import processing.sound.*;
SoundFile music1;
SoundFile music2;
SoundFile cadutaBloccoSound;
SoundFile eliminaRigaSound;
SoundFile gameOverSound;

PImage sprite;

Gui interfaccia;
Grid griglia;

int timeGame = 0; //tempo di gioco effettivo
int timeoffset = 0; //offset di tempo accumulato al menu princ e durante le pause
int h = 20; //righe
int w = 10; //colonne


ArrayList<Blocco> blocks = new ArrayList<Blocco>();
boolean bloccoInDiscesa = false;  //è true quando un blocco sta scendendo e non ne serve uno nuuovo
int blockOffset = 700; //offset di default per la caduta dei blocchi
int aum = 700;  //aumento di block offset, più è piccolo e più è veloce a scendere
int aumDefault = 700;

int punti = 0; //tutte queste var si spiegano da sole credo
int lvl = 0;
int nextLvl = 0;
int righeEliminate = 0;
boolean pausa = false;
boolean avviato = false; //ho premuto z o no?
boolean gameOver = false;

int musicTrack = 1; //traccia musicale selez
boolean musicLoaded = false;

int nextBlock = (int)random(8);  //indica la tipologia del blocco successivo (in anteprima), viene randomizzato all'inizio per stabilire il primo blocco
BlockManager manager = new BlockManager();  //gestore nuovi blocchi

void setup() {
  size(600, 800); //stampo schermata di loading mentre il programma carica le sue musiche
  background(9, 9, 9);
  textSize(30);
  textAlign(CENTER);
  fill(#d93444);
  text("LOADING", 300, 300);

  interfaccia = new Gui(); //inizializzo la gui
  griglia = new Grid(h, w); //inizializzo la griglia di gioco

  sprite = loadImage("block.png"); //carico le sprite dei blocchi

  cadutaBloccoSound = new SoundFile(this, "cadutaBlocco.wav"); //carico i vari effetti sonori + musica
  eliminaRigaSound = new SoundFile(this, "eliminaRiga.wav");
  gameOverSound = new SoundFile(this, "gameOver.wav");
  music1 = new SoundFile(this, "music1.mp3");
  music2 = new SoundFile(this, "music2.mp3");
  cadutaBloccoSound.amp(0.4); //fixo l'effetto strano
}

void draw() {
  if (avviato && musicLoaded) 
    drawGame(); //gioco se ho avviato e caricato la musica
  else //altrimenti stampo il menu principale
    interfaccia.stampoMenu();

  if (gameOver) 
    interfaccia.stampoGameOver(); //se sono in gameover richiamo stampoGameOver
}

void drawGame() {
  fill(9, 9, 9); //colore bg e tab sx in alto
  background(35, 35, 35);
  rect(200, 0, 400, height);
  noFill();

  if (millis()-timeoffset > blockOffset) {  //"delay" fittizio, esegue la logica della caduta solamente ogni aum millisecondi 
    if (!bloccoInDiscesa) {  //se non scende nulla creo blocco nuovo
      //crea blocco
      manager.loadBlocks(nextBlock, blocks, griglia);  //spawno nuovo blocco multiplo

      nextBlock = (int)random(8); //randomizza il blocco successivo
      manager.loadBlocksAnteprima(nextBlock, interfaccia.leftBlocks);  //genero l'anteprima dei blocchi riempiendo l'array di blocchi di sinistra

      bloccoInDiscesa = true;
    } else {
      bloccoInDiscesa = update(griglia, blocks, h);  //eseguo la discesa dei blocchi con "update", ritorna se il blocco sta scendendo o se è alla fine
      if (!bloccoInDiscesa)  //se ha finito di scendere ripristino la velocità normale, serve in caso di hard drop perché aum diventa 0
        aum = aumDefault;
    }

    blockOffset+=aum;
  }

  griglia.updateGriglia(blocks); //update della griglia  

  if (!bloccoInDiscesa) //controllo eliminazione riga
    griglia.controlloEliminazione(blocks);

  translate(200, 0); //mi sposto nella zona di gioco
  for ( Blocco i : blocks) //stampo i blocchi
    i.show();

  interfaccia.mostra(); //stampo gui

  timeGame = millis(); //calcoli per il tempo
}

void keyPressed() {
  int mov = 0;  //conterrà il codice per l'eventuale movimento orizzontale

  if (avviato && (!pausa && bloccoInDiscesa)) {
    //per muoversi orizzontalmente non deve esserci pausa e il blocco deve stare scendendo
    //altrimenti nell'ultima riga può continuare a muoversi e continua a scendere mentre si è in pausa
    if (key == CODED) {
      if (keyCode == LEFT) {
        mov = -1;
      } else if (keyCode == RIGHT) {
        mov = 1;
      } else if (keyCode == DOWN && aum == aumDefault) {  //aumento velocità solo se non è già aumentata
        aum/=2;
      }

      movimentoOrizzontale(griglia, blocks, mov, w);  //se scende lo faccio muovere
    }
  }

  if ((key == 'p'|| key== 'P') && gameOver==false) { //tasto pausa, controllo che non sia gameover
    int timetemp = millis();
    if (!pausa && avviato) { //metto in pausa
      noLoop();
      pausa=true;
      timeGame = millis(); //salvo millis al momento dell'inizio pausa
      interfaccia.stampoPausa();
    } else if (pausa && avviato) {  //esco dalla pausa
      loop(); 
      pausa=false;
      timeoffset += timetemp - timeGame; //ricalcolo tempo con millis e offset calcolato prima
    }
  }

  //inizio
  if ((key == 'z' || key == 'Z')) { //tasto d'avvio 
    avviato = true;
  }

  //hard drop
  if ((key == 'c' || key == 'C') && pausa==false) {  //se premo h azzero il gap tra un ciclo di update e l'altro (scende ogni 0 millisecondi)
    aum = 0;
  }

  //scelgo traccia musica
  if ((key == 'a' || key == 'A') && !avviato) {
    if ( musicTrack == 1) 
      musicTrack = 2;
    else 
      musicTrack = 1;
  }
}


void keyReleased() {
  if (avviato && !pausa && bloccoInDiscesa) {
    if (key == CODED) {
      //quando rilascio il tasto torna a normale velocità
      if (keyCode == DOWN && aum != aumDefault) {
        aum = aumDefault;
      }
    }
  }

  if ((key == 'x' || key == 'X')&& pausa==false) { //tasto di rotazione
    if (avviato) 
      manager.rotate(blocks);
  }
}
