final int GOW = 0;
final int gotham = 1;
final int kBodyFontSize = 12;

PFont[] gFont = new PFont[2];

// sets a font attributes, this shortens up a lot of lines
void setFont(PFont font, int hAlign, int vAlign, int size, color fill) {
  textFont(font);
  textAlign(hAlign, vAlign);
  textSize(size);
  fill(fill);
}

void setColour(color fill, color stroke) {
  fill(fill);
  stroke(stroke);
}

void setRect(int align, color fill, color stroke) {
  rectMode(align);
  fill(fill);
  stroke(stroke);
}

void setRect(int align, color fill, char nostroke) {
  rectMode(align);
  fill(fill);
  noStroke();
}

class Timer {
  int start;
  float wait;
  
  Timer() { this(-1); }
  Timer(float wait) {
    this.wait = wait;
    this.reset();
  }
  
  void displayCountdown(String description) {
    setFont(gFont[gotham], CENTER, CENTER, 20, color(255));
    text(description + (int)map(this.elapsed()/1000, 0, 10, 10, 0), width/2, kTSize/2);
  }
  
  void printTime() {
    println(this.elapsed());
  }
  
  void reset() {
    this.start = millis();
  }
  
  int elapsed() {
    return millis() - this.start;
  }
  
  boolean isDone() {
    if (this.wait == -1) {
      return false;
    }
    return this.elapsed() >= this.wait;
  }
}

// probably one of the best functions ever wrote
// checks mouse click bounds for rectangular objects
boolean checkBounds(float xBound, float yBound, float x, float y) {
  return (mouseX > xBound-x && mouseX < xBound+x && mouseY > yBound-y && mouseY < yBound+y);
}

// same as previous function, except for a perfect square
boolean checkBounds(float xBound, float yBound, float s) {
  return (mouseX > xBound-s && mouseX < xBound+s && mouseY > yBound-s && mouseY < yBound+s);
}

// returns a boolean depending on the bound of 2 objects values
boolean itemBound(float x, float y, float xBound, float yBound, float size) {
  return (x > xBound-size && x < xBound+size && y > yBound-size && y < yBound+size);
}
