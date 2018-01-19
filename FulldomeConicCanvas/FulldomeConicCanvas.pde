PShader domeShader;
PShape domeQuad;

void setup() {
  size(600, 600, P3D);
  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
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
