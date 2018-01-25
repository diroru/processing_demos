import java.util.*;

//.rotate([-25, -12])
boolean inDome = false;
PImage background;
float scaleFactor;
PFont corpusFont;
Table worstData;
Table unusualData;

Timeline timeline;
float TIME = 0;
float TIME_INC = 0.0005;
float SEEK_TIME = 1;
float SEEK_INC = 0.005f;
float SEEK_EPSILON = 0.001;
float SEEK_DURATION = 100f;
float GLOW_DURATION = 0.01;
int YEAR_START = 1930;
int YEAR_END = 2015;
int REPEAT_COUNT = 2;
float SCALE = 0.8125;

float PHI1 = radians(12);
float LAMBDA0 = radians(25);

ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<CrashDot> myDots = new ArrayList<CrashDot>();

final int STATE_PLAY = 0;
final int STATE_PAUSED = 1;
final int STATE_SEEKING = 2;
int currentState = STATE_PAUSED;

void setup() {
  //size(1920, 1920, P3D);
  size(960, 960, P2D);
  pixelDensity(displayDensity());
  scaleFactor = width / 1920f;
  println(scaleFactor);
  background = loadImage("background_map.png");
  corpusFont = loadFont("SourceSansPro-Regular-44.vlw");

  initData();

  //textSize(24);
  timeline = new Timeline((1920 - 390)/2 * scaleFactor, 35 * scaleFactor, HALF_PI, 110 * scaleFactor, YEAR_START, YEAR_END, REPEAT_COUNT, loadFont("SourceSansPro-SemiBold-40.vlw"), 40* scaleFactor, this);

  initDots();
  hint(DISABLE_DEPTH_TEST);
}

void draw() {

  background(0);
  image(background, width*(1 - SCALE)*0.5,height*(1 - SCALE)*0.5, width*SCALE, height*SCALE);


  textFont(corpusFont);

  /*
  String s = "Hello World!!!&#*";
   fill(232,26,154,300);
   drawTangentialText(s, mouseX, mouseY);
   fill(28,229,142,300);
   drawArcTextCentered(s, mouseX, mouseY);
   */
  //text("Hello", 0, 48);
  timeline.display(TIME);

  /*
  for (Datum d : data) {
   timeline.drawDate(d, 5 * scaleFactor, 40 * scaleFactor);
   }
   */
  for (CrashDot cd : myDots) {
    cd.display();
  }

  switch(currentState) {
  case STATE_PLAY:
    TIME += TIME_INC;
    if (TIME > 1) {
      TIME = 0;
      currentState = STATE_PAUSED;
    }
    break;
  case STATE_SEEKING:
    TIME += SEEK_INC;
    if (abs(SEEK_TIME - TIME) < SEEK_EPSILON) {
      currentState = STATE_PAUSED;
    }
    break;
  }
  stroke(255, 0, 0);
  noFill();
  drawGeodetic(-QUARTER_PI, 0.1, QUARTER_PI, 2.1, 50);
  noStroke();
  fill(0, 0, 255);
  drawPoint(-QUARTER_PI, 0.1);
  drawPoint(QUARTER_PI, 2.1);
  /*
  ellipseMode(RADIUS);
   fill(255,255,0,31);
   ellipse(width*0.5,height*0.5,width*0.5,height*0.5);
   */
}

void keyPressed() {
}