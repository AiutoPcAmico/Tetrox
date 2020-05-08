class RotationManager {

  int type;

  public RotationManager(int t) {
    type = t;
  }

  //Ribalta i blocchi
  boolean Flap(ArrayList<Blocco> blocks) {

    int maxX = getMax(blocks, true);
    int maxY = getMax(blocks, false);

    int minX = getMin(blocks, true);
    int minY = getMin(blocks, false);

    boolean overflow = OverflowBlocks(blocks);
    int dist = getDistance(blocks);
    boolean freedom = (minX + dist) < 10 && !overflow;

    if (freedom) { //All' inizio controlla se i blocchi non fuoriescono dai bordi
      for (Blocco block : blocks) {

        if (block.staScendendo && type == block.type) { 
          PVector pattern = new PVector((maxX - minX) - (maxX - block.pos.x), 
            (maxY - minY) - (maxY - block.pos.y));
          block.pos.x = minX + pattern.y;
          block.pos.y = minY + pattern.x;
        }
      }
    }

    return freedom;
  }

  //Inverte i blocchi da sinistra a destra o viceversa
  void InvertX(ArrayList<Blocco> blocks) {

    float max = getMax(blocks, true);
    float min = getMin(blocks, true);

    for (Blocco block : blocks) {
      if (block.staScendendo && type == block.type) {
        block.pos.x = min + (max - block.pos.x);
      }
    }
  }

  //Inverte i blocchi dal basso all' alto o viceversa
  void InvertY(ArrayList<Blocco> blocks) {

    float max = getMax(blocks, false);
    float min = getMin(blocks, false);

    for (Blocco block : blocks) {
      if (block.staScendendo && type == block.type) {
        block.pos.y = min + (max - block.pos.y);
      }
    }
  }

  //Ritorna la coordinata x o y maggiore
  private int getMax(ArrayList<Blocco> blocks, boolean forX) {

    int max = -1;

    for (Blocco block : blocks) {
      if (block.staScendendo) {
        if (forX) {
          if (max < block.pos.x) 
            max = (int)block.pos.x;
        } else {
          if (max < block.pos.y) 
            max = (int)block.pos.y;
        }
      }
    }

    return max;
  }

  private int getDistance(ArrayList<Blocco> blocks) {
    int min = getMin(blocks, false);
    int max = getMax(blocks, false);

    return (max - min) + 1;
  }

  //Ritorna la coordinata x o y minore
  private int getMin(ArrayList<Blocco> blocks, boolean forX) {

    int min = 20;

    for (Blocco block : blocks) {
      if (block.staScendendo) {
        if (forX) {
          if (min > block.pos.x) 
            min = (int)block.pos.x;
        } else {
          if (min > block.pos.y) 
            min = (int)block.pos.y;
        }
      }
    }

    return min;
  }

  //Controlla che i blocchi che scendono non intersechino con i blocchi fermi
  private boolean OverflowBlocks(ArrayList<Blocco> blocks) {
    boolean res = false;
    float d = 0;
    int maxX = getMax(blocks, true);
    int maxY = getMax(blocks, false);
    int dist = getDistance(blocks);

    for (Blocco block : blocks) {
      if (!block.staScendendo && (block.pos.x > maxX && block.pos.y <= maxY)) {
        d = block.pos.x - maxX;
        if (d < dist) {
          res = true;
          break;
        }
      }
    }

    return res;
  }
}
