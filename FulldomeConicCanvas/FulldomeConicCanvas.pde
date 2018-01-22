PShader domeShader;
PShape domeQuad;
PImage img;

final int FULLDOME_MODE = 0;
final int CANVAS_MODE = 1;

PGraphics canvas;

float APERTURE = 1f;
float CONE_RADIUS_BOTTOM = 512;
float CONE_RADIUS_TOP = 512;
float CONE_HEIGHT = 512;
float CONE_BOTTOM = 0;
float CONE_ORIENTATION = 0;

void setup() {
  size(1200, 600, P3D);
  pixelDensity(displayDensity());

  img = loadImage("images/World_Equirectangular.jpg");
  canvas = createGraphics(img.width, img.height, P2D);
  canvas.beginDraw();
  canvas.background(0);
  canvas.image(img,0,0);
  canvas.endDraw();

  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  domeShader.set("aperture", APERTURE);
  domeShader.set("radiusBottom", CONE_RADIUS_BOTTOM);
  domeShader.set("radiusTop", CONE_RADIUS_TOP);
  domeShader.set("bottom", CONE_BOTTOM);
  domeShader.set("height", CONE_HEIGHT);
  domeShader.set("rotation", CONE_ORIENTATION);
  domeShader.set("canvas", canvas);
  initShape();
}

void draw() {
  PVector mm = mappedMouse(CANVAS_MODE);

  background(0);

  canvas.beginDraw();
  canvas.background(0);
  canvas.image(img,0,0);
  canvas.ellipseMode(RADIUS);
  canvas.noStroke();
  canvas.fill(0,255,0,127);
  canvas.ellipse(mm.x, mm.y, 10, 10);
  canvas.endDraw();
  image(canvas,0,0, canvasToWindowRatio() * canvas.width, canvasToWindowRatio() * canvas.height );

/*
  pushMatrix();
  translate(width*0.5,height*0.5);
  shader(domeShader);
  shape(domeQuad);
  resetShader();
  popMatrix();
  domeShader.set("rotation", frameCount/2000f);
  domeShader.set("radiusBottom", mouseX + 0f);
  domeShader.set("radiusTop", mouseY + 0f);
  */
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
