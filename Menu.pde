final String copyright = "Copyright Hsu & Goudie™ 2014. All Rights Reserved.";
final int kMBOffSet = 120;
final int kBodyPadding = 10;

// since enum does not work, use constants instead
final int play = 0;
final int settings = 1;
final int instructions = 2;
final int exit = 3;

class Menu implements View {
  MenuButton[] buttons = new MenuButton[4];
  Map background;
  PImage title, td;
  
  Menu() {
    hatred.rewind();
    hatred.pause();
    overture.play();
    this.loadButtons();
    this.background = new Map(width/2, height/2, loadImage("MenuBG.jpg"));
    this.title = loadImage("title.png");
    this.td = loadImage("TowerDefence.png");
  }
  
  void draw() {
    background(255);
    this.background.draw();
    this.displayAssets();
    this.displayText();
  }
  
  View mouseReleased() {
    for (int i = 0; i < this.buttons.length; i++) {
      boolean bound = checkBounds(this.buttons[i].x, this.buttons[i].y, kMWidth/2, kMHeight/2);
      if (bound) {
        switch(i) {
          case play: return new Game();
          case settings: return new Settings();
          case instructions: return new Instructions();
          case exit: exit();
        }
      }
    }
    return null;
  }
  
  void displayAssets() {
    for (int i = 0; i < this.buttons.length; i++) {
      this.buttons[i].draw();
      this.buttons[i].rollover();
    }
  }
  
  void displayText() {
    image(title, width/2-140, height/4, 1661*0.475, 350*0.475);
    image(td, width/2+80, height/2-70, 2007*0.45, 202*0.45);
    setFont(gFont[gotham], CENTER, CENTER, kBodyFontSize, color(255));
    text(copyright, width/2, height-kBodyPadding);
  }
  
  void loadButtons() {
    this.buttons[play] = new MenuButton(width/2-kMBOffSet, height/2+kMBOffSet/2, "Play");
    this.buttons[settings] = new MenuButton(width/2+kMBOffSet, height/2+kMBOffSet/2, "Settings");
    this.buttons[instructions] = new MenuButton(width/2-kMBOffSet, height/2+kMBOffSet*1.5, "Instructions");
    this.buttons[exit] = new MenuButton(width/2+kMBOffSet, height/2+kMBOffSet*1.5, "Exit");
  }
}
