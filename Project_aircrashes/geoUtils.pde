float[] getProjectionParams(PVector latLon0, PVector latLon1,  float targetSize) {
  return getProjectionParams(latLon0.x, latLon0.y, latLon1.x, latLon1.y, targetSize);
}

float[] getProjectionParams(float lat0, float lon0, float lat1, float lon1, float targetSize) {
  PVector midpointLatLon = getMidpoint(lat0, lon0, lat1, lon1);
  float theDeltaLat = HALF_PI + midpointLatLon.x;
  float theDeltaLon = -PI + midpointLatLon.y;
  PVector startXY = getGeodeticPoint(lat0, lon0, theDeltaLat, theDeltaLon, 1);
  PVector endXY = getGeodeticPoint(lat1, lon1, theDeltaLat, theDeltaLon, 1);
  float currentSize = PVector.dist(startXY, endXY);
  float theSize = currentSize/targetSize;
  /*
  println("****");
  println(degrees(lat0), " > ", degrees(ll.x), " > ", degrees(lat1));
  println(degrees(lon0), " > ", degrees(ll.y), " > ", degrees(lon1));
  println("****");
  */
  return new float[]{theDeltaLat, theDeltaLon, theSize};
}

PVector getMidpoint(float lat0, float lon0, float lat1, float lon1) {
  PVector startXYZ = latLonToXYZ_basic(lat0, lon0);
  PVector endXYZ = latLonToXYZ_basic(lat1, lon1);
  PVector midpointXYZ = sphericInterpolation(startXYZ, endXYZ, 0.5);
  return xyzToLatLon(midpointXYZ);
}

ArrayList<PVector> getGeodetic(float lat0, float lon0, float lat1, float lon1) {
  return getGeodetic(lat0, lon0, lat1, lon1, deltaLat, deltaLon, mapScale, 64);
}

void drawGeodetic(PVector latLon0, PVector latLon1) {
  drawGeodetic(latLon0.x, latLon0.y, latLon1.x, latLon1.y, deltaLat, deltaLon, mapScale, 64);
}


void drawGeodetic(float lat0, float lon0, float lat1, float lon1) {
  drawGeodetic(lat0, lon0, lat1, lon1, deltaLat, deltaLon, mapScale, 64);
}

void drawGeodetic(float lat0, float lon0, float lat1, float lon1, float deltaLat, float deltaLon, float scale, int resolution) {
  ArrayList<PVector> gs = getGeodetic(lat0, lon0, lat1, lon1, deltaLat, deltaLon, scale, resolution);
  beginShape();
  for (PVector v : gs) {
    vertex(v.x, v.y);
  }
  endShape();
}

ArrayList<PVector> getGeodetic(float lat0, float lon0, float lat1, float lon1, float deltaLat, float deltaLon, float scale, int resolution) {
  PVector startXYZ = latLonToXYZ(lat0, lon0, deltaLat, deltaLon);
  PVector endXYZ = latLonToXYZ(lat1, lon1, deltaLat, deltaLon);
  ArrayList<PVector> result = new ArrayList<PVector>();
  result.add(getGeodeticPoint(startXYZ, scale));
  for (int i = 1; i < resolution; i++) {
    float f = i / float(resolution);
    result.add(getGeodeticPoint(sphericInterpolation(startXYZ, endXYZ, f), scale));
  }
  result.add(getGeodeticPoint(endXYZ, scale));
  return result;
}

PVector getGeodeticPoint(PVector latLon) {
  return getGeodeticPoint(latLon.x, latLon.y);
}

PVector getGeodeticPoint(float lat, float lon) {
  return getGeodeticPoint(lat, lon, deltaLat, deltaLon, mapScale);
}

//in radians!!!
PVector getGeodeticPoint(float lat, float lon, float deltaLat, float deltaLon, float scale) {
  PVector xyz = latLonToXYZ(lat, lon, deltaLat, deltaLon);
  return getGeodeticPoint(xyz, scale);
}

PVector getGeodeticPoint(PVector xyz, float scale) {
  PVector latLon = xyzToLatLon(xyz);
  float theta = latLon.y;
  float rho = map(latLon.x, HALF_PI, -HALF_PI, 0, 1f/scale);
  float x = width * 0.5 + cos(theta) * rho * width;
  float y = height * 0.5 + sin(theta) * rho * height;
  return new PVector(x,y);
}

PVector sphericInterpolation(PVector a, PVector b, float f) {
  //TODO: cross is 0
  //TODO: a and b of different lengths
  PVector axis = a.cross(b);
  float theta = PVector.angleBetween(a, b);
  return rotateAroundAxis(a, axis, theta * f);
}

PVector rotateAroundAxis(PVector v, PVector axis, float theta) {
  PVector a = axis.copy();
  a.normalize();
  PVector result = v.copy();
  float ct = cos(theta);
  float st = sin(theta);
  //could be simpler ...
  //source: wikipedia
  PMatrix m = new PMatrix3D(
    ct + a.x * a.x * (1 - ct), a.x * a.y * (1 - ct) - a.z * st, a.x * a.z * (1 - ct) +  a.y * st, 0,
    a.y * a.x * (1 - ct) + a.z * st, ct + a.y * a.y * (1 - ct), a.y * a.z * (1 - ct) - a.x * st, 0,
    a.z * a.x * (1 - ct) - a.y * st, a.z * a.y * (1 - ct) + a.x * st, ct + a.z * a.z * (1 - ct), 0,
    0, 0, 0, 1
    );
  m.mult(result, result);
  return result;
}

PVector xyzToLatLon(PVector xyz) {
  float lat = asin(xyz.z);
  float lon = atan2(xyz.y, xyz.x);
  return new PVector(lat, lon);
}

PVector latLonToXYZ(float lat, float lon) {
  return latLonToXYZ(lat, lon, 0f, 0f);
}

PVector latLonToXYZ(float lat, float lon, float deltaLat, float deltaLon) {
  float x = cos(lon) * cos(lat);
  float y = sin(lon) * cos(lat);
  float z = sin(lat);
  z *= -1; //"hack" for glsl
  PVector result = new PVector(x,y,z);
  result = rotateZ(result, deltaLon); //"hack" for glsl
  result = rotateY(result, -deltaLat); //"hack" for glsl
  result = rotateZ(result, -deltaLon); //"hack" for glsl
  return result;
}

PVector latLonToXYZ_basic(float lat, float lon) {
  float x = cos(lon) * cos(lat);
  float y = sin(lon) * cos(lat);
  float z = sin(lat);
  PVector result = new PVector(x,y,z);
  return result;
}


PVector rotateZ(PVector v, float theta) {
  float x = v.x * cos(theta) + v.y * sin(theta);
  float y = -v.x * sin(theta) + v.y * cos(theta);
  float z = v.z;
  return new PVector(x,y,z);
}

PVector rotateY(PVector v, float theta) {
  float y = v.y;
  float x = v.x * cos(theta) - v.z * sin(theta);
  float z = v.x * sin(theta) + v.z * cos(theta);
  return new PVector(x,y,z);
}

PVector rotateX(PVector v, float theta) {
  float x = v.x;
  float y = v.y * cos(theta) - v.z * sin(theta);
  float z = v.y * sin(theta) + v.z * cos(theta);
  return new PVector(x,y,z);
}

PVector getLatLonAtNormDist(PVector latLng0, PVector latLng1, float norm) {
  return getLatLonAtNormDist(latLng0.x, latLng0.y, latLng1.x, latLng1.y, norm);
}
 
PVector getLatLonAtNormDist(float lat0, float lon0, float lat1, float lon1, float norm) {
  //PVector v0 = latLonToXYZ(lat0, lng0, deltaLat, deltaLon);
  //PVector v1 = latLonToXYZ(lat1, lng1, deltaLat, deltaLon);
  //return xyzToLatLon(sphericInterpolation(v0, v1, norm));
  //PVector startXYZ = latLonToXYZ(lat0, lon0, deltaLat, deltaLon);
  //PVector endXYZ = latLonToXYZ(lat1, lon1, deltaLat, deltaLon);
  PVector startXYZ = latLonToXYZ_basic(lat0, lon0);
  PVector endXYZ = latLonToXYZ_basic(lat1, lon1);
  PVector resultXYZ = sphericInterpolation(startXYZ, endXYZ, norm);
  PVector resultLatLon = xyzToLatLon(resultXYZ);
  return resultLatLon;
  //return xyzToLatLon(PVector.lerp(v0, v1, norm));
}

void drawDashedGeodetic(PVector latLng0, PVector latLng1, int res, float dashLength, float gapLength) {
  drawDashedGeodetic(latLng0.x, latLng0.y, latLng1.x, latLng1.y, res, dashLength, gapLength);
}

void drawDashedGeodetic(float lat0, float lng0, float lat1, float lng1, int res, float dashLength, float gapLength) {
  //drawGeodetic(lat0, lng0, lat1, lng1);
  
  ArrayList<PVector> gs = getGeodetic(lat0, lng0, lat1, lng1);
  boolean dash = true;
  boolean gap = false;
  float len = 0;

  PVector v0 = gs.get(0);
  beginShape(LINES);

  for (int i = 1; i < gs.size(); i++) {
    PVector v = gs.get(i);
    float delta = PVector.dist(v, v0);
    len += delta;
    if (dash) {
      vertex(v0.x, v0.y);
      vertex(v.x, v.y);
      if (len >= dashLength) {
        len = 0;
        gap = true;
        dash = false;
      }
    } else if (gap) {
      if (len >= gapLength) {
        len = 0;
        gap = false;
        dash = true;
      }
    }    

    v0 = v.copy();
  }
  endShape();
  
}