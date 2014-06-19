final int tutButtonPadding = 100;
final int nTutImages = 4;
final int next = 0;
final int previous = 1;

class Instructions implements View {
  Map background;
  InGameButton back;
  TutorialSkip[] tutSkip = new TutorialSkip[2];
  int currentImage = 0;
  PImage[] tutorial = new PImage[nTutImages];
  PImage title;
  
  Instructions() {
    this.background = new Map(width/2, height/2, loadImage("MenuBG.jpg"));
    this.back = new InGameButton(width/2, height-100, 100, 40, 20, "Back");
    this.loadAssets();
  }
  
  void draw() {
    this.background.draw();
    this.drawAssets();
    this.displayText();
  }
  
  View mouseReleased() {
    this.checkSkipped();
    boolean bound = checkBounds(this.back.x, this.back.y, this.back.xSize/2, this.back.ySize/2);
    if (bound) return new Menu();
    return null;
  }
  
  void drawAssets() {
    this.back.draw();
    this.back.rollover();
    for(int i = 0; i < this.tutorial.length; i++) {
      image(this.tutorial[this.currentImage], width/2, height/2, 1873*0.4, 1126*0.4);
    }
    for (int i = 0; i < this.tutSkip.length; i++) {
      this.tutSkip[i].draw();
    }
  }
  
  void displayText() {
    image(this.title, width/2, 80, 1430*0.35, 239*0.35);
  }
  
  void checkSkipped() {
    for (int i = 0; i < this.tutSkip.length; i++) {
      boolean bound = checkBounds(this.tutSkip[i].x, this.tutSkip[i].y, 40, 40);
      if (bound) {
        switch (i) {
          case next:
            if (this.currentImage < nTutImages-1) this.currentImage++; break;
          case previous:
            if (this.currentImage > 0) this.currentImage--; break;
        }
      }
    }
  }
  
  void loadAssets() {
    this.loadImages();
    this.tutSkip[next] = new TutorialSkip(width/2+tutButtonPadding, height-100, "next");
    this.tutSkip[previous] = new TutorialSkip(width/2-tutButtonPadding, height-100, "previous");
  }
  
  void loadImages() {
    this.tutorial[0] = loadImage("tut1.png");
    this.tutorial[1] = loadImage("tut2.png");
    this.tutorial[2] = loadImage("tut3.png");
    this.tutorial[3] = loadImage("tut4.png");
    this.title = loadImage("tutorial.png");
  }
}

class TutorialSkip {
  float x;
  float y;
  color colour;
  String operation;
  
  TutorialSkip(float x, float y, String operation) {
    this.x = x;
    this.y = y;
    this.colour = color(255, 255, 0);
    this.operation = operation;
  }
  
  void draw() {
    setColour(this.colour, color(255, 100));
    if (operation.equals("next")) triangle(this.x-20, this.y-20, this.x-20, this.y+20, this.x+20, this.y);
    else triangle(this.x-20, this.y, this.x+20, this.y-20, this.x+20, this.y+20);
    this.rollover();
  }
  
  void rollover() {
    
  }
}
