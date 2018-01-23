class ConicMeshInfo {
  PGraphics canvas;
  //float aperture, angle, radiusBottom, radiusTop, height, bottom;
  float margin = 10;

  ConicMeshInfo(int w, int h) {
    canvas = createGraphics(w, h, P2D);
  }

  PGraphics getCanvas() {
    return getCanvas(APERTURE, CONE_ORIENTATION, CONE_RADIUS_BOTTOM, CONE_RADIUS_TOP, CONE_HEIGHT, CONE_BOTTOM);
  }

  PGraphics getCanvas(float aperture, float coneOrientation, float radiusBottom, float radiusTop, float cHeight, float bottom) {

    // float coneAngle = acos((radiusTop - radiusBottom) / cHeight);
    float coneAngle = atan2(cHeight, radiusTop - radiusBottom);
    float coneHeight = cHeight;
    float scaleFactor = (canvas.height - 2 * margin) / max(coneHeight, max(radiusTop, radiusBottom) * 2f);
    float dRadius = radiusBottom;
    if (coneAngle > HALF_PI) {
      dRadius = sin(coneAngle) * radiusBottom;
    }
    // println(degrees(coneAngle));

    canvas.beginDraw();
    canvas.background(63);
    canvas.translate(canvas.width*0.5, canvas.height - margin);
    canvas.scale(scaleFactor, -scaleFactor);
    canvas.noFill();
    canvas.stroke(255,255,0);
    canvas.strokeWeight(2/scaleFactor);

    canvas.beginShape();
    canvas.vertex(0, 0);
    canvas.vertex(radiusBottom, 0);
    canvas.vertex(radiusTop, coneHeight);
    canvas.vertex(-radiusTop, coneHeight);
    canvas.vertex(-radiusBottom, 0);
    canvas.endShape(CLOSE);

    canvas.stroke(255);
    canvas.ellipseMode(RADIUS);
    canvas.arc(0, 0, dRadius, dRadius, 0f, PI, CHORD);

    canvas.fill(255,63);
    canvas.noStroke();
    PVector v0 = new PVector(radiusBottom, 0);
    PVector v1 = new PVector(radiusTop, coneHeight);
    for (int i = 0; i < 5; i++) {
      PVector v = PVector.lerp(v0, v1, i / 4f);
      canvas.beginShape();
      canvas.vertex(0,0);
      canvas.vertex(v.x, v.y);
      canvas.vertex(radiusBottom, 0);
      canvas.endShape(CLOSE);
      canvas.beginShape();
      canvas.vertex(0,0);
      canvas.vertex(-v.x, v.y);
      canvas.vertex(-radiusBottom, 0);
      canvas.endShape(CLOSE);
    }

    canvas.endDraw();
    return canvas;
  }

  void display() {
    image(getCanvas(), margin, height-canvas.height-margin);
  }
}
