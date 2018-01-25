final int SET_START_POS = 0;
final int SET_END_POS = 1;

void setSortByName(int thePos) {
  currentSorting = SORT_BY_NAME;
  displayableCountries = makeLayout(matrixLayout, thePos);
}

void setSortByName() {
  setSortByName(SET_END_POS);
}


void setSortByFatalityCount() {
  currentSorting = SORT_BY_FATALITY_COUNT;
  displayableCountries = makeDetailedLayout(matrixLayout, SET_END_POS, DETAILED_COUNTRY_COUNT, DETAILED_COUNTRY_WIDTH);
}

ArrayList<Country> makeDetailedLayout(LayoutInfo theLayout, int thePos, int dCountryCount, int dCountryWidth) {
  ArrayList<Country> result = new ArrayList<Country>();
  TreeMap<Integer, ArrayList<Country>> c = getCountriesByYears();
  for (ArrayList<Country> countryList : c.values()) {
    Collections.sort(countryList);
  }
  int count = 0;
  int hCount = c.values().iterator().next().size();
  int vCount = c.keySet().size();
  float cellHeight = theLayout.getUnitHeight(vCount);
  float cellWidthNormal = theLayout.getUnitWidthWithDetails(hCount, dCountryCount, dCountryWidth);
  float x = theLayout.x;
  float y = theLayout.y;
  for (Integer year : c.keySet()) {
    //println(year);
    int countriesInRow = 0;
    for (Country theCountry : c.get(year)) {
      float cellWidth;
      if (countriesInRow < dCountryCount) {
        theCountry.displayDetailed = true;
        cellWidth = dCountryWidth;
      } else {
        cellWidth = cellWidthNormal;
        theCountry.displayDetailed = false;
      }
      count++;
      //print(theCountry.name + ",");
      switch(thePos) {
      case SET_START_POS:
        theCountry.setStartLayout(x, y, cellWidth, cellHeight);
        theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight);
        break;
      case SET_END_POS:
        //theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight, ANIMATION_DURATION);
        //theCountry.setEndPos(x, y, 1000);
        break;
      }
      result.add(theCountry);
      //x += theLayout.deltaX(hCount);
      x += cellWidth + theLayout.hGap;
      countriesInRow++;
    }
    x = theLayout.x;
    y += theLayout.deltaY(vCount);
  }
  //println("COUNT", hCount, vCount, count);
  return result;
}

ArrayList<Country> makeLayout(LayoutInfo theLayout) {
  return makeLayout(theLayout, SET_START_POS);
}

ArrayList<Country> makeLayout(LayoutInfo theLayout, int thePos) {
  ArrayList<Country> result = new ArrayList<Country>();
  TreeMap<Integer, ArrayList<Country>> c = getCountriesByYears();
  for (ArrayList<Country> countryList : c.values()) {
    Collections.sort(countryList);
  }
  int count = 0;
  int hCount = c.values().iterator().next().size();
  int vCount = c.keySet().size();
  float cellHeight = theLayout.getUnitHeight(vCount);
  float cellWidth = theLayout.getUnitWidth(hCount);
  float x = theLayout.x;
  float y = theLayout.y;
  for (Integer year : c.keySet()) {
    //println(year);
    for (Country theCountry : c.get(year)) {
      count++;
      theCountry.displayDetailed = false;
      //print(theCountry.name + ",");
      switch(thePos) {
      case SET_START_POS:
        theCountry.setStartLayout(x, y, cellWidth, cellHeight);
        theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight);
        break;
      case SET_END_POS:
        //theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        //theCountry.setEndLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight, ANIMATION_DURATION);
        //theCountry.setEndPos(x, y, 1000);
        break;
      }
      result.add(theCountry);
      x += theLayout.deltaX(hCount);
    }
    x = theLayout.x;
    y += theLayout.deltaY(vCount);
  }
  //println("COUNT", hCount, vCount, count);
  return result;
}