class Gui {

  ArrayList<Blocco> leftBlocks = new ArrayList<Blocco>();  //blocchi di anteprima
  
  PImage leftTab;
  PImage mainmenu;
  PImage maintitle;
  PImage gameOverImg;

  Gui() { //load della grafica
    leftTab = loadImage("leftsidetab2.png");
    mainmenu = loadImage("main_menu.png");
    gameOverImg = loadImage("game_over.png");
    maintitle = loadImage("tetrox.png");
  }

  void mostra() {
    translate(-200, 0); //mi sposto all'origine
    
    imageMode(CENTER);
    image(maintitle, 100, 85, 180, 54); //stampo nome gioko
    imageMode(CORNER);
    
    fill(100); //faccio il pulsante pausa
    rect(20, height/2-150, 160, 55, 5);
    
    textSize(16); //stampo varie cose
    fill(255);
    text("Punti: "+punti, 100, 160);
    fill(#d93444);
    text("Righe eliminate: "+righeEliminate, 100, 180);
    fill(255);
    text("Livello: "+lvl, 100, 200);
    fill(#d93444);
    text("Tempo di gioco: "+ (timeGame - timeoffset)/1000, 100, 220); //faccio il calcolo del tempo di gioco effettivo
    
    fill(255);
    textSize(18);
    text("PREMI P PER\nPAUSA", 100, height/2-130);
    textSize(15);
    text("Premi X per \nruotare il blocco", 100, 340);
    fill(#d93444);
    text("Premi C\nper l'hard drop", 100, 385);
    fill(255);
    text("Premi Freccia in giù\nper velocizzare la discesa", 100, 430);
    noFill();
    
    image(leftTab, 0, 480); //stampo la sprite del muro a sx
    
    translate(80, 560); //stampo i blocchi in anteprima
    for (Blocco i : leftBlocks)
      i.show();
    translate(-80, -560);
  }

  void stampoPausa() {
    fill(100);
    rect(20, height/2-150, 160, 55, 5); //stampo pulsante
    noFill();
    fill(255);
    textSize(18); //stampo testo per riprendere il gioco
    text("PREMI P PER\nRIPRENDERE", 100, height/2-130);
    noFill();
  }

  void stampoGameOver() {
    imageMode(CENTER);
    image(gameOverImg, 400, 200); //stampo img gameover
    if (musicTrack == 1) music1.stop(); //fermo la traccia corretta
    else music2.stop();
    noLoop(); //stoppo il draw
    gameOverSound.play(); //riproduco la musica di gameover
  }

  void stampoMenu() {
    if (!avviato) { //se non ho avviato con z stampo il menù principale
      timeoffset = millis() - aum; //preparo un offset per azzerare il tempo di gioco finchè non si avvia effettivamente
      image(mainmenu, 0, 0); //stampo il bg
      imageMode(CENTER);
      image(maintitle, width/2, 300); //stampo il titolo
      imageMode(CORNER);
      textSize(25);
      fill(255);
      text("PREMI Z PER INIZIARE", 300, 430); //scrivo puttanate
      text("PREMI A PER CAMBIARE LA MUSICA\nTRACCIA CARICATA: " + musicTrack, 300, 630);
    } else { //se ho avviato seleziono la traccia e la faccio partire, impostando musicLoaded a true
      if (musicTrack == 1) {
        music1.amp(0.05);
        music1.loop();
      } else {
        music2.amp(0.1);
        music2.loop();
      }
      musicLoaded = true;
    }
  }
}
