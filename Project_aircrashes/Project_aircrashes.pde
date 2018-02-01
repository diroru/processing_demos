import java.util.*;

//.rotate([-25, -12])
boolean inDome = false;
PImage background;
float scaleFactor;
PFont corpusFont;
PFont corpusFontBold;
Table worstData;
Table unusualData;

Timeline timeline;
float TIME = 0;
float TIME_INC = 0.001; //used to be 0.00007
float FLIGHT_TIME = 0;
float FLIGHT_TIME_INC = 0.003;
float SEEK_TIME = 1;
float SEEK_INC = 0.005f;
float SEEK_EPSILON = 0.001;
float SEEK_DURATION = 100f;
float GLOW_DURATION = 0.01;
int YEAR_START = 1930;
int YEAR_END = 2015;
int REPEAT_COUNT = 2;
float SCALE = 0.76; //0.8125; //map scaling

float PHI1 = radians(12);
float LAMBDA0 = radians(25);
float ORIENTATION = PI * 0.4; 

ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<CrashDot> myDots = new ArrayList<CrashDot>();

final int STATE_PLAY = 0;
final int STATE_PAUSED = 1;
final int STATE_SEEKING = 2;
final int STATE_DISPLAY_FLIGHT = 3;
int currentState = STATE_PAUSED;

ArrayList<CrashFlight> myFlights = new ArrayList<CrashFlight>();

color GREEN = #1ce58e;
color RED = #e81a9a;

int MIN_FATALITIES = Integer.MAX_VALUE;
int MAX_FATALITIES = Integer.MIN_VALUE;
int MIN_OCCUPANTS = Integer.MAX_VALUE;
int MAX_OCCUPANTS = Integer.MIN_VALUE;

HashSet<String> phaseCodes = new HashSet<String>();
HashMap<String, Float> phaseProgress = new HashMap<String, Float>();
HashMap<Datum, CrashFlight> flightsByDatum = new HashMap<Datum, CrashFlight>();
CrashFlight currentFlight;

void setup() {
  //size(1920, 1920, P3D);
  size(960, 960, P2D);
  pixelDensity(displayDensity());
  scaleFactor = width / 1920f;
  println(scaleFactor);
  background = loadImage("background_map.png");
  corpusFont = loadFont("SourceSansPro-Regular-44.vlw");
  corpusFontBold = loadFont("SourceSansPro-Bold-48.vlw");

  //textSize(24);
  timeline = new Timeline((1920 - 390)/2 * scaleFactor, 35 * scaleFactor, HALF_PI, 110 * scaleFactor, YEAR_START, YEAR_END, REPEAT_COUNT, loadFont("SourceSansPro-SemiBold-40.vlw"), 40* scaleFactor, this);

  initData(timeline);
  initFlights(timeline);
  currentFlight = myFlights.get(0);
  initDots();
  hint(DISABLE_DEPTH_TEST);
}

void draw() {

  background(0);
 // pushMatrix();
  translate(width*0.5, height*0.5);
  rotate(ORIENTATION);
  translate(-width*0.5, -height*0.5);
  image(background, width*(1 - SCALE)*0.5, height*(1 - SCALE)*0.5, width*SCALE, height*SCALE);


  textFont(corpusFont);
  String s = "100 worst and unusual Aircrashes   1933 – 2014";

  fill(255);

  textFont(corpusFontBold);
  textSize(30*scaleFactor);
  for (int i = 0; i < REPEAT_COUNT; i++) {
    pushMatrix();
    translate(width * 0.5, height * 0.5);
    rotate((i * TWO_PI) / REPEAT_COUNT);
    translate(-width * 0.5, -height * 0.5);
    drawArcTextCentered(s, width-1770*scaleFactor, height-1200*scaleFactor);
    popMatrix();
  }

  String s2= "  Fatalities             Total number of passanger4";
  fill(255);
  textFont(corpusFont);
  textSize(30*scaleFactor);
  for (int i = 0; i < REPEAT_COUNT; i++) {
    pushMatrix();
    translate(width * 0.5, height * 0.5);
    rotate((i * TWO_PI) / REPEAT_COUNT);
    translate(-width * 0.5, -height * 0.5);
    drawArcTextCentered(s2, width-1810*scaleFactor, height-1228*scaleFactor);
    popMatrix();
  }



  fill(28, 229, 142);
  for (int i = 0; i < REPEAT_COUNT; i++) {
    pushMatrix();
    translate(width * 0.5, height * 0.5);
    rotate((i * TWO_PI) / REPEAT_COUNT);
    translate(-width * 0.5, -height * 0.5);
    ellipse (width-1763*scaleFactor, height-1331*scaleFactor, 15*scaleFactor, 15*scaleFactor);
    popMatrix();
  }

  fill(232, 26, 154);
  for (int i = 0; i < REPEAT_COUNT; i++) {
    pushMatrix();
    translate(width * 0.5, height * 0.5);
    rotate((i * TWO_PI) / REPEAT_COUNT);
    translate(-width * 0.5, -height * 0.5);
    ellipse (width-1654*scaleFactor, height-1507*scaleFactor, 15*scaleFactor, 15*scaleFactor);
    popMatrix();
  }     




  //s.rotate(phi);

  /*
  String d = "Hello World!!!&#*";
   fill(232,26,154);
   drawArcTextCentered(d, mouseX, mouseY);
   println((mouseX-width)/scaleFactor, (mouseY-height)/scaleFactor);
   */
  // fill(28,229,142,300);
  // drawArcTextCentered(d, mouseX, mouseY);

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
    if (aboutFlightTime(TIME, currentFlight)) {
      currentFlight.display(FLIGHT_TIME);
      FLIGHT_TIME += FLIGHT_TIME_INC;
      if (FLIGHT_TIME > 1) {
        FLIGHT_TIME = 0;
        currentFlight = currentFlight.nextFlight;
        if (currentFlight == null) {
          currentFlight = myFlights.get(0);
        }
      }
    } else {

      TIME += TIME_INC;
      if (TIME > 1) {
        TIME = 0;
        FLIGHT_TIME = 0;
        currentState = STATE_PAUSED;
        currentFlight = myFlights.get(0);
      }
    }
    /*
    if (currentFlight == null) {
     currentFlight = getFlight(TIME);
     } 
     if (currentFlight != null) {
     currentState = STATE_DISPLAY_FLIGHT;
     }
     */
    break;
  case STATE_SEEKING:
    TIME += SEEK_INC;
    if (abs(SEEK_TIME - TIME) < SEEK_EPSILON) {
      currentState = STATE_PAUSED;
    }
    break;
    /*
  case STATE_DISPLAY_FLIGHT:
     FLIGHT_TIME += FLIGHT_TIME_INC;
     if (FLIGHT_TIME > 1) {
     FLIGHT_TIME = 0;
     currentState = STATE_PLAY;
     } else {
     currentFlight.display(FLIGHT_TIME);
     }
     break;
     */
  }
  //println(TIME, FLIGHT_TIME);
  /*
  for (CrashFlight cf : myFlights) {
   cf.display(TIME);
   }
   */
  /*
  ellipseMode(RADIUS);
   fill(255, 0, 0, 127);
   ellipse(width*0.5, height*0.5, 10, 10);
   */
  /*
  stroke(255, 0, 0);
   noFill();
   drawGeodetic(-QUARTER_PI, 0.1, QUARTER_PI, 2.1, 50);
   noStroke();
   fill(0, 0, 255);
   drawPoint(-QUARTER_PI, 0.1);
   drawPoint(QUARTER_PI, 2.1);
   */
  /*
  ellipseMode(RADIUS);
   fill(255,255,0,31);
   ellipse(width*0.5,height*0.5,width*0.5,height*0.5);
   */
}

void keyPressed() {
}