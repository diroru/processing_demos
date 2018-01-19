import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FulldomeConicCanvas extends PApplet {

PShader domeShader;
PShape domeQuad;
PImage img;

public void setup() {
  
  
  img = loadImage("images/World_Equirectangular.jpg");
  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  domeShader.set("aperture", 1.0f);
  domeShader.set("radiusBottom", height*0.5f);
  domeShader.set("radiusTop", height*0.5f);
  domeShader.set("bottom", 0.0f);
  domeShader.set("height", PApplet.parseFloat(height));
  domeShader.set("rotation", 0.0f);
  domeShader.set("canvas", img);
  initShape();
}

public void draw() {
  background(0);
  pushMatrix();
  translate(width*0.5f,height*0.5f);
  shader(domeShader);
  shape(domeQuad);
  resetShader();
  popMatrix();
  domeShader.set("rotation", frameCount/2000f);
  domeShader.set("radiusBottom", mouseX + 0f);
  domeShader.set("radiusTop", mouseY + 0f);
}

public void initShape() {
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
  public void settings() {  size(600, 600, P3D);  pixelDensity(displayDensity()); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "FulldomeConicCanvas" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
