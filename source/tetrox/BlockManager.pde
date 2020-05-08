interface BlockType {
  int
    Straight = 0, 
    L = 1, 
    Square = 2, 
    Plus = 3, 
    Lightning = 4, 
    Short = 5, 
    Long = 6,
    NegativeLightning = 7;
}

interface FlipType {
  int
    horizontalStraight = 6, 
    left_right_L = 7, 
    up_down_L = 8, 
    left_right_Plus = 9, 
    up_down_Plus = 10, 
    left_right_Lightning = 11, 
    up_down_Lightning = 12;
}

interface RotationType {
  int
    normal = 0, 
    down_right = 1, 
    down_left = 2, 
    up_left = 3, 
    up_right = 4;
}

class BlockManager {

  int rotation_type = 0;
  boolean first = true;

  //SUMMARY
  //Si occupa di aggiungere i blocchi nella lista, per disegnare le forme.
  public void loadBlocks(int type, ArrayList<Blocco> blocks, Grid griglia) {

    int initialPos;  //x iniziale
    int initialY = 0;
    int grandezza = 0;  //indica quanto il blocco generato è grande

    switch(type) {
    case BlockType.Straight:

      initialPos = (int)random(w);
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY+2));

      grandezza = 3;

      break;
    case BlockType.L:

      initialPos = (int)random(w-1);
      blocks.add(new Blocco(BlockType.L, initialPos, initialY));
      blocks.add(new Blocco(BlockType.L, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.L, initialPos, initialY+2));
      blocks.add(new Blocco(BlockType.L, initialPos + 1, initialY+2));

      grandezza = 4;

      break;
    case BlockType.Square:

      initialPos = (int)random(w-1);
      blocks.add(new Blocco(BlockType.Square, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Square, initialPos + 1, initialY));
      blocks.add(new Blocco(BlockType.Square, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Square, initialPos + 1, initialY+1));

      grandezza = 4;

      break;
    case BlockType.Plus:

      initialPos = (int)random(w-2);
      blocks.add(new Blocco(BlockType.Plus, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Plus, initialPos + 1, initialY));
      blocks.add(new Blocco(BlockType.Plus, initialPos + 2, initialY));
      blocks.add(new Blocco(BlockType.Plus, initialPos + 1, initialY+1));

      grandezza = 4;

      break;
    case BlockType.Lightning:

      initialPos = (int)random(w-1);
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+2));

      grandezza = 4;

      break;
    case BlockType.Short:

      initialPos = (int)random(w);
      blocks.add(new Blocco(BlockType.Short, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Short, initialPos, initialY+1));

      grandezza = 2;

      break;
    case BlockType.Long:

      initialPos = (int)random(w);
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+2));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+3));

      grandezza = 4;

      break;
      
   case BlockType.NegativeLightning:
     
      initialPos = (int)random(w-1);
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+2));

      grandezza = 4;

      break;
   
    default:
      println("Error BlockType");
    }

    //CONTROLLO GAMEOVER
    for (int i = 1; i <= grandezza; i++) {  //controllo se gli ultimi blocchi spawnati son già occupati, in tal caso gameOver
      int riga = (int)blocks.get(blocks.size()-i).pos.y;
      int colonna = (int)blocks.get(blocks.size()-i).pos.x;
      if (griglia.grid[riga][colonna] != -1) {
        gameOver = true;
      }
    }
  }

  public void loadBlocksAnteprima(int type, ArrayList<Blocco> blocks) {  //metodo per generare l'array di blocchi in anteprima

    int initialPos = 0;  //x iniziale
    int initialY = 0;
    
    blocks.clear();  //svuota array blocchi in anteprima prima di generarne nuovi
    
    switch(type) {
    case BlockType.Straight:
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Straight, initialPos, initialY+2));

      break;
    case BlockType.L:
      blocks.add(new Blocco(BlockType.L, initialPos, initialY));
      blocks.add(new Blocco(BlockType.L, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.L, initialPos, initialY+2));
      blocks.add(new Blocco(BlockType.L, initialPos + 1, initialY+2));

      break;
    case BlockType.Square:
      blocks.add(new Blocco(BlockType.Square, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Square, initialPos + 1, initialY));
      blocks.add(new Blocco(BlockType.Square, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Square, initialPos + 1, initialY+1));

      break;
    case BlockType.Plus:
      blocks.add(new Blocco(BlockType.Plus, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Plus, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Plus, initialPos, initialY+2));
      blocks.add(new Blocco(BlockType.Plus, initialPos + 1, initialY + 1));

      break;
    case BlockType.Lightning:
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+2));

      break;
    case BlockType.Short:
      blocks.add(new Blocco(BlockType.Short, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Short, initialPos, initialY+1));

      break;
    case BlockType.Long:
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+2));
      blocks.add(new Blocco(BlockType.Long, initialPos, initialY+3));

      break;

    case BlockType.NegativeLightning:
      
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY));
      blocks.add(new Blocco(BlockType.Lightning, initialPos + 1, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+1));
      blocks.add(new Blocco(BlockType.Lightning, initialPos, initialY+2));

      break;
      
    default:
      println("Error BlockType");
    }
  }

  //Gestisce le rotazioni
  public void rotate(ArrayList<Blocco> blocks) {
    RotationManager rotationManager = new RotationManager(blocks.get(blocks.size() - 1).type);
    rotationManager.InvertX(blocks);
    boolean freedom = rotationManager.Flap(blocks);
    if (!freedom) 
      rotationManager.InvertY(blocks);
  }
}
