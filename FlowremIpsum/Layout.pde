void makeLayout(float x0, float y0, float layoutWidth, float layoutHeight, float gap, ArrayList<Country> theCountries, int theSortingMethod, int thePosType, int theYear) {
  sortCountries(theCountries, theSortingMethod, theYear);
  int countryCount = theCountries.size();
  float countryWidth = (layoutWidth - gap * (countryCount - 1)) / float(countryCount);
  float x = x0;  
  //this is the same
  //for (int i = 0; i < theCountries.size(); i++) {
  //Country theCountry = theCountries.get(i);
  for (Country theCountry : theCountries) {
    
    Float gpi = theCountry.getGPI(theYear);
    Long pop = theCountry.getPOP(theYear);
    if (pop == null) {
      pop = 0L;
    }
    //float gpi = 2f;
    //float countryHeight = map(pop, POPULATION_MIN, POPULATION_MAX, 0, layoutHeight - 5) + 5;
    float countryHeight = constrainedLogScale(pop, layoutHeight);
    float gray = map(gpi, GPI_MIN, GPI_MAX, 255, 0);
    color theColor = color(gray, 0, 255);
    float y = layoutHeight - countryHeight + y0;

    //it is cleaner to say, but it needs to be implemented!
    //theCountry.setX(x);
    //we set the layout values for each country
    //setting start position
    if (thePosType == SET_START_POS) {
      theCountry.setStartX(x);
      theCountry.setStartY(y);
      //theCountry.setCurrentX(x);
      //theCountry.setCurrentY(y);
    } else {
      theCountry.setEndX(x);
      theCountry.setEndY(y);
      //Ani.to(this, 1.5, "theCountry.currentX", theCountry.endX, Ani.BOUNCE_OUT);
      //Ani.to(this, 1.5, "theCountry.currentY", theCountry.endY, Ani.BOUNCE_OUT);
    }
    theCountry.w = countryWidth;
    theCountry.h = countryHeight;
    theCountry.setColor(theColor);

    //x needs to be incremented for the next country / bar
    x = x + countryWidth + gap;
  }
}

void makeLayout(LayoutInfo theInfo, ArrayList<Country> theCountries, int theSortingMethod, int thePosType, int theYear) {
  makeLayout(theInfo.x, theInfo.y, theInfo.w, theInfo.h, theInfo.gap, theCountries, theSortingMethod, thePosType, theYear);
}

void makeStartLayout(int theSortingMethod, int theYear) {
  makeLayout(graphLayout, countries, theSortingMethod, SET_START_POS, theYear);
}

void makeEndLayout(int theSortingMethod, int theYear) {
  makeLayout(graphLayout, countries, theSortingMethod, SET_END_POS, theYear);
}

void makeStartLayout(int theYear) {
  makeStartLayout(currentSortingMethod, theYear);
}

void makeEndLayout(int theYear) {
  makeEndLayout(currentSortingMethod, theYear);
}

void sortCountries(ArrayList<Country> theCountries, int theSortingMethod, int theActiveYear) {
  //get only countries as a list
  //set the proper sorting method for each country
  for (Country theCountry : theCountries) {
    theCountry.sortingMethod = theSortingMethod;
    theCountry.activeYear = theActiveYear;
  }
  //do the sorting
  Collections.sort(theCountries);
}