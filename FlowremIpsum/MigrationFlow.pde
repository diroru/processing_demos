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

  void display_v2(PGraphics g, float maxHeight, float y0) {
    float y = y0 + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    g.beginShape();
    g.vertex(origin.cx(), y0 + maxHeight);
    g.vertex(origin.cx(), y);
    g.vertex(destination.cx(), y);
    g.vertex(destination.cx(), y0 + maxHeight);
    g.endShape();
  }

  void display_v3(PGraphics g, float maxHeight, float y) {
    float x0 = origin.cx();
    float y0 = origin.cy();
    float x1 = x0;
    float y1 = y + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    float x2 = destination.cx();
    float y2 = y1;
    float x3 = x2;
    float y3 = destination.cy();
    drawArcLine(g,x0,y0,x1,y1,x2,y2,x3,y3);  
  }

  void display_v4(PGraphics g, float maxHeight, float y) {
    float x0 = origin.cx();
    float y0 = origin.cy();
    float x1 = x0;
    float y1 = y + map(flow, 0, MIGRATION_FLOW_MAX, maxHeight, 0);
    float x2 = destination.cx();
    float y2 = y1;
    float x3 = x2;
    float y3 = destination.cy();
    g.stroke(255,map(flow, 0, MIGRATION_FLOW_MAX, 4, 255));
    g.beginShape();
    g.vertex(x0,y0);
    g.bezierVertex(x1,y1,x1,y1,(x1+x2)*0.5,y1);
    g.bezierVertex(x2,y2,x2,y2,x3,y3);
    g.endShape();
  }
  
}