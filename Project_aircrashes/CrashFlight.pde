class CrashFlight {
  Datum myDatum;
  int geodeticRes = 100;
  float duration = 0.05;
  PVector dep, dst;
  boolean coordsValid;
  Timeline myTimeline;
  float myStartMoment, myEndMoment;
  float minRadius = 3 * scaleFactor, maxRadius = 300 * scaleFactor;
  float rOcc, rFat;
  Float progressTime;
  CrashFlight previousFlight = null, nextFlight = null;
  /*
  boolean finished = false, displayAll = false, pausable = false;
   float myTotalDuration;
   float FADE_IN_TIME = 0.2;
   float FADE_OUT_TIME = 0.2;
   float DISPLAY_TIME = 1.0;
   */

  CrashFlight(Datum d, Timeline tl) {
    myDatum = d;
    coordsValid = d.coordsValid();
    dep = new PVector(radians(d.depLatLng[0]), radians(d.depLatLng[1]));
    dst = new PVector(radians(d.dstLatLng[0]), radians(d.dstLatLng[1]));
    myTimeline = tl;
    myStartMoment = getNormalizedMoment(d, tl);
    myEndMoment = constrain(myStartMoment + duration, 0, 1);
    //   rFat = map(sqrt(d.fatalities), sqrt(MIN_FATALITIES), sqrt(MAX_FATALITIES), minRadius, maxRadius);
    //  rOcc = map(sqrt(d.occupants), sqrt(MIN_OCCUPANTS), sqrt(MAX_OCCUPANTS), minRadius, maxRadius);
    rFat = map(sqrt(d.fatalities), sqrt(0), sqrt(MAX_OCCUPANTS), minRadius, maxRadius);
    rOcc = map(sqrt(d.occupants), sqrt(0), sqrt(MAX_OCCUPANTS), minRadius, maxRadius);

    try {
      progressTime = phaseProgress.get(d.phaseCode);
      //println(phaseProgress.get(d.phaseCode), d.phaseCode);
    } 
    catch (Exception e) {
      e.printStackTrace();
      progressTime = 0.5;
    }
    //myTotalDuration = FADE_IN_TIME + progressTime + DISPLAY_TIME + FADE_OUT_TIME;
  }

  void display() {
    //println(FADE_TIME, TRAJECTORY_SHOW_TIME);

    //if (coordsValid && normTime >= myStartMoment && normTime <= myEndMoment) {

    float progress = TRAJECTORY_SHOW_TIME;
    if (progressTime == 0f) {
      progress = 0;
    } else if (progressTime < 1) {
      progress = map(TRAJECTORY_SHOW_TIME, 0, 1, 0, progressTime);
    }

    float globalAlpha = FADE_TIME * 255;
    //println("progress", progress);
    PVector planePosLatLon = getLatLonAtNormDist(dep, dst, progress);
    PVector planePosXY = getGeodeticPoint(planePosLatLon);
    noFill();
    strokeWeight(1 * scaleFactor);

    //drawGeodetic(dep, dst, geodeticRes);
    strokeWeight(2 * scaleFactor);
    //DEBUG
    //stroke(255, 0, 0);
    //drawGeodetic(dep, dst, geodeticRes);
    //
    stroke(255, globalAlpha);
    if (myDatum.isUnusual) {
      drawDashedGeodetic(dep, dst, geodeticRes, 0.5 * scaleFactor, 7 * scaleFactor);
    } else {
      drawDashedGeodetic(dep, dst, geodeticRes, 10 * scaleFactor, 20 * scaleFactor);
    }


    strokeWeight(4 * scaleFactor);
    drawGeodetic(dep, planePosLatLon);


    PVector depXY = getGeodeticPoint(dep);
    PVector dstXY = getGeodeticPoint(dst);

    noStroke();
    fill(255, globalAlpha);
    pushStyle();
    textFont(corpusFontBold);
    textSize(36 * scaleFactor);

    float crashRadius = rOcc * scaleFactor;

    float depAngle = atan2(depXY.y - height * 0.5, depXY.x - width * 0.5);
    float dstAngle = atan2(dstXY.y - height * 0.5, dstXY.x - width * 0.5);
    float planeAngle = atan2(planePosXY.y - height * 0.5, planePosXY.x - width * 0.5);

    float depRadius = PVector.dist(depXY, new PVector(width*0.5, height*0.5));
    float dstRadius = PVector.dist(dstXY, new PVector(width*0.5, height*0.5));
    float planeRadius = PVector.dist(planePosXY, new PVector(width*0.5, height*0.5)) - 15 * scaleFactor;

    float refRadius = rOcc * scaleFactor + 5;

    
    String[] depStrings = getTokens(myDatum.depShort);
    String[] dstStrings = getTokens(myDatum.dstShort);
    PFont[] fonts = new PFont[]{corpusFont, corpusFontBold, corpusFont};
    Float[] sizes = new Float[]{36 * scaleFactor, 36 * scaleFactor, 36 * scaleFactor};
    drawTangentialTextPolar(depStrings, fonts, sizes, null, depAngle, depRadius + max(refRadius, 30 * scaleFactor));
    drawTangentialTextPolar(dstStrings, fonts, sizes, null, dstAngle, dstRadius + max(refRadius, 30 * scaleFactor));
    //textAlign(CENTER, TOP);
    //drawTangentialTextPolar(myDatum.depShort, depAngle, depRadius + max(refRadius, 30 * scaleFactor));
    //drawTangentialTextPolar(myDatum.dstShort, dstAngle, dstRadius + max(refRadius, 30 * scaleFactor));
    //drawArcTextCenteredPolar(myDatum.depShort, depAngle, depRadius + max(refRadius, 30 * scaleFactor));
    //drawArcTextCenteredPolar(myDatum.dstShort, dstAngle, dstRadius + max(refRadius, 30 * scaleFactor));

    ellipseMode(RADIUS);
    fill(255, globalAlpha);
    noStroke();
    ellipse(depXY.x, depXY.y, 5*scaleFactor, 5*scaleFactor);
    ellipse(dstXY.x, dstXY.y, 5*scaleFactor, 5*scaleFactor);
    popStyle();

    //draw dot
    /*
      if (rOcc - rFat > 0) {
     stroke(GREEN,127);
     strokeWeight((rFat-rOcc) * scaleFactor);
     } else {
     noStroke();
     }
     */

    float radiusAnimationFactor = min(FADE_TIME, CRASH_INFO_SHOW_TIME);
    noStroke();
    fill(GREEN, 255*0.4);
    ellipse(planePosXY.x, planePosXY.y, rOcc * scaleFactor * radiusAnimationFactor, rOcc * scaleFactor * radiusAnimationFactor);
    fill(RED, 255*0.4);
    ellipse(planePosXY.x, planePosXY.y, rFat * scaleFactor * radiusAnimationFactor, rFat * scaleFactor * radiusAnimationFactor);
    pushStyle();
    //textAlign(CENTER, BOTTOM);
    textFont(corpusFontBold);
    textSize(60 * scaleFactor);
    textAlign(RIGHT, CENTER);
    fill(RED, radiusAnimationFactor*255);
    drawRadialText(myDatum.fatalities + "", planePosXY, depAngle + HALF_PI, PI, refRadius);
    textAlign(LEFT, CENTER);
    fill(GREEN, radiusAnimationFactor*255);
    //drawRadialText((myDatum.occupants - myDatum.fatalities) + "", planePosXY, depAngle - HALF_PI, 0, refRadius);
    drawRadialText(myDatum.occupants + "", planePosXY, depAngle - HALF_PI, 0, refRadius);
    popStyle();
  }
  
  @Override
  String toString() {
    return myDatum.toString();
  }
}

String[] getTokens(String src) {
  int i0 = src.indexOf("|");
  int i1 = src.indexOf("(");
  
  String s0 = "";
  String s1 = "";
  String s2 = "";
  if (i0 > 0) {
    s0 = src.substring(0, i0);
  }
  if (i1 > 0) {
    s2 = src.substring(i1, src.length());
  }
  if (i0 > 0 && i1 > 0) {
    s1 = src.substring(i0, i1);
  } else if (i1 > 0) {
    s1 = src.substring(0, i1);
  } else {
    s1 = src;
  }
  return new String[]{s0, s1, s2};
}