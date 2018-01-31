public class Country implements Comparable { //<>// //<>//
  //attribute / field
  String name, iso3, iso2, region, subRegion;
  //gpi indices by year
  HashMap<Integer, Float> gpi = new HashMap<Integer, Float>();
  HashMap<Integer, Integer> gpiRanks = new HashMap<Integer, Integer>();
  //migration flows by year and by country iso3
  HashMap<Integer, HashMap<String, Long>> immigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  HashMap<Integer, HashMap<String, Long>> emigrationFlows = new HashMap<Integer, HashMap<String, Long>>();
  //totals by year
  HashMap<Integer, Long> totalImmigraionFlow = new HashMap<Integer, Long>();
  HashMap<Integer, Long> totalEmigraionFlow = new HashMap<Integer, Long>();
  //population by year
  HashMap<Integer, Long> pop = new HashMap<Integer, Long>();
  float startX = 0f, endX = 0f, currentX = 0f;
  float startY = 0f, endY = 0f, currentY = 0f;
  float startW = 0f, endW = 0f, currentW = 0f;
  float startH = 0f, endH = 0f, currentH = 0f;
  int startColor = #000000, endColor = #000000, currentColor = #000000;
  int activeYear = GPI_YEAR_END;
  boolean hover = false;
  boolean selected = false;

  int sortingMethod = SORT_BY_CONTINENT_THEN_NAME;
  long animationStart, animationEnd, lastTime;

  float nameWidth;
  LayoutInfo myContainerLayout;

  //constructor method
  Country(String theName, String theIso3, String theIso2, String theRegion, String theSubRegion, PApplet parent, PGraphics canvas, LayoutInfo theContainerLayout) {
    name = theName;
    iso3 = theIso3;
    iso2 = theIso2;
    region = theRegion;
    subRegion = theSubRegion;
    parent.registerMethod("mouseEvent", this);
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
  }

  //used by migration flow
  float cx() {
    return currentX + currentW * 0.5;
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
  /*
  void setStartX(float x) {
   startX = x;
   }
   void setStartY(float y) {
   startY = y;
   }
   */
  void setEndPos(float x, float y, int duration) {
    endY = y;
    endX = x;
    startX = currentX;
    startY = currentY;
    animationStart = millis();
    animationEnd = animationStart + duration;
    lastTime = animationStart;
  }

  void setEndLayout(float x, float y, float w, float h, int theColor, int duration) {
    endW = w;
    endH = h;
    endX = x;
    endY = y;
    endColor = theColor;

    startX = currentX;
    startY = currentY;
    startW = currentW;
    startH = currentH;
    startColor = currentColor;

    animationStart = millis();
    animationEnd = animationStart + duration;
    lastTime = animationStart;
  }
  /*
  void setEndY(float y, int duration) {
   endY = y;
   }
   */
  /*
  void setCurrentX(float x) {
   currentX = x;
   }
   
   void setCurrentY(float y) {
   currentY = y;
   }
   */
  void setColor(color theColor) {
    currentColor = theColor;
  }

  void update(long delta) {
    long now = lastTime + delta;
    now = Math.min(animationEnd, now);
    if (now == animationEnd || animationStart == animationEnd) {
      currentX = endX;
      currentY = endY;
      currentW = endW;
      currentH = endH;
      currentColor = endColor;
    } else {
      currentX = map(now, animationStart, animationEnd, startX, endX);
      currentY = map(now, animationStart, animationEnd, startY, endY);
      currentW = map(now, animationStart, animationEnd, startW, endW);
      currentH = map(now, animationStart, animationEnd, startH, endH);
      currentColor = lerpColor(startColor, endColor, norm(now, animationStart, animationEnd));
    }
    /*
    if (time == 1) {
     startX = endX;
     startY = endY;
     }
     */
    lastTime = now;
  }


  void display(PGraphics g) {
    if (getGPIRank(activeYear) == GPI_LAST_RANK) {
      displayOutlined(g);
    } else {
      displayFilled(g);
    }
  }

  void displayFilled(PGraphics g) {
    g.noStroke();
    g.fill(currentColor);
    if (hover || selected) {
      g.fill(PRIMARY);
    }
    float z = -1;
    g.vertex(this.currentX, this.currentY, z);
    g.vertex(this.currentX + this.currentW, this.currentY, z);
    g.vertex(this.currentX + this.currentW, this.currentY + this.currentH, z);
    g.vertex(this.currentX, this.currentY + this.currentH, z);
    //display country name
    if (hover || selected) {
      g.endShape();
      g.textFont(INFO);
      g.textAlign(BOTTOM, LEFT);
      float m = 5; //margin
      float nameY = currentY + currentH + m;
      g.fill(PRIMARY);
      if (currentY + currentH + nameWidth + m > myContainerLayout.y + myContainerLayout.h) {
        g.fill(0);
        nameY -= nameWidth + 2*m;
      }
      g.pushMatrix();
      g.translate(currentX, nameY);
      g.rotate(HALF_PI);
      g.text(name, 0, 0);
      g.popMatrix();
      g.beginShape(QUADS);
    }
  }

  String getGPIRankString(int year) {
    Integer result = getGPIRank(year);
    if (result == GPI_LAST_RANK) {
      return "N/A";
    }
    return result + "";
  }

  void displayOutlined(PGraphics g) {
    g.endShape();
    g.beginShape(QUADS);
    g.strokeWeight(1);
    g.fill(0);
    g.stroke(currentColor);
    if (hover || selected) {
      g.stroke(PRIMARY);
    }
    float z = -1;
    g.vertex(this.currentX, this.currentY, z);
    g.vertex(this.currentX + this.currentW, this.currentY, z);
    g.vertex(this.currentX + this.currentW, this.currentY + this.currentH, z);
    g.vertex(this.currentX, this.currentY + this.currentH, z);
    //display country name
    if (hover || selected) {
      g.endShape();
      g.textFont(INFO);
      g.textAlign(BOTTOM, LEFT);
      float m = 5; //margin
      float nameY = currentY + currentH + m;
      g.fill(PRIMARY);
      if (currentY + currentH + nameWidth + m > myContainerLayout.y + myContainerLayout.h) {
        g.fill(0);
        nameY -= nameWidth + 2*m;
      }
      g.pushMatrix();
      g.translate(currentX, nameY);
      g.rotate(HALF_PI);
      g.text(name, 0, 0);
      g.popMatrix();
      g.beginShape(QUADS);
    }
    g.endShape();
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
  public boolean isHover(float x, float y) {
    return x >= currentX && x <= currentX + currentW && y >= currentY && y <= currentY + currentH;
    //return x >= currentX && x <= currentX + currentW;
  }

  Long getImmigration(int theYear) {
    return totalImmigraionFlow.get(theYear);
  }

  Long getEmigration(int theYear) {
    return totalEmigraionFlow.get(theYear);
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
      //println("CLICK", e);
      if (hover) {
        selected = true;
      } else {
        selected = false;
      }
      break;
    }
  }
}