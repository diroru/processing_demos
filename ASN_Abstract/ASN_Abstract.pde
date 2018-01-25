//TODO: decide about 2014!!!
//TODO: treat Unknown country!!!
import java.util.*;
//import java.awt.event.*;
//import javax.swing.event.*;
//import java.awt.event.*;
import controlP5.*;
import java.lang.reflect.*;

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

Table dataTable;
ArrayList<String> countryNames;
ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<Country> countries = new ArrayList<Country>();
ArrayList<Country> displayableCountries = new ArrayList<Country>();
HashMap<String, Integer> fatalitiesByCountry = new HashMap<String, Integer>();
//a crude database listing all countries, first by name, then by year
TreeMap<String, TreeMap<Integer, Country>> dataBase = new TreeMap<String, TreeMap<Integer, Country>>();
HashSet<String> countryNameSet;

int YEAR_START = Integer.MAX_VALUE;
int YEAR_END = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_YEAR = Integer.MIN_VALUE;
float MARGIN = 20;
float GAP = 2;
float CELL_SIZE = 6;

float margin = 20;

PVector mappedMouse = new PVector();

LayoutInfo matrixLayout;
PGraphics canvas;

int DOME_SIZE = 960;
int PREVIEW_WIDTH = 1536;
int PREVIEW_HEIGHT = 768;
int CANVAS_WIDTH = 2048;
int CANVAS_HEIGHT = 1024;
int BOTTOM_REGION_HEIGHT = 100;

final int SORT_BY_NAME = 0;
//TODO: define sorting year
// final int SORT_BY_ACCIDENT_COUNT = 2;
final int SORT_BY_FATALITY_COUNT = 1;
//TODO: by continents?
//TODO: treat Unknown country!!!

int currentSorting = SORT_BY_FATALITY_COUNT;
int currentYear;
int DETAILED_COUNTRY_COUNT = 11;
int DETAILED_COUNTRY_WIDTH = 60;
int ANIMATION_DURATION = 3000;

long lastTime;

PFont headerFont, corpusFont, smallFont;

void settings() {
  size(DOME_SIZE, DOME_SIZE, P3D);
  pixelDensity(displayDensity());
}

void setup() {
  //size(1200, 600, P2D);
  //initial default camera, i.e. interface to interact with the renderer.
  surface.setResizable(true);
  //we enable the sixth side, sothat we see what is happenning
  initShape();
  initCanvas();
  initShader();
  initFonts();
  initData(); //see data.pde
  matrixLayout = layoutFromCellSizeRightAlign(canvas.width - MARGIN, canvas.height - BOTTOM_REGION_HEIGHT, CELL_SIZE, CELL_SIZE, GAP, GAP, getColumnCount(), getRowCount());
  setSortByName(SET_START_POS);

  //ArrayList<Integer> decades = new ArrayList<Integer>(Arrays.asList(1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010));
  //float matrixH = canvas.height / 2f;
  //matrixLayout = new LayoutInfo(MARGIN, canvas.height - matrixH - MARGIN, canvas.width - 2 * MARGIN, matrixH, GAP, GAP);
  println(getColumnCount());
  println(getRowCount());
  lastTime = millis();
  // frameRate(120);
}

void draw() {
  mappedMouse = mappedMouse(CURRENT_MODE);
  long now = millis();
  long delta = now - lastTime;
  //delta = 16;
  lastTime = now;
  //println(delta);
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
  // if (frameCount % 4 == 0) {
  canvas.beginDraw();
  //draw countries
  canvas.background(0);

  canvas.fill(255);
  canvas.noStroke();
  for (Country dc : displayableCountries) {
    dc.update(delta);
    dc.display(canvas);
  }
  displayLabels(canvas.height - BOTTOM_REGION_HEIGHT + MARGIN, displayableCountries);
  displayYears(100);
  drawTooltip();
  canvas.fill(255, 0, 0, 127);
  canvas.ellipseMode(RADIUS);
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 10, 10);
  canvas.ellipse(mappedMouse.x + canvas.width, mappedMouse.y, 5, 5);
  canvas.endDraw();
  // } else {
  background(0);
  switch(CURRENT_MODE) {
  case FULLDOME_MODE:
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
  // }
}

void displayLabels(float y, ArrayList<Country> displayableCountries ) {
  HashSet<String> writtenLetters = new HashSet<String>();
  //long t0 = millis();
  //TODO: optimize
  for (int i = 0; i <  displayableCountries.size(); i++) {
    Country c = displayableCountries.get(i);
    switch(currentSorting) {
    case SORT_BY_FATALITY_COUNT:
      if (i < DETAILED_COUNTRY_COUNT) {
        canvas.textFont(smallFont);
        canvas.fill(WHITE);
        canvas.text(c.name, c.currentX, y, DETAILED_COUNTRY_WIDTH, canvas.height - y);
      }
      break;
    case SORT_BY_NAME:
      String currentLetter = c.name.charAt(0) + "";
      if (!writtenLetters.contains(currentLetter)) {
        canvas.textFont(smallFont);
        canvas.fill(WHITE);
        canvas.text(currentLetter, c.currentX, y);
        writtenLetters.add(currentLetter);
        //println(currentLetter);
      }
      break;
    }
  }
  //println(millis() - t0);
}

void displayYears(int deltaX) {
  for (int year = YEAR_START; year <= YEAR_END; year++) {
    canvas.pushStyle();
    canvas.textFont(smallFont);
    canvas.fill(WHITE);
    canvas.textAlign(LEFT, TOP);
    if (year % 10 == 0) {
      canvas.text(year+"", matrixLayout.x - deltaX, matrixLayout.getYNo(year-YEAR_START, YEAR_END-YEAR_START) - 2);
    }
    canvas.popStyle();
  }
}

void keyPressed() {
  switch(key) {
  case 'l':
    switch(currentSorting) {
    case SORT_BY_NAME:
      setSortByFatalityCount();
      break;
    case SORT_BY_FATALITY_COUNT:
      setSortByName();
      break;
    }
    break;
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

void mouseMoved() {
}