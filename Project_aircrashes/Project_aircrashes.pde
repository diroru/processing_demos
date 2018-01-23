import java.util.*;

//.rotate([-25, -12])
boolean inDome = false;
PImage background;
float scaleFactor;
PFont testFont;
Table worstData;
Table unusualData;

Timeline timeline;
ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<CrashDot> myDots = new ArrayList<CrashDot>();

void setup() {
  //size(1920, 1920, P3D);
  size(600, 600, P2D);
  pixelDensity(displayDensity());
  scaleFactor = width / 1920f;
  println(scaleFactor);
  background = loadImage("background_map.png");
  testFont = loadFont("SourceSansPro-Regular-44.vlw");

  initData();
  
  //textSize(24);
  timeline = new Timeline((1920 - 150)/2 * scaleFactor, 40 * scaleFactor, HALF_PI, 130* scaleFactor, 1930, 2015, 2, loadFont("SourceSansPro-SemiBold-40.vlw"), 40* scaleFactor);
  
  initDots();
  hint(DISABLE_DEPTH_TEST);
}

void draw() {
  background(0);
  image(background, 0,0, width, height);
  textFont(testFont);
  
  String s = "Hello World!!!&#*";
  fill(232,26,154,300);
  drawTangentialText(s, mouseX, mouseY);
  fill(28,229,142,300);
  drawArcTextCentered(s, mouseX, mouseY);
  
  //text("Hello", 0, 48);
  timeline.display();
  /*
  for (Datum d : data) {
    timeline.drawDate(d, 5 * scaleFactor, 40 * scaleFactor);
  }
  */
  for (CrashDot cd : myDots) {
    cd.display();
  }
} 