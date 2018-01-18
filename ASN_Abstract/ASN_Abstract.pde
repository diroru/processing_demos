//TODO: decide about 2014!!!
//TODO: treat Unknown country!!!
import java.util.*;
//import java.awt.event.*;
//import javax.swing.event.*;
//import java.awt.event.*;
import codeanticode.planetarium.*;
import controlP5.*;
import java.lang.reflect.*;


Table dataTable;
ArrayList<String> countryNames;
ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<Country> countries = new ArrayList<Country>();
ArrayList<Country> displayableCountries = new ArrayList<Country>();
//a crude database listing all countries, first by name, then by year
TreeMap<String, TreeMap<Integer, Country>> dataBase = new TreeMap<String, TreeMap<Integer, Country>>(); 

int YEAR_START = Integer.MAX_VALUE;
int YEAR_END = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_YEAR = Integer.MIN_VALUE;
float MARGIN = 20;
float GAP = 1;

float margin = 20;

PVector mappedMouse = new PVector();

LayoutInfo matrixLayout;
DomeCamera dc;
ProjectionMesh mesh;
PGraphics canvas;

boolean domeDisplay = true;
int DOME_SIZE = 1024;
int PREVIEW_WIDTH = 1200;
int PREVIEW_HEIGHT = 600;

long lastTime;

void settings() {
  size(DOME_SIZE, DOME_SIZE, Dome.RENDERER);
}

void setup() {
  //size(1200, 600, P2D);
  //initial default camera, i.e. interface to interact with the renderer.
  surface.setResizable(true);
  dc = new DomeCamera(this);
  dc.setDomeAperture(1f);
  //we enable the sixth side, sothat we see what is happenning
  dc.setFaceDraw(DomeCamera.NEGATIVE_Z, false);
  canvas = createGraphics(2048, 1024, P3D);
  mesh = new ProjectionMesh(canvas);
  mesh.setHeight(238);
  mesh.setRadius1(66);
  mesh.setRadius0(186);
  initData(); //see data.pde
  //ArrayList<Integer> decades = new ArrayList<Integer>(Arrays.asList(1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000, 2010));
  float matrixH = canvas.height / 2f; 
  matrixLayout = new LayoutInfo(MARGIN, canvas.height - matrixH - MARGIN, canvas.width - 2 * MARGIN, matrixH, GAP, GAP);
  displayableCountries = makeLayout(matrixLayout);
  lastTime = millis();
}

void pre() {
  mappedMouse = mapMouse(canvas, mouseX, mouseY);
}

void draw() {
  if (domeDisplay) {
    background(0);
    pushMatrix();
    translate(width/2, height/2, 0f);
    /*
  rotateX(radians(xAngle));
     rotateY(radians(yAngle));
     rotateZ(radians(zAngle));
     translate(deltaX, deltaY, deltaZ);
     */
    mesh.display();
    popMatrix();
  } else {
    background(255, 255, 0);
    fitImage(canvas);
  }
}

void post() {
  long now = millis();
  long delta = now - lastTime;
  lastTime = now;
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
  canvas.beginDraw();
  //draw countries
  canvas.background(0);

  canvas.fill(255);
  canvas.noStroke();

  canvas.fill(255, 255, 0, 127);
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 10, 10);

  background(0);
  translate(20, 20);
  for (Country dc : displayableCountries) {
    dc.update(delta);
    dc.display(canvas);
  }
  canvas.endDraw();
}

void keyPressed() {
  switch(key) {
  case 'g':
    mesh.toggleGrid();
    break;
  case ' ':
    canvas.save("output/test.png");
    break;
  case 'd':
    domeDisplay = !domeDisplay;
    if (domeDisplay) {
      dc.enable();
      surface.setSize(DOME_SIZE, DOME_SIZE);
    } else {
      dc.disable();
      surface.setSize(PREVIEW_WIDTH, PREVIEW_HEIGHT);
    }
    break;
  }
}