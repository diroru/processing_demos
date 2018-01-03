class Country {
  //attribute / field
  String name, iso3, region, subRegion;
  
  //constructor method
  Country(String theName, String theIso3, String theRegion, String theSubRegion) {
    name = theName;
    iso3 = theIso3;
    region = theRegion;
    subRegion = theSubRegion;
  }
  
  @Override
  String toString() {
    return name + " | "  + iso3 + " | " + region + " | " + subRegion + "\n";
  }
}