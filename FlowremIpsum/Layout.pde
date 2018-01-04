void makeLayout(float x0, float y0, float layoutWidth, float layoutHeight, float gap, ArrayList<Country> theCountries, int thePosType, int theYear) {
  int countryCount = theCountries.size();
  float countryWidth = (layoutWidth - gap * (countryCount - 1)) / float(countryCount);
  float x = x0;  
  //this is the same
  //for (int i = 0; i < theCountries.size(); i++) {
  //Country theCountry = theCountries.get(i);
  for (Country theCountry : theCountries) {
    
    Float gpi = theCountry.getGPI(theYear);
    //float gpi = 2f;
    float countryHeight = map(gpi, GPI_MIN, GPI_MAX, 0, layoutHeight);
    float gray = map(gpi, GPI_MIN, GPI_MAX, 255, 0);
    color theColor = color(gray);

    //it is cleaner to say, but it needs to be implemented!
    //theCountry.setX(x);
    //we set the layout values for each country
    //setting start position
    if (thePosType == SET_START_POS) {
      theCountry.setStartX(x);
      theCountry.setStartY(y0);
    } else {
      theCountry.setEndX(x);
      theCountry.setEndY(y0);
    }
    theCountry.w = countryWidth;
    theCountry.h = countryHeight;
    theCountry.setColor(theColor);

    //x needs to be incremented for the next country / bar
    x = x + countryWidth + gap;
  }
}