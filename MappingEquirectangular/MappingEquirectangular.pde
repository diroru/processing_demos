PImage map;
Table data;
float[] totalFatalitiesMinMax;
float totalFatalitiesSum;

public void setup() {
  size(1024, 512, P3D);
  map = loadImage("Equirectangular_projection_SW.jpg");
  data = loadTable("171123_plane-crashes.ascii_strangest+worst.csv", "header, tsv");
  printArray(data.getColumnTitles());
  totalFatalitiesMinMax = getMinMax(data, "total_fatalities");
  totalFatalitiesSum = getSum(data, "total_fatalities");
  println(totalFatalitiesSum);
  //PVector test = latlngToXYZ(xyzToLatLng(new PVector(1,-0.1,1)));
  //PVector test = latlngToXYZ(new PVector(90f, 90f));
  //println(test.x, test.y, test.z);
  frameRate(1);
}

public void draw() {
  background(0);
  image(map, 0, 0, width, height);
  strokeWeight(3);
  stroke(0);
  /*
  for (int i= 0; i < data.getRowCount(); i++) {
    float lat = data.getRow(i).getFloat("departure_lat");
    float lng = data.getRow(i).getFloat("departure_lng");
    float x = map(lng, -180f, 180f, 0f, width);
    float y = map(lat, 90f, -90f, 0f, height);
    point(x, y);
  }
  stroke(0, 0, 255);
  for (int i= 0; i < data.getRowCount(); i++) {
    float lat = data.getRow(i).getFloat("destination_lat");
    float lng = data.getRow(i).getFloat("destination_lng");
    float x = map(lng, -180f, 180f, 0f, width);
    float y = map(lat, 90f, -90f, 0f, height);
    point(x, y);
  }
  */
  strokeWeight(1);
  //int ind = frameCount;
  //println(data.getRow(ind).getString("departure_airport"));
  //println(data.getRow(ind).getString("destination_airport_formatted"));
  println(frameCount);
  for (int i= 0; i < data.getRowCount(); i++) {
  //for (int i= ind; i < ind+1; i++) {
    float lat0 = data.getRow(i).getFloat("departure_lat");
    float lng0 = data.getRow(i).getFloat("departure_lng");
    float x0 = map(lng0, -180f, 180f, 0f, width);
    float y0 = map(lat0, 90f, -90f, 0f, height);
    float lat1 = data.getRow(i).getFloat("destination_lat");
    float lng1 = data.getRow(i).getFloat("destination_lng");
    float x1 = map(lng1, -180f, 180f, 0f, width);
    float y1 = map(lat1, 90f, -90f, 0f, height);
    float totalFatalities = data.getRow(i).getFloat("total_fatalities");
    ellipseMode(RADIUS);
    noStroke();
    fill(255,255,0,63);
    float r = map(totalFatalities,totalFatalitiesMinMax[0],totalFatalitiesMinMax[1],3,50);
    ellipse(x0,y0,r,r);
    stroke(127,127);
    line(x0, y0, x1, y1);
    if (!Float.isNaN(lat0) && !Float.isNaN(lng0) && !Float.isNaN(lat1) && !Float.isNaN(lng1)) {
      ArrayList<PVector> geodetic = getGodetic(lat0, lng0, lat1, lng1, 100);
      stroke(255,0,0);
      beginShape(LINE_STRIP);
      for (PVector v : geodetic) {
        float x = map(v.y, -180f, 180f, 0f, width);
        float y = map(v.x, 90f, -90f, 0f, height);
        vertex(x,y,0);
      }
      endShape();
    }
    
  }
  //noLoop();
}