public class Country implements Comparable { //<>// //<>//
  //attribute / field
  String name, iso3, region, subRegion;
  //gpi indices by year
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  //migration flows by year and by country iso3
  HashMap<Integer, HashMap<String, Long>> immigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  HashMap<Integer, HashMap<String, Long>> emigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  //totals by year
  HashMap<Integer, Long> totalImmigraionFlow = new HashMap<Integer, Long>();
  HashMap<Integer, Long> totalEmigraionFlow = new HashMap<Integer, Long>();
  //population by year
  HashMap<Integer, Long> pop = new HashMap<Integer, Long>();
  float startX, endX, currentX;
  float startY, endY, currentY;
  float w, h;
  color col;
  int activeYear = GPI_YEAR_END;
  boolean hover = false;

  int sortingMethod = SORT_BY_CONTINENT_THEN_INDEX; 
  
  //constructor method
  Country(String theName, String theIso3, String theRegion, String theSubRegion, PApplet parent) {
    name = theName;
    iso3 = theIso3;
    region = theRegion;
    subRegion = theSubRegion;
    parent.registerMethod("mouseEvent", this);
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

  void addImmigrationFlow(MigrationFlow flow) {
    int y = flow.year;
    String orgISO3 = flow.origin.iso3;
    if (immigrationFlows.get(y) == null) {
      immigrationFlows.put(y, new HashMap<String, Long>());
    }
    if (immigrationFlows.get(y).get(orgISO3) == null) {
      immigrationFlows.get(y).put(orgISO3, flow.flow);
    } else {
      //println("IMMIGRATION FLOW already exists!", flow.origin.name, " -> ", flow.destination.name);
    }
  }

  void addEmigrationFlow(MigrationFlow flow) {
    int y = flow.year;
    String dstISO3 = flow.destination.iso3;
    if (emigrationFlows.get(y) == null) {
      emigrationFlows.put(y, new HashMap<String, Long>());
    }
    if (emigrationFlows.get(y).get(dstISO3) == null) {
      emigrationFlows.get(y).put(dstISO3, flow.flow);
    } else {
      //println("EMIGRATION FLOW already exists!", flow.origin.name, " -> ", flow.destination.name);
    }
  }

  //used by migration flow
  float cx() {
    return currentX + w * 0.5;
  }

  float cy() {
    return currentY - 10;
  }

  @Override
    String toString() {
    return "\n" + name + " | "  + iso3 + " | " + region + " | " + subRegion + " | " + this.getPOP(2016);
    //return "*";
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
    if (hover) {
      g.fill(255);
      g.text(this.name, mappedMouse.x + 10, mappedMouse.y - 10);
    }
  }

  //COMPARISON
  @Override
    public boolean equals(Object obj) {
    if (!(obj instanceof Country)) {
      return false;
    }
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

  public boolean isHover(float x, float y) {
    return x >= currentX && x <= currentX + w && y >= currentY && y <= currentY + h;
    //return x >= currentX && x <= currentX + w;
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      hover = isHover(mappedMouse.x, mappedMouse.y);
      if (hover) {
        hoverCountries.add(this);
      } else {
        hoverCountries.remove(this);
      }
      break;
    case MouseEvent.CLICK:
      println("CLICK", e);
      break;
    }
  }
}