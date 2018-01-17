class Timeline {
  //radius is the outer one
  float myRadius, myHeight;
  int startYear, endYear;
  float yearContainerWidth;
  int repeatCount;
  float startAngle;
  PFont myFont;
  color bgColor;
  int yearInc = 5;
  float myFontSize;
  //TODO: yearInc!!!

  Timeline(float theRadius, float theHeight, float theStartAngle, float theYearContainerWidth, int theStartYear, int theEndYear, int theRepeatCount, PFont theFont, float theFontSize) {
    myRadius = theRadius;
    myHeight = theHeight;
    startAngle = theStartAngle;
    yearContainerWidth = theYearContainerWidth;
    startYear = theStartYear;
    endYear = theEndYear;
    repeatCount = theRepeatCount;
    myFont = theFont;
    myFontSize = theFontSize;
  }

  void display() {
    pushStyle();

    noFill();
    //TODO: define padding!
    float padding = 2;
    strokeWeight(myHeight + padding * 2);
    stroke(103);
    //stroke(255, 0, 0);
    ellipseMode(RADIUS);
    ellipse(width*0.5, height*0.5, (myRadius - myHeight*0.5) + 2, (myRadius - myHeight*0.5) + 2);

    noStroke();
    for (int i = 0; i < repeatCount; i++) {
      float phi0 = startAngle + i * TWO_PI / repeatCount;
      textFont(myFont);
      textSize(myFontSize);
      pushMatrix();
      translate(width*0.5, height*0.5);
      rotate(phi0);
      //TODO: button
      float nextWidth = myHeight + 20;
      fill(255);
      rect(0, myRadius-myHeight, myHeight, myHeight);
      popMatrix();
      float phi = phi0-getPhiFromSides(nextWidth, myRadius) ;

      for (int year = startYear; year <= endYear; year+=yearInc) {
        PVector pos = new PVector(0, myRadius);
        pos.rotate(phi);
        drawArcText(year + "", pos.x + width*0.5, pos.y+height*0.5);
        phi -= getPhiFromSides(yearContainerWidth, myRadius);
      }
    }
    popStyle();
  }

  void drawDate(Datum d, float rad, float deltaRadius) {
    //float moment = d.getNormMoment(startYear,endYear);
    float moment = getNormalizedMomentNoDayNoMonth(d, this);
    pushMatrix();
    translate(width*0.5, height*0.5);
    for (int i = 0; i < repeatCount; i++) {
      float phi0 = startAngle + i * TWO_PI / repeatCount;
      textFont(myFont);
      textSize(myFontSize);

      float nextWidth = myHeight + 20;
      float phi = phi0-getPhiFromSides(nextWidth, myRadius);
      float startPhi = phi;
      for (int year = startYear; year < endYear; year+=yearInc) {
        phi -= getPhiFromSides(yearContainerWidth, myRadius);
      }
      //phi -= getPhiFromSides(textWidth(endYear + ""), myRadius);
      float endPhi = phi;

      noStroke();

      float theta = map(moment, 0, 1, startPhi, endPhi);
      PVector pos = new PVector(0, myRadius + deltaRadius);
      pos.rotate(theta);
      ellipseMode(RADIUS);
      fill(255, 255, 0, 63);
      ellipse(pos.x, pos.y, rad, rad);
      
      pos = new PVector(0, myRadius + deltaRadius);
      pos.rotate(startPhi);
      fill(0, 255, 0, 63);
      ellipse(pos.x, pos.y, rad, rad);
      
      pos = new PVector(0, myRadius + deltaRadius);
      pos.rotate(endPhi);
      fill(0, 255, 0, 63);
      ellipse(pos.x, pos.y, rad, rad);
    }
    popMatrix();
  }
  
  PVector getCrashDotPosition(Datum d, float deltaRadius) {
    //float moment = d.getNormMoment(startYear,endYear);
    float moment = getNormalizedMomentNoDayNoMonth(d, this);
    //pushMatrix();
    //translate(width*0.5, height*0.5);
    //for (int i = 0; i < repeatCount; i++) {
      //float phi0 = startAngle + i * TWO_PI / repeatCount;
      float phi0 = startAngle;
      textFont(myFont);
      textSize(myFontSize);

      float nextWidth = myHeight + 20;
      float phi = phi0-getPhiFromSides(nextWidth, myRadius);
      float startPhi = phi;
      for (int year = startYear; year < endYear; year+=yearInc) {
        phi -= getPhiFromSides(yearContainerWidth, myRadius);
      }
      //phi -= getPhiFromSides(textWidth(endYear + ""), myRadius);
      float endPhi = phi;

      noStroke();

      float theta = map(moment, 0, 1, startPhi, endPhi);
      PVector pos = new PVector(0, myRadius + deltaRadius);
      pos.rotate(theta);
      pos.add(new PVector(width *0.5, height*0.5));

    //}
    //popMatrix();
    return pos;
  }
}