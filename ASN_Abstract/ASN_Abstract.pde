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

float APERTURE = 180f;
float CONE_RADIUS_BOTTOM = 186;
float CONE_RADIUS_TOP = 66;
float CONE_HEIGHT = 238;
float CONE_BOTTOM = 0;
float CONE_ORIENTATION = 250f;
PShader domeShader;
PShape domeQuad;
float SCROLL_FACTOR = 5;

Table dataTable;
ArrayList<String> countryNames;
ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<Country> countries = new ArrayList<Country>();
ArrayList<Country> displayableCountries = new ArrayList<Country>();
HashMap<String, Integer> fatalitiesByCountry = new HashMap<String, Integer>();
//a crude database listing all countries, first by name, then by year
TreeMap<String, TreeMap<Integer, Country>> dataBase = new TreeMap<String, TreeMap<Integer, Country>>();
HashSet<String> countryNameSet;
HashMap<Integer, Integer> fatalitiesByYear = new HashMap<Integer, Integer>();

int YEAR_START = Integer.MAX_VALUE;
int YEAR_END = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_YEAR = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_COUNTRY_PER_YEAR = Integer.MIN_VALUE;
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
int DELTA_Y = 0;
float DELTA_Y_MIN;
float DELTA_Y_MAX;

PImage overlay;

void settings() {
  size(DOME_SIZE, DOME_SIZE, P3D);
  //pixelDensity(displayDensity());
  //fullScreen(P3D, SPAN);
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
  DELTA_Y_MAX = round(matrixLayout.h - (CELL_SIZE + GAP) * 19);
  DELTA_Y_MIN = - CELL_SIZE - GAP;
  setSortByName(SET_START_POS);

  //ArrayList<Integer> decades = new ArrayList<Integer>(Arrays.asList(1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010));
  //float matrixH = canvas.height / 2f;
  //matrixLayout = new LayoutInfo(MARGIN, canvas.height - matrixH - MARGIN, canvas.width - 2 * MARGIN, matrixH, GAP, GAP);
  println(getColumnCount());
  println(getRowCount());
  lastTime = millis();
  // frameRate(120);
  overlay = loadImage("img/zenit_header_overlay.png");
}

void draw() {
  updateShader();
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
  }
  //
  //canvas.pushMatrix();
  //canvas.translate(0, DELTA_Y);
  canvas.noStroke();
  canvas.beginShape(QUADS);
  for (Country dc : displayableCountries) {
    dc.displayEmpty(canvas);
  }
  canvas.endShape();

  if (tooltipCountry == null) {
    displayYears(50, 255);
  } else {
    displayHighlight();
    displayYears(50, 127);
    displayHighlightYear(50);
  }

  canvas.beginShape(TRIANGLES);
  for (Country dc : displayableCountries) {
    dc.displayRegular(canvas);
  }
  canvas.endShape();

  canvas.beginShape(QUADS);
  for (Country dc : displayableCountries) {
    dc.displayDetailed(canvas);
  }
  canvas.endShape();
  //display decade divisor
  canvas.stroke(255);
  for (int year = 1; year <= YEAR_END-YEAR_START; year++) {
    if ((year + YEAR_START) % 10 == 0) {
      float x0 = matrixLayout.x;
      float x1 = matrixLayout.x + matrixLayout.w;
      //println(matrixLayout.getUnitHeight(YEAR_END - YEAR_START)); //same az CELL_SIZE
      float y = matrixLayout.y + year * (matrixLayout.cellHeight  + matrixLayout.vGap) - matrixLayout.vGap*0.5  + DELTA_Y;
      canvas.line(x0, y, -3, x1, y, -3);
      /*
      beginShape();
       vertex(x0, y, 3);
       vertex(x1, y, 3);
       endShape();
       */
    }
  }
  
  canvas.noStroke();
  float labelY = canvas.height - BOTTOM_REGION_HEIGHT + MARGIN;
  float totalX = matrixLayout.x -170;
  displayTotals(canvas, totalX, labelY, 100);

  //hide overlapping countries
  canvas.fill(0);
  canvas.noStroke();
  canvas.rect(0, matrixLayout.y + matrixLayout.h, canvas.width, canvas.height - matrixLayout.y - matrixLayout.h);
  if (tooltipCountry == null) {
    displayLabels(labelY, displayableCountries, 255);
  } else {
    displayLabels(labelY, displayableCountries, 127, tooltipCountry);
  }
  canvas.text("GLOBAL", totalX, labelY);

  drawTooltip();
  canvas.fill(255, 0, 0, 127);
  canvas.ellipseMode(RADIUS);
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 5, 5);
  canvas.ellipse(mappedMouse.x + canvas.width, mappedMouse.y, 5, 5);
  
  //canvas.popMatrix();
  //
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
    image(overlay, 0, 0, width, height);  
    break;
  case CANVAS_MODE:
    background(255, 255, 0);
    fitImage(canvas);
    break;
  }
  // }
}

void displayLabels(float y, ArrayList<Country> displayableCountries, int alpha) {
  displayLabels(y, displayableCountries, alpha, null);
}

void displayLabels(float y, ArrayList<Country> displayableCountries, int alpha, Country theTooltipCountry) {
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
        canvas.fill(WHITE, alpha);
        canvas.text(currentLetter, c.currentX, y);
        writtenLetters.add(currentLetter);
        //println(currentLetter);
      }
      break;
    }
  }
  if (theTooltipCountry != null) {
    canvas.fill(WHITE);
    float w = canvas.textWidth(theTooltipCountry.name);
    canvas.rect(theTooltipCountry.currentX-3, y+6, w+6, 15);
    canvas.fill(0);
    canvas.text(theTooltipCountry.name, theTooltipCountry.currentX, y + 18);
  }
  //println(millis() - t0);
}

void displayYears(int deltaX, int alpha) {
  for (int year = YEAR_START; year <= YEAR_END; year++) {
    canvas.pushStyle();
    canvas.textFont(smallFont);
    canvas.fill(WHITE, alpha);
    canvas.textAlign(LEFT, TOP);
    if (year % 10 == 0) {
      canvas.text(year+"", matrixLayout.x - deltaX, matrixLayout.getYNo(year-YEAR_START, YEAR_END-YEAR_START) - 2 + DELTA_Y);
    }
    canvas.popStyle();
  }
}

void displayTotals(PGraphics g, float x, float y, float w) {
  for (int year = YEAR_START; year <= YEAR_END; year++) {
    g.pushStyle();
    g.fill(NO_CRASHES);
    g.rect(x, matrixLayout.getYNo(year-YEAR_START, YEAR_END-YEAR_START) + DELTA_Y, w, matrixLayout.getUnitHeight(YEAR_END-YEAR_START));
    float wTotal = map(fatalitiesByYear.get(year),0,MAX_FATALITIES_PER_YEAR, 0, w);
    g.fill(WHITE);
    g.rect(x, matrixLayout.getYNo(year-YEAR_START, YEAR_END-YEAR_START) + DELTA_Y, wTotal, matrixLayout.getUnitHeight(YEAR_END-YEAR_START));

    g.popStyle();
  }
}

void displayHighlightYear(int deltaX) {
  int year = tooltipCountry.year;
  float x = matrixLayout.x - deltaX;
  float y = matrixLayout.getYNo(year-YEAR_START, YEAR_END-YEAR_START) - 2 + DELTA_Y;
  canvas.pushStyle();
  canvas.textFont(smallFont);
  canvas.fill(WHITE);
  canvas.rect(x-2, y-3, 32, 14);
  canvas.textAlign(LEFT, TOP);
  canvas.fill(0);
  canvas.text(year+"", x, y);
  canvas.popStyle();
}

void displayHighlight() {
  if (tooltipCountry != null) {
    canvas.fill(127);
    canvas.rect(matrixLayout.x, tooltipCountry.currentY - GAP + DELTA_Y, matrixLayout.w, tooltipCountry.currentH + 2*GAP );
    canvas.rect(tooltipCountry.currentX - GAP, matrixLayout.y + DELTA_Y, tooltipCountry.currentW + 2*GAP, matrixLayout.h);
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

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //println(event.getAmount());
  //println(event.getModifiers());
  if (event.getModifiers() == MouseEvent.SHIFT) {
    //println("shift");
  }
  //println(MouseEvent.);
  DELTA_Y = round(constrain(DELTA_Y + e * SCROLL_FACTOR, DELTA_Y_MIN, DELTA_Y_MAX));
}