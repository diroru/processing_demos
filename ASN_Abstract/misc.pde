void fitImage(PImage img) {
  float scaleFactor = fittingScaleFactor(img);
  image(img,0,0,img.width*scaleFactor,img.height*scaleFactor);
}

float fittingScaleFactor(PImage src) {
  return fittingScaleFactor(src, g);
}

float fittingScaleFactor(PImage src, PImage target) {
  return min(float(target.width)/src.width, float(target.height)/src.height);
}

void initShader() {
  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  domeShader.set("aperture", APERTURE);
  domeShader.set("radiusBottom", CONE_RADIUS_BOTTOM);
  domeShader.set("radiusTop", CONE_RADIUS_TOP);
  domeShader.set("coneBottom", CONE_BOTTOM);
  domeShader.set("coneHeight", CONE_HEIGHT);
  domeShader.set("coneOrientation", CONE_ORIENTATION);
  domeShader.set("canvas", canvas);
}

void initCanvas() {
  canvas = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  canvas.beginDraw();
  canvas.background(0);
  //canvas.textMode(SHAPE);
  canvas.ortho();
  canvas.endDraw();
}

void initShape() {
  domeQuad = createShape();
  domeQuad.beginShape();
  domeQuad.fill(255, 255, 0);
  domeQuad.textureMode(NORMAL);
  domeQuad.noStroke();
  domeQuad.vertex(-width * 0.5f, -height * 0.5f, 0, 1, 1);
  domeQuad.vertex(width * 0.5f, -height * 0.5f, 0, 0, 1);
  domeQuad.vertex(width * 0.5f, height * 0.5f, 0, 0, 0);
  domeQuad.vertex(-width * 0.5f, height * 0.5f, 0, 1, 0);
  domeQuad.endShape();
}

void initFonts() {
  headerFont = loadFont("fonts/PTSans-Regular-46.vlw");
  corpusFont = loadFont("fonts/PTSans-Regular-16.vlw");
  smallFont =  loadFont("fonts/PTSans-Regular-12.vlw");
}