final int kMWidth = 200;
final int kMHeight = 80;
final int kMBFontSize = 25;
final int kMBPadding = 3;
final int kIGWidth = 100;
final int kIGHeight = 40;
final color kStroke = color(0);  
final color kRollover = color(255, 255, 0);
final color kClicked = color(200, 200, 0);

class Button {
  float x;
  float y;
  color colour = color(255, 200);
  String choice;
}

class MenuButton extends Button {
  MenuButton(float x, float y, String choice) {
    this.x = x;
    this.y = y;
    this.choice = choice;
  }
  
  void draw() {
    setRect(CENTER, this.colour, kStroke);
    rect(this.x, this.y, kMWidth, kMHeight, 6);
    setFont(gFont[gotham], CENTER, CENTER, kMBFontSize, kStroke);
    text(this.choice, this.x, this.y-kMBFontSize*0.1);
  }
  
  void rollover() {
    boolean bound = checkBounds(this.x, this.y, kMWidth/2, kMHeight/2);
    if (mousePressed && bound) this.colour = color(255, 150);
    else if (bound) this.colour = color(255, 170);
    else this.colour = color(255, 200);
  }
}

// button class for in game buttons
class InGameButton extends Button {
  float xSize;
  float ySize;
  int textSize;
  
  InGameButton(float x, float y, float xSize, float ySize, int textSize, String choice) {
    this.x = x;
    this.y = y;
    this.xSize = xSize;
    this.ySize = ySize;
    this.colour = color(255);
    this.textSize = textSize;
    this.choice = choice;
  }
  
  void draw() {
    setRect(CENTER, this.colour, kStroke);
    rect(this.x, this.y, this.xSize, this.ySize, 6);
    setFont(gFont[gotham], CENTER, CENTER, this.textSize, kStroke);
    text(this.choice, this.x, this.y-textSize*0.1);
  }
  
  void rollover() {
    boolean bound = checkBounds(this.x, this.y, this.xSize/2, this.ySize/2);
    if (mousePressed && bound) this.colour = kClicked;
    else if (bound) this.colour = kRollover;
    else this.colour = 255;
  }
}
