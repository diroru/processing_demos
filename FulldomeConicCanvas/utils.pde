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
