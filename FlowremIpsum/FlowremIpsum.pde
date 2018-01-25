import java.util.*; //<>//
//import java.awt.event.*;
//import javax.swing.event.*;
//import java.awt.event.*;
//import codeanticode.planetarium.*;
import controlP5.*;
import java.lang.reflect.*;

Table countryData, flowData, populationData;

//GENERAL CONSTANTS
final int GPI_YEAR_START = 2008;
final int GPI_YEAR_END = 2016;
final int MIGRATION_YEAR_START = 1980;
final int MIGRATION_YEAR_END = 2013;
final int YEAR_START = 2008;
final int YEAR_END = 2016;
final float GPI_MIN = 1.1;
final float GPI_MAX = 3.8;
final int SET_START_POS = 0;
final int SET_END_POS = 1;

//SORTING TYPE CONSTANTS
final int SORT_BY_NAME = 0;
final int SORT_BY_CONTINENT_THEN_NAME = 1;
final int SORT_BY_GPI = 2; //needs active year!
final int SORT_BY_CONTINENT_THEN_GPI = 3; //needs active year!
final int SORT_BY_POPULATION = 4;
final int SORT_BY_CONTINENT_THEN_POPULATION = 5;
int currentSortingMethod = SORT_BY_GPI;

//float TIME = 0;
//float TIME_INC = 0.05;
int DEFAULT_DURATION = 500; //in millis;
long lastTime;

//Layout globals
//float margin = 10;
float gap = 2;
Long POPULATION_MIN = Long.MAX_VALUE;
Long POPULATION_MAX = Long.MIN_VALUE;
Long POPULATION_CUTOFF = 100000L;
Long MIGRATION_FLOW_MAX = Long.MIN_VALUE;
Long MIGRATION_FLOW_MIN = Long.MAX_VALUE;
Long MIGRATION_FLOW_LOWER_LIMIT = 100L;

ArrayList<Country> countries = new ArrayList<Country>();
//Map of countries, labelled by names
HashMap<String, Country> countriesByName = new HashMap<String, Country>();

HashMap<Integer, ArrayList<MigrationFlow>> migrationFlows = new HashMap<Integer, ArrayList<MigrationFlow>>(); 

//lookup table for mismatched country names
HashMap<String, String> countryLookupTable = new HashMap<String, String>(); 
ArrayList<String> missingCountries = new ArrayList<String>();

int currentYear = 2013;

HashSet<Country> hoverCountries = new HashSet<Country>();
ArrayList<YearSelector> yearSelectors = new ArrayList<YearSelector>();

int MARGIN = 20;
LayoutInfo panelLayout, graphLayout, flowLayout, yearsLayout; 

//DomeCamera dc;
ControlP5 cp5;

//int gridMode = Dome.NORMAL;
//ProjectionMesh mesh;

final int FULLDOME_MODE = 0;
final int CANVAS_MODE = 1;
int CURRENT_MODE = FULLDOME_MODE;

float APERTURE = 1f;
float CONE_RADIUS_BOTTOM = 186;
float CONE_RADIUS_TOP = 66;
float CONE_HEIGHT = 238;
float CONE_BOTTOM = 0;
float CONE_ORIENTATION = 0;
PShader domeShader;
PShape domeQuad;

PGraphics canvas;

float xAngle = 0f;
float yAngle = 0f;
float zAngle = 0f;
float deltaX = 0f;
float deltaY = 0f;
float deltaZ = 0f;
int currentImage = 0;

PVector mappedMouse = new PVector();
ArrayList<RadioButtonGroup> radio = new ArrayList<RadioButtonGroup>();

boolean domeDisplay = true;
int DOME_SIZE = 960;
int PREVIEW_WIDTH = 1920;
int PREVIEW_HEIGHT = 960;
int CANVAS_WIDTH = 2048;
int CANVAS_HEIGHT = 1024;

void settings() {
  size(DOME_SIZE, DOME_SIZE, P3D); //for working on the laptop (single screen)
  //pixelDensity(displayDensity()); //uncomment for retina rendering
  //fullScreen( P3D, SPAN); //for presenting in the dome (double screen)
}

void setup() {
  //size(1024, 1024, Dome.RENDERER);
  //initial default camera, i.e. interface to interact with the renderer.
  //colorMode(HSB, 1, 1, 1, 1);
  canvas = createGraphics(2048, 1024, P2D);
  canvas.beginDraw();
  canvas.background(0);
  //canvas.colorMode(HSB, 1, 1, 1);
  canvas.endDraw();
  
  initShape();
  initCanvas();
  initShader();
  initFonts();

  //mesh.toggleShape();
  //mesh.toggleGrid();
  float panelWidth = 200;
  float yearBarHeight = 30f;
  float graphHeight = (canvas.height - MARGIN * 3 - yearBarHeight) * 0.5;
  float graphWidth = canvas.width - MARGIN * 3 - panelWidth;
  panelLayout = new LayoutInfo(MARGIN, MARGIN, panelWidth, canvas.height - 2*MARGIN);
  graphLayout = new LayoutInfo(panelWidth + 2 * MARGIN, height - (MARGIN + graphHeight), graphWidth, graphHeight);
  flowLayout = new LayoutInfo(panelWidth + 2 * MARGIN, MARGIN, graphWidth, graphHeight);
  graphLayout.gap = gap;

  //pixelDensity(2);
  canvas.ellipseMode(CORNER);
  //canvas.textSize(20);
  loadData(false);
  initRadio();
  //Example of animating between two layouts
  //first sort by one criterium, then set start layout
  makeLayout(graphLayout, countries, currentSortingMethod, 0, currentYear);

  //sort by other criterium, then set end layout
  println("Population MIN", POPULATION_MIN);
  println("Population MAX", POPULATION_MAX);
  //println(countries);

  int repeat = 3;
  int count = YEAR_END - YEAR_START + 1;
  for (int i = 0; i <= repeat * count; i++) {
    int year = i % count + YEAR_START;
    float dw = (canvas.width - panelWidth - 2*MARGIN) / (repeat * float(count));
    float y = canvas.height - MARGIN;
    float w = 50;
    float h  = 20;
    LayoutInfo yearLayout = new LayoutInfo(panelWidth + 2*MARGIN + dw * i, y, w, h);
    yearSelectors.add(new YearSelector(year, yearLayout, this));
  }
  lastTime = millis();
}

void draw() {
  
  mappedMouse = mappedMouse(CURRENT_MODE);
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
  canvas.beginDraw();
  //draw countries
  canvas.background(0);

  canvas.fill(WHITE);
  canvas.noStroke();
  
  long delta = millis() - lastTime;
  for (Country theCountry : countries) {
    //println(theCountry.name);
    theCountry.update(delta);
    theCountry.display(canvas);
  }
  lastTime = millis();

  displayFlows(canvas);
  for (YearSelector ys : yearSelectors) {
    ys.display(canvas);
  }

  //DRAW POPULATION GUIDES
  canvas.stroke(DARK_GREY);
  canvas.strokeWeight(2);
  for (int i = 0; i < 10; i++) {
    float y = graphLayout.y + constrainedLogScale(pow(10, i), graphLayout.h);
    canvas.line(0, y, canvas.width, y);
  }

  for (RadioButtonGroup rbg : radio) {
    rbg.display(canvas);
  }
  
  canvas.fill(255, 255, 0, 127);
  canvas.ellipseMode(RADIUS);
  canvas.noStroke();
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 10, 10);
  canvas.ellipse(mappedMouse.x + canvas.width, mappedMouse.y, 10, 10);

  canvas.endDraw();
  switch(CURRENT_MODE) {
  case FULLDOME_MODE:
    background(0);
    pushMatrix();
    translate(width*0.5, height*0.5);
    shader(domeShader);
    shape(domeQuad);
    resetShader();
    popMatrix();
    break;
  case CANVAS_MODE:
    background(255, 255, 0);
    fitImage(canvas);
    break;
  }
}

void displayFlows(PGraphics pg) {
  pg.noFill();
  String hoverCountry = null;

  if (hoverCountries.size() > 0) {
    Country hc = (Country)(hoverCountries.iterator().next());
    hoverCountry = hc.name;
  }

  ArrayList<MigrationFlow> yearlyMigrationFlows = migrationFlows.get(currentYear); 
  for (MigrationFlow mf : yearlyMigrationFlows) {
    if (hoverCountry == null) {
      pg.stroke(WHITE, 25);
      pg.strokeWeight(2);
      if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
        //mf.display(pg, height/2, MARGIN);
        mf.displayRounded(pg, flowLayout.h, flowLayout.y);
      }
    } else {
      if (mf.origin.name.equals(hoverCountry)) {
        pg.stroke(WHITE, 50);
      } else if (mf.destination.name.equals(hoverCountry)) {
        pg.stroke(PRIMARY);
      } else {
        //stroke(255, 1);
        pg.noStroke();
      }
      if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
        //mf.display(pg, height/2, MARGIN);
        mf.displayRounded(pg, flowLayout.h, flowLayout.y);
      }
    }
  }
}

void keyPressed() {
  switch(key) {
  case ' ':
    canvas.save("output/test.png");
    break;
  case 's':
    saveFrame("output/test.png");
    break;
  case 'd':
    switch(CURRENT_MODE) {
    case FULLDOME_MODE:
      CURRENT_MODE = CANVAS_MODE;
      surface.setSize(PREVIEW_WIDTH, PREVIEW_HEIGHT);

      break;
    case CANVAS_MODE:
      CURRENT_MODE = FULLDOME_MODE;
      surface.setSize(DOME_SIZE, DOME_SIZE);
      break;
    }
  }
}