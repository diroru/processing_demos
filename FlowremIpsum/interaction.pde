void initRadio() {
  RadioButtonGroup rb0 = new RadioButtonGroup(MARGIN, canvas.height - graphLayout.h, 100, this);
  new RadioButton(rb0, 30, "show continent", this, "setContinental");
  new RadioButton(rb0, 30, "show global", this, "setGlobal");
  radio.add(rb0);

  RadioButtonGroup rb1 = new RadioButtonGroup(MARGIN, canvas.height - graphLayout.h + rb0.getHeight() + MARGIN, 100, this);
  new RadioButton(rb1, 30, "order by Population", this, "setByPopulation");
  new RadioButton(rb1, 30, "order by Global Peace Index", this, "setByGPI");
  new RadioButton(rb1, 30, "order by Name", this, "setByName");
  radio.add(rb1);
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

void showAll() {
  println("SHOW ALL pressed");
}

void showTopThree() {
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

void setCurrentYear(int theNewYear) {
  currentYear = theNewYear;
  makeLayout();
}