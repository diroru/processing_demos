class MigrationFlow {
  Country origin, destination;
  int year;
  Long flow;

  MigrationFlow(Country theOrigin, Country theDestination, int theYear, Long theFlow) {
    origin = theOrigin;
    destination = theDestination;
    year = theYear;
    flow = theFlow;
    origin.addEmigrationFlow(this);
    destination.addImmigrationFlow(this);
  }

  void display(PGraphics g, float maxHeight, float y0) {
    float y = y0 + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    g.beginShape();
    g.vertex(origin.cx(), origin.cy());
    g.vertex(origin.cx(), y);
    g.vertex(destination.cx(), y);
    g.vertex(destination.cx(), destination.cy());
    g.endShape();
  }

  void displayRounded(PGraphics g, float maxHeight, float y0) {
    float y = y0 + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    drawRoundedLine(g, origin.cx(), origin.cy(), origin.cx(), y, destination.cx(), y, destination.cx(), destination.cy(), 0);
  }

  void displayBezier(PGraphics g, float maxHeight, float y) {
    float x0 = origin.cx();
    float y0 = origin.cy();
    float x1 = x0;
    float y1 = y + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    float x2 = destination.cx();
    float y2 = y1;
    float x3 = x2;
    float y3 = destination.cy();
    g.stroke(255, map(flow, 0, MIGRATION_FLOW_MAX, 4, 255));
    g.beginShape();
    g.vertex(x0, y0);
    g.bezierVertex(x1, y1, x1, y1, (x1+x2)*0.5, y1);
    g.bezierVertex(x2, y2, x2, y2, x3, y3);
    g.endShape();
  }
}

void drawRoundedLine(PGraphics pg, float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float maxRadius) {
  drawRoundedLine(pg, new PVector(x0, y0), new PVector(x1, y1), new PVector(x2, y2), new PVector(x3, y3), maxRadius);
}

void drawRoundedLine(PGraphics pg, PVector p0, PVector p1, PVector p2, PVector p3, float maxRadius) {
  if (p1.x > p2.x) {
    PVector temp = p1.copy();
    p1 = p2.copy();
    p2 = temp.copy();
    temp = p0.copy();
    p0 = p3.copy();
    p3 = temp.copy();
  }
  
  float y1 = min(p0.y, p3.y);
  float y0 = p1.y;
  float x0 = min(p1.x, p2.x);
  float x1 = max(p1.x, p2.x);
  float radius = min((x1 - x0)* 0.5, y1 - y0);
  if (maxRadius > 0) {
    radius = min(radius, maxRadius);
  }

  pg.beginShape();
  pg.vertex(p0.x, p0.y);
  pg.vertex(p0.x, p1.y + radius);
  pg.quadraticVertex(p0.x, p1.y, p1.x + radius, p1.y);
  //vertex(p1.x + radius,p1.y);
  pg.vertex(p2.x - radius, p1.y);
  pg.quadraticVertex(p2.x, p2.y, p2.x, p2.y + radius);
  //vertex(p2.x, p2.y + radius);
  pg.vertex(p3.x, p3.y);
  pg.endShape();

  /*
  beginShape();
   vertex(p0.x,p0.y);
   vertex(p0.x,p1.y + radius);
   vertex(p1.x + radius,p1.y);
   vertex(p2.x - radius,p1.y);
   vertex(p2.x, p2.y + radius);
   vertex(p3.x, p3.y);
   endShape();
   */
  /*
  stroke(255,255,0);
   line(p0.x,p0.y,p1.x,p1.y);
   line(p1.x,p1.y,p2.x,p2.y);
   line(p2.x,p2.y,p3.x,p3.y);
   */
}