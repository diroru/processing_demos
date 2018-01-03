class Country {
  //attribute / field
  String name, iso3, region, subRegion;
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  float x, y, w, h;
  color col;
  
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
}