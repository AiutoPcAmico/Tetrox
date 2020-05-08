class Blocco {
  PVector pos; //salva come coord nella griglia
  int size = (width-200)/w;
  boolean del = false;  //diventa true quando il blocco va eliminato dalla lista (la sua riga è stata eliminata)
  boolean staScendendo = true;  //è true quando in discesa, viene messo a false quando raggiunge la fine
  int type; //indica il tipo di blocco multiplo a cui appartiene

  Blocco(int t, int x, int y) {
    pos = new PVector(x, y);
    type = t;
  }

  void show() {
    switch(type) {
    case 0: 
      tint(97, 162, 255); 
      break; //azzurro
    case 1: 
      tint(227, 81, 0); 
      break; //arancio
    case 2: 
      tint(235, 211, 32); 
      break; //giallo
    case 3: 
      tint(97, 16, 162); 
      break; //viola
    case 4: 
      tint(81, 162, 0); 
      break; //verde
    case 5: 
      tint(158, 16, 48); 
      break; //rosso
    case 6: 
      tint(65, 65, 255); 
      break; //blu
    case 7: 
      tint(255, 64, 246);
      break; //lillà
    default: 
      tint(255); 
      break; //bianco
    }

    image(sprite, (pos.x)*size, (pos.y)*size);
    noTint();
  }
}

//ritorna true se il blocco è in discesa, false se si ferma
boolean update(Grid griglia, ArrayList<Blocco> blocchi, int h) {  //scende, movimento verticale

  //genero un array con gli indici dei blocchi in discesa
  ArrayList<Integer> blocchiInDiscesa = new ArrayList<Integer>();
  for (int i = blocchi.size()-1; i >= 0; i--) {  //scorro tutti i blocchi e genero l'array
    if (blocchi.get(i).staScendendo) {
      blocchiInDiscesa.add(i);
    } else {
      break;
    }
  }

  //controllo che tutti si possano muovere, in caso contrario non muovo nulla
  boolean siPossonoMuovere = true;

  for (int i = 0; i < blocchiInDiscesa.size(); i++) {
    if (blocchi.get(blocchiInDiscesa.get(i)).pos.y < h - 1) {  //controllo che non sia già sul fondo
      //controllo blocco della griglia sotto che non sia già occupato o che sia un blocco che sta scendendo quindi appartiene al proprio blocco multiplo
      if (!(griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y + 1][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x] == -1 || blocchi.get(griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y + 1][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x]).staScendendo)) {
        siPossonoMuovere = false;
        break;
      }
    } else {
      siPossonoMuovere = false;
    }
  }

  //se si possono muovere li muovo
  if (siPossonoMuovere) {
    for (int i = 0; i < blocchiInDiscesa.size(); i++) {
      blocchi.get(blocchiInDiscesa.get(i)).pos.y ++;
    }
  }

  //se è arrivato in fondo (o il posto sotto è occupato) blocco subito la discesa
  //se non lo si facesse passerebbe un altro clock prima che si bloccasse
  for (int i = 0; i < blocchiInDiscesa.size(); i++) {
    if (!(blocchi.get(blocchiInDiscesa.get(i)).pos.y < h - 1 && (griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y + 1][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x] == -1 || blocchi.get(griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y + 1][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x]).staScendendo))) {
      if (aum == 0)
        cadutaBloccoSound.play();  //se è in hard-drop fa il suono
        
      return false;  //se ha terminato la discesa rinasce
    }
  }

  return true;  
}

//muove orizzontalmente tutti i blocchi che stanno scendendo
static void movimentoOrizzontale(Grid griglia, ArrayList<Blocco> blocchi, int mov, int w) {  //-1 a sx 1 a dx
  //genero un array con gli indici dei blocchi in discesa
  ArrayList<Integer> blocchiInDiscesa = new ArrayList<Integer>();
  for (int i = blocchi.size()-1; i >= 0; i--) {  //scorro tutti i blocchi e genero l'array
    if (blocchi.get(i).staScendendo) {
      blocchiInDiscesa.add(i);
    } else {
      break;
    }
  }

  //controllo che tutti si possano muovere, in caso contrario non muovo nulla
  boolean siPossonoMuovere = true;

  for (int i = 0; i < blocchiInDiscesa.size(); i++) {

    //controllo prima che la x sia favorevole rispetto ai bordi, poi che il blocco in parte sia vuoto oppure che il blocco in parte stia scendendo (appartiene alla stessa forma)
    if (!(blocchi.get(blocchiInDiscesa.get(i)).pos.x + mov >= 0 && blocchi.get(blocchiInDiscesa.get(i)).pos.x + mov < w  && (griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x + mov] == -1 || blocchi.get(griglia.grid[(int)blocchi.get(blocchiInDiscesa.get(i)).pos.y][(int)blocchi.get(blocchiInDiscesa.get(i)).pos.x + mov]).staScendendo))) {
      siPossonoMuovere = false;
    }
  }

  //se tutti si possono muovere si muovono
  if (siPossonoMuovere) {
    //scorro tutti i blocchi in discesa e li faccio muovere
    for (int i = 0; i < blocchiInDiscesa.size(); i++) {
      blocchi.get(blocchiInDiscesa.get(i)).pos.x += mov;
    }
  }
}
