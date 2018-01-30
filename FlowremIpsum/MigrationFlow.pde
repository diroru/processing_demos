class MigrationFlow implements Comparable {
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
    drawRoundedLine(g, origin.cx(), origin.cy(), origin.cx(), y, destination.cx(), y, destination.cx(), destination.cy(), 10, WHITE, 127); //last number is amount of roundness
  }

  void displayNormal(PGraphics pg, LayoutInfo theLayout) {
    float flowNorm = getNormFlow(flow);    
    float yTop = theLayout.y + theLayout.h - map(flowNorm, 0, 1, 0, theLayout.h  );
    float alpha =  map(flowNorm, 0, 1, 0, 255);
    drawRoundedLine(pg, origin.cx(), origin.cy(), origin.cx(), yTop, destination.cx(), yTop, destination.cx(), destination.cy(), 10, WHITE, alpha); //last number is amount of roundness
  }

  void displayHighlighted(PGraphics pg, LayoutInfo theLayout, Country activeCountry) {
    if (activeCountry.name.equals(origin.name) || activeCountry.name.equals(destination.name)) {
      color c = activeCountry.name.equals(origin.name) ? SECONDARY : PRIMARY;
      float flowNorm = getNormFlow(flow);
      float yTop = theLayout.y + theLayout.h - map(flowNorm, 0, 1, 0, theLayout.h);
      drawRoundedLine(pg, origin.cx(), origin.cy(), origin.cx(), yTop, destination.cx(), yTop, destination.cx(), destination.cy(), 10, c, 127); //last number is amount of roundness
    }
  }

  void displayAsTop(PGraphics pg, LayoutInfo theLayout, Country activeCountry, int No) {
    color c = SECONDARY;
    if (activeCountry != null && activeCountry.name.equals(origin.name)) {
      c = PRIMARY;
    }
    float flowNorm = getNormFlow(flow);
    float yTop = theLayout.y + theLayout.h - map(flowNorm, 0, 1, 0, theLayout.h);
    pg.beginShape(POLYGON);
    drawRoundedLine(pg, origin.cx(), origin.cy(), origin.cx(), yTop, destination.cx(), yTop, destination.cx(), destination.cy(), 10, c, 127); //last number is amount of roundness
    pg.endShape();
    switch(No) {
    case 0:
      pg.textFont(TOPNUMBER);
      break;
    case 1:
      pg.textFont(SECONDNUMBER);
      break;
    case 2:
      pg.textFont(THIRDNUMBER);
      break;
    }
    pg.textAlign(BOTTOM, LEFT);
    pg.fill(WHITE);
    pg.noStroke();
    pg.text(flow + "", min(origin.cx() + 10, destination.cx() + 10), yTop - 10);
    pg.textAlign(TOP, LEFT);
    pg.fill(PRIMARY);
    pg.textFont(INFOHEADLINE);
    pg.text("People moved from " + origin.name + " to " + destination.name, min(origin.cx() + 10, destination.cx() + 10), yTop + 25);
  }

  //COMPARISON
  @Override
    public boolean equals(Object obj) {
    if (!(obj instanceof MigrationFlow)) {
      return false;
    }
    MigrationFlow mf = ((MigrationFlow) obj);
    return mf.origin.equals(this.origin) && mf.destination.equals(this.destination) && mf.year == this.year;
  }

  @Override
    public int compareTo(Object o) {
    MigrationFlow other = (MigrationFlow) o;
    return int(other.flow - this.flow);
  }
  boolean isActive(Country activeCountry) {
    return this.origin.name.equals(activeCountry.name) || this.destination.name.equals(activeCountry.name);
  }
}


float getNormFlow(float flow) {
  //return norm(flow, 0, MIGRATION_FLOW_MAX);
  float result = constrainedLogScale(flow, MIGRATION_FLOW_LOWER_LIMIT, MIGRATION_FLOW_MAX);
  //println(result);
  return result;
}

void drawRoundedLine(PGraphics pg, float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float maxRadius, color c, float alpha) {
  drawRoundedLine(pg, new PVector(x0, y0), new PVector(x1, y1), new PVector(x2, y2), new PVector(x3, y3), maxRadius, c, alpha);
}

void drawRoundedLine(PGraphics pg, PVector p0, PVector p1, PVector p2, PVector p3, float maxRadius, color c, float alpha) {
  pg.noFill();
  pg.stroke(c, alpha);
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

  //pg.beginShape(); //don’t forget to call it in outer loop!!!
  pg.vertex(p0.x, p0.y);
  pg.vertex(p0.x, p1.y + radius);
  pg.quadraticVertex(p0.x, p1.y, p1.x + radius, p1.y);
  //vertex(p1.x + radius,p1.y);
  pg.vertex(p2.x - radius, p1.y);
  pg.quadraticVertex(p2.x, p2.y, p2.x, p2.y + radius);
  //vertex(p2.x, p2.y + radius);
  pg.vertex(p3.x, p3.y);
  //pg.endShape(); //don’t forget to call it in outer loop!!!
}