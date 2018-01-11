//.rotate([-25, -12])
boolean inDome = false;
PImage background;
float scaleFactor;
PFont testFont;
Table worstData;
Table unusualData;

void setup() {
  //size(1920, 1920, P3D);
  size(800, 800, P3D);
  pixelDensity(displayDensity());
  scaleFactor = width / 1920f;
  println(scaleFactor);
  background = loadImage("background_map.png");
  testFont = loadFont("Roboto-Light-48.vlw");
  worstData = loadTable("180111_toProcess_worst.tsv","header");
  unusualData = loadTable("180111_toProcess_unusual.tsv","header");
  
}

void draw() {
  background(0);
  image(background, 0,0, width, height);
  textFont(testFont);
  text("Hello", 0, 48);
} 