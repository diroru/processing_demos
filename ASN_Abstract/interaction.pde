void setHighlight(String countryName, int year) { //<>//
  if (year != currentYear) {
    currentYear = year;
    makeLayout(matrixLayout, SET_END_POS);
  }
  for (Country c : getCountries()) {
    if (c.name.equalsIgnoreCase(countryName)) {
      c.highlight = true;
    } else if (c.year == year) {
      c.highlight = true;
    } else {
      c.highlight = false;
    }
  }
}

void unsetHighlight() {
  for (Country c : getCountries()) {
    c.highlight = false;
  }
}

PVector mapMouse(PGraphics target, int mx, int my) {
  float x, y;
  if (domeDisplay) {
    float dx = (mx - width * 0.5) / width * 2f;
    float dy = (my - height * 0.5) / height * 2f;
    float r = sqrt(dx * dx + dy * dy);
    float phi = atan2(dy, dx);
    float x0 = cos(phi) * r;
    float y0 = sin(phi) * r;
    x = (map(phi, -PI, PI, target.width, 0) + target.width * 0.5 ) % target.width;
    y = map(r, 0, 1, 0, target.height);
    return new PVector(x, y);
  } else {
    float scaleFactor = fittingScaleFactor(target);
    x = map(mouseX,0,width,0,width/scaleFactor);
    y = map(mouseY,0,height,0,height/scaleFactor);
  }
  return new PVector(x,y);
}