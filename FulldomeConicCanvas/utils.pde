//overloaded with global vars
PVector mappedMouse(int mode) {
  return mappedMouse(mode, mouseX, mouseY, canvas.width, canvas.height, APERTURE, CONE_RADIUS_TOP, CONE_RADIUS_BOTTOM, CONE_HEIGHT, CONE_BOTTOM, CONE_ORIENTATION);
}

//decoupled version
PVector mappedMouse(int mode, int mx, int my, int canvasWidth, int canvasHeight, float aperture, float coneRadiusTop, float coneRadiusBottom, float coneHeight, float coneBottom, float coneOrientation) {
  PVector result = new PVector();
  switch(mode) {
    case CANVAS_MODE:
      //canvas to sketch radio
      result = new PVector(mx / canvasToWindowRatio(canvasWidth, canvasHeight, width, height), my / canvasToWindowRatio(canvasWidth, canvasHeight, width, height));
    break;
    case FULLDOME_MODE:
      result = getConicMappedMouse(mx, my, canvasWidth, canvasHeight, width, height);
    break;
  }
  return result;
}

float canvasToWindowRatio() {
  return canvasToWindowRatio(canvas.width, canvas.height, width, height);
}

float canvasToWindowRatio(float cw, float ch, float ww, float wh) {
  return min(ww/cw, wh/ch);
}

PVector getConicMappedMouse(float mx, float my, float canvasWidth, float canvasHeight, float windowWidth, float windowHeight) {
  PVector normalizedMouse = new PVector(norm(mx, 0, windowWidth), norm(my, 0, windowHeight));
  PVector latLon = domeXYToLatLon(normalizedMouse, APERTURE * PI);
  PVector ray = latLonToXYZ(latLon);
  PVector st = conicTexCoordinates(ray, CONE_BOTTOM, CONE_RADIUS_BOTTOM, CONE_HEIGHT, CONE_RADIUS_TOP, CONE_ORIENTATION / 360f);
  if (st == null) {
    return new PVector(-1, -1);
  }
  return new PVector(st.x * canvasWidth, st.y * canvasHeight);
}

///
PVector domeXYToLatLon(PVector xy, float aperture) {
  float x = xy.x - 0.5;
  float y = xy.y - 0.5;
  float lat = sqrt(x*x + y*y) * aperture;
  float lon = atan2(y,x);
  return new PVector(lat, lon);
}

PVector latLonToXYZ(PVector latLon) {
  float lat = latLon.x;
  float lon = latLon.y;
  float x = cos(lon) * sin(lat);
  float y = sin(lon) * sin(lat);
  float z = cos(lat);
  return new PVector(x,y,z);
}

PVector domeXYToXYZ(PVector xy, float aperture) {
  return latLonToXYZ(domeXYToLatLon(xy, aperture));
}

///
PVector conicVector(float bottom, float radiusBottom, float cHeight, float radiusTop) {
  //vec3 p0 = vec3(radiusBottom, 0, bottom);
  PVector p0 = new PVector(radiusBottom, 0, 0);
  PVector p1 = new PVector(radiusTop, 0, cHeight);
  return PVector.sub(p1, p0);
}

//TODO: check this!!!
PVector rotateZ(PVector v, float theta) {
  float x = v.x * cos(theta) + v.y * sin(theta);
  float y = -v.x * sin(theta) + v.y * cos(theta);
  float z = v.z;
  return new PVector(x,y,z);
}

PVector getRayInXZPlane(PVector theRay) {
  float theta = atan2(theRay.y, theRay.x);
  return rotateZ(theRay, theta);
}

PVector conicIntersection(PVector ray, float bottom, float radiusBottom, float height, float radiusTop) {
  //rotating the ray into the XZ plane
  float theta = atan2(ray.y, ray.x);

  PVector r = rotateZ(ray, theta);

  PVector d = new PVector(radiusBottom, 0, bottom);

  PVector c = conicVector(bottom, radiusBottom, height, radiusTop);
  float nom = r.x * d.z - r.z * d.x;
  float den = c.x * r.z - c.z * r.x;
  //vectors are parallel

  if (den == 0.0) {
    return null;
  }
  //cone is degenerate, TODO: further cases
  if (nom == 0.0) {
    return null;
  }
  float lambda = nom / den;
  if (lambda < 0.0 || lambda > 1.0) {
    return null;
  }
  //return rotateZ(d + lambda * c, theta);
  return new PVector(theta / TWO_PI, lambda,  0.0);

  //return vec3(1.0, theta / PI * 0.5 + 0.5,  0.0);
  //return r;
}

PVector conicTexCoordinates(PVector ray, float bottom, float radiusBottom, float theHeight, float radiusTop, float deltaS) {
  PVector v = conicIntersection(ray, bottom, radiusBottom, theHeight, radiusTop);
  if (v == null) {
    return null;
  }
  float s = (v.x + deltaS) % 1.0;
  float t = 1.0 - v.y;
  return new PVector(s,t);
}