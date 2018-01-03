class Country {
  //attribute / field
  String name, iso3, region, subRegion;
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  
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
  
  @Override
  String toString() {
    return name + " | "  + iso3 + " | " + region + " | " + subRegion + "\n";
  }
}