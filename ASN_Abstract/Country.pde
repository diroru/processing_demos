//Contains data for a country for a period of time
//in other words
public class Country implements Comparable {
  float startX, startY, startW, startH;
  float endX, endY, endW, endH;
  float currentX, currentY, currentW, currentH;

  boolean hover;
  int year;
  String name;
  String iso3;
  boolean highlight = false;
  int c0 = NO_CRASHES, c1 = NO_CRASHES;

  ArrayList<Datum> data = new ArrayList<Datum>();

  long animationStart, animationEnd, lastTime;

  Country(String theName, int theYear, PApplet parent) {
    parent.registerMethod("mouseEvent", this);
    name = theName;
    year = theYear;
  }

  Country(int theYear, Country c0, Country c1, PApplet parent) {
    this(c0.name, theYear, parent);
    if (!c0.name.equals(c1.name)) {
      println("ERROR CREATING COUNTRY", c0, c1);
    }
    this.addDatum(c0);
    this.addDatum(c1);
  }

  void addDatum(Country c) {
    data.addAll(c.data);
    updateColors();
  }

  void addDatum(Datum theDatum) {
    data.add(theDatum);
    updateColors();
  }

  void updateColors() {
    if (data.size() == 0) {
      c0 = NO_CRASHES;
      c1 = NO_CRASHES;
    } else {
      int minPercentage = 100;
      int maxPercentage = 0;
      for (Datum d : data) {
        int percentage = 0;
        if (d.total_fatalities > 0) {
          percentage = (d.total_fatalities * 100) / d.total_occupants;
        }
        minPercentage = min(minPercentage, percentage);
        maxPercentage = max(maxPercentage, percentage);
      }
      //see colors.pde
      c0 = getColor(minPercentage);
      c1 = getColor(maxPercentage);
      println(minPercentage, maxPercentage);
    }
  }

  int getAccidentCount() {
    return data.size();
  }

  int getFatalityCount() {
    int result = 0;
    for (Datum d : data) {
      result += d.total_fatalities;
    }
    return result;
  }

  void update(long delta) {
    long now = lastTime + delta;
    now = Math.min(animationEnd, now);
    if (now == animationEnd || animationStart == animationEnd) {
      currentX = endX;
      currentY = endY;
    } else {
      currentX = map(now, animationStart, animationEnd, startX, endX);
      currentY = map(now, animationStart, animationEnd, startY, endY);
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
    //g.fill(col);
    g.noStroke();
    if (highlight) {
      g.fill(255);
      g.rect(this.currentX-GAP, this.currentY-GAP, this.currentW+GAP*2, this.currentH+GAP*2);
    }
  
    g.noStroke();
    g.fill(c1);
    g.beginShape();
    g.vertex(this.currentX, this.currentY);
    g.vertex(this.currentX + this.currentW, this.currentY);
    g.vertex(this.currentX, this.currentY + this.currentH);
    g.endShape(CLOSE);
    
    
    g.fill(c0);
    g.beginShape();
    g.vertex(this.currentX + this.currentW, this.currentY);
    g.vertex(this.currentX + this.currentW, this.currentY + this.currentH);
    g.vertex(this.currentX, this.currentY + this.currentH);
    g.endShape(CLOSE);

  
    /*
  
    int accidentCount = getAccidentCount();
    float casualtyPercentage = getCasualtyPercentage();
    if (accidentCount == 0) {
      g.fill(255, 16);
    } else {
      if (casualtyPercentage == 0f) {
        g.fill(255, 63);
      } else if (casualtyPercentage < 0.9) {
        g.fill(192, 0, 0);
      } else {
        g.fill(255, 0, 0);
      }
    }
    */
    //g.rect(this.currentX, this.currentY, this.currentW, this.currentH);
    if (hover) {

      //g.text(this.name, mappedMouse.x + 10, mappedMouse.y - 10);
    }
  }

  int getTotalFatalities() {
    int fatalitySum = 0;
    for (Datum d : data) {
      fatalitySum += d.total_fatalities;
    }
    return fatalitySum;
  }

  float getCasualtyPercentage() {
    float occupantSum = 0;
    float fatalitySum = getTotalFatalities();
    if (fatalitySum == 0f) {
      return 0;
    }
    for (Datum d : data) {
      occupantSum += d.total_occupants;
    }
    return fatalitySum/occupantSum;
  }

  void setEndPos(float x, float y, int duration) {
    endY = y;
    endX = x;
    startX = currentX;
    startY = currentY;
    animationStart = millis();
    animationEnd = animationStart + duration;
    lastTime = animationStart;
  }


  void setStartLayout(float theX, float theY, float theW, float theH) {
    startX = theX;
    startY = theY;
    startW = theW;
    startH = theH;
  }

  void setCurrentLayout(float theX, float theY, float theW, float theH) {
    currentX = theX;
    currentY = theY;
    currentW = theW;
    currentH = theH;
  }

  void setEndLayout(float theX, float theY, float theW, float theH) {
    endX = theX;
    endY = theY;
    endW = theW;
    endH = theH;
  }

  //COMPARISON
  @Override
    public boolean equals(Object obj) {
    if (!(obj instanceof Country)) {
      return false;
    }
    Country c = ((Country) obj); 
    return c.year == this.year && c.name.equals(this.name);
  }

  @Override
    public int compareTo(Object o) {
    Country otherCountry = (Country) o;
    //always sort first by year!!!
    int yearComparison = this.year - otherCountry.year;
    int nameComparison = this.name.compareTo(otherCountry.name);
    int fatalityComparison = this.getTotalFatalities() - otherCountry.getTotalFatalities();
    if (yearComparison != 0) {
      return yearComparison;
    }
    switch(currentSorting) {
    case SORT_BY_NAME:
      return this.name.compareTo(otherCountry.name);
    case SORT_BY_ACCIDENT_COUNT:
      return this.getAccidentCount() - otherCountry.getAccidentCount();
    case SORT_BY_FATALITY_COUNT:
      //return this.getFatalityCount() - otherCountry.getFatalityCount();
      return getFatalityComparison(this.name, otherCountry.name, currentYear);
    }

    return 0;
  }

  public boolean isHover(float x, float y) {
    return x >= currentX && x <= currentX + currentW && y >= currentY && y <= currentY + currentH;
    //return x >= currentX && x <= currentX + w;
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      //println("MOVE", e);
      hover = isHover(mappedMouse.x, mappedMouse.y);
      //println(mappedMouse.x, mappedMouse.y, currentX, currentY);
      if (hover) {
        setHighlight(name, year);
      } else {
        //unsetHighlight();
      }
      break;
    case MouseEvent.CLICK:
      if (isHover(mappedMouse.x, mappedMouse.y)) {
        println("CLICK", e);
      }
      break;
    }
  }
}