PImage img;

float PHI1 = radians(12);
float LAMBDA0 = radians(25);
float SCALE = 1;

void setup() {
  size(800, 800, P3D);
  //img = loadImage("Lambert_azimuthal_equal-area_projection_SW.jpg");
  img = loadImage("background_map.png");
}

void draw() {
  background(0);
  image(img, width * (1 - SCALE) * 0.5, height * (1 - SCALE) * 0.5, width * SCALE, height * SCALE);

  ellipseMode(RADIUS);

  noStroke();
  fill(255, 0, 0, 127);
  //PVector testVector = polarToXY(xyToPolar(mouseX, mouseY).x, xyToPolar(mouseX, mouseY).y);
  
  PVector testSpherical = new PVector(map(mouseX, 0, width, 0, PI), map(mouseY, 0, height, -HALF_PI, HALF_PI));
  PVector testPolar = sphericalToPolar(testSpherical.x, testSpherical.y);
  PVector test = polarToXY(testPolar.x, testPolar.y);

  ellipse(test.x, test.y, 5, 5);
  
  PVector southPole = lonLatToXY(-HALF_PI,0);
  PVector newYork = lonLatToXY(radians(40.712775),radians(-74.005973));
  PVector buenosAires = lonLatToXY(radians(-37.201728),radians(-59.84107));
  PVector bahiaThetis = lonLatToXY(radians(-54.623991),radians(-65.226912));
  //PVector center = sphericalToXY(0f,0f);
  //PVector center = lonLatToXY(-HALF_PI,TWO_PI,0,0);
  PVector center = lonLatToXY(map(mouseY,0,height,-HALF_PI,HALF_PI),map(mouseX,0,width,0,TWO_PI));
  //println(center.x, center.y);
  fill(255,255,0,127);
  ellipse(newYork.x, newYork.y, 5, 5);
  ellipse(buenosAires.x, buenosAires.y, 5, 5);
  ellipse(southPole.x, southPole.y, 5, 5);
  ellipse(bahiaThetis.x, bahiaThetis.y, 5, 5);
  fill(0,255,0,127);
  //ellipse(center.x*width*0.5 + width*0.5, center.y*height*0.5 + height*0.5, 10, 10);
  ellipse(center.x, center.y, 10, 10);
  
  noFill();
  stroke(255,0,0,63);
  drawGraticule(-HALF_PI, HALF_PI, 0, TWO_PI, 25,13);
  SCALE = map(mouseY, 0, height, 2f, 0.5f);
}

PVector lonLatToXY(float phi, float lambda) {
  return lonLatToXY(phi, lambda, PHI1, LAMBDA0, SCALE);
}


//source: http://mathworld.wolfram.com/LambertAzimuthalEqual-AreaProjection.html
//phi1 standard parallel
//lambda0 central longitude
PVector lonLatToXY(float phi, float lambda, float phi1, float lambda0, float scale) {
  float k = sqrt(2f / (1 + sin(phi1) * sin(phi) + cos(phi1) * cos(phi) * cos(lambda - lambda0)));
  //println(k);
  float x = k * cos(phi) * sin(lambda - lambda0);
  float y = k * (cos(phi1) * sin(phi) - sin(phi1) * cos(phi) * cos(lambda - lambda0));
  //return new PVector(x, y);
  return new PVector(x*width*0.25*SCALE + width*0.5, height*0.5 - y*height*0.25*SCALE);
  
}

void drawGraticule(float lat0, float lat1, float lon0, float lon1, int hr, int vr) {
  float latInc = (lat1-lat0) * 1f / (vr - 1f);
  float lonInc = (lon1-lon0) * 1f / (hr - 1f);
  for (int i = 0; i < vr; i++) {
    for (int j = 0; j < hr; j++) {
      PVector p0 = lonLatToXY(lat0 + latInc * i, lon0 + lonInc * j);
      PVector p1 = lonLatToXY(lat0 + latInc * i, lon0 + lonInc * (j+1));
      PVector p2 = lonLatToXY(lat0 + latInc * (i+1), lon0 + lonInc * (j+1));
      PVector p3 = lonLatToXY(lat0 + latInc * (i+1), lon0 + lonInc * j);
      beginShape();
      vertex(p0.x, p0.y);
      vertex(p1.x, p1.y);
      vertex(p2.x, p2.y);
      vertex(p3.x, p3.y);
      endShape(CLOSE);
    }
  }
}



PVector sphericalToXY(float phi, float theta) {
  PVector polar = sphericalToPolar(phi, theta);
  PVector xy =polarToXY(polar.x, polar.y); 
  return xy;
}

PVector xyToPolar(float x, float y) {
  float dx = (x - width * 0.5) / float(width) * 2;
  float dy = (y - height * 0.5) / float(height) * 2;
  float r = sqrt(dx*dx + dy*dy);
  float theta = atan2(dy, dx);
  return new PVector(r, theta);
}

PVector polarToXY(float r, float theta) {
  float x = width*0.5 + cos(theta) * r * width*0.5;
  float y = height*0.5 + sin(theta) * r * height*0.5;
  return new PVector(x, y);
}

PVector polarToSpherical(float R, float theta) {
  return new PVector(2 * acos(R * 0.5), theta);
}

PVector sphericalToPolar(float phi, float theta) {
  return new PVector(2 * cos(phi * 0.5), theta);
  //return new PVector(cos(phi * 0.5), theta);
}