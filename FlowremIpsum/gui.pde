boolean drawGUI = false;

int CONE_BOTTOM_MIN = -1000;
int CONE_BOTTOM_MAX = 1000;
int CONE_HEIGHT_MIN = 0;
int CONE_HEIGHT_MAX = 1000;
int CONE_RADIUS_TOP_MIN = 0;
int CONE_RADIUS_TOP_MAX = 1000;
int CONE_RADIUS_BOTTOM_MIN = 0;
int CONE_RADIUS_BOTTOM_MAX = 1000;


void initGUI() {
  cp5 = new ControlP5(this);
  //Button b = cp5.addButton("toggleBox", 1, 20, 20, 100, 20);
  //b.setLabel("Toggle Box");
  int margin = 20;
  int padding = 10;
  int w = 200;
  int bw = 50;
  int h = 20;
  int y0 = margin;
  String[] sliders = {};
  textFont(createFont("", 30));
  //cp5.addButton("button", 10, 100, 60, 80, 20).setId(1);
  //cp5.addButton("buttonValue", 4, 100, 90, 80, 20).setId(2);

  cp5.addSlider("coneBottom", CONE_BOTTOM_MIN, CONE_BOTTOM_MAX).setValue(CONE_BOTTOM).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneHeight", CONE_HEIGHT_MIN, CONE_HEIGHT_MAX).setValue(CONE_HEIGHT).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusTop", CONE_RADIUS_TOP_MIN, CONE_RADIUS_TOP_MAX).setValue(CONE_RADIUS_TOP).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneRadiusBottom", CONE_RADIUS_BOTTOM_MIN, CONE_RADIUS_BOTTOM_MAX).setValue(CONE_RADIUS_BOTTOM).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("aperture", 0, 360).setValue(APERTURE).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("coneOrientation", 0, 360).setValue(CONE_ORIENTATION).setHeight(h).setWidth(w).setPosition(margin, y0);

  cp5.setAutoDraw(false);
}

void coneBottom(float f) {
  CONE_BOTTOM = f;
}

void coneHeight(float f) {
  CONE_HEIGHT = f;
}

void coneRadiusTop(float f) {
  CONE_RADIUS_TOP = f;
}

void coneRadiusBottom(float f) {
  CONE_RADIUS_BOTTOM = f;
}

void aperture(float f) {
  APERTURE = f;
}
void coneOrientation(float f) {
  CONE_ORIENTATION = f;
}



void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  if (drawGUI) {
    cp5.draw();
    cursor();
  } else {
    noCursor();
  }
  hint(ENABLE_DEPTH_TEST);
}