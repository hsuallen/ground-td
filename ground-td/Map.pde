class Map {
  float x;
  float y;
  PImage map;
  
  Map(float x, float y, PImage map) {
    this.x = x;
    this.y = y;
    this.map = map;
  }
  
  void draw() {
    imageMode(CENTER);
    image(this.map, this.x, this.y, width, height);
  }
}
