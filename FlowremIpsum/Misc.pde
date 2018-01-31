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

float logScale(float val, float base, float scale) {
  return log(val) / log(base) * scale;
}

float logScale(float val, float scale) {
  return logScale(val, POPULATION_MAX, scale);
}

float constrainedLogScale(float val, float minVal, float maxVal) {
  return constrainedLogScale(val, minVal, maxVal, 1f);
}

float constrainedLogScale(float val, float minVal, float maxVal, float scale) {
  if (minVal <= 0) {
    println("constrained log scale ERROR: min val shouldn’t be <= 0");
  }
  float lVal = log(val) / log(maxVal);
  float lValMin = log(minVal) / log(maxVal);
  float scaleCorrection = 1 - lValMin;
  return max(lVal - lValMin, 0) * scale / scaleCorrection;
}

float constrainedLogScale(float val, float scale) {
  return constrainedLogScale(val, POPULATION_CUTOFF, POPULATION_MAX, scale);
}

void fitImage(PImage img) {
  float scaleFactor = fittingScaleFactor(img);
  image(img, 0, 0, img.width*scaleFactor, img.height*scaleFactor);
}

float fittingScaleFactor(PImage src) {
  return fittingScaleFactor(src, g);
}

float fittingScaleFactor(PImage src, PImage target) {
  return min(float(target.width)/src.width, float(target.height)/src.height);
}

void initShader() {
  domeShader = loadShader("glsl/fulldomeCone.frag", "glsl/fulldomeCone.vert");
  domeShader.set("canvas", canvas);
  updateShader();
}

void updateShader() {
  domeShader.set("aperture", APERTURE / 180f);
  domeShader.set("radiusBottom", CONE_RADIUS_BOTTOM);
  domeShader.set("radiusTop", CONE_RADIUS_TOP);
  domeShader.set("coneBottom", CONE_BOTTOM);
  domeShader.set("coneHeight", CONE_HEIGHT);
  domeShader.set("coneOrientation", CONE_ORIENTATION);
}

void initCanvas() {
  canvas = createGraphics(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  canvas.beginDraw();
  canvas.ortho();
  canvas.background(0);
  canvas.endDraw();
}

void initShape() {
  domeQuad = createShape();
  domeQuad.beginShape();
  domeQuad.fill(255, 255, 0);
  domeQuad.textureMode(NORMAL);
  domeQuad.noStroke();
  domeQuad.vertex(-width * 0.5f, -height * 0.5f, 0, 1, 1);
  domeQuad.vertex(width * 0.5f, -height * 0.5f, 0, 0, 1);
  domeQuad.vertex(width * 0.5f, height * 0.5f, 0, 0, 0);
  domeQuad.vertex(-width * 0.5f, height * 0.5f, 0, 1, 0);
  domeQuad.endShape();
}

float getFittingFontSize(String input, PFont font, float targetWidth) {
  float maxWidth = maxWidth(input, font);
  return targetWidth / maxWidth * font.getDefaultSize(); 
}

ArrayList<String> getOptimalStrings(String input, PFont font) {
  ArrayList<String> result = new ArrayList<String>();
  float currentWidth = 0;
  float maxWidth = maxWidth(input, font);
  String[] temp = input.split(" ");
  for (String s : temp) {
    float w = textWidth(s + " ");
    if (currentWidth + w <= maxWidth) {
      if (result.size() == 0) {
        result.add(s);
      } else {
        String previous = result.get(result.size()-1);
        result.set(result.size()-1, previous + " " + s);
      }
      currentWidth += w;
    } else {
      result.add(s);
      currentWidth = w;
    }
  }
  popStyle();
  return result;
}

float maxWidth(String input, PFont font) {
  String[] temp = input.split(" ");

  float maxWidth = 0;
  pushStyle();
  textFont(font);
  for (String s : temp) {
    maxWidth = max(maxWidth, textWidth(s));
  }
  return maxWidth;
}