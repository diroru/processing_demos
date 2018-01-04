class Country implements Comparable {
  //attribute / field
  String name, iso3, region, subRegion;
  //gpi indices by year
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  //population by year
  HashMap<Integer, Long> pop = new HashMap<Integer, Long>();
  float startX, endX, currentX;
  float startY, endY, currentY;
  float w, h;
  color col;
  int activeYear = GPI_YEAR_END;

  int sortingMethod = SORT_BY_CONTINENT_THEN_INDEX;

  //constructor method
  Country(String theName, String theIso3, String theRegion, String theSubRegion) {
    name = theName;
    iso3 = theIso3;
    region = theRegion;
    subRegion = theSubRegion;
  }

  void setGPI(Integer year, Float value) {
    gpi.put(year, value);
  }

  Float getGPI(Integer year) {
    Float result = gpi.get(year);
    /*
    if (result == null) {
      result = -1f;
    }
    */
    return result;
  }

  void setPOP(Integer year, Long value) {
    pop.put(year, value);
  }

  Long getPOP(Integer year) {
    Long result = pop.get(year);
    return result;
  }


  @Override
    String toString() {
    return "\n" + name + " | "  + iso3 + " | " + region + " | " + subRegion + " | " + this.getPOP(2016);
  }

  //TODO:
  //void setX(), getX() etc.
  void setStartX(float x) {
    startX = x;
  }
  void setStartY(float y) {
    startY = y;
  }
  void setEndX(float x) {
    endX = x;
  }
  void setEndY(float y) {
    endY = y;
  }
  
  void setCurrentX(float x) {
    currentX = x;
  }

  void setCurrentY(float y) {
    currentY = y;
  }

  void setColor(color theColor) {
    col = theColor;
  }
  
  //time goes from 0 to 1
  void update(float time) {
    currentX = map(time, 0, 1, startX, endX);
    currentY = map(time, 0, 1, startY, endY);
  }

  void display(PGraphics g) {
    g.fill(col);
    g.rect(this.currentX, this.currentY, this.w, this.h);
  }

  //COMPARISON
  @Override
    public boolean equals(Object obj) {
    Country c = ((Country) obj); 
    return c.iso3.equals(this.iso3);
  }

  @Override
    public int compareTo(Object o) {
    Country otherCountry = (Country) o;
    Float myIndex = this.getGPI(activeYear);
    Float otherIndex = otherCountry.getGPI(activeYear);
    int indexComparison, regionComparison;
    switch(sortingMethod) {
    case SORT_BY_COUNTRY_NAME:
      return this.name.compareTo(otherCountry.name);
    case SORT_BY_CONTINENT:
      return this.region.compareTo(otherCountry.region);
    case SORT_BY_INDEX:
      return myIndex.compareTo(otherIndex);
    case SORT_BY_CONTINENT_THEN_INDEX:
      //first, compare regions
      regionComparison = this.region.compareTo(otherCountry.region);
      //if the region (continent) is the same, compare indices
      if (regionComparison == 0) {
         //return comparison result
         return myIndex.compareTo(otherIndex);
      }
      //if region (continent) is not the same, make this the comparison basis 
      return regionComparison;
    }

    return 0;
  }
}