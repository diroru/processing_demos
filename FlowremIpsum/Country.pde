class Country implements Comparable {
  //attribute / field
  String name, iso3, region, subRegion;
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  float x, y, w, h;
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
    return gpi.get(year);
  }

  @Override
    String toString() {
    return name + " | "  + iso3 + " | " + region + " | " + subRegion + "\n";
  }

  //TODO:
  //void setX(), getX() etc.

  void setColor(color theColor) {
    col = theColor;
  }

  void display() {
    fill(col);
    rect(this.x, this.y, this.w, this.h);
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