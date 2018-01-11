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



void setCurrentYear(int theNewYear) {
  currentYear = theNewYear;
  makeLayout();
}