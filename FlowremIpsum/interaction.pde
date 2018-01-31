void initRadio() {
  float radioButtonHeight = 20;
  float radioButtonHeLeft = MARGIN*2-10;
  float radioButtonStartY = 660;
  float radioButtonWidth = 130;
  RadioButtonGroup rb0 = new RadioButtonGroup(radioButtonHeLeft, radioButtonStartY, radioButtonWidth, this);
  new RadioButton(rb0, radioButtonHeight, "group by continent", this, canvas, "setContinental");
  new RadioButton(rb0, radioButtonHeight, "show global", this, canvas, "setGlobal", true);
  radio.add(rb0);

  RadioButtonGroup rb1 = new RadioButtonGroup(radioButtonHeLeft, radioButtonStartY + rb0.getHeight() + MARGIN, radioButtonWidth, this);
  new RadioButton(rb1, radioButtonHeight, "order by Population", this, canvas, "setByPopulation");
  new RadioButton(rb1, radioButtonHeight*3, radioButtonHeight*0.5, "order by Global Peace Index Ranking", this, canvas, "setByGPI");
  new RadioButton(rb1, radioButtonHeight, "order by Name", this, canvas, "setByName", true);
  radio.add(rb1);

  RadioButtonGroup rb2 = new RadioButtonGroup(radioButtonHeLeft, radioButtonStartY + rb0.getHeight() + rb1.getHeight() + MARGIN*2, radioButtonWidth, this);
  new RadioButton(rb2, radioButtonHeight*2, radioButtonHeight*0.5, "show top 3 immigration flows", this, canvas, "setShowTopThree");
  new RadioButton(rb2, radioButtonHeight*2, radioButtonHeight*0.5, "show global immigration flows", this, canvas, "setShowAll", true);
  radio.add(rb2);
}

void setGlobal() {
  switch(currentSortingMethod) {
    //case SORT_BY_NAME:
  case SORT_BY_CONTINENT_THEN_NAME:
    currentSortingMethod = SORT_BY_NAME;
    makeLayout();
    break;
    //case SORT_BY_GPI:
  case SORT_BY_CONTINENT_THEN_GPI:
    currentSortingMethod = SORT_BY_GPI;
    makeLayout();
    break;
    //case SORT_BY_POPULATION:
  case SORT_BY_CONTINENT_THEN_POPULATION:
    currentSortingMethod = SORT_BY_POPULATION;
    makeLayout();
    break;
  }
  println("SET GLOBAL selected");
}

void setContinental() {
  switch(currentSortingMethod) {
  case SORT_BY_NAME:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_NAME;
    makeLayout();
    break;
    //case SORT_BY_CONTINENT_THEN_NAME:
  case SORT_BY_GPI:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_GPI;
    makeLayout();
    break;
    //case SORT_BY_CONTINENT_THEN_GPI:
  case SORT_BY_POPULATION:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_POPULATION;
    makeLayout();
    break;
    //case SORT_BY_CONTINENT_THEN_POPULATION:
  }
  println("SET CONTINENTAL selected");
}

void setByPopulation() {
  switch(currentSortingMethod) {
  case SORT_BY_NAME:
    currentSortingMethod = SORT_BY_POPULATION;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_NAME:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_POPULATION;
    makeLayout();
    break;
  case SORT_BY_GPI:
    currentSortingMethod = SORT_BY_POPULATION;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_GPI:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_POPULATION;
    makeLayout();
    break;
    //case SORT_BY_POPULATION:
    //case SORT_BY_CONTINENT_THEN_POPULATION:
  }
  println("SET BY POP selected");
}

void setByGPI() {
  switch(currentSortingMethod) {
  case SORT_BY_NAME:
    currentSortingMethod = SORT_BY_GPI;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_NAME:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_GPI;
    makeLayout();
    break;
    //case SORT_BY_GPI:
    //case SORT_BY_CONTINENT_THEN_GPI:
  case SORT_BY_POPULATION:
    currentSortingMethod = SORT_BY_GPI;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_POPULATION:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_GPI;
    makeLayout();
    break;
  }
  println("SET BY GPI selected");
}

void setByName() {
  switch(currentSortingMethod) {
    //case SORT_BY_NAME:
    //case SORT_BY_CONTINENT_THEN_NAME:
  case SORT_BY_GPI:
    currentSortingMethod = SORT_BY_NAME;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_GPI:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_NAME;
    makeLayout();
    break;
  case SORT_BY_POPULATION:
    currentSortingMethod = SORT_BY_NAME;
    makeLayout();
    break;
  case SORT_BY_CONTINENT_THEN_POPULATION:
    currentSortingMethod = SORT_BY_CONTINENT_THEN_NAME;
    makeLayout();
    break;
  }
  println("SET BY ABC selected");
}

void setShowAll() {
  if (currentShowMode == SHOW_TOP_THREE) {
    currentShowMode = SHOW_ALL;
  }
  println("SHOW ALL pressed");
}

void setShowTopThree() {
  if (currentShowMode == SHOW_ALL) {
    currentShowMode = SHOW_TOP_THREE;
  }
  println("SHOW TOP THREE pressed");
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
    x = map(mouseX, 0, width, 0, width/scaleFactor);
    y = map(mouseY, 0, height, 0, height/scaleFactor);
  }
  return new PVector(x, y);
}

void displayMouse() {
  canvas.fill(255, 255, 0, 127);
  canvas.ellipseMode(RADIUS);
  canvas.noStroke();
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 5, 5);
  canvas.ellipse(mappedMouse.x + canvas.width, mappedMouse.y, 10, 5);
}

void setCurrentYear(int theNewYear) {
  currentYear = theNewYear;
  yearlyMigrationFlows = migrationFlows.get(currentYear);
  println("setting year to", theNewYear, yearlyMigrationFlows.size());

  Collections.sort(yearlyMigrationFlows);
  makeLayout();
}