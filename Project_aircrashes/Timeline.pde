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
  float myPadding = 2;
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

  void display(float currentTime) {
    pushStyle();

    noFill();
    //TODO: define padding!
    stroke(103);
    //stroke(255, 0, 0);
    //ellipse(width*0.5, height*0.5, (myRadius - myHeight*0.5) + 2, (myRadius - myHeight*0.5) + 2);
    //strokeCap(PROJECT);
    drawArcAround(0,TWO_PI);
    
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
      noStroke();
      rect(0, myRadius-myHeight, myHeight, myHeight);
      popMatrix();
      float phi = phi0-getPhiFromSides(nextWidth, myRadius);
      
      PVector pos;
      for (int year = startYear; year <= endYear; year+=yearInc) {
        pos = new PVector(0, myRadius);
        pos.rotate(phi);
        drawArcTextCentered(year + "", pos.x + width*0.5, pos.y+height*0.5);
        phi -= getPhiFromSides(yearContainerWidth, myRadius);
      }
      //draw current date
      int[] date = getDatumFromNormMoment(currentTime);
      String dateString = nf(date[0],2) + "/" + nf(date[1],2) + "/" + date[2];
      phi -= getPhiFromSides(textWidth(dateString)-yearContainerWidth, myRadius);
      
      stroke(255);
      noFill();
      drawArcAround(phi + HALF_PI, getPhiFromSides(textWidth(dateString), myRadius));
      pos = new PVector(0, myRadius);
      pos.rotate(phi);
      fill(0);
      drawArcTextCentered(dateString, pos.x + width*0.5, pos.y+height*0.5);
      
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
  
  void drawArcAround(float phi0, float deltaPhi) {
    ellipseMode(RADIUS);
    strokeWeight(myHeight + myPadding * 2);
    arc(width*0.5, height*0.5, (myRadius - myHeight*0.5) + 2, (myRadius - myHeight*0.5) + 2, phi0-deltaPhi*0.5, phi0+deltaPhi*0.5);
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