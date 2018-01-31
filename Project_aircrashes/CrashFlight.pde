class CrashFlight {
  Datum myDatum;
  int geodeticRes = 50;
  float duration = 0.1;
  PVector dep, dst;
  boolean coordsValid;
  Timeline myTimeline;
  float myStartMoment, myEndMoment;
  
  CrashFlight(Datum d, Timeline tl) {
    myDatum = d;
    coordsValid = d.coordsValid();
    dep = new PVector(radians(d.depLatLng[0]), radians(d.depLatLng[1]));
    dst = new PVector(radians(d.dstLatLng[0]), radians(d.dstLatLng[1]));
    myTimeline = tl;
    myStartMoment = getNormalizedMoment(d, tl);
    myEndMoment = constrain(myStartMoment + duration, 0, 1);
  }
  
  void update(float normTime) {
  }
  
  void display(float normTime) {
    
    if (coordsValid && normTime > myStartMoment && normTime < myEndMoment) {
      float progress = norm(normTime, myStartMoment, myEndMoment);
      PVector planePos = getGeodeticAtNormDist(dep, dst, 1-progress);
      noFill();
      strokeWeight(1);
      stroke(255,127);
      drawGeodetic(dep, dst, geodeticRes);
      strokeWeight(2);
      stroke(255,255,0,127);
      drawGeodetic(dep, planePos, geodeticRes);

      PVector depXY = lngLatToXY(dep);
      PVector dstXY = lngLatToXY(dst);
      noStroke();
      fill(255);
      textSize(18 * scaleFactor);
      //drawArcTextCentered(myDatum.depCountry, depXY);
      //drawArcTextCentered(myDatum.dstCountry, dstXY);
      drawTangentialText(myDatum.depCountry, depXY);
      drawTangentialText(myDatum.dstCountry, dstXY);
    }
    
  }
}