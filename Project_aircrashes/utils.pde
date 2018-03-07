//TODO: font settings

void drawArcTextCenteredPolar(String theText, float theta, float radius) {
  float x = width * 0.5 + cos(theta) * radius;
  float y = height * 0.5 + sin(theta) * radius;
  drawArcTextCentered(theText, x, y);
}


void drawArcTextCentered(String theText, PVector v) {
  drawArcTextCentered(theText, v.x, v.y);
}

void drawArcTextCentered(String theText, float x0, float y0) {
  float theW = textWidth(theText);
  float rad = PVector.dist(new PVector(x0, y0), center());
  float phi = getPhiFromSides(theW, rad);
  PVector v = new PVector(x0, y0);
  v.sub(center());
  v.rotate(phi*0.5);
  v.add(center());
  drawArcText(theText, v.x, v.y);
}

void drawArcText(String theText, PVector v) {
  drawArcText(theText, v.x, v.y);
}

void drawArcText(String theText, float x0, float y0) {
  float dx = x0 - width*0.5;
  float dy = y0 - height*0.5;
  float x = x0;
  float y = y0;
  float radius = sqrt(dx * dx + dy * dy);
  char[] letters = theText.toCharArray();
  for (int i = 0; i < letters.length; i++) {
    char letter = letters[i];
    drawTangentialText(letter, x, y);

    float characterWidth = textWidth(letter);
    //applying sine theorem
    float theta = 2f * asin(characterWidth / radius * 0.5f);
    PVector nextCoords = new PVector(x, y);
    nextCoords.add(new PVector(-width*0.5, -height*0.5));
    nextCoords.rotate(-theta);
    nextCoords.add(new PVector(width*0.5, height*0.5));
    x = nextCoords.x;
    y = nextCoords.y;
  }
}

void drawTangentialTextPolar(String theText, float theta, float radius) {
  float x = width * 0.5 + cos(theta) * radius;
  float y = height * 0.5 + sin(theta) * radius;
  drawTangentialText(theText + "", x, y);
}

void drawTangentialText(String theText, PVector v) {
  drawTangentialText(theText + "", v.x, v.y);
}

void drawTangentialText(char theText, float x, float y) {
  drawTangentialText(theText + "", x, y);
}

void drawTangentialTextPolar(String[] theTextTokens, PFont[] theTextFonts, Float[] theTextSizes, color[] colors, float theta, float radius) {
  float x = width * 0.5 + cos(theta) * radius;
  float y = height * 0.5 + sin(theta) * radius;
  drawTangentialText(theTextTokens, theTextFonts, theTextSizes, colors, 255, x, y);
}

void drawTangentialText(String[] theTextTokens, color[] colors, float x, float y) {
  drawTangentialText(theTextTokens, null, null, colors, 255, x, y);
}

void drawTangentialText(String[] theTextTokens, PFont[] theTextFonts, Float[] theTextSizes, color[] colors, float alpha, float x, float y) {
  float dx = x - width*0.5;
  float dy = y - height*0.5;
  float angle = atan2(dy, dx) - HALF_PI;

  textAlign(LEFT, TOP);
  float fullWidth = 0f;
  for (int i = 0; i < theTextTokens.length; i++) {
    try {
      textFont(theTextFonts[i]);
    } 
    catch (Exception e) {
    }
    try {
      textSize(theTextSizes[i]);
    } 
    catch (Exception e) {
    }
    fullWidth += textWidth(theTextTokens[i]);
  }

  pushMatrix();
  translate(x, y);
  rotate(angle);
  translate(-fullWidth*0.5, 0);

  for (int i = 0; i < theTextTokens.length; i++) {
    try {
      fill(colors[i], alpha);
    } 
    catch (Exception e) {
    }
    try {
      textFont(theTextFonts[i]);
    } 
    catch (Exception e) {
    }
    try {
      textSize(theTextSizes[i]);
    } 
    catch (Exception e) {
    }
    text(theTextTokens[i], 0, 0);
    translate(textWidth(theTextTokens[i]), 0);
  }
  popMatrix();
}

void drawTangentialTextPolar(String[] theTextTokens, PFont[] theTextFonts, Float[] theTextSizes, color[] colors, float alpha, float theta, float radius) {
  float x = width*0.5 + cos(theta) * radius;
  float y = height*0.5 + sin(theta) * radius;
  drawTangentialText(theTextTokens, theTextFonts, theTextSizes, colors, alpha, x, y);
}

void drawTangentialText(String theText, float x, float y) {
  float dx = x - width*0.5;
  float dy = y - height*0.5;
  float angle = atan2(dy, dx) - HALF_PI;

  pushMatrix();
  translate(x, y);
  rotate(angle);
  text(theText, 0, 0);
  popMatrix();
}

void drawRadialText(String s, PVector p, float angle, float angle2, float radius) {
  pushMatrix();
  translate(p.x, p.y);
  rotate(angle);
  translate(radius, 0);
  rotate(angle2);
  text(s, 0, 0);
  popMatrix();
}

PVector incrementRadially(PVector src, float delta) {
  PVector result = src.copy();
  result.sub(new PVector(width * 0.5, height * 0.5));
  float mag = result.mag();
  result.setMag(mag + delta);
  result.add(new PVector(width * 0.5, height * 0.5));
  return result;
}

PVector center() {
  return new PVector(width*0.5, height*0.5);
}

float getPhiFromSides(float base, float radius) {
  return asin(base * 0.5 / radius) * 2;
}

int signum(float f) {
  if (f >= 0) {
    return 1;
  }
  return -1;
}

void updateSequence(CrashFlight nextFlight) {
  activeFlight = nextFlight;
  float[] nextProjecitonParams = getProjectionParams(activeFlight.myDatum);

  nextDeltaLat = nextProjecitonParams[0];
  nextDeltaLon = nextProjecitonParams[1];
  nextDeltaLonPost = nextProjecitonParams[2] + HALF_PI;
  nextMapScale = max(nextProjecitonParams[3], MIN_MAP_SCALE);

  float ddlon = nextDeltaLon - deltaLon;
  while (abs(ddlon) > PI) {
    ddlon -= signum(ddlon) * TWO_PI;
  }

  nextDeltaLon = deltaLon + ddlon;

  float ddlonp = nextDeltaLonPost - deltaLonPost;
  while (abs(ddlonp) > PI) {
    ddlonp -= signum(ddlonp) * PI;
  }
  if (abs(ddlonp) > HALF_PI) {
    ddlonp = ddlonp - signum(ddlonp) * PI;
  }

  nextDeltaLonPost = deltaLonPost + ddlonp;

  println("animating delta lat", degrees(deltaLat), " > ", degrees(nextDeltaLat));
  println("animating delta lon", degrees(deltaLon), " > ", degrees(nextDeltaLon));
  println("animating delta lon post", degrees(deltaLonPost), " > ", degrees(nextDeltaLonPost));
  println("animating scale", mapScale, " > ", nextMapScale);
  println(degrees(nextDeltaLon) - degrees(nextDeltaLonPost), degrees(nextDeltaLon) + degrees(nextDeltaLonPost));
  println("-----");

  float t = SEEK_DURATION;
  float t_half = t/2f;
  float t_two_thirds = t/3f * 2f;
  float t_third = t/3f;
  float dt = t*0.15;
  float tSum = 0;

  //if (globalAniSequence.isEnded() || !globalAniSequence.isPlaying()) {
  Ani.killAll();
  //1. animate time, NB callback!
  timeAni = Ani.to(this, t, 0, "TIME", activeFlight.myDatum.normMoment, Ani.LINEAR);

  //2. zoom out
  mapScaleOutAni = Ani.to(this, t_third, 0, "mapScale", MAX_MAP_SCALE);
  //3. rotate
  lonAni = Ani.to(this, t_half + dt*2, t_half - dt, "deltaLon", nextDeltaLon);
  latAni = Ani.to(this, t_half + dt*2, t_half - dt, "deltaLat", nextDeltaLat);
  lonPostAni = Ani.to(this, t_half + dt*2 + 0.1, t_half - dt, "deltaLonPost", nextDeltaLonPost, Ani.getDefaultEasing(), "onEnd:zoomIn");


  timeAni.start();
  mapScaleOutAni.start();
  lonAni.start();
  lonPostAni.start();
  latAni.start();
}

void zoomIn() {
  Ani.killAll();
  //4. zoom in
  mapScaleInAni = Ani.to(this, SEEK_DURATION / 3f, "mapScale", nextMapScale, Ani.getDefaultEasing(), "onEnd:fadeIn");
  mapScaleInAni.start();
}

void fadeIn() {
  Ani.killAll();
  //5. TODO: animate flight
  fadeInAni = Ani.to(this, FADE_DURATION, "FADE_TIME", 1, Ani.getDefaultEasing(), "onEnd:showFlight");
  fadeInAni.start();
}

void showFlight() {
  Ani.killAll();
  trajectoryShowAni = Ani.to(this, TRAJECTORY_SHOW_DURATION, "TRAJECTORY_SHOW_TIME", 1);
  crashInfoShowAni = Ani.to(this, FADE_DURATION, TRAJECTORY_SHOW_DURATION, "CRASH_INFO_SHOW_TIME", 1, Ani.BOUNCE_OUT, "onEnd:fadeOut");
  trajectoryShowAni.start();
  crashInfoShowAni.start();
}

void fadeOut() {
  fadeOut(CRASH_INFO_SHOW_DURATION);
}

void fadeOut(Float delay) {
  Ani.killAll();
  fadeOutAni = Ani.to(this, FADE_DURATION, delay, "FADE_TIME", 0, Ani.getDefaultEasing(), "onEnd:callbackAfterFlightShown");
  fadeOutAni.start();
}

void pauseSafely(Ani theAni) {
  if (theAni != null) {
    if (theAni.isPlaying () || theAni.isDelaying() && !theAni.isEnded()) {
      theAni.pause();
    }
  }
}

void resumeSafely(Ani theAni) {
  if (theAni != null) {
    if (!theAni.isPlaying() && !theAni.isEnded()) {
      theAni.resume();
    }
  }
}

void callbackAfterFlightShown() {
  switch(currentState) {
  case STATE_PLAY:
    TRAJECTORY_SHOW_TIME = 0;
    CRASH_INFO_SHOW_TIME = 0;
    if (nextFlightCandidate == null) {
      updateSequence(getNextFlight(activeFlight));
    } else {
      updateSequence(nextFlightCandidate);
      nextFlightCandidate = null;
    }
    break;
  }
}

CrashFlight getNextFlight(CrashFlight theActiveFlight) {
  if (theActiveFlight == null) {
    return myFlights.get(0);
  }
  return theActiveFlight.nextFlight;
}