class MigrationFlow {
  MigrationRelation myRelation;
  HashMap<Integer, Long> flowsByYear = new HashMap<Integer, Long>();
  HashMap<Integer, Float> flowsByYearNormLog = new HashMap<Integer, Float>(); //logscaled!
  HashMap<Integer, Float> flowsByYearNormLinear = new HashMap<Integer, Float>(); //logscaled!
  //HashMap<Integer, Float> heightsByYearLog = new HashMap<Integer, Float>();
  //HashMap<Integer, Float> heightsByYearLinear = new HashMap<Integer, Float>();
  int myLayoutMode = LAYOUT_ABOVE_MIDDLE;
  float myPadding = 10;
  float myMargin = 20;
  float myReferenceHeight = 0f;

  LayoutInfo myLayout;
  boolean _hover;

  //those will be animated
  //float myHeight;
  //float myAlphaFactor = 1f;
  //float myFlowNorm;

  MigrationFlow(MigrationRelation theRelation, LayoutInfo theLayout) {
    myRelation = theRelation;
    myLayout = theLayout;

    myRelation.origin.addEmigrationFlow(this);
    myRelation.destination.addImmigrationFlow(this);
    //myHeight = 0f;
    //myFlowNorm = 0f;
  }

  MigrationFlow(Country theOrigin, Country theDestination, LayoutInfo theLayout) {
    this(new MigrationRelation(theOrigin, theDestination), theLayout);
  }

  void addFlow(int theYear, Long theFlow) {
    //TODO: do error checking here?
    Long existingFlow = flowsByYear.get(theYear);
    if (existingFlow == null) {
      flowsByYear.put(theYear, theFlow);
      flowsByYearNormLog.put(theYear, calcNormFlow(this, theFlow, false));
      flowsByYearNormLinear.put(theYear, calcNormFlow(this, theFlow, true));
      //addHeight(theYear, theFlow);
    } else {
      println("flow already exists", theYear, " : ", existingFlow, theFlow);
    }
  }

  Long getFlow(int theYear) {
    Long result = flowsByYear.get(theYear);
    if (result == null) {
      result = 0L;
    }
    return result;
  }

  /*
  void addHeight(int theYear, Long theFlow) {
   float heightLog = constrainedLogScale(theFlow, MIGRATION_FLOW_LOWER_LIMIT, MIGRATION_FLOW_MAX) * myLayout.h;
   float heightLinear = norm(theFlow, 0, MIGRATION_FLOW_MAX) * myLayout.h;
   heightsByYearLinear.put(theYear, heightLinear);
   heightsByYearLog.put(theYear, heightLinear);
   }
   */

  Float getNormFlow(int theYear, int theCurrentScaleMode) {
    switch(theCurrentScaleMode) {
    case SCALE_MODE_LINEAR:
      return getNormFlow(theYear, true);
    case SCALE_MODE_LOG:
      return getNormFlow(theYear, false);
    }
    return getNormFlow(theYear, false);
  }

  Float getNormFlow(int theYear, boolean linear) {
    Float result = linear ? flowsByYearNormLinear.get(theYear) : flowsByYearNormLog.get(theYear);
    if (result == null) {
      result = 0f;
    }
    return result;
  }

  Float getNormFlowLog(int theYear) {
    return getNormFlow(theYear, false);
  }

  Float getNormFlowLinear(int theYear) {
    return getNormFlow(theYear, true);
  }

  FormattedText getFormattedText(int no) {
    int flow = floor(getFlow(currentYear));
    /*    
     pg.textAlign(BOTTOM, LEFT);
     pg.text(flow + "", min(origin().cx() + 10, destination().cx() + 10), yTop - 10);
     pg.textAlign(TOP, LEFT);
     pg.textFont(INFOHEADLINE);
     pg.text("People moved from " + origin().name + " to " + destination().name, min(origin().cx() + 10, destination().cx() + 10), yTop + 25);
     */
    String s0 = flow + "";
    PFont f0 = THIRDNUMBER;
    switch(no) {
    case 0:
      f0 = TOPNUMBER;
      break;
    case 1:
      f0 = SECONDNUMBER;
      break;
    }
    String s1 = "People moved from " + origin().name + " to " + destination().name;
    PFont f1 = INFOHEADLINE;

    float yTop =  myLayout.y + myLayout.h - myHeight();
    PVector origin = new PVector(min(origin().cx(), destination().cx()), yTop);
    float theReferenceWidth = abs(origin().cx() -  destination().cx());
    myReferenceHeight = f0.getDefaultSize() + myMargin;
    
    FormattedText result = new FormattedText(new ArrayList<String>(Arrays.asList(s0, s1)), new ArrayList<PFont>(Arrays.asList(f0, f1)), new ArrayList<Float>(Arrays.asList(myMargin, myMargin)), origin, theReferenceWidth, myReferenceHeight, LAYOUT_ABOVE_MIDDLE, myPadding);
    return result;
  }

  Float getHeight(int theYear, int scaleMode) {
    Float result = scaleMode == SCALE_MODE_LINEAR ? getNormFlowLinear(theYear) * myLayout.h : getNormFlowLog(theYear) * myLayout.h;
    return result;
  }

  Float getHeight(int theYear, boolean linear) {
    Float result = linear ? getNormFlowLinear(theYear) * myLayout.h : getNormFlowLog(theYear) * myLayout.h;
    return result;
  }

  Float getHeightLinear(int theYear) {
    return getHeight(theYear, true);
  }

  Float getHeightLog(int theYear) {
    return getHeight(theYear, false);
  }

  void displayNormal(PGraphics pg) {
    float theAlpha =  map(myFlowNorm(currentScaleMode), 0, 1, 0, 255) * FLOW_ALPHA_FACTOR;
    drawLine(pg, WHITE, theAlpha);
  }

  float myHeight() {
    return myFlowNorm(currentScaleMode) * myLayout.h;
  }

  void drawLine(PGraphics pg) {
    drawLine(pg, WHITE, 255);
  }

  void drawLine(PGraphics pg, color theColor, float theAlpha) {
    float x0 = min(myRelation.origin.cx(), myRelation.destination.cx());
    float x1 = max(myRelation.origin.cx(), myRelation.destination.cx());
    float y0 = myLayout.y + myLayout.h;
    float y1 = myLayout.y + myLayout.h - myHeight();
    drawRoundedLine(pg, x0, x1, y0, y1, 10, theColor, theAlpha); //last number is amount of roundness
    if (myHeight() > myLayout.h) {
      //println(this, flowsByYear.get(currentYear), myFlowNorm(currentScaleMode));
    }
  }

  void displayHighlighted(PGraphics pg, Country activeCountry) {

    if (originEquals(activeCountry) || destinationEquals(activeCountry)) {
      color c = originEquals(activeCountry) ? SECONDARY : PRIMARY;
      drawLine(pg, c, 255);
    }
  }

  void displayHover(PGraphics pg) {
    float yTop = myLayout.y + myLayout.h - myHeight();
    color c = PRIMARY;
    pg.beginShape(POLYGON);
    drawLine(pg, c, 255);
    pg.endShape();
    pg.textFont(THIRDNUMBER);

    pg.pushMatrix();
    pg.translate(0, 0, 10);
    pg.textAlign(BOTTOM, LEFT);
    pg.fill(WHITE);
    pg.noStroke();
    pg.text(floor(getFlow(currentYear)) + "", min(origin().cx() + 10, destination().cx() + 10), yTop - 10);
    pg.textAlign(TOP, LEFT);
    pg.fill(c);
    pg.textFont(INFOHEADLINE);
    pg.text("People moved from " + origin().name + " to " + destination().name, min(origin().cx() + 10, destination().cx() + 10), yTop + 25);
    pg.popMatrix();
  }

  Country origin() {
    return myRelation.origin;
  }

  Country destination() {
    return myRelation.destination;
  }

  void displayWithInfo(PGraphics pg) {
    color c = PRIMARY;
    float yTop =  myLayout.y + myLayout.h - myHeight();
    int flow = floor(getFlow(currentYear));
    pg.beginShape(POLYGON);
    pg.stroke(c);
    drawLine(pg, c, 127);
    pg.endShape();
    pg.textFont(THIRDNUMBER); //TODO
    pg.pushMatrix();
    pg.translate(0, 0, 10);
    pg.textAlign(BOTTOM, LEFT);
    pg.fill(WHITE);
    pg.noStroke();
    pg.text(flow + "", min(origin().cx() + 10, destination().cx() + 10), yTop - 10);
    pg.textAlign(TOP, LEFT);
    pg.fill(c);
    pg.textFont(INFOHEADLINE);
    pg.text("People moved from " + origin().name + " to " + destination().name, min(origin().cx() + 10, destination().cx() + 10), yTop + 25);
    pg.popMatrix();
  }


  void displayAsTop(PGraphics pg, Country activeCountry, int No) {

    color c = PRIMARY;
    if (activeCountry != null && originEquals(activeCountry)) {
      c = SECONDARY;
    }
    float flowNorm = myFlowNorm(currentScaleMode);
    float yTop =  myLayout.y + myLayout.h - myHeight();
    int flow = floor(getFlow(currentYear));
    pg.beginShape(POLYGON);
    pg.stroke(c);
    drawLine(pg, c, 127);
    //drawRoundedLine(pg, origin.cx(), origin.cy(), origin.cx(), yTop, destination.cx(), yTop, destination.cx(), destination.cy(), 10, c, 127); //last number is amount of roundness
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
    default:
      pg.textFont(THIRDNUMBER);
      break;
    }
    float x0 = min(origin().cx(), destination().cx());
    float x1 = max(origin().cx(), destination().cx());
    float x = x0 + myPadding;
    float y = yTop + myPadding;
    float myReferenceWidth = x1 - x0;
    
    switch(myLayoutMode) {
    case LAYOUT_ABOVE_MIDDLE:
      pg.textAlign(LEFT, TOP);
      y -= myReferenceHeight;
      break;
    case LAYOUT_BELOW_MIDDLE:
      pg.textAlign(LEFT, TOP);
      break;
    case LAYOUT_BELOW_LEFT:
      pg.textAlign(RIGHT, TOP);
      x -= myPadding * 2;
      break;
    case LAYOUT_BELOW_RIGHT:
      pg.textAlign(LEFT, TOP);
      x += myReferenceWidth;
      break;
    case LAYOUT_ABOVE_LEFT:
      pg.textAlign(RIGHT, TOP);
      y -= myReferenceHeight;
      x -= myPadding * 2;
      break;
    case LAYOUT_ABOVE_RIGHT:
      pg.textAlign(LEFT, TOP);
      y -= myReferenceHeight;
      x += myReferenceWidth;
      break;
    }
    
    pg.pushMatrix();
    pg.translate(0, 0, 10);
    pg.fill(WHITE);
    pg.noStroke();
    pg.text(flow + "", x,y);
    pg.fill(c);
    pg.textFont(INFOHEADLINE);
    pg.text("People moved from " + origin().name + " to " + destination().name, x, y + myReferenceHeight - myMargin * 0.5);
    pg.popMatrix();
  }

  boolean isHover() {
    return _hover;
  }

  void hover(PVector m) {
    hover(m.x, m.y);
  }

  void hover(float x, float y) {
    float xMin = min(origin().cx(), destination().cx());
    float xMax = max(origin().cx(), destination().cx());

    float yMin = myLayout.y + myLayout.h  - myHeight();
    float yMax = myLayout.y + myLayout.h;
    //println(xMin, xMax, " | ", yMin, yMax, " | ", x, y);
    _hover = x >= xMin && x <= xMax && y >= yMin && y <= yMax;
  }

  /*
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
   
   
   float getHeight(LayoutInfo theLayout) {
   float flowNorm = getNormFlow(flow);
   float result = theLayout.h - map(flowNorm, 0, 1, 0, theLayout.h);
   //println(theLayout.h, map(flowNorm, 0, 1, 0, theLayout.h));
   return result;
   }
   */

  boolean destinationEquals(Country c) {
    return myRelation.destination.equals(c);
  }

  boolean originEquals(Country c) {
    return myRelation.origin.equals(c);
  }

  @Override
    String toString() {
    return myRelation.toString();
  }

  float myFlowNorm(int theCurrentScaleMode) {
    int y0 = floor(fractionalYear);
    int y1 = ceil(fractionalYear);
    //int y1 = currentYear;
    float dy = fractionalYear - y0;
    //float dy = 1f - (fractionalYear - y0) / (y1 - y0);
    float f0 = getNormFlow(y0, theCurrentScaleMode);
    float f1 = getNormFlow(y1, theCurrentScaleMode);
    float result = (f1-f0) * dy + f0;
    if (Float.isNaN(result)) {
      result = 0f;
    }
    return result;
    //return getNormFlow(currentYear, theCurrentScaleMode);
  }
}

float calcNormFlow(MigrationFlow mf, float flow, boolean linear) {
  float result = linear ? norm(flow, 0, MIGRATION_FLOW_MAX) : constrainedLogScale(flow, MIGRATION_FLOW_LOWER_LIMIT, MIGRATION_FLOW_MAX);
  if (result > 1) {
    println(mf, flow, MIGRATION_FLOW_MAX, norm(flow, 0, MIGRATION_FLOW_MAX), constrainedLogScale(flow, MIGRATION_FLOW_LOWER_LIMIT, MIGRATION_FLOW_MAX));
  }
  return result;
}

float calcNormFlow(MigrationFlow mf, float flow) {
  return calcNormFlow(mf, flow, true);
}

void drawRoundedLine(PGraphics pg, float x0, float x1, float y0, float y1, float maxRadius, color c, float alpha) {
  drawRoundedLine(pg, new PVector(x0, y0), new PVector(x0, y1), new PVector(x1, y1), new PVector(x1, y0), maxRadius, c, alpha);
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