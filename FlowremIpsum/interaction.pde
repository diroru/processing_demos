void initRadio() {
  float radioButtonHeight = 15;
  float radioButtonHeLeft = MARGIN*2-10;
  float radioButtonStartY = 720;
  float radioButtonWidth = 130;
  RadioButtonGroup rb0 = new RadioButtonGroup(radioButtonHeLeft, radioButtonStartY, radioButtonWidth, this);
  new RadioButton(rb0, radioButtonHeight, "group by continent", this, canvas, "setContinental");
  new RadioButton(rb0, radioButtonHeight, "show global", this, canvas, "setGlobal", true);
  radio.add(rb0);

  RadioButtonGroup rb1 = new RadioButtonGroup(radioButtonHeLeft, radioButtonStartY + rb0.getHeight() + MARGIN, radioButtonWidth, this);
  new RadioButton(rb1, radioButtonHeight, "order by Population", this, canvas, "setByPopulation");
  new RadioButton(rb1, radioButtonHeight*2, radioButtonHeight*0.5, "order by Global Peace Index Ranking", this, canvas, "setByGPI");
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
  if (currentShowMode == GS_SHOW_TOP_THREE) {
    currentShowMode = GS_SHOW_ALL;
    if (hoverMigrationFlow == null && currentCountryState == CS_NONE) {
      undimFlows();
    }
  }
  println("SHOW ALL pressed");
}

void setShowTopThree() {
  if (currentShowMode == GS_SHOW_ALL) {
    currentShowMode = GS_SHOW_TOP_THREE;
    dimFlows();
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
  canvas.ellipseMode(RADIUS);
  canvas.fill(SECONDARY, 170);
  canvas.noStroke();
  canvas.ellipse(mappedMouse.x, mappedMouse.y, 5, 5);
  canvas.ellipse(mappedMouse.x + canvas.width, mappedMouse.y, 10, 5);
}

void setCurrentYear(int theNewYear) {
  Ani.to(this, ANI_DURATION, "fractionalYear", theNewYear, Ani.LINEAR);
  currentYear = theNewYear;
  makeLayout();
}

void mouseMoved() {
  layoutNeedsUpdate = true;
  
  mappedMouse = mappedMouse(CURRENT_MODE);

  hoverCountry = null;
  switch(currentCountryState) {
  case CS_ACTIVE_ACTIVE_HOVER:
    currentCountryState = CS_ACTIVE_ACTIVE;
    break;
  case CS_ACTIVE_HOVER:
    currentCountryState = CS_ACTIVE;
    break;
  case CS_HOVER:
    currentCountryState = CS_NONE;
    break;
  }
  for (Country c : countries) {
    c.hover(mappedMouse.x, mappedMouse.y);
    if (c.isHover()) {
      //println(c);
      hoverCountry = c;
      switch(currentCountryState) {
      case CS_ACTIVE_ACTIVE:
        currentCountryState = CS_ACTIVE_ACTIVE_HOVER;
        break;
      case CS_ACTIVE:
        currentCountryState = CS_ACTIVE_HOVER;
        break;
      case CS_NONE:
        currentCountryState = CS_HOVER;
        break;
      }
    }
  }

  for (YearSelector ys : yearSelectors) {
    ys.hover(mappedMouse.x, mappedMouse.y);
  }

  for (RadioButtonGroup rbg : radio) {
    for (RadioButton rb : rbg.buttons) {
      rb.hover(mappedMouse.x, mappedMouse.y);
    }
  }

  currentFlowState = MS_NONE;
  hoverMigrationFlow = null;
  //if (currentCountryState == CS_NONE) {
  //making sure that we hover the smallest possible element
  //when there are several overlapping ones
  float flowMaxHeight = Float.MAX_VALUE;
  //if (activeCountry == null && hoverCountry == null && activeCountryTwo == null) {
  for (MigrationFlow mf : migrationFlows.values()) {
    mf.hover(mappedMouse);
    if (mf.isHover()) {
      currentFlowState = MS_HOVER;
      float h = mf.getHeight(currentYear, currentScaleMode);
      if (h < flowMaxHeight) {
        //println(flowMaxHeight, h);
        hoverMigrationFlow = mf;
        flowMaxHeight = h;
      }
    }
    //}
    //println(hoverMigrationFlow);
  }
  //}
  if (hoverMigrationFlow == null && currentCountryState == CS_NONE) {
    undimFlows();
  } else {    
    dimFlows();
  }
  if (currentShowMode == GS_SHOW_TOP_THREE) {
    dimFlows();
  }

  switch(currentCountryState) {
  case CS_ACTIVE_ACTIVE:
    updateHighlights(activeCountry);
    updateTopThree(activeCountry);
    break;
  case CS_ACTIVE:
    updateHighlights(activeCountry);
    updateTopThree(activeCountry);
    break;
  case CS_ACTIVE_ACTIVE_HOVER:
    updateHighlights(activeCountry);
    updateTopThree(hoverCountry);
    break;
  case CS_ACTIVE_HOVER:
    updateHighlights(activeCountry);
    updateTopThree(hoverCountry);
    break;
  case CS_HOVER:
    updateHighlights(hoverCountry);
    updateTopThree(hoverCountry);
    break;
  case CS_NONE:
    updateHighlights(null);
    updateTopThree(null);
    break;
  }

  if (currentCountryState == CS_NONE) {
    //println("cs none");
    //updateHighlights(null);
  } else {
    //Country targetCountry = activeCountry != null ? activeCountry : hoverCountry;
    //updateHighlights(targetCountry);
    //updateHighlights(null);
  }


  println("mouse move", millis() / 1000.0);
  println("STATE", currentCountryState);
  println("active", activeCountry);
  println("active 2", activeCountryTwo);
  println("hover", hoverCountry);
  println("hover flow", hoverMigrationFlow);
  println("----------");
}

void mousePressed() {
  //check if interacting with UI
  layoutNeedsUpdate = true;
  boolean guiInteraction = false;
  for (RadioButtonGroup rbg : radio) {
    for (RadioButton rb : rbg.buttons) {
      if (rb.isHover()) {
        rbg.setSelectedButton(rb);
        rb.trigger();
        guiInteraction = true;
      }
    }
  }

  for (YearSelector ys : yearSelectors) {
    if (ys.isHover()) {
      ys.trigger();
      guiInteraction = true;
    }
  }

  if (!guiInteraction) {
    /*
    if (activeCountry != null) {
     activeCountry.setSelected(false);
     }
     activeCountry = null;
     */
    boolean noCountryClicked = true;


    for (Country c : countries) {
      if (c.isHover()) {
        noCountryClicked = false;
        println("Selected: ", c);
        switch(currentCountryState) {
        case CS_NONE:
          //this should never be the case, except for clicking during animation?!
          println("CHECK ERROR IN INTERACTION LOGIC!");
          break;
        case CS_HOVER:
          activeCountry = c;
          activeCountry.setSelected(true);
          updateHighlights(activeCountry);
          currentCountryState = CS_ACTIVE_HOVER;
          break;
        case CS_ACTIVE:
          println("CHECK ERROR IN INTERACTION LOGIC!");
          break;
        case CS_ACTIVE_HOVER:
          if (c.equals(activeCountry)) {
            activeCountry.setSelected(false);
            activeCountry = null;
            hoverCountry = c;
            currentCountryState = CS_HOVER;
          } else {
            activeCountryTwo = c;
            activeCountryTwo.setSelected(true);
            currentCountryState = CS_ACTIVE_ACTIVE_HOVER;
          }
          break;
        case CS_ACTIVE_ACTIVE:
          println("CHECK ERROR IN INTERACTION LOGIC!");
          break;
        case CS_ACTIVE_ACTIVE_HOVER:
          if (c.equals(activeCountry)) {
            activeCountry.setSelected(false);
            activeCountryTwo.setSelected(false);
            activeCountry = activeCountryTwo;
            activeCountryTwo = null;
            activeCountry.setSelected(true);
            currentCountryState = CS_ACTIVE_HOVER;
          } else if (c.equals(activeCountryTwo)) {
            activeCountryTwo.setSelected(false);
            activeCountryTwo = null;
            currentCountryState = CS_ACTIVE_HOVER;
          } else {
            activeCountryTwo.setSelected(false);
            activeCountryTwo = c;
            activeCountryTwo.setSelected(true);
            currentCountryState = CS_ACTIVE_ACTIVE_HOVER;
          }
          break;
        }
        /*
        highlightOriginCountries.addAll(activeCountry.getOriginCountries());
         highlightDestinationCountries.addAll(activeCountry.getDestinationCountries());
         */
      }
    }
    if (noCountryClicked) {
      if (activeCountry != null) {
        activeCountry.setSelected(false);
        activeCountry = null;
      }
      if (activeCountryTwo != null) {
        activeCountryTwo.setSelected(false);
        activeCountryTwo = null;
      }
      currentCountryState = CS_NONE;
      updateHighlights(null);
    }
  }

  println("mouse clicked", millis() / 1000.0);
  println("STATE", currentCountryState);
  println("active", activeCountry);
  println("active 2", activeCountryTwo);
  println("hover", hoverCountry);
  println("----------");
}

void updateHighlights(Country targetCountry) {
  updateHighlights(targetCountry, false);
}

void updateHighlights(Country targetCountry, boolean forceUpdate) {
  boolean updateNeeded = false;
  if (highlightBase == null) {
    updateNeeded = true;
  } else if (!highlightBase.equals(targetCountry)) {
    updateNeeded = true;
  }
  if (updateNeeded || forceUpdate) {
    println("updating using", targetCountry);
    highlightedOriginCountries.clear();
    highlightedDestinationCountries.clear();
    highlightedFlows.clear();

    if (targetCountry != null) {
      HashSet<MigrationFlow> flowTemp = new HashSet<MigrationFlow>();
      HashSet<Country> originTemp = new HashSet<Country>();
      HashSet<Country> destinationTemp = new HashSet<Country>();
      for (MigrationFlow mf : migrationFlows.values()) {
        if (flowIsShowable(mf)) {
          if (mf.originEquals(targetCountry)) {
            destinationTemp.add(mf.destination());
            flowTemp.add(mf);
          }
          if (mf.destinationEquals(targetCountry)) {
            originTemp.add(mf.origin());
            flowTemp.add(mf);
          }
        }
      }
      highlightedDestinationCountries.addAll(destinationTemp);
      highlightedOriginCountries.addAll(originTemp);
      highlightedFlows.addAll(flowTemp);
    }
    highlightBase = targetCountry;
  }
}

void updateTopThree(Country targetCountry) {
  updateTopThree(targetCountry, false);
}

void updateTopThree(Country targetCountry, boolean forceUpdate) {
  boolean updateNeeded = false;
  if (topThreeBase == null) {
    updateNeeded = true;
  } else if (!topThreeBase.equals(targetCountry)) {
    updateNeeded = true;
  }
  if (updateNeeded || forceUpdate) {
    println("updating top three using", targetCountry);
    topThreeFlows.clear();
    topThreeFlows = getTopThree(targetCountry);
    topThreeBase = targetCountry;
  }
}

void dimFlows() {
  Ani.to(this, 0.3, "FLOW_ALPHA_FACTOR", 0.1);
}

void undimFlows() {
  Ani.to(this, 0.3, "FLOW_ALPHA_FACTOR", 1.0);
}