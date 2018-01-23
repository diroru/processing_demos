PShader domeShader;
PShape domeQuad;
PImage img;

final int FULLDOME_MODE = 0;
final int CANVAS_MODE = 1;

PGraphics canvas;
ConicMeshInfo coneInfo;

float APERTURE = 2f;
float CONE_RADIUS_BOTTOM = 512;
float CONE_RADIUS_TOP = 512;
float CONE_HEIGHT = 512;
float CONE_BOTTOM = 0;
float CONE_ORIENTATION = 0;

void setup() {
  size(800, 800, P3D);
  pixelDensity(displayDensity());

  img = loadImage("images/World_Equirectangular.jpg");
  canvas = createGraphics(img.width, img.height, P2D);
  canvas.beginDraw();
  canvas.background(0);
  canvas.image(img,0,0);
  canvas.endDraw();

  coneInfo = new ConicMeshInfo(400,400);

  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  updateShader();
  domeShader.set("canvas", canvas);
  initShape();
}

void draw() {
  PVector mm = mappedMouse(FULLDOME_MODE);

  background(0);

  canvas.beginDraw();
  canvas.background(0);
  canvas.image(img,0,0);
  canvas.ellipseMode(RADIUS);
  canvas.noStroke();
  canvas.fill(255,0,0,192);
  canvas.ellipse(mm.x, mm.y, 10, 10);
  canvas.ellipse(mm.x + canvas.width, mm.y, 10, 10);
  canvas.endDraw();
  //image(canvas,0,0, canvasToWindowRatio() * canvas.width, canvasToWindowRatio() * canvas.height );
  CONE_ORIENTATION = frameCount/10000f;
  //CONE_RADIUS_BOTTOM = mouseX + 0f;
  CONE_RADIUS_TOP = mouseX + 0f;
  CONE_BOTTOM = mouseY - height*0.5;
  updateShader();
  pushMatrix();
  translate(width*0.5,height*0.5);
  shader(domeShader);
  shape(domeQuad);
  resetShader();
  popMatrix();

  coneInfo.display();
}

void updateShader() {
  domeShader.set("aperture", APERTURE);
  domeShader.set("radiusBottom", CONE_RADIUS_BOTTOM);
  domeShader.set("radiusTop", CONE_RADIUS_TOP);
  domeShader.set("coneBottom", CONE_BOTTOM);
  domeShader.set("coneHeight", CONE_HEIGHT);
  domeShader.set("coneOrientation", CONE_ORIENTATION);
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

void mouseMoved() {
  PVector mm = mappedMouse(FULLDOME_MODE);
  //println(mm.x, mm.y);
}
