void displayTrajectories() {
  strokeWeight(3);
  stroke(0);
  strokeWeight(1);
  for (int i= 0; i < data.getRowCount(); i++) {
    //for (int i= ind; i < ind+1; i++) {
    //println(data.getRow(i).getString("departure_airport"));
    //println(data.getRow(i).getString("destination_airport_formatted"));
    float lat0 = data.getRow(i).getFloat("departure_airport_lat");
    float lng0 = data.getRow(i).getFloat("departure_airport_lng");
    float lat1 = data.getRow(i).getFloat("destination_airport_lat");
    float lng1 = data.getRow(i).getFloat("destination_airport_lng");
    PVector p0 = latLonToAzimuthalXY(lat0, lng0);
    PVector p1 = latLonToAzimuthalXY(lat1, lng1);

    float totalFatalities = data.getRow(i).getFloat("total_fatalities");
    ellipseMode(RADIUS);
    noStroke();
    fill(255, 255, 0, 63);
    float r = map(totalFatalities, totalFatalitiesMinMax[0], totalFatalitiesMinMax[1], 3, 50);
   // ellipse(p0.x, p0.y, r, r);
    stroke(0, 255, 0);
    //line(p0.x, p0.y, p1.x, p1.y);
    if (!Float.isNaN(lat0) && !Float.isNaN(lng0) && !Float.isNaN(lat1) && !Float.isNaN(lng1)) {
      float distance = getGeodeticDistance(lat0, lng0, lat1, lng1, 100);
      int year = data.getRow(i).getInt("year");
      int month = data.getRow(i).getInt("month");
      float normalizedPosOnPath = getNormalizedTime(year, month, distance, speed);
      PVector currentLatLng = getGeodeticAtNormDist(lat0, lng0, lat1, lng1, constrain(normalizedPosOnPath, 0, 1));

      //ArrayList<PVector> geodetic = getGeodetic(lat0, lng0, lat1, lng1, 100);
      ArrayList<PVector> geodetic = getGeodetic(lat0, lng0, currentLatLng.x, currentLatLng.y, 100);
      strokeWeight(3);
      if (normalizedPosOnPath >= 0 && normalizedPosOnPath <= 1 ) {
        stroke(255, 0, 0);
      } else if (normalizedPosOnPath >= 1 && normalizedPosOnPath <= fadeTimeRatio) {
        float alpha = map(normalizedPosOnPath, 1, fadeTimeRatio, 255, 0);
        stroke(255, 0, 0, alpha);
      } else {
        stroke(255, 255, 0, 63);
      }
      beginShape(LINE_STRIP);
      for (PVector v : geodetic) {
        PVector p = latLonToAzimuthalXY(v.x, v.y);
        vertex(p.x, p.y, 0);
      }
      endShape();
    }
  }
}