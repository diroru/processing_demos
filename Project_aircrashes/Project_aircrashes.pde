//.rotate([-25, -12])
boolean inDome = false;
PImage background;
float scaleFactor;

void setup() {
  //size(1920, 1920, P3D);
  size(800, 800, P3D);
  scaleFactor = width / 1920f;
  println(scaleFactor);
  background = loadImage("background_map.png");
}

void draw() {
  background(0);
  image(background, 0,0, width, height);
} 