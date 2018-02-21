import de.looksgood.ani.*; //<>//
import de.looksgood.ani.easing.*;
import java.util.*; //<>// //<>// //<>// //<>//
//import java.awt.event.*;
//import javax.swing.event.*;
//import java.awt.event.*;
//import codeanticode.planetarium.*;
import controlP5.*;
import java.lang.reflect.*;


Table countryDataBase, countryDataExtended, flowData, populationData;

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
int currentSortingMethod = SORT_BY_NAME;

final int SHOW_ALL = 0;
final int SHOW_TOP_THREE = 1;
int currentShowMode = SHOW_ALL;

//float TIME = 0;
//float TIME_INC = 0.05;
int DEFAULT_DURATION = 500; //in millis;
float ANI_DURATION = 2; //in secods
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
HashMap<String, PImage> flags = new HashMap<String, PImage>();

//lookup table for mismatched country names
HashMap<String, String> countryLookupTable = new HashMap<String, String>();
ArrayList<String> missingCountries = new ArrayList<String>();

int currentYear = 2013;

HashSet<Country> hoverCountries = new HashSet<Country>();
ArrayList<YearSelector> yearSelectors = new ArrayList<YearSelector>();

int MARGIN = 20;
LayoutInfo panelLayout, graphLayout, flowLayout, yearsLayout, countryInfoLayout;

//DomeCamera dc;
ControlP5 cp5;

//int gridMode = Dome.NORMAL;
//ProjectionMesh mesh;

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
int PREVIEW_WIDTH = 1888;
int PREVIEW_HEIGHT = 944;
int CANVAS_WIDTH = 2048;
int CANVAS_HEIGHT = 1024;

String[] POP_LABELS = {"1", "10", "100", "1k", "10k", "100k", "1mio", "10mio", "100mio", "1bio"};

ArrayList<MigrationFlow> yearlyMigrationFlows;

int GPI_LAST_RANK = 100000;
PImage zenith;
PImage legend;

void settings() {
  size(DOME_SIZE, DOME_SIZE, P3D); //for working on the laptop (single screen)
  pixelDensity(displayDensity()); //uncomment for retina rendering
  //fullScreen( P3D, SPAN); //for presenting in the dome (double screen)
}

void setup() {

  initCanvas();
  initShape();
  initShader();
  initFonts();
  Ani.init(this);
  Ani.setDefaultEasing(Ani.CUBIC_IN_OUT);
  //mesh.toggleShape();
  //mesh.toggleGrid();
  float panelWidth = 200;
  float yearBarHeight = 30f;
  //float graphHeight = (canvas.height - MARGIN * 3 - yearBarHeight) * 0.5;
  float graphHeight = 500;
  //float graphWidth = canvas.width - MARGIN * 3 - panelWidth;
  float graphLeft = 250;
  graphLayout = new LayoutInfo(graphLeft, canvas.height - (graphHeight + yearBarHeight + MARGIN - 10), canvas.width-MARGIN-graphLeft, graphHeight);
  graphLayout.gap = gap;
  panelLayout = new LayoutInfo(MARGIN, graphLayout.y, panelWidth, canvas.height - 2*MARGIN);

  //flowLayout = new LayoutInfo(panelWidth + 2 * MARGIN, MARGIN, graphWidth, graphHeight);
  float flowHeight = 350;
  flowLayout = new LayoutInfo(graphLayout.x, graphLayout.y - flowHeight - MARGIN, graphLayout.w, flowHeight);
  countryInfoLayout = new LayoutInfo(8, 450, panelLayout.w-40, 300);

  zenith = loadImage("title/zenith.png");
  legend = loadImage("title/legend2.png");


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
  float yearX = graphLayout.x;
  float yearY = canvas.height - yearBarHeight;
  float yearW = 35;
  float dw = (graphLayout.w- MARGIN*2*(repeat-1) - yearW) / (repeat * float(count)-1);
  float yearH  = INFO_SIZE;
  for (int i = 0; i < repeat; i++) {
    for (int j= 0; j < count; j++) {
      int year = j + YEAR_START;
      LayoutInfo yearLayout = new LayoutInfo(yearX, yearY, yearW, yearH);
      yearSelectors.add(new YearSelector(year, yearLayout, this));
      yearX += dw;
    }
    yearX += MARGIN*2;
  }
  lastTime = millis();
  //canvas.hint(DISABLE_DEPTH_TEST);


  setCurrentYear(2013);
  initGUI();
  
  noCursor();
}

void draw() {
  updateShader();
  mappedMouse = mappedMouse(CURRENT_MODE);
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
  canvas.beginDraw();
  //draw countries
  canvas.background(0);
  canvas.image(legend, -45, -11);

  drawFlowGraphLegend(graphLayout, flowLayout, MARGIN, canvas);

  canvas.fill(WHITE);
  canvas.noStroke();

  long delta = millis() - lastTime;
  canvas.beginShape(QUADS);
  /*
  for (Country theCountry : countries) {
    //println(theCountry.name);
    theCountry.update(delta);
  }
  */
  Country activeCountry = null;
  for (Country theCountry : countries) {
    theCountry.display(canvas);
    if (theCountry.selected || theCountry.hover) {
      activeCountry = theCountry;
    }
  }
  canvas.endShape();
  lastTime = millis();

  displayFlows(canvas, activeCountry);
  for (YearSelector ys : yearSelectors) {
    ys.display(canvas);
  }

  for (RadioButtonGroup rbg : radio) {
    rbg.display(canvas);
  }

  displayMouse();
  displayCountryInfo(canvas, activeCountry, countryInfoLayout);

  /*//DEBUG
   canvas.fill(255, 0, 0, 63);
   canvas.rect(flowLayout.x, flowLayout.y, flowLayout.w, flowLayout.h);
   canvas.fill(0, 255, 0, 63);
   canvas.rect(graphLayout.x, graphLayout.y, graphLayout.w, graphLayout.h);
   */
  canvas.endDraw();
  switch(CURRENT_MODE) {
  case FULLDOME_MODE:
    background(0);
    image(zenith, 0, 0, width, height);
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
  drawGUI();
}

void drawFlowGraphLegend(LayoutInfo graphLayout, LayoutInfo flowLayout, float margin, PGraphics pg) {
  //DRAW POPULATION GUIDES & LABELS
  int startExponentPopulation = floor(log(POPULATION_CUTOFF)/log(10));
  pg.textFont(INFO);
  pg.textAlign(RIGHT, CENTER);
  float y = 0;
  for (int i = startExponentPopulation; i < 10; i++) {
    y = graphLayout.y + constrainedLogScale(pow(10, i), POPULATION_CUTOFF, POPULATION_MAX, graphLayout.h);
    pg.stroke(DARK_GREY);
    pg.line(graphLayout.x, y, -3, graphLayout.x + graphLayout.w, y, -3);
    pg.fill(255);
    pg.noStroke();
    pg.text(POP_LABELS[i], graphLayout.x - margin, y);
    //println(y);
  }
  pg.text("POPULATION", graphLayout.x - margin, y + margin + INFO_SIZE);
  //DRAW MIGRATION GUIDES & LABELS
  int startExponentMigration = floor(log(MIGRATION_FLOW_LOWER_LIMIT)/log(10));
  y = 0;
  for (int i = startExponentMigration; i < 6; i++) {
    y = flowLayout.y + flowLayout.h - constrainedLogScale(pow(10, i), MIGRATION_FLOW_LOWER_LIMIT, MIGRATION_FLOW_MAX, flowLayout.h);
    pg.stroke(DARK_GREY);
    pg.line(flowLayout.x, y, -3, flowLayout.x + flowLayout.w, y, -3);
    pg.fill(255);
    pg.noStroke();
    pg.text(POP_LABELS[i], flowLayout.x - margin, y);
  }
  pg.text("MIGRATION", flowLayout.x - margin, y - margin - INFO_SIZE);
}

void displayFlows(PGraphics pg, Country activeCountry) {
  pg.noFill();
  pg.strokeWeight(2);

  if (currentShowMode == SHOW_TOP_THREE ) {
    if (activeCountry == null) {
      for (int i = 0; i < min(3, yearlyMigrationFlows.size()); i++) {
        MigrationFlow mf = yearlyMigrationFlows.get(i);        
        mf.displayAsTop(pg, flowLayout, activeCountry, i);
      }
    } else {
      int count = 0;
      int i = 0;
      while (count < 3 && i < yearlyMigrationFlows.size()) {
        MigrationFlow mf = yearlyMigrationFlows.get(i);
        if (mf.isActive(activeCountry)) {
          mf.displayAsTop(pg, flowLayout, activeCountry, count);
          count++;
        }
        i++;
      }
    }
  } else {
    if (activeCountry == null) {
      for (MigrationFlow mf : yearlyMigrationFlows) {
        if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
          //mf.display(pg, height/2, MARGIN);
          pg.beginShape(POLYGON);
          mf.displayNormal(pg, flowLayout);
          pg.endShape();
        }
      }
    } else {
      for (MigrationFlow mf : yearlyMigrationFlows) {
        //mf.display(pg, height/2, MARGIN);
        if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
          pg.beginShape(POLYGON);
          mf.displayHighlighted(pg, flowLayout, activeCountry);
          pg.endShape();
        }
      }

      /*
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
       */
    }
  }
}

void displayCountryInfo(PGraphics pg, Country activeCountry, LayoutInfo layout) {
  if (activeCountry != null || hoverCountries.size() > 0) {
    Country c = activeCountry;
    if (c == null) {
      c = hoverCountries.iterator().next();
    }
    float x = layout.x;
    float y = layout.y;
    PImage flag = flags.get(c.iso2);
    if (flag != null) {        
      pg.image(flag, x, y, 25, 18);
    }
    y+= 20 + MARGIN;
    pg.textAlign(LEFT, BOTTOM);
    pg.textFont(HEADLINETITLE);
    pg.fill(PRIMARY);
    /*
    pg.text(c.name, x, y, layout.w, HEADLINETITLE_SIZE);
     y+= MARGIN*2 + HEADLINETITLE_SIZE;
     */

    float fittingSize = min(getFittingFontSize(c.name, HEADLINETITLE, layout.w), HEADLINETITLE.getDefaultSize());
    y += fittingSize ;
    pg.textSize(fittingSize);
    ArrayList<String> countryNameTokens = getOptimalStrings(c.name, HEADLINETITLE);
    for (String s : countryNameTokens) {
      pg.text(s, x, y);
      y += fittingSize;
    }

    /*
    float titleWidthFull = pg.textWidth(c.name);
     float titleHeight = ceil(titleWidthFull / layout.w) * HEADLINETITLE_SIZE;
     pg.text(c.name,x,y-titleHeight + HEADLINETITLE_SIZE, layout.w, titleHeight);
     y+= MARGIN*2 + titleHeight;
     */
    pg.textFont(HEADLINEALTSUBTITLE);
    pg.textSize(HEADLINEALTSUBTITLE.getDefaultSize());
    pg.text("Global Peace Index: #" + c.getGPIRankString(currentYear), x, y);
    y+= 5 + HEADLINEALTSUBTITLE_SIZE;
    pg.text("Population: " + c.pop.get(currentYear), x, y);
    y+= 5 + HEADLINEALTSUBTITLE_SIZE;
    pg.text("Immigration: " + c.totalImmigraionFlow.get(currentYear), x, y);
    y+= 5+ HEADLINEALTSUBTITLE_SIZE;
    pg.text("Emigration: " + c.totalEmigraionFlow.get(currentYear), x, y);
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
  case 'g':
    drawGUI = !drawGUI;
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