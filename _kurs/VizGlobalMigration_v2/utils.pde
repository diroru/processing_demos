boolean checkExistence(String a, String b, int year) {
  //String idAB = a + "+" + b + "+" + year;
  String idBA = b + "+" + a + "+" + year;
  if (uniqueFlows.contains(idBA)) {
    return true;
  } else {
    uniqueFlows.add(idBA);
  }
  return false;
}

void addTotal(HashMap<Integer, Integer> theTotal, int year, int vol) {
  Integer total = theTotal.get(year);
  if (total == null) {
    total = 0;
  }
  total = new Integer(total + vol);
  theTotal.put(year, total);
}

void addFlow(MigrationFlow theFlow) {
  ArrayList<MigrationFlow> flowsForYear = flows.get(theFlow.year);
  if (flowsForYear == null) {
    flowsForYear = new ArrayList<MigrationFlow>();
    flows.put(theFlow.year, flowsForYear);
  }
  flowsForYear.add(theFlow);
}

void drawBezier_v2(float x0, float y0, float x1, float y1, float w, float factor) {
  drawBezier_v2(new PVector(x0, y0), new PVector(x1, y1), w, factor);
}

void drawBezier_v2(PVector p0, PVector p1, float w, float factor) {
  PVector c = PVector.lerp(p0, p1, 0.5);
  PVector v0 = new PVector(p0.x, p0.y + (c.y - p0.y)*factor);
  PVector v1 = new PVector(p1.x, p1.y + (c.y - p1.y)*factor);
  PVector d0 = PVector.sub(v1, v0).normalize();
  PVector d1 = PVector.sub(v0, v1).normalize();
  PVector d0N = d0.rotate(HALF_PI);
  PVector d1N = d1.rotate(HALF_PI);
  d0N = d0N.mult(w * 0.5);
  d1N = d1N.mult(w * 0.5);

  ////////

  float theta = -factor * QUARTER_PI;
  PVector c0 = new PVector(cos(theta) * w * 0.5, sin(theta) * w * 0.5);
  PVector c1 = new PVector(-c0.x, -c0.y);

  //DRAW
  beginShape();
  vertex(p0.x - w *0.5, p0.y);
  vertex(p0.x + w *0.5, p0.y);
  bezierVertex(v0.x + c0.x, v0.y + c0.y, v0.x + c0.x, v0.y + c0.y, c.x + d1N.x, c.y + d1N.y);
  bezierVertex(v1.x + c0.x, v1.y + c0.y, v1.x + c0.x, v1.y + c0.y, p1.x + w * 0.5, p1.y);
  vertex(p1.x - w*0.5, p1.y);
  bezierVertex(v1.x + c1.x, v1.y + c1.y, v1.x + c1.x, v1.y + c1.y, c.x + d0N.x, c.y + d0N.y);
  bezierVertex(v0.x + c1.x, v0.y + c1.y, v0.x + c1.x, v0.y + c1.y, p0.x - w * 0.5, p0.y);
  endShape();
}


void drawBezier(float x0, float y0, float x1, float y1, float w, float factor) {
 drawBezier(new PVector(x0,y0), new PVector(x1, y1), w, factor); 
}

void drawBezier(PVector p0, PVector p1, float w, float factor) {
  stroke(0, 255, 0, 127);
  strokeWeight(2);
  //line(p0.x, p0.y, p1.x, p1.y);
  PVector c = PVector.lerp(p0, p1, 0.5);
  PVector v0 = new PVector(p0.x, p0.y + (c.y - p0.y)*factor);
  PVector v1 = new PVector(p1.x, p1.y + (c.y - p1.y)*factor);
  PVector d0 = PVector.sub(v1, v0);
  PVector d1 = PVector.sub(v0, v1);
  PVector d0N = d0.rotate(HALF_PI);
  PVector d1N = d1.rotate(HALF_PI);
  d0N = d0N.normalize().mult(w * 0.5);
  d1N = d1N.normalize().mult(w * 0.5);

  //line(p0.x, p0.y, v0.x, v0.y);
  //line(p1.x, p1.y, v1.x, v1.y);
  //line(v0.x, v0.y, v1.x, v1.y);
  //line(c.x, c.y, c.x + d0N.x, c.y + d0N.y);
  //line(c.x, c.y, c.x + d1N.x, c.y + d1N.y);

  //float lambdaInner = getLambda(new PVector (p1.x - w*0.5 - c.x + d0N.x, p1.y - w*0.5 - c.y + d0N.y), new PVector(0, -1), new PVector((v1.x - v0.x)*0.5, (v1.y - v0.y)*0.5));
  PVector a0 = new PVector (p1.x - w*0.5 - c.x - d0N.x, p1.y - c.y - d0N.y);
  PVector a1 = new PVector (p1.x + w*0.5 - c.x - d1N.x, p1.y - c.y - d1N.y);
  stroke(255, 255, 0);
  //line(c.x + d0N.x, c.y + d0N.y, c.x + d0N.x + a0.x, c.y + d0N.y + a0.y);
  float lambdaInner = getLambda(a0, new PVector(0, -1), PVector.sub(v1, v0));
  float lambdaOuter = getLambda(a1, new PVector(0, -1), PVector.sub(v1, v0));
  PVector b0 = new PVector(0,  lambdaOuter);
  PVector b1 = new PVector(0,  lambdaInner);
  PVector b2 = new PVector(0, -lambdaInner);
  PVector b3 = new PVector(0, -lambdaOuter);

  stroke(255, 0, 0);
  //line(p1.x - w*0.5, p1.y, p1.x -w*0.5 + b2.x, p1.y + b2.y);
  //line(p1.x + w*0.5, p1.y, p1.x +w*0.5 + b3.x, p1.y + b3.y);
  //line(p0.x - w*0.5, p0.y, p0.x -w*0.5 + b0.x, p0.y + b0.y);
  //line(p0.x + w*0.5, p0.y, p0.x +w*0.5 + b1.x, p0.y + b1.y);
  float f = 3.0;
  //fill(255,63);
  noStroke();
  beginShape();
  vertex(p0.x - w*0.5, p0.y);
  vertex(p0.x + w*0.5, p0.y);
  bezierVertex(p0.x + w * 0.5, p0.y + lambdaInner*f, p1.x + w * 0.5, p1.y - lambdaOuter*f, p1.x + w * 0.5, p1.y);
  //bezierVertex(p0.x + w * 0.5, p0.y + lambdaInner*f, p1.x + w * 0.5, p1.y - lambdaOuter*f, c.x + d1N.x, c.y + d1N.y);
  vertex(p1.x - w*0.5, p1.y);
  bezierVertex(p1.x - w*0.5, p1.y - lambdaInner*f, p0.x - w*0.5, p0.y + lambdaOuter*f, p0.x - w*0.5, p0.y);
  endShape();

}


float getLambda(PVector a, PVector b, PVector c) {
  //check corner cases!!!
  return -(c.y * a.x - c.x * a.y) / (c.y *  b.x - b.y * c.x);
}


void drawBezierOld(float x0, float y0, float x1, float y1, float w, float bezierFactor) {
  beginShape();
  vertex(x0 - w * 0.5, y0);
  vertex(x0 + w * 0.5, y0);
  float cx0 = x0 + w * 0.5;
  float cy0 = y0 + (y1 - y0) * bezierFactor;
  float cx1 = x1 + w * 0.5;
  float cy1 = y1 - (y1 - y0) * bezierFactor;
  bezierVertex(cx0, cy0, cx1, cy1, x1 + w * 0.5, y1);
  //vertex(x1 + w * 0.5, y1);
  vertex(x1 - w * 0.5, y1);
  float cx2 = x1 - w * 0.5;
  float cy2 = y1 - (y1 - y0) * bezierFactor;

  float cx3 = x0 - w * 0.5;
  float cy3 = y0 + (y1 - y0) * bezierFactor;
  bezierVertex(cx2, cy2, cx3, cy3, x0 - w * 0.5, y0);
  endShape();
}