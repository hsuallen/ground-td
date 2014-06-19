final int alienSFX = 0;
final int robotSFX = 1;
final int gunSFX = 2;
final int glueSFX = 3;
final int laserSFX = 4;

import ddf.minim.*;

Minim minim;
AudioPlayer overture, hatred;
AudioPlayer[] SFX = new AudioPlayer[5];

void loadSFX() {
  minim = new Minim(this);
  overture = minim.loadFile("Overture.mp3");
  overture.loop();
  overture.setGain(10);
  hatred = minim.loadFile("Hatred.mp3");
  
//  SFX[alienSFX] = minim.loadFile("Alien.wav");
  SFX[robotSFX] = minim.loadFile("Robot.wav");
  SFX[gunSFX] = minim.loadFile("Gun.wav");
  SFX[glueSFX] = minim.loadFile("Glue.wav");
  SFX[laserSFX] = minim.loadFile("Laser.wav");
}
