class ConicMeshInfo {
  PGraphics canvas;
  //float aperture, angle, radiusBottom, radiusTop, height, bottom;
  float margin = 10;

  ConicMeshInfo(int w, int h) {
    canvas = createGraphics(w, h, P2D);
  }

  PGraphics getCanvas() {
    return getCanvas(APERTURE, CONE_RADIUS_BOTTOM, CONE_RADIUS_TOP, CONE_HEIGHT, CONE_BOTTOM);
  }

  PGraphics getCanvas(float aperture, float radiusBottom, float radiusTop, float coneHeight, float coneBottom) {

    // float coneAngle = acos((radiusTop - radiusBottom) / coneHeight);
    float coneAngle = atan2(coneHeight, radiusTop - radiusBottom);

    float coneLeft = min(-radiusBottom, -radiusTop);
    float coneWidth = abs(coneLeft)*2;
    float coneTop = coneBottom + coneHeight;

    float rTop = PVector.dist(new PVector(-radiusTop, coneTop), new PVector());
    float rBottom = PVector.dist(new PVector(-radiusBottom, coneBottom), new PVector());
    float rMin = min(rTop, rBottom);
    //float rMax = max(rTop, rBottom);
    float domeRadius = rMin;
    //float domeRadius = distanceTo(radiusBottom, coneBottom, radiusTop, coneTop);
    
    if (touchesInside(-radiusBottom, coneBottom, -radiusTop, coneTop)) {
      domeRadius = distanceTo(-radiusBottom, coneBottom, -radiusTop, coneTop);
      //println("inside", frameCount);
    } else {
      //println("outside", frameCount);
    }
    
    float visibleWidth = max(coneWidth, domeRadius*2);
  /*
    float domeRadius = radiusBottom;
    if (coneAngle > HALF_PI) {
      dRadius = sin(coneAngle) * radiusBottom;
    }
    */
    float domeBottom = -max(0, sin((APERTURE * PI - PI)*0.5)) * domeRadius;
    float visibleTop = max(coneTop, domeRadius);
    float visibleBottom = min(coneBottom, domeBottom);    
    float visibleHeight = visibleTop - visibleBottom;
    float deltaY = -visibleTop;
    //println(visibleHeight, domeBottom, bottom, degrees(APERTURE*PI));


    //float scaleFactor = (canvas.height - 2 * margin) / max(coneHeight, max(radiusTop, radiusBottom) * 2f);
    float scaleFactor = min((canvas.height - 2 * margin) / visibleHeight, (canvas.width - 2 * margin) / visibleWidth);
    //float deltaY = ( -max(-dRadius, coneBottom)) * scaleFactor;
    //float deltaY = (visibleHeight - min(-dRadius, coneBottom)) * scaleFactor;

    //scaleFactor = 0.1f;
    // println(degrees(coneAngle));

    canvas.beginDraw();
    canvas.background(31);
    canvas.translate(canvas.width*0.5, margin);
    canvas.scale(scaleFactor, -scaleFactor);
    canvas.translate(0f, deltaY);
    canvas.noFill();
    canvas.stroke(255, 255, 0);
    canvas.strokeWeight(2/scaleFactor);

    canvas.noStroke();
    PVector v0 = new PVector(radiusBottom, coneBottom);
    PVector v1 = new PVector(radiusTop, coneHeight + coneBottom);
    int count = 4; 
    float[] angles = new float[count+1];
    float minAngle = TWO_PI;
    float maxAngle = 0;
    for (int i = 0; i <= count; i++) {
      float f0 = i / (count+1f);
      float f1 = (i + 1) / (count+1f);
      PVector w0 = PVector.lerp(v0, v1, f0);
      PVector w1 = PVector.lerp(v0, v1, f1);
      float theta = PVector.angleBetween(w0, w1);
      minAngle = min(minAngle, theta);
      maxAngle = max(maxAngle, theta);
      angles[i] = theta;
    }
    for (int i = 0; i <= count; i++) {
      float f0 = i / (count+1f);
      float f1 = (i + 1) / (count+1f);
      PVector w0 = PVector.lerp(v0, v1, f0);
      PVector w1 = PVector.lerp(v0, v1, f1);
      float gray = norm(angles[i], minAngle, maxAngle) * 127; 
      canvas.fill(63 + gray);
      canvas.beginShape();
      canvas.vertex(0, 0);
      canvas.vertex(w0.x, w0.y);
      canvas.vertex(w1.x, w1.y);
      //canvas.vertex(radiusBottom, 0);
      canvas.endShape(CLOSE);
      canvas.beginShape();
      canvas.vertex(0, 0);
      //canvas.vertex(-v.x, v.y);
      //canvas.vertex(-radiusBottom, 0);
      canvas.vertex(-w0.x, w0.y);
      canvas.vertex(-w1.x, w1.y);
      canvas.endShape(CLOSE);
    }

    canvas.noFill();
    canvas.stroke(255,255,0);
    canvas.beginShape();
    canvas.vertex(0, coneBottom);
    canvas.vertex(radiusBottom, coneBottom);
    canvas.vertex(radiusTop, coneHeight + coneBottom);
    canvas.vertex(-radiusTop, coneHeight + coneBottom);
    canvas.vertex(-radiusBottom, coneBottom);
    canvas.endShape(CLOSE);

    canvas.stroke(255);
    canvas.ellipseMode(RADIUS);
    float deltaAperture = aperture * PI - PI;
    canvas.arc(0, 0, domeRadius, domeRadius, -deltaAperture * 0.5, PI+deltaAperture * 0.5, PIE);

    canvas.endDraw();
    return canvas;
  }

  void display() {
    image(getCanvas(), margin, height-canvas.height-margin);
  }
}

boolean touchesInside(float p0x, float p0y, float p1x, float p1y) {
  return touchesInside(new PVector(p0x, p0y), new PVector(p1x, p1y), new PVector(0, 0));
}

boolean touchesInside(PVector p, PVector p1, PVector v) {
  float lambda = getLambda(p, p1, v);
  return lambda >= 0 && lambda <= 1;
}

float getLambda(PVector p, PVector p1, PVector v) {
  PVector dp = PVector.sub(p1, p);
  PVector dv = new PVector(dp.y, -dp.x);
  float den = (dp.x * dv.y - dp.y * dv.x);
  if (den == 0) {
    return 0;
  }
  float lambda = (dv.x * (p.y - v.y) - dv.y * (p.x - v.x)) / den;
  return lambda;
}

float distanceTo(float p0x, float p0y, float p1x, float p1y) {
  return distanceTo(new PVector(p0x, p0y), new PVector(p1x, p1y), new PVector(0, 0));
}

float distanceTo(PVector p, PVector p1, PVector v) {
  float lambda = getLambda(p, p1, v);
  PVector dp = PVector.sub(p1,p);
  return PVector.dist(new PVector(p.x + dp.x * lambda, p.y + dp.y * lambda), v);
}