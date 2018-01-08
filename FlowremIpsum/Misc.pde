void drawArcLine(PGraphics g, float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
  float w = x2 - x1;
  float h = min(y0, y3) - y1;
  if (w >= 2*h) {
    g.line(x0, y0, x1, y1 + h);
    g.arc(x1, y1, h*2, h*2, PI, PI+HALF_PI, OPEN);
    g.line(x1 + h, y1, x2 - h, y2);
    g.arc(x2-2*h, y2, h*2, h*2, PI+HALF_PI, TWO_PI, OPEN);
    g.line(x2, y2 + h, x3, y3);
  } else {
    g.line(x0, y0, x1, y1+w/2);
    g.arc(x1, y1, w, w, PI, PI+HALF_PI, OPEN);
    g.arc(x1, y1, w, w, PI+HALF_PI, TWO_PI, OPEN);
    g.line(x2, y2 + w*0.5, x3, y3);
  }
}

PVector mapMouse(PGraphics target, int mx, int my) {
  float dx = (mx - width * 0.5) / width * 2f;
  float dy = (my - height * 0.5) / height * 2f;
  float r = sqrt(dx * dx + dy * dy);
  float phi = atan2(dy, dx);
  float x0 = cos(phi) * r;
  float y0 = sin(phi) * r;
  float x = (map(phi, -PI, PI, target.width, 0) + target.width * 0.5 ) % target.width;
  float y = map(r, 0, 1, 0, target.height);
  return new PVector(x, y);
}

float logScale(float val, float base, float scale) {
  return log(val) / log(base) * scale;
}

float logScale(float val, float scale) {
  return logScale(val, POPULATION_MAX, scale);
}

float constrainedLogScale(float val, float minVal, float base, float scale) {
  float lVal = log(val) / log(base);
  float lValMin = log(minVal) / log(base);
  float scaleCorrection = 1 - lValMin;
  return max(lVal - lValMin, 0) * scale / scaleCorrection;
}

float constrainedLogScale(float val, float scale) {
  return constrainedLogScale(val, POPULATION_CUTOFF, POPULATION_MAX, scale);
}