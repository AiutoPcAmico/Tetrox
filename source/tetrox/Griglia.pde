class Grid {
  int [][] grid;

  //griglia di posizioni nell'array list, ogni cella della griglia conterrò l'indice del blocco che la occupa relativo all'arrayList blocks

  Grid(int h, int w) {
    grid = new int[h][w];
    for (int i=0; i<h; i++)
      for (int j=0; j<w; j++)
        grid[i][j] = -1;
  }

  void printGrid() {
    translate(200, 0);
    stroke(100);
    for (int i=0; i<h; i++)
      line(0, i*height/h, width-200, i*height/h);
    for (int i=0; i<width-200; i++)
      line(i*(width-200)/w, 0, i*(width-200)/w, height);
  }

  void updateGriglia(ArrayList<Blocco> blocchi) {  //riempie la griglia con le coordinate di ogni blocco
    for (int i=0; i<h; i++)  //svuoto tutta la griglia
      for (int j=0; j<w; j++)
        grid[i][j] = -1;


    //è UN FOR CATTIVO NON TOCCARLO PERCHé MORDE
    for (int i = blocchi.size()-1; i >=0; i--) {  
      if (blocchi.get(i).staScendendo && !bloccoInDiscesa) {  //segno come "non in discesa" quando la caduta deve fermarsi
        blocchi.get(i).staScendendo = false;
      }

      if (blocchi.get(i).del) {  //se è da eliminare lo elimino
        blocchi.remove(i);
      }
    }

    //riempio nuovamente la griglia
    for (int i = blocchi.size()-1; i >=0; i--)
      grid[(int)blocchi.get(i).pos.y][(int)blocchi.get(i).pos.x] = i;
  }

  void eliminaRiga(int n, ArrayList<Blocco> blocchi) {  //elimina una singola riga e sposta tutte quelle sopra in già
    eliminaRigaSound.play();
    //sposto in giù tutte le rige superiori modificando la coordinata nella lista
    for (int i = n-1; i > 0; i--) {
      for (int j = 0; j < w; j++) {
        if (grid[i][j] != -1) {  //se non è vuoto
          blocchi.get(grid[i][j]).pos.y ++;  //aumento la y
        }
      }
    }

    //scorro tutte le colonne della riga da eliminare e segno i blocchi come da eliminare dalla lista
    for (int j = w-1; j >= 0; j--) {
      blocchi.get(grid[n][j]).del = true;
    }

    updateGriglia(blocchi);  //riempio di nuovo la griglia correttamente
  }

  void controlloEliminazione(ArrayList<Blocco> blocchi) {  //controlla se riga va eliminata 
    //controlla ogni riga, le salva in un array, aumenta i punti ed elima riga per riga

    ArrayList<Integer> righeDaEliminare = new ArrayList<Integer>();
    boolean daEliminare = true;  //è true quando va eliminata la riga

    for (int i = 0; i < h; i++) { //scorre le righe dalla prima in alto a scendere (si elimina da quella più in alto)
      daEliminare = true;
      for (int j = 0; j < w; j++) {
        if (grid[i][j] == -1) {  //quando trovo una cella vuota passo alla prossima riga
          daEliminare = false;
        }
      }
      //se la riga è piena la metto in lista per l'eliminazione
      if (daEliminare) {
        righeDaEliminare.add(i);
        righeEliminate++;
      }
    }

    //aggiungo punti in base al numero di righe da eliminare (size della lista)
    switch(righeDaEliminare.size()) {
    case 0:  //se non ci son righe da eliminare non aggiungo punti
      break;
    case 1:
      punti += 50 * (lvl+1);
      break;
    case 2:
      punti += 150 * (lvl+1);
      break;
    case 3:
      punti += 350 * (lvl+1);
      break;
    default:  //da 4 righe in avanti
      punti += 1000 * (lvl+1);
      break;
    }
    
    //eliminazione effettiva delle righe
    if (!bloccoInDiscesa)
      for (int i = 0; i < righeDaEliminare.size(); i++) {
        eliminaRiga(righeDaEliminare.get(i), blocchi);
      }

    nextLvl += righeDaEliminare.size(); //aumento il contatore di righe eliminate
    
    if (nextLvl >= 10) { //guardo se ho eliminato almeno 10 righe in questo livello
      lvl++; //aumento di livello
      nextLvl = 0; //azzero il contatore
      aum = (int)map(lvl, 0, 30, 700, 10); //rimappo la velocità in base al livello
      aumDefault = aum; //assegno la vel default del livello a questa var
      blockOffset+=aum; //boh??
    }
  }
}
