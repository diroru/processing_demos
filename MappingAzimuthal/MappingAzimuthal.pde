PImage map;
Table data;
float[] totalFatalitiesMinMax;
int minYear;
int maxYear;
int currentYear;
int currentMonth = 0;
int millisPerMonth = 10;
long then;
long elapsed = 0;
float speed = 0.05;
float fadeTimeRatio = 3; //must be greater than 1 if there should be fading

public void setup() {
  size(1024, 1024, P3D);
  map = loadImage("Azimuthal_equidistant_projection_SW.jpg");
  data = loadTable("100worst_crashes_latlng.csv", "header");
  printArray(data.getColumnTitles());
  totalFatalitiesMinMax = getMinMax(data, "total_fatalities");
  //PVector test = latlngToXYZ(xyzToLatLng(new PVector(1,-0.1,1)));
  //PVector test = latlngToXYZ(new PVector(90f, 90f));
  //println(test.x, test.y, test.z);  
  minYear = floor(getMinMax(data, "year")[0]);
  maxYear = floor(getMinMax(data, "year")[1]) +10;
  println("years", minYear, maxYear);
  currentYear = minYear;
  then = millis();
  //frameRate(1);
}

public void draw() {
  calculateTime();
  background(0);
  //image(map, 0, 0, width, height);
  displayTime(100);
  displayTrajectories();
  //speed = map(mouseX,0,width,0.1,10);
  //noLoop();
}