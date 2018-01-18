class ProjectionMesh {
  PImage tex;
  PShape myShape;
  float r0, r1, w, h;
  //float orientation = 0f; //TODO
  int hRes = 64, vRes = 64;
  boolean showGrid = false;

  static final int MESH_PLANE = 0;
  static final int MESH_CONE = 1;

  int myType = MESH_CONE;

  ProjectionMesh(String imgPath) {
    this(loadImage(imgPath));
  }

  ProjectionMesh(PImage theTex) {
    tex = theTex;
    r0 = width*0.5;
    r1 = width*0.5;
    //r1 = 66;
    //r0 = 186;
    //h = tex.height;
    //w = tex.width * r0 * 2f * PI / tex.height; // w / width = perimiter / width;
    h = r0 * TWO_PI * tex.height / tex.width;
    //h = 238;
    w = r0 * TWO_PI; // w / width = perimiter / width;
    updateShape();
  }

  PShape createConicShape(float rBottom, float rTop, float h, float hr, float vr) {
    textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUADS);
    sh.noFill();
    if (showGrid) {
      sh.stroke(1/6f, 1, 1, 1);
      sh.strokeWeight(4);
    } else {
      sh.noStroke();
    }
    sh.texture(tex);
    float vInc = 1f / vr;
    float hInc = 1f / hr;
    float thetaInc = TWO_PI * hInc;
    float zInc = -h * vInc;
    for (int i = 0; i < vr; i++) {
      for (int j = 0; j < hr; j++) {
        float r0 = rBottom + (rTop - rBottom) * i * vInc;
        float r1 = rBottom + (rTop - rBottom) * (i + 1) * vInc;
        sh.vertex(cos(thetaInc * j) * r0, sin(thetaInc * j) * r0, i * zInc, 1 - j * hInc, 1 - i * vInc);
        sh.vertex(cos(thetaInc * (j+1)) * r0, sin(thetaInc * (j+1)) * r0, i * zInc, 1 - (j+1) * hInc, 1 - i * vInc);
        sh.vertex(cos(thetaInc * (j+1)) * r1, sin(thetaInc * (j+1)) * r1, (i+1) * zInc, 1 - (j+1) * hInc, 1 - (i+1) * vInc);
        sh.vertex(cos(thetaInc * j) * r1, sin(thetaInc * j) * r1, (i+1) * zInc, 1 - j * hInc, 1 - (i+1) * vInc);
      }
    }
    sh.endShape();
    return sh;
  }

  PShape createPlanarShape(float r0, float w, float h, float hr, float vr) {
    textureMode(NORMAL);
    PShape sh = createShape();
    sh.beginShape(QUADS);
    sh.noFill();
    if (showGrid) {
      sh.stroke(1/6f, 1, 1, 1);
      sh.strokeWeight(2);
    } else {
      sh.noStroke();
    }
    sh.texture(tex);
    float vInc = 1f / vr;
    float hInc = 1f / hr;
    float zInc = -h * vInc;

    for (int i = 0; i < vr; i++) {
      for (int j = 0; j < hr; j++) {
        float x0 = -w * 0.5;
        //float x0 = 0f;
        float y0 = r0;
        sh.vertex(x0 + j * hInc * w, y0, i * zInc, j * hInc, 1 - i * vInc);
        sh.vertex(x0 + (j+1) * hInc * w, y0, i * zInc, (j+1) * hInc, 1 - i * vInc);
        sh.vertex(x0 + (j+1) * hInc * w, y0, (i+1) * zInc, (j+1) * hInc, 1 - (i+1) * vInc);
        sh.vertex(x0 + j * hInc * w, y0, (i+1) * zInc, j * hInc, 1 - (i+1) * vInc);
      }
    }
    sh.endShape();
    return sh;
  }

  void updateShape() {
    switch(myType) {
    case MESH_CONE:
      myShape = null;
      myShape = createConicShape(r0, r1, h, hRes, vRes);
      break;
    case MESH_PLANE:
      myShape = null;
      myShape = createPlanarShape(r0, w, h, hRes, vRes); //TODO: hacky!!!
      break;
    }
    printInfo();
  }

  void setRadius0(float r) {
    r0 = r;
    updateShape();
  }

  void setRadius1(float r) {
    r1 = r;
    updateShape();
  }

  void addRadius0(float dr) {
    setRadius0(r0 + dr);
  }

  void addRadius1(float dr) {
    setRadius1(r1 + dr);
  }

  void addHeight(float dh) {
    setHeight(h + dh);
  }

  void setHeight(float f) {
    h = f;
    updateShape();
  }

  void addWidth(float dw) {
    setWidth(w + dw);
  }

  void setWidth(float f) {
    w = f;
    updateShape();
  }

  void setTexture(PImage img) {
    tex = img;
    h = tex.height;
    w = tex.width;
    updateShape();
  }

  void toggleGrid() {
    setGrid(!getGrid());
  }
  
  void setGrid(boolean b) {
    showGrid = b;
    updateShape();
  } 
  
  boolean getGrid() {
    return showGrid;
  }

  void setType(int theType) {
    myType = theType;
    updateShape();
  }

  void toggleShape() {
    switch(myType) {
    case MESH_CONE:
      myType = MESH_PLANE; 
      break;
    case MESH_PLANE:
      myType = MESH_CONE;
      break;
    }
    updateShape();
  }

  void display() {
    try {
      shape(myShape);
    } 
    catch (Exception e) {
    }
  }

  void addScale(float ds) {
    r0 *= (1 + ds);
    r1 *= (1 + ds);
    //h *= (1 + ds);
    //w *= (1 + ds);
    h = r0 * TWO_PI * tex.height / tex.width;
    w = r0 * TWO_PI; // w / width = perimiter / width;
    updateShape();
  }
  
  float getHeight() {
    return h;
  }
  
  void printInfo() {
    println("--------");
    println("width", w);
    println("height", h);
    println("r0", r0);
    println("r1", r1);
    println("res", hRes + "x" + vRes);
    println("--------");
  }
}