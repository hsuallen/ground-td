final int gSlimeHealth = 20;      // hit points of the green slimes
final int pSlimeHealth = 40;      // hit points of the purple slimes
final int rSlimeHealth = 70;      // hit points of the red slimes
final int gHeavyHealth = 100;     // hit points of the green heavy unit
final int bHeavyHealth = 200;     // hit points of the blue heavy unit
final int pHeavyHealth = 350;     // hit points of the red heavy unit
final int gSlimeReward = 1;       // money for killing green slime
final int pSlimeReward = 2;       // money for killing purple slime
final int rSlimeReward = 3;       // money for killing red slime
final int gHeavyReward = 5;       // money for killing green heavy unit
final int bHeavyReward = 10;      // money for killing blue heavy unit
final int rHeavyReward = 20;      // money for killing red heavy unit
final int kEnemySpeed = 5;        // the enemy speed
final int kEnemyTimer = 800;      // how long it takes for the next enemy to spawn
final int kEnemyHPPadding = 50;
final int nWaves = 20;            // total number of waves
final float kEnemyWidth = 72;
final float kEnemyHeight = 69.3;

// g for green, and p for purple
PImage gSlime, pSlime, rSlime, gHeavy, bHeavy, rHeavy;

class Enemy {
  int mode = 0;
  int reward;
  float x = -100, y;
  float speed = kEnemySpeed;
  float rotateInc = 0.03, rotate;
  float health, kHealth;
  PImage enemy;
  boolean slowed, once = false;
  Timer slowTimer;

  Enemy(int reward, float health, PImage enemy) {
    this.reward = reward;
    this.y = height/2;
    this.health = health;
    this.kHealth = health;
    this.enemy = enemy;
    this.slowTimer = new Timer(1);
  }

  void draw() {
    imageMode(CENTER);
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.rotate);
    image(this.enemy, 0, 0, kEnemyWidth, kEnemyHeight);
    popMatrix();
    this.updateAngle();
    this.displayHealth();
    this.checkSlow();
  }

  void updateAngle() {
    this.rotate += this.rotateInc;
    if (this.rotate > QUARTER_PI/4) this.rotateInc = -this.rotateInc;
    else if (this.rotate < -QUARTER_PI/4) this.rotateInc = -this.rotateInc;
  }
  
  void displayHealth() {
    setRect(CENTER, color(0, 255, 0), color(0));
    strokeWeight(1);
    rect(this.x, this.y-kEnemyHPPadding, 70, 4);
    setRect(CORNER, color(255, 0, 0), 'n');
    rect(this.x+35, this.y-kEnemyHPPadding-2, map(this.health, 0, this.kHealth, -70, 0), 4);
  }
  
  void checkSlow() {
    if (this.slowed && !this.once) {
      this.slowTimer = new Timer(1000);
      this.once = true;
    }
    
    if (this.slowTimer.isDone()) {
      this.slowed = false;
      this.speed = kEnemySpeed;
      this.once = false;
    }
  }
  
  void enemySlow(int slow) {
    this.slowed = true;
    this.speed = slow;
  }
}

class Wave {
  Timer spawnTimer;
  ArrayList<Enemy> gSlimes = new ArrayList<Enemy>();
  ArrayList<Enemy> pSlimes = new ArrayList<Enemy>();
  ArrayList<Enemy> rSlimes = new ArrayList<Enemy>();
  ArrayList<Enemy> gHeavyUnits = new ArrayList<Enemy>();
  ArrayList<Enemy> bHeavyUnits = new ArrayList<Enemy>();
  ArrayList<Enemy> rHeavyUnits = new ArrayList<Enemy>();
  int level = 0, count = 0;;
  int doneTime = kEnemyTimer;
  int totalEnemies = 0;
  int[][] waves = new int[nWaves][6];
  boolean begin = false;
  boolean pause = false;
  Timer spawnDelay;
  
  Wave() {
    this.loadWaves();
    this.spawnTimer = new Timer(this.doneTime);
  }
  
  void draw() {
    this.drawAssets();
    this.addWaves();
    if (this.begin) this.displayWave();
    println(this.count);
  }
  
  void drawAssets() {
    this.drawEnemies(this.gSlimes);
    this.drawEnemies(this.pSlimes);
    this.drawEnemies(this.rSlimes);
    this.drawEnemies(this.gHeavyUnits);
    this.drawEnemies(this.bHeavyUnits);
    this.drawEnemies(this.rHeavyUnits);
  }

  void drawEnemies(ArrayList<Enemy> enemies) {
    for (int i = 0; i < enemies.size (); i++) {
      Enemy e = enemies.get(i);
      e.draw();
    }
  }
  
  void displayWave() {
    setFont(gFont[gotham], CENTER, CENTER, 20, color(255));
    text("Wave " + (this.level+1), width/2, kTSize/2);
  }
  int test = 0;
  void addWaves() {
    switch(this.count) {
      case 0:
      println(test);
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.gSlimes, gSlimeReward, gSlimeHealth, this.waves[this.level][count], gSlime);
          if (test < 1) {
            this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
            test++;
          }
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++; //break;
      case 1:
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.pSlimes, pSlimeReward, pSlimeHealth, this.waves[this.level][count], pSlime);
          if (test < 2) this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++; //break;
      case 2:
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.pSlimes, pSlimeReward, pSlimeHealth, this.waves[this.level][count], pSlime);
          if (test < 3) this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++; //break;
      case 3:
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.pSlimes, pSlimeReward, pSlimeHealth, this.waves[this.level][count], pSlime);
          if (test < 4) this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++;
      case 4:
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.pSlimes, pSlimeReward, pSlimeHealth, this.waves[this.level][count], pSlime);
          if (test < 5) this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++; //break;
      case 5:
        if (this.waves[this.level][count] != 0) {
          this.addEnemies(this.pSlimes, pSlimeReward, pSlimeHealth, this.waves[this.level][count], pSlime);
          if (test < 6) this.spawnDelay = new Timer(this.waves[this.level][count]*kEnemyTimer);
          if (this.spawnDelay.isDone()) {
            this.count++;
          }
        } else this.count++; //break;
      case 6: 
        if (test < 7) this.spawnDelay = new Timer(15000);
        if (this.spawnDelay.isDone()) {
          this.level++;
          this.count = 0;
          this.test = 0;
        }
    }
  }

  void addEnemies(ArrayList<Enemy> enemies, int money, int health, int nEnemies, PImage image) {
    if (this.begin && this.totalEnemies < nEnemies) {
      boolean addEnemy = this.spawnTimer.isDone();
      if (addEnemy) {
        enemies.add(new Enemy(money, health, image));
        this.totalEnemies++;
        this.spawnTimer.reset();
      }  
    }
  }

  // updates the enemies' path using modes, values were tested
  int update(ArrayList<Enemy> enemies) {
    if (!this.pause) {
      for (int i = 0; i < enemies.size (); i++) {
        Enemy g = enemies.get(i);
        switch(g.mode) {
          case 0: g.x += g.speed; if (g.x > 270) g.mode++; break;
          case 1: g.y += g.speed; if (g.y > 595) g.mode++; break;
          case 2: g.x += g.speed; if (g.x > 510) g.mode++; break;
          case 3: g.y -= g.speed; if (g.y < 124) g.mode++; break;
          case 4: g.x += g.speed; if (g.x > 755) g.mode++; break;
          case 5: g.y += g.speed; if (g.y > 350) g.mode++; break;
          case 6: 
            g.x += kEnemySpeed;
            if (g.x > width-kTSize/2) {
              enemies.remove(i);
              return 1;
            }
            break;
        }
      }
    }
    return 0;
  }

  void loadWaves() {
    String[] lines = loadStrings("waves.txt");
    for (int i = 0; i < nWaves; i++) {
      int[] enemies = int(split(lines[i], ' '));
      for (int j = 0; j < 6; j++) {
        this.waves[i][j] = enemies[j];
      }
    }
  }
}
