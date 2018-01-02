boolean drawGUI = true;

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
  cp5.addSlider("deltaX", -1000, 1000).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("deltaY", -1000, 1000).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("deltaZ", -1000, 1000).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("xAngle", -180, 180).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("yAngle", -180, 180).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("zAngle", -180, 180).setHeight(h).setWidth(w).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addSlider("meshHeight", 0, 1000).setHeight(h).setWidth(w).setPosition(margin, y0).setValue(100);
  mesh.setHeight(100);
  y0 += h + padding;
  cp5.addSlider("meshWidth", 0, 1000).setHeight(h).setWidth(w).setPosition(margin, y0).setValue(100);
  mesh.setWidth(200);
  y0 += h + padding;
  cp5.addSlider("meshRadiusTop", 0, 1000).setHeight(h).setWidth(w).setPosition(margin, y0).setValue(100);
  mesh.setRadius1(100);
  y0 += h + padding;
  cp5.addSlider("meshRadiusBottom", 0, 1000).setHeight(h).setWidth(w).setPosition(margin, y0).setValue(100);
  mesh.setRadius0(100);
  y0 += h + padding;
  cp5.addButton("nextImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addButton("prevImage").setHeight(h).setWidth(bw).setPosition(margin, y0);
  y0 += h + padding;
  cp5.addToggle("toggleGrid").setHeight(h).setWidth(bw).setPosition(margin, y0).setValue(false);
  y0 += h + padding*2;
  cp5.addToggle("toggleShape").setHeight(h).setWidth(bw).setPosition(margin, y0);

  cp5.setAutoDraw(false);
}

void meshHeight(float f) {
  mesh.setHeight(f);
}

void meshWidth(float f) {
  mesh.setWidth(f);
}


void meshRadiusTop(float f) {
  mesh.setRadius1(f);
}

void meshRadiusBottom(float f) {
  mesh.setRadius0(f);
}

void toggleGrid(boolean b) {
  mesh.setGrid(b);
}

void toggleShape(boolean b) {
  mesh.toggleShape();
}


void nextImage() {
  currentImage = (currentImage + 1) % images.size();
  try {
    mesh.setTexture(loadImage(images.get(currentImage)));
  } 
  catch (Exception e) {
  }
}

void prevImage() {
  currentImage = (currentImage + images.size() - 1) % images.size();
  try {
    mesh.setTexture(loadImage(images.get(currentImage)));
  } 
  catch (Exception e) {
  }
}

void drawGUI() {
  hint(DISABLE_DEPTH_TEST);
  camera();
  if (drawGUI) {
    cp5.draw();
  } 
  hint(ENABLE_DEPTH_TEST);
}