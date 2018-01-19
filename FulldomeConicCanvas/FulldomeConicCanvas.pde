PShader domeShader;
PShape domeQuad;
PImage img;

void setup() {
  size(600, 600, P3D);
  pixelDensity(displayDensity());
  img = loadImage("images/World_Equirectangular.jpg");
  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  domeShader.set("aperture", 1.0f);
  domeShader.set("radiusBottom", height*0.5f);
  domeShader.set("radiusTop", height*0.5f);
  domeShader.set("bottom", 0.0f);
  domeShader.set("height", float(height));
  domeShader.set("rotation", 0.0f);
  domeShader.set("canvas", img);
  initShape();
}

void draw() {
  background(0);
  pushMatrix();
  translate(width*0.5,height*0.5);
  shader(domeShader);
  shape(domeQuad);
  resetShader();
  popMatrix();
  domeShader.set("rotation", frameCount/2000f);
  domeShader.set("radiusBottom", mouseX + 0f);
  domeShader.set("radiusTop", mouseY + 0f);
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
