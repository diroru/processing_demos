import codeanticode.planetarium.*;

DomeCamera dc;
int gridMode = Dome.NORMAL;
Cone myCone;

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
  myCone = new Cone("2017-52-06-16_52_28output.png");
}

// Called one time per frame.
void pre() {
  // The dome projection is centered at (0, 0), so the mouse coordinates
  // need to be offset by (width/2, height/2)
}

// Called five times per frame.
void draw() {
  background(255, 255, 0, 0);
  pushMatrix();
  translate(width/2, height/2, 0);
  myCone.display();
  popMatrix();
}

void mouseDragged() {
  //exaggerating dome aperture. 1f <=> 180°
  dc.setDomeAperture(map(mouseY, 0, height, 0.1f, 2f));
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
    dc.enable();
    break;
  case 'f':
    //rendering only into a single, conventional camera
    dc.disable();
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
    myCone.addRadius1(32);
    break;
  case 'a':
    myCone.addRadius1(-32);
    break;
  case 'w':
    myCone.addRadius0(32);
    break;
  case 's':
    myCone.addRadius0(-32);
    break;
  case 'e':
    myCone.addHeight(32);
    break;
  case 'd':
    myCone.addHeight(-32);
    break;

  case 'g':
    myCone.toggleGrid();
    break;
  }
}