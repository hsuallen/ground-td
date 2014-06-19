final int kTSize = 80;
final int kBulletSize = 20;
final float kEase = 0.1;

PImage Platform;
PImage[] PeaShooter = new PImage[3];
PImage[] GlueShooter = new PImage[3];
PImage[] LaserShooter = new PImage[3];
PImage pellet, glue, laser;

// loads all the image assets
void loadImages() {
  Platform = loadImage("Platform.png");
  PeaShooter[0] = loadImage("PeaShooterLevel1.png");
  PeaShooter[1] = loadImage("PeaShooterLevel2.png");
  PeaShooter[2] = loadImage("PeaShooterLevel3.png");
  GlueShooter[0] = loadImage("GlueShooterLevel1.png");
  GlueShooter[1] = loadImage("GlueShooterLevel2.png");
  GlueShooter[2] = loadImage("GlueShooterLevel3.png");
  LaserShooter[0] = loadImage("LaserShooterLevel1.png");
  LaserShooter[1] = loadImage("LaserShooterLevel2.png");
  LaserShooter[2] = loadImage("LaserShooterLevel3.png");
  pellet = loadImage("pellet.png");
  glue = loadImage("glue.png");
  laser = loadImage("laser.png");
  gSlime = loadImage("monster1.png");
  pSlime = loadImage("monster2.png");
  rSlime = loadImage("monster3.png");
  gHeavy = loadImage("heavy1.png");
  bHeavy = loadImage("heavy2.png");
  rHeavy = loadImage("heavy3.png");
}

class Turret {
  int level = 0;
  float x;
  float y;
  float targetX;
  float targetY;
  float targetAngle;
  float dir;
  float angle;
  PImage[] tower;
  PImage bullet;
  Timer bulletDelay;
  ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  
  Turret(float x, float y, PImage[] tower) {
    this.x = x;
    this.y = y;
    this.targetX = this.x;
    this.targetY = this.y-QUARTER_PI/2;
    this.tower = tower;
    this.bulletDelay = new Timer(100);
  }
  
  void draw() {
    this.angle = atan2(targetY - this.y, targetX - this.x);
    this.dir = (this.angle - this.targetAngle) / TWO_PI;
    this.dir -= round(dir);
    this.dir *= TWO_PI;
    this.targetAngle += this.dir * kEase;
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.targetAngle);
    image(this.tower[this.level], 0, 0, kTSize-10, kTSize-10);
    popMatrix();
    resetMatrix();
    for (int i = 0; i < this.projectiles.size(); i++) {
      Projectile p = this.projectiles.get(i);
      p.draw();
    }
  }
}

class Projectile {
  int type;
  int damage;
  float x;
  float y;
  float xo, yo;
  float vx;
  float vy;
  PImage bullet;
  
  Projectile(int type, int damage, float x, float y, PImage bullet) {
    this.type = type;
    this.damage = damage;
    this.x = x;
    this.y = y;
    this.xo = x; this.yo = y;
    this.bullet = bullet;
  }
  
  void draw() {
    this.x += this.vx;
    this.y += this.vy;
    switch (this.type) {
      case 1:
        image(this.bullet, this.x, this.y, kBulletSize, kBulletSize);
//        strokeWeight(5);
        break;
      case 2:
        stroke(255, 0, 0);
        line(xo, yo, x, y);
        break;
    }
  }
}
