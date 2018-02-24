public class Country implements Comparable { //<>// //<>// //<>//
  //attribute / field
  String name, lookupName, iso3, iso2, region, subRegion;
  //gpi indices by year
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  HashMap<Integer, Integer> gpiRanks = new HashMap<Integer, Integer>();
  //migration flows by year and by country iso3
  HashMap<Integer, HashMap<String, Long>> immigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  HashMap<Integer, HashMap<String, Long>> emigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  HashMap<Integer, ArrayList<MigrationFlow>> immigrationFlowsByYear = new HashMap<Integer, ArrayList<MigrationFlow>>();
  HashMap<Integer, ArrayList<MigrationFlow>> emigrationFlowsByYear = new HashMap<Integer, ArrayList<MigrationFlow>>();
  //totals by year
  HashMap<Integer, Long> totalImmigraionFlow = new HashMap<Integer, Long>();
  HashMap<Integer, Long> totalEmigraionFlow = new HashMap<Integer, Long>();
  //population by year
  HashMap<Integer, Long> pop = new HashMap<Integer, Long>();
  float myX = 0f, myY = 0f, myWidth = 0f, myHeight = 0f;
  float myRed = 0, myGreen = 0, myBlue = 0, myAlpha = 255;
  int activeYear = GPI_YEAR_END;
  boolean _hover = false;
  boolean _selected = false;

  int sortingMethod = SORT_BY_CONTINENT_THEN_NAME;
  long animationStart, animationEnd, lastTime;

  float nameWidth;
  LayoutInfo myContainerLayout;

  //constructor method
  Country(String theName, String theLookupName, String theIso3, String theIso2, String theRegion, String theSubRegion, PApplet parent, PGraphics canvas, LayoutInfo theContainerLayout) {
    name = theName;
    lookupName = theLookupName;
    iso3 = theIso3;
    iso2 = theIso2;
    region = theRegion;
    subRegion = theSubRegion;
    //parent.registerMethod("mouseEvent", this);
    canvas.beginDraw();
    canvas.textFont(INFO);
    nameWidth = canvas.textWidth(name);
    canvas.endDraw();
    myContainerLayout = theContainerLayout;
  }

  void setGPI(Integer year, Float value) {
    gpi.put(year, value);
  }

  void setGPIRank(Integer year, Integer value) {
    gpiRanks.put(year, value);
  }


  Float getGPI(Integer year) {
    Float result = gpi.get(year);

    if (result == 0) {
      return -1f;
    }

    return result;
  }

  Integer getGPIRank(Integer year) {
    Integer result = gpiRanks.get(year);
    return result;
  }

  void setPOP(Integer year, Long value) {
    pop.put(year, value);
  }

  Long getPOP(Integer year) {
    Long result = pop.get(year);
    if (result == null) {
      return 0L;
    }
    return result;
  }

  void addImmigrationFlow(MigrationFlow flow) {
    int y = flow.year;
    String orgISO3 = flow.origin.iso3;
    if (immigrationFlows.get(y) == null) {
      immigrationFlows.put(y, new HashMap<String, Long>());
      totalImmigraionFlow.put(y, 0L);
    }
    if (immigrationFlows.get(y).get(orgISO3) == null) {
      immigrationFlows.get(y).put(orgISO3, flow.flow);
      long sum = totalImmigraionFlow.get(y) ;
      totalImmigraionFlow.put(y, sum + flow.flow);
    } else {
      //println("IMMIGRATION FLOW already exists!", flow.origin.name, " -> ", flow.destination.name);
    }
    ArrayList<MigrationFlow> iFlows =  immigrationFlowsByYear.get(y);
    if (iFlows == null) {
      iFlows = new ArrayList<MigrationFlow>();
      immigrationFlowsByYear.put(y, iFlows);
    }
    iFlows.add(flow);
  }

  void addEmigrationFlow(MigrationFlow flow) {
    int y = flow.year;
    String dstISO3 = flow.destination.iso3;
    if (emigrationFlows.get(y) == null) {
      emigrationFlows.put(y, new HashMap<String, Long>());
      totalEmigraionFlow.put(y, 0L);
    }
    if (emigrationFlows.get(y).get(dstISO3) == null) {
      emigrationFlows.get(y).put(dstISO3, flow.flow);
      long sum = totalEmigraionFlow.get(y) ;
      totalEmigraionFlow.put(y, sum + flow.flow);
    } else {
      //println("EMIGRATION FLOW already exists!", flow.origin.name, " -> ", flow.destination.name);
    }
    ArrayList<MigrationFlow> eFlows =  emigrationFlowsByYear.get(y);
    if (eFlows == null) {
      eFlows = new ArrayList<MigrationFlow>();
      emigrationFlowsByYear.put(y, eFlows);
    }
    eFlows.add(flow);
  }

  //used by migration flow
  float cx() {
    return myX + myWidth * 0.5;
  }

  float cy() {
    float distToFlowLine = 10;
    return myY - distToFlowLine;
  }

  @Override
    String toString() {
    return "\n" + name + " | "  + iso3 + " | " + region + " | " + subRegion + " | " + this.getPOP(2016);
    //return "*";
  }

  void setColor(color theColor) {
    //currentColor = theColor;
    myRed = red(theColor);
    myGreen = green(theColor);
    myBlue = blue(theColor);
    myAlpha = alpha(theColor);
  }

  void displayFilled(PGraphics g) {

    if (getGPIRank(activeYear) != GPI_LAST_RANK) {
      g.fill(myRed, myGreen, myBlue, myAlpha);
      if (isSelected() || isHover()) {
        g.fill(PRIMARY);
      }
      float z = -1;
      g.vertex(this.myX, this.myY, z);
      g.vertex(this.myX + this.myWidth, this.myY, z);
      g.vertex(this.myX + this.myWidth, this.myY + this.myHeight, z);
      g.vertex(this.myX, this.myY + this.myHeight, z);
    }
  }

  void displayOutlined(PGraphics g, ArrayList<Country> destinationCountries, ArrayList<Country> originCountries) {
    boolean isDestination = destinationCountries.contains(this);
    boolean isOrigin = originCountries.contains(this);
    boolean gpiMissing = getGPIRank(activeYear) == GPI_LAST_RANK;
    if (gpiMissing || isDestination || isOrigin) {
      g.fill(myRed, myGreen, myBlue, myAlpha);
      if (gpiMissing) {
        g.stroke(myRed, myGreen, myBlue, myAlpha);
      }
      if (isDestination) {
        g.stroke(SECONDARY);
      }
      if (isSelected() || isHover() || isOrigin) {
        g.stroke(PRIMARY);
      }
      float z = -1;
      g.vertex(this.myX, this.myY, z);
      g.vertex(this.myX + this.myWidth, this.myY, z);
      g.vertex(this.myX + this.myWidth, this.myY + this.myHeight, z);
      g.vertex(this.myX, this.myY + this.myHeight, z);
    }

  }

  void displayName(PGraphics g, ArrayList<Country> destinationCountries, ArrayList<Country> originCountries) {
    boolean isDestination = destinationCountries.contains(this);
    boolean isOrigin = originCountries.contains(this);

    float m = 5; //margin
    float nameY = myY + myHeight + m;

    if (isHover() || isSelected() || isDestination || isOrigin) {
      if (myY + myHeight + nameWidth + m > myContainerLayout.y + myContainerLayout.h) {
        g.fill(0);
        nameY -= m * 2;
        g.textAlign(RIGHT, CENTER);
      } else {
        if (isSelected() || isHover() || isOrigin) {
          g.fill(PRIMARY);
        }
        if (isDestination) {
          g.fill(SECONDARY);
        }
        g.textAlign(LEFT, CENTER);
      }
      g.pushMatrix();
      g.translate(myX + myWidth * 0.5, nameY);
      g.rotate(HALF_PI);
      g.text(name, 0, 0);
      g.popMatrix();
    }
  }

  String getGPIRankString(int year) {
    Integer result = getGPIRank(year);
    if (result == GPI_LAST_RANK) {
      return "N/A";
    }
    return result + "";
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
  public int hashCode() {
     return Objects.hash(iso3);
  }

  @Override
    public int compareTo(Object o) {
    Country otherCountry = (Country) o;

    int gpiComparison = this.getGPIRank(activeYear).compareTo(otherCountry.getGPIRank(activeYear));
    //int gpiComparison = this.getGPI(activeYear).compareTo(otherCountry.getGPI(activeYear));
    /*
    if (this.getGPI(currentYear) == -1 && otherCountry.getGPI(currentYear) == -1) {
     gpiComparison = 0;
     } else if (this.getGPI(currentYear) == -1 || this.getGPI(currentYear) == -1) {
     gpiComparison = 0;
     }
     */
    //TODO!!!
    int regionComparison = this.region.compareTo(otherCountry.region);
    int nameComparison = this.name.compareTo(otherCountry.name);
    int populationComparison = this.getPOP(activeYear).compareTo(otherCountry.getPOP(activeYear));

    switch(sortingMethod) {
    case SORT_BY_NAME:
      return nameComparison;
    case SORT_BY_CONTINENT_THEN_NAME:
      if (regionComparison == 0) {
        return nameComparison;
      }
      return regionComparison;
    case SORT_BY_GPI:
      return gpiComparison;
    case SORT_BY_CONTINENT_THEN_GPI:
      if (regionComparison == 0) {
        return gpiComparison;
      }
      return regionComparison;
    case SORT_BY_POPULATION:
      return populationComparison;
    case SORT_BY_CONTINENT_THEN_POPULATION:
      if (regionComparison == 0) {
        return populationComparison;
      }
      return regionComparison;
    }
    return 0;
  }

  //shows countrynames hovering on a bar / without a bar
  public void hover(float x, float y) {
    _hover = x >= myX && x <= myX + myWidth && y >= myY && y <= myY + myHeight;
    //return x >= currentX && x <= currentX + currentW;
  }

  boolean isHover() {
    return _hover;
  }

  Long getImmigration(int theYear) {
    return totalImmigraionFlow.get(theYear);
  }

  Long getEmigration(int theYear) {
    return totalEmigraionFlow.get(theYear);
  }

  void setSelected(boolean s) {
    _selected = s;
  }

  boolean isSelected() {
    return _selected;
  }

  ArrayList<Country> getDestinationCountries() {
    ArrayList<Country> result = new ArrayList<Country>();
    ArrayList<MigrationFlow> eFlows = emigrationFlowsByYear.get(currentYear);
    if (eFlows != null) {
      for (MigrationFlow mf : eFlows) {
        if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
          result.add(mf.destination);
          println(mf.origin.name, " -> ", mf.destination.name, " : ", mf.flow);
        }
      }
    }
    return result;
  }

  ArrayList<Country> getOriginCountries() {
    ArrayList<Country> result = new ArrayList<Country>();
    ArrayList<MigrationFlow> iFlows = immigrationFlowsByYear.get(currentYear);
    if (iFlows != null) {
      for (MigrationFlow mf : iFlows) {
        if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
          result.add(mf.origin);
          println(mf.destination.name, " <- ", mf.origin.name, " : ", mf.flow);
        }
      }
    }
    return result;
  }
}
