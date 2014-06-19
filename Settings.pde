final int kCSize = 40;      // constant checkmark box size
final int kCPadding = 40;   // padding for checkmark boxes
final int kCOffSet = 5;     // offset for the checkmark in the boxes
final int muteMusic = 0;
final int muteSFX = 1;

class Settings implements View {
  Map background;
  Checkmark[] options = new Checkmark[2];
  InGameButton back;
  
  Settings() {
    this.background = new Map(width/2, height/2, loadImage("MenuBG.jpg"));
    this.options[muteMusic] = new Checkmark(width/2-200, height/2-50, "Mute Music");
    this.options[muteSFX] = new Checkmark(width/2-200, height/2+50, "Mute SFX");
    this.back = new InGameButton(width/2, height-100, 100, 40, 20, "Back");
  }
  
  void draw() {
    this.background.draw();
    this.displayAssets();
    this.displayText();
    this.checkOptions();
  }
  
  View mouseReleased() {
    this.checkOptionsClicked();
    boolean menu = this.back();
    if (menu) return new Menu();
    return null;
  }
  
  void displayAssets() {
    setRect(CENTER, color(255, 150), color(255));
    rect(width/2, height/2, width-200, height-300);
    for (int i = 0; i < this.options.length; i++) {
      this.options[i].draw();
    }
    this.back.draw();
    this.back.rollover();
  }
  
  void displayText() {
    setFont(gFont[GOW], CENTER, CENTER, 80, color(50, 0, 255));
    text("Settings", width/2, 70);
  }
  
  void checkOptions() {
    for (int i = 0; i < this.options.length; i++) {
      if (this.options[i].active) {
        switch(i) {
          case muteMusic: overture.setGain(-100); hatred.setGain(-100); break;
          case muteSFX: setVolume(SFX, -100); break;
        }
      } else {
        switch(i) {
          case muteMusic: overture.setGain(10); hatred.setGain(10); break;
          case muteSFX: setVolume(SFX, 0); break;
        }
      }
    }
  }
  
  void setVolume(AudioPlayer[] sfx, int gain) {
    for (int i = 1; i < sfx.length; i++) {
      sfx[i].setGain(gain);
    }
  }
  
  boolean back() {
    boolean bound = checkBounds(this.back.x, this.back.y, this.back.xSize/2, this.back.ySize/2);
    if (bound) return true;
    return false;
  }
  
  void checkOptionsClicked() {
    for (int i = 0; i < this.options.length; i++) {
      boolean bound = checkBounds(this.options[i].x, this.options[i].y, this.options[i].size/2);
      if (bound) {
        this.options[i].active = this.options[i].active? false : true;
      }
    }
  }
}

class Checkmark {
  float x;
  float y;
  float size = kCSize;
  boolean active = false;
  String description;
  PImage checkmark;
  
  Checkmark(float x, float y, String description) {
    this.x = x;
    this.y = y;
    this.description = description;
    this.checkmark = loadImage("checkmark.png");
  }
  
  void draw() {
    setRect(CENTER, color(180), color(255));
    rect(this.x, this.y, this.size, this.size);
    setFont(gFont[gotham], LEFT, CENTER, 30, color(0));
    text(this.description, this.x+kCPadding, this.y);
    if (this.active) {
      image(this.checkmark, this.x+kCOffSet, this.y-kCOffSet, 234*0.2, 242*0.2);
    }
  }
}

class Slider {
}
