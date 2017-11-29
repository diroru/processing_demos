PVector latlngToXYZ(PVector latlng) {
  float lat = radians(-latlng.x);
  float lng = radians(latlng.y);
  float x = cos(lng) * cos(lat);
  float z = sin(lng) * cos(lat);
  float y = sin(lat);
  return new PVector(x, y, z);
}

/*
PVector domeXYToLatlng(PVector xy, float aperture) {
 float x = xy.x - 0.5;
 float y = xy.y - 0.5;
 float lat = sqrt(x*x + y*y) * aperture;
 float lng = atan2(y,x);
 return new PVector(lat, lng);
 }
 */

PVector xyzToLatLng(PVector v) {
  float lambda = atan2(v.z, v.x);
  float mu = atan2(-v.y, sqrt(v.x*v.x  + v.z*v.z));
  return new PVector(degrees(mu), degrees(lambda));
}

ArrayList<PVector> getGeodetic(float lat0, float lng0, float lat1, float lng1, int res) {
  ArrayList<PVector> result = new ArrayList();
  //result.add(new PVector(lat0,lng0));
  PVector v0 = latlngToXYZ(new PVector(lat0, lng0));
  PVector v1 = latlngToXYZ(new PVector(lat1, lng1));
  for (int i = 0; i < res; i++) {
    float inc = i / float(res-1);
    //println(inc);
    PVector v = PVector.lerp(v0, v1, inc);
    result.add(xyzToLatLng(v));
  }
  //result.add(new PVector(lat1,lng1));
  return result;
}

PVector getGeodeticAtNormDist(float lat0, float lng0, float lat1, float lng1, float norm) {
  PVector v0 = latlngToXYZ(new PVector(lat0, lng0));
  PVector v1 = latlngToXYZ(new PVector(lat1, lng1));
  return xyzToLatLng(PVector.lerp(v0, v1, norm));
}

float getGeodeticDistance(float lat0, float lng0, float lat1, float lng1, int res) {
  ArrayList<PVector> geodetic = getGeodetic(lat0, lng0, lat1, lng1, res);
  float result = 0;
  PVector v0 = latlngToXYZ(new PVector(lat0, lng0));
  PVector v1 = latlngToXYZ(new PVector(lat1, lng1));
  PVector p0 = v0.copy();
  for (int i = 1; i < res; i++) {
    float inc = i / float(res-1);
    //println(inc);
    PVector p1 = PVector.lerp(v0, v1, inc);
    result += PVector.dist(p0, p1);
    p0 = p1.copy();
  }
  return result;
}

PVector latLonToAzimuthalXY(float lat, float lon) {
  float r = map(lat, 90, -90, 0, height*0.5);
  float phi = radians(-lon) + HALF_PI;
  float x = cos(phi) * r + width*0.5;
  float y = sin(phi) * r + height*0.5;
  return new PVector(x, y);
}

float[] getMinMax(Table theTable, String theColumnName) {
  float theMin = Float.MAX_VALUE;
  float theMax = Float.MIN_VALUE;
  for (int i = 0; i < theTable.getRowCount(); i++) {
    float f = theTable.getRow(i).getFloat(theColumnName);
    theMin = min(f, theMin);
    theMax = max(f, theMax);
  }
  return new float[]{theMin, theMax};
}