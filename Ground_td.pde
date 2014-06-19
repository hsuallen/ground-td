/*
 * Ground Tower Defense
 *
 * By Allen Hsu & Dylan Goudie
 * Copyright Hsu & Goudie™ 2014. All Rights Reserved
 */

View currentView;

interface View {
  void draw();
  View mouseReleased();
}

void setup() {
  size(1200, 720);
  smooth();
  frameRate(60);
  loadAssets();
  currentView = new Menu();
}

void draw() {
  currentView.draw();
}

void mouseReleased() {
  View v = currentView.mouseReleased();
  if (v != null) currentView = v;
}

void loadAssets() {
  imageMode(CENTER);
  gFont[GOW] = createFont("GodofWar.ttf", kBodyFontSize);
  gFont[gotham] = createFont("Gotham.ttf", kBodyFontSize);
  loadImages();
  loadSFX();
}
