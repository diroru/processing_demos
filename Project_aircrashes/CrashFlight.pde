class CrashFlight {
  Datum myDatum;
  int geodeticRes = 100;
  float duration = 0.05;
  PVector dep, dst;
  boolean coordsValid;
  Timeline myTimeline;
  float myStartMoment, myEndMoment;
  float minRadius = 3, maxRadius = 20;
  float rOcc, rFat;
  Float maxProgress;
  CrashFlight previousFlight = null, nextFlight = null;

  CrashFlight(Datum d, Timeline tl) {
    myDatum = d;
    coordsValid = d.coordsValid();
    dep = new PVector(radians(d.depLatLng[0]), radians(d.depLatLng[1]));
    dst = new PVector(radians(d.dstLatLng[0]), radians(d.dstLatLng[1]));
    myTimeline = tl;
    myStartMoment = getNormalizedMoment(d, tl);
    myEndMoment = constrain(myStartMoment + duration, 0, 1);
    rFat = map(sqrt(d.fatalities), sqrt(MIN_FATALITIES), sqrt(MAX_FATALITIES), minRadius, maxRadius);
    rOcc = map(sqrt(d.occupants), sqrt(MIN_OCCUPANTS), sqrt(MAX_OCCUPANTS), minRadius, maxRadius);
    try {
      maxProgress = phaseProgress.get(d.phaseCode);
      //println(phaseProgress.get(d.phaseCode), d.phaseCode);
    } 
    catch (Exception e) {
      e.printStackTrace();
      maxProgress = 0.5;
    }
  }

  void update(float normTime) {
  }

  void display(float normTime) {

    //if (coordsValid && normTime >= myStartMoment && normTime <= myEndMoment) {

    //float progress = norm(normTime, myStartMoment, myEndMoment);
    float progress = normTime;
    boolean showStats = false;
    if (progress >= maxProgress) {
      showStats = true;
      progress = maxProgress;
    }
    PVector planePos = getGeodeticAtNormDist(dep, dst, progress);
    PVector planePosXY = lngLatToXY(planePos);
    noFill();
    strokeWeight(1 * scaleFactor);

    //drawGeodetic(dep, dst, geodeticRes);
    strokeWeight(2 * scaleFactor);
    //DEBUG
    //stroke(255, 0, 0);
    //drawGeodetic(dep, dst, geodeticRes);
    //
    stroke(255);
    if (myDatum.isUnusual) {
      drawDashedGeodetic(dep, dst, geodeticRes, 0.5 * scaleFactor, 7 * scaleFactor);
    } else {
      drawDashedGeodetic(dep, dst, geodeticRes, 10 * scaleFactor, 20 * scaleFactor);
    }


    strokeWeight(4 * scaleFactor);
    drawGeodetic(dep, planePos, geodeticRes);


    PVector depXY = lngLatToXY(dep);
    PVector dstXY = lngLatToXY(dst);
    noStroke();
    fill(255);
    pushStyle();
    textSize(18 * scaleFactor);
    //drawArcTextCentered(myDatum.depCountry, depXY);
    //drawArcTextCentered(myDatum.dstCountry, dstXY);
    textAlign(CENTER, TOP);
    drawTangentialText(myDatum.depCountry, depXY);
    //textAlign(CENTER, BOTTOM);
    drawTangentialText(myDatum.dstCountry, dstXY);
    ellipseMode(RADIUS);
    fill(255);
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
    noStroke();
    fill(GREEN);
    ellipse(planePosXY.x, planePosXY.y, rOcc * scaleFactor, rOcc * scaleFactor);
    fill(RED);
    ellipse(planePosXY.x, planePosXY.y, rFat * scaleFactor, rFat * scaleFactor);

    if (showStats) {
      drawTangentialText(new String[]{myDatum.fatalities+ " / ", myDatum.occupants + ""}, new color[]{RED, GREEN}, planePosXY.x, planePosXY.y);
    }

    //}
  }
}