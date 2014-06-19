final int kGOSize = 50;                // game option icon size
final int kBPadding = 15;              // balance padding
final int kHGrids = 14;                // horizontal lines for the grid
final int kVGrids = 9;                 // vertical lines for the grid
final int kTOSize = 40;                // turret option size, upgrade & sell
final int resume = 0;                  // value for resume
final int quit = 1;                    // value for quit
final int peashooter = 0;              // value for peashooter
final int glueshooter = 1;             // value for glueshooter
final int lasershooter = 2;            // value for lasershooter
final int pShooterD = 400;             // the attack range of the peashooter
final int gShooterD = 240;             // the attack range of the glueshooter
final int lShooterD = 640;             // the attack range of the lasershooter
final int pShooterDamage = 10;          // peashooter damage
final int lShooterDamage = 30;         // laser tower damage
final int pShooterBal = 10;            // price of the peashooter
final int gShooterBal = 20;            // price of the glueshooter
final int lShooterBal = 50;            // price of the lasershooter
final int kBulletVelocity = 20;        // velocity for peashooter pellets
final int bulletDelay = 500;           // delay between each bullet fire
final int countdownTime = 1000;       // time before game starts

class Game implements View {
  PImage option, live;
  ArrayList<Turret> pShooters = new ArrayList<Turret>();
  ArrayList<Turret> gShooters = new ArrayList<Turret>();
  ArrayList<Turret> lShooters = new ArrayList<Turret>();
  Wave waves = new Wave();
  Grid[] grids = new Grid[126];
  GameOption[] options = new GameOption[4];
  InGameButton[] buttons = new InGameButton[2];
  InGameButton cancel;
  Map background, path;
  Timer countdown;
  int balance = 100, lives = 20, type = 0;
  Boolean tPlace = false, tOption = false, gameover = false;

  Game() {
    this.background = new Map(width/2-kTSize, height/2, loadImage("map.png"));
    this.path = new Map(width/2, height/2, loadImage("path.png"));
    this.loadOptions();
    this.loadGrids();
    this.loadObstacle();
    this.countdown = new Timer(countdownTime);
    this.sounds();
  }

  void draw() {
    this.drawAssets();
    this.displayText();
    this.checkAssets();
  }

  View mouseReleased() {
    this.checkActive();
    this.checkTowerOption();
    this.checkGrid();
    boolean menu = this.checkOptions();
    if (menu) return new Menu();
    return null;
  }

  void displayText() {
    setFont(gFont[gotham], CENTER, CENTER, 20, color(255, 255, 0));
    text("$ " + this.balance, width-kTSize/2, height-kBPadding);
    image(this.live, width-kTSize/2-15, kBPadding, 34*0.7, 29*0.7);
    setFont(gFont[gotham], CENTER, CENTER, 20, color(255, 0, 0));
    text(this.lives, width-kTSize/2+15, kBPadding-3);
  }

  void checkAssets() {
    this.checkEnemyDist(this.pShooters, 1, pShooterD, pShooterDamage, kEnemySpeed, pellet, SFX[gunSFX]);
    this.checkEnemyDist(this.gShooters, 1, gShooterD, 0, 2, glue, SFX[glueSFX]);
    this.checkEnemyDist(this.lShooters, 1, lShooterD, lShooterDamage, kEnemySpeed, laser, SFX[laserSFX]);
    this.balance += this.checkEnemyHealth(this.waves.gSlimes);
    this.checkLives();
    this.waves.begin = this.countdown.isDone();
    if (!this.waves.begin) this.countdown.displayCountdown("Round starts in: ");
  }

  void checkLives() {
    if (lives < 1) {
      this.gameover = true;
    }
  }

  void drawAssets() {
    this.background.draw();
    this.path.draw();
    this.drawGrid();

    this.waves.draw();
    int sub = this.waves.update(this.waves.gSlimes);
    this.lives -= sub;

    setRect(CENTER, color(180), 'n');
    rect(width-kTSize/2, height/2, kTSize, height);
    for (int i = 0; i < this.options.length; i++) {
      this.options[i].draw();
      this.options[i].rollover();
    }

    drawTurret(this.pShooters);
    drawTurret(this.gShooters);
    drawTurret(this.lShooters);

    if (this.tPlace) {
      for (int i = 0; i < grids.length; i++) {
        grids[i].rollover();
      }
      this.cancel.draw();
      this.cancel.rollover();
    }

    for (int i = 0; i < this.grids.length; i++) {
      this.grids[i].options();
    }

    if (this.tOption) {
      setRect(CENTER, color(0, 70), 'n');
      rect(width/2-kTSize/2, height/2, width-kTSize, height);
      setRect(CENTER, color(150), 'n');
      rect(width/2, height/2, 120, 90, 7);
      for (int i = 0; i < this.buttons.length; i++) {
        this.buttons[i].draw();
        this.buttons[i].rollover();
      }
    }
  }

  void drawTurret(ArrayList<Turret> turrets) {
    for (int i = 0; i < turrets.size (); i++) {
      Turret t = turrets.get(i);
      t.draw();
    }
  }

  // check if the enemy is in attack range, if so follow the enemy
  void checkEnemyDist(ArrayList<Turret> turrets, int type, int range, int damage, int slow, PImage bullet, AudioPlayer SFX) {
    for (int i = 0; i < turrets.size (); i++) {
      Turret t = turrets.get(i);
      t.draw();
      for (int k = this.waves.gSlimes.size ()-1; k >= 0; k--) {
        Enemy e = this.waves.gSlimes.get(k);
        if (dist(e.x, e.y, t.x, t.y) < range/2+5) {
          t.targetX = e.x;
          t.targetY = e.y;
          if (t.bulletDelay.isDone()) {
            t.projectiles.add(new Projectile(type, damage, t.x, t.y, bullet));
            for (int j = 0; j < t.projectiles.size (); j++) {
              Projectile p = t.projectiles.get(j);
              p.xo += (5 * cos(atan2(e.y - t.y, e.x - t.x)));
              p.yo += (30 * cos(atan2(e.y - t.y, e.x - t.x)));
            }
            SFX.rewind();
            SFX.play();
            t.bulletDelay = new Timer(bulletDelay);
          }
          for (int j = 0; j < t.projectiles.size (); j++) {
            Projectile p = t.projectiles.get(j);
            p.vx = (kBulletVelocity * cos(atan2(e.y - t.y, e.x - t.x)));
            p.vy = (kBulletVelocity * sin(atan2(e.y - t.y, e.x - t.x)));
            boolean bound = itemBound(p.x, p.y, e.x, e.y, 70);
            if (bound) {
              e.health -= p.damage;
              e.enemySlow(slow);
              t.projectiles.remove(j);
            }
          }
        }
      }
    }
  }

  int checkEnemyHealth(ArrayList<Enemy> enemies) {
    for (int i = 0; i < enemies.size (); i++) {
      Enemy e = enemies.get(i);
      if (e.health <= 0) {
        enemies.remove(i);
        return e.reward;
      }
    }
    return 0;
  }

  void addProjectile(Turret turret, int damage, PImage bullet) {
    turret.projectiles.add(new Projectile(type, damage, turret.x, turret.y, bullet));
  }

  void checkActive() {
    for (int i = 0; i < this.options.length; i++) {
      boolean bound = checkBounds(this.options[i].x, this.options[i].y, kGOSize/2);
      if (bound && !this.tOption) {
        switch(i) {
        case peashooter: 
          checkPrice(pShooterBal, peashooter); 
          break;
        case glueshooter: 
          checkPrice(gShooterBal, glueshooter); 
          break;
        case lasershooter: 
          checkPrice(lShooterBal, lasershooter); 
          break;
        case 3:
          this.tPlace = false;
          this.tOption = this.tOption? this.tOption : !this.tOption;
          break;
        }
      }
    }
  }

  // checks if the balance is greater than the selected turret, if so placing is active
  void checkPrice(int price, int type) {
    if (this.balance >= price) {
      this.tPlace = true;
      this.type = type;
      resetGrids(type);
    }
  }

  void resetGrids(int turret) {
    for (int i = 0; i < this.grids.length; i++) {
      if (!this.grids[i].active) this.grids[i].type = turret;
    }
  }

  void checkTowerOption() {
    for (int i = 0; i < this.grids.length; i++) {
      boolean bound = checkBounds(this.grids[i].x, this.grids[i].y, kTSize/2);
      boolean sell = (dist(mouseX, mouseY, this.grids[i].x-60, this.grids[i].y) < 30);
      boolean upgrade = (dist(mouseX, mouseY, this.grids[i].x+60, this.grids[i].y) < 30);
      if (!this.grids[i].option && this.grids[i].active && bound && !this.tPlace) {
        this.grids[i].option = true;
      } else if (this.grids[i].option && (sell || upgrade)) {
        if (sell) {
          this.grids[i].active = false;
          this.turretOptions(this.grids[i], this.pShooters, 's');
          this.turretOptions(this.grids[i], this.gShooters, 's');
          this.turretOptions(this.grids[i], this.lShooters, 's');
          switch(this.grids[i].type) {
            case peashooter: this.balance += (5); break;
            case glueshooter: this.balance += (10); break;
            case lasershooter: this.balance += (30); break;
          }
          this.grids[i].option = false;
        } else if (upgrade) {
          this.turretOptions(this.grids[i], this.pShooters, 'u');
          this.turretOptions(this.grids[i], this.gShooters, 'u');
          this.turretOptions(this.grids[i], this.lShooters, 'u');
          this.grids[i].option = false;
        }
      } else {
        this.grids[i].option = false;
      }
    }
  }

  /* this function saved at least 25 lines
   * it checks which grid the turret is in by the boundaries, the depending on
   * the char, it either sells or upgrades */
  void turretOptions(Grid grid, ArrayList<Turret> turrets, char operation) {
    for (int i = 0; i < turrets.size (); i++) {
      Turret t = turrets.get(i);
      boolean bound = itemBound(t.x, t.y, grid.x, grid.y, kTSize);
      if (bound && operation == 'u') {
        if (t.level < 2) {
          t.level++;
        }
      } else if (bound && operation == 's') {
        turrets.remove(i);
      }
    }
  }

  void checkGrid() {
    if (this.tPlace) {
      // checks if clicked on one of the grids
      for (int i = 0; i < this.grids.length; i++) {
        boolean bound = checkBounds(this.grids[i].x, this.grids[i].y, kTSize/2);
        if (!this.grids[i].active && bound && !this.grids[i].path && !this.grids[i].bush) {
          switch(type) {
          case peashooter:
            this.addTurret(this.pShooters, pShooterBal, this.grids[i], pShooterD, PeaShooter); 
            break;
          case glueshooter:
            this.addTurret(this.gShooters, gShooterBal, this.grids[i], gShooterD, GlueShooter); 
            break;
          case lasershooter:
            this.addTurret(this.lShooters, lShooterBal, this.grids[i], lShooterD, LaserShooter); 
            break;
          }
          this.tPlace = false;
          break;
        }
      }
      // checks if clicked on the cancel button
      boolean bound = checkBounds(this.cancel.x, this.cancel.y, 35, 15);
      if (bound) this.tPlace = false;
    }
  }

  // adds a new turret, while applying the restrictions
  void addTurret(ArrayList<Turret> turret, int bal, Grid grid, int diameter, PImage image[]) {
    turret.add(new Turret(grid.x, grid.y, image));
    this.balance -= bal;
    grid.active = true;
    grid.diameter = diameter;
  }

  // returns true or false, depending on where the user clicks
  boolean checkOptions() {
    if (this.tOption) {
      for (int i = 0; i < this.buttons.length; i++) {
        boolean bound = checkBounds(this.buttons[i].x, this.buttons[i].y, 50, 15);
        if (i == resume && bound) this.tOption = false;
        else if (i == quit && bound) return true;
      }
    }
    return false;
  }

  void drawGrid() {
    stroke(0, 50);
    // draws the lines for the grids
    if (this.tPlace) {
      for (int i = 1; i <= width/kTSize-1; i++) {
        line(i*kTSize, 0, i*kTSize, height);
      }
      for (int i = 1; i <= height/kTSize-1; i++) {
        line(0, i*kTSize, width-kTSize, i*kTSize);
      }
    }
    for (int i = 0; i < this.grids.length; i++) {
      this.grids[i].draw();
    }
  }

  // loads the grids exact locations
  void loadGrids() {
    int count = 0;
    for (int i = 0; i < kVGrids; i++) {
      for (int k = 0; k < kHGrids; k++) {
        this.grids[count] = new Grid(kTSize/2+kTSize*k, kTSize/2+kTSize*i);
        count++;
      }
    }
  }

  void loadOptions() {
    this.option = loadImage("Option.png");
    this.live = loadImage("live.png");
    this.options[0] = new GameOption(width-kTSize/2, height/2-kTSize, PeaShooter[0]);
    this.options[1] = new GameOption(width-kTSize/2, height/2, GlueShooter[0]);
    this.options[2] = new GameOption(width-kTSize/2, height/2+kTSize, LaserShooter[0]);
    this.options[3] = new GameOption(width-kTSize/2, height-kTSize*1.5, this.option);

    this.cancel = new InGameButton(width-kTSize/2, height-50, kTSize-10, 30, 15, "Cancel");
    this.buttons[resume] = new InGameButton(width/2, height/2-20, 100, 30, 20, "Resume");
    this.buttons[quit] = new InGameButton(width/2, height/2+20, 100, 30, 20, "Quit");
  }

  // loads the values for the class Grid in which turrets cannot be placed
  void loadObstacle() {
    String[] pathElements = loadStrings("path.txt");
    int[] elements = int(split(pathElements[0], ' '));
    for (int i = 0; i < elements.length; i++) {
      this.grids[elements[i]].path = true;
    }
    for (int i = 0; i < this.grids.length; i++) {
      if (i < 14 || i > 112) {
        this.grids[i].bush = true;
      } else if (i % 14 == 0) {
        this.grids[i].bush = true;
        this.grids[i-1].bush = true;
      }
    }
    this.grids[56].bush = false;
    this.grids[69].bush = false;
  }

  void sounds() {
    overture.rewind();
    overture.pause();
    hatred.loop();
  }
}

// this is the grid class for the snapping to grid action
class Grid {
  float x;
  float y;
  float diameter;
  int type = peashooter;
  boolean active = false;
  boolean path = false;
  boolean bush = false;
  boolean option = false;
  PImage imgBush;
  TurretOption turretOption;

  Grid(float x, float y) {
    this.x = x;
    this.y = y;
    this.turretOption = new TurretOption(this.x, this.y);
    this.imgBush = loadImage("Bush.png");
  }

  void draw() {
    boolean bound = checkBounds(this.x, this.y, kTSize/2);
    if (this.active) {
      image(Platform, this.x, this.y, kTSize, kTSize);
      // when hovered over, shows white square indiating spot is active
      if (bound) {
        setRect(CENTER, color(255, 80), 'n');
        rect(this.x, this.y, kTSize, kTSize);
      }
    } else if (this.bush) {
      image(this.imgBush, this.x, this.y, kTSize, kTSize);
    }
  }

  void rollover() {
    boolean bound = checkBounds(this.x, this.y, kTSize/2);
    if (!this.active && !this.path && !this.bush && bound) {
      pushStyle();
      tint(255, 50);
      image(Platform, this.x, this.y, kTSize, kTSize);
      switch(this.type) {
        case peashooter: image(PeaShooter[0], this.x, this.y, kTSize-10, kTSize-10); break;
        case glueshooter: image(GlueShooter[0], this.x, this.y, kTSize-10, kTSize-10); break;
        case lasershooter: image(LaserShooter[0], this.x, this.y, kTSize-10, kTSize-10); break;
      }
      popStyle();
    } else if (this.path || this.active) {
      setRect(CENTER, color(255, 0, 0, 80), 'n');
      rect(this.x, this.y, kTSize, kTSize);
    }
  }

  // draws the attack range, with sell and upgrade options
  void options() {
    if (this.option) {
      setColour(color(0, 255, 0, 100), color(0, 255, 0));
      ellipse(this.x, this.y, this.diameter, this.diameter);
      this.turretOption.draw();
      this.turretOption.rollover();

      switch(this.type) {
        case peashooter: this.turretOption.drawPrices(5, 7); break;
        case glueshooter: this.turretOption.drawPrices(10, 15); break;
        case lasershooter: this.turretOption.drawPrices(30, 40); break;
      }
    }
  }
}

// this is a class for the option icons on the menu bar in the game
class GameOption {
  float x;
  float y;
  float size = kGOSize;
  PImage option;

  GameOption(float x, float y, PImage option) {
    this.x = x;
    this.y = y;
    this.option = option;
  }

  void draw() {
    image(this.option, this.x, this.y, this.size, this.size);
  }

  // magnifies the icon when hovered over
  void rollover() {
    boolean bound = checkBounds(this.x, this.y, kGOSize/2);
    this.size = bound? kGOSize + 5 : kGOSize;
  }
}

// the sell and upgrade icons for the turret options
class TurretOption {
  float x;
  float y;
  float size = kTOSize;
  color sell = color(255, 255, 0, 150), upgrade = color(255, 255, 0, 150);

  TurretOption(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void draw() {
    setColour(this.sell, color(255, 255, 0));
    ellipse(this.x-60, this.y, this.size, this.size);
    setColour(this.upgrade, color(255, 255, 0));
    ellipse(this.x+60, this.y, this.size, this.size);
    setFont(gFont[GOW], CENTER, CENTER, 30, color(255, 0, 0));
    text("$", this.x-60, this.y-3);
    noStroke();
    rect(this.x+60, this.y+5, this.size-27, 18);
    triangle(this.x+47, this.y, this.x+73, this.y, this.x+60, this.y-15);
  }

  void drawPrices(int sell, int upgrade) {
    // draws the sell price 
    setRect(CENTER, color(255, 200, 0), color(255, 150, 0));
    rect(this.x+kTOSize/3-60, this.y+kTOSize/2, 26, 13, 6);
    setFont(gFont[gotham], CENTER, CENTER, 12, color(255, 0, 0));
    text("$" + sell, this.x+kTOSize/3-60, this.y+kTOSize/2-2);
    
    // draws the upgrade price
    setRect(CENTER, color(255, 200, 0), color(255, 150, 0));
    rect(this.x+kTOSize/3+60, this.y+kTOSize/2, 26, 13, 6);
    setFont(gFont[gotham], CENTER, CENTER, 12, color(255, 0, 0));
    text("$" + upgrade, this.x+kTOSize/3+60, this.y+kTOSize/2-2);
  }

  void rollover() {
    boolean sell = checkBounds(this.x-60, this.y, kTOSize/2, kTOSize/2);
    if (mousePressed && sell) this.sell = color(255, 255, 0, 200);
    else if (sell) this.sell = color(255, 255, 0, 175);
    else this.sell = color(255, 255, 0, 150);

    boolean upgrade = checkBounds(this.x+60, this.y, kTOSize/2, kTOSize/2);
    if (mousePressed && upgrade) this.upgrade = color(255, 255, 0, 200);
    else if (upgrade) this.upgrade = color(255, 255, 0, 175);
    else this.upgrade = color(255, 255, 0, 150);
  }
}

class GameAction {
  float x;
  float y;
  boolean active = false;
  PImage pActive;
  PImage pInactive;

  GameAction(float x, float y, PImage pActive, PImage pInactive) {
    this.x = x;
    this.y = y;
    this.pActive = pActive;
    this.pInactive = pInactive;
  }

  void draw() {
    image(this.active? pActive : pInactive, this.x, this.y, 50, 50);
  }
}
