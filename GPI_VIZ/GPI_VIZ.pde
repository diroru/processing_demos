import codeanticode.planetarium.*;
import controlP5.*;

DomeCamera dc;
ControlP5 cp5;

int gridMode = Dome.NORMAL;
ProjectionMesh mesh;
ArrayList<String> images;

float xAngle = 0f;
float yAngle = 0f;
float zAngle = 0f;
float deltaX = 0f;
float deltaY = 0f;
float deltaZ = 0f;
int currentImage = 0;

void setup() {
  // For the time being, only use square windows  
  size(1024, 1024, Dome.RENDERER);
  //initial default camera, i.e. interface to interact with the renderer.
  dc = new DomeCamera(this);
  //Set the aperture, or radial coverage of the dome. 
  //1 is default, 2 would show the contents of an entire sphere.
  dc.setDomeAperture(1f);
  //we enable the sixth side, sothat we see what is happenning
  dc.setFaceDraw(DomeCamera.NEGATIVE_Z, true);
  //This method unfortunately doesn't work yet. 
  //dc.setCubemapSize(2048);
  //mesh = new ProjectionMesh("2017-52-06-16_52_28output.png");
  images = getImagePaths();
  mesh = new ProjectionMesh(images.get(currentImage));
  initGUI();
}

// Called one time per frame.
void pre() {
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
}

// Called five times per frame.
void draw() {
  //background(255, 255, 0, 0);
  background(0);
  pushMatrix();

  translate(width/2, height/2, 0f);
  rotateX(radians(xAngle));
  rotateY(radians(yAngle));
  rotateZ(radians(zAngle));
  translate(deltaX, deltaY, deltaZ);
  mesh.display();
  popMatrix();
}

void post() {
  drawGUI();
}

void mouseDragged() {
  //exaggerating dome aperture. 1f <=> 180°
  //dc.setDomeAperture(map(mouseY, 0, height, 0.1f, 2f));
  //xAngle += (pmouseY - mouseY) * 0.01;
  //deltaZ += (pmouseX - mouseX) * 5f;
  //println("x angle", degrees(xAngle), "dz", deltaZ);
}

void keyPressed() {
  if (key == CODED) {
    /*
    if (keyCode == UP) cubeZ -= 5;
     else if (keyCode == DOWN) cubeZ += 5;
     */
  }
  switch(key) {
  case ' ':
    gridMode = gridMode == Dome.GRID ? Dome.NORMAL : Dome.GRID;
    //enables rendering of a reference grid (happens inside the shader)
    dc.setMode(gridMode);
    break;
  case 'r':
    //fulldome-conform rendering
    //dc.enable();
    mesh.addWidth(32);
    break;
  case 'f':
    //rendering only into a single, conventional camera
    //dc.disable();
    mesh.addWidth(-32);
    break;
  case 'z':
    mesh.addScale(0.1);
    break;
  case 'h':
    mesh.addScale(-0.1);
    break;
  case '0':
    //toggles rendering into the X+ side of the cubemap
    dc.toggleFaceDraw(0);
    break;
  case '1':
    //toggles rendering into the X- side of the cubemap
    dc.toggleFaceDraw(1);
    break;
  case '2':
    //toggles rendering into the Y+ side of the cubemap
    dc.toggleFaceDraw(2);
    break;
  case '3':
    //toggles rendering into the Y- side of the cubemap
    dc.toggleFaceDraw(3);
    break;
  case '4':
    //toggles rendering into the Z+ side of the cubemap
    dc.toggleFaceDraw(4);
    break;
  case '5':
    //toggles rendering into the Z- side of the cubemap
    dc.toggleFaceDraw(5);
    break;
  case 'q':
    mesh.addRadius1(32);
    break;
  case 'a':
    mesh.addRadius1(-32);
    break;
  case 'w':
    mesh.addRadius0(32);
    break;
  case 's':
    mesh.addRadius0(-32);
    break;
  case 'e':
    mesh.addHeight(32);
    break;
  case 'd':
    mesh.addHeight(-32);
    break;
  case 'g':
    //mesh.toggleGrid();
    drawGUI = !drawGUI;
    break;
  case 'm':
    mesh.toggleShape();
    break;
  case 'b':
    currentImage = (currentImage + 1) % images.size();
    try {
      mesh.setTexture(loadImage(images.get(currentImage)));
    } 
    catch (Exception e) {
    }
    break;
  case 'n':
    currentImage = (currentImage + images.size() - 1) % images.size();
    try {
      mesh.setTexture(loadImage(images.get(currentImage)));
    } 
    catch (Exception e) {
    }    
    break;
  }
}