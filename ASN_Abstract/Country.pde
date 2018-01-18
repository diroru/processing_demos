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

  ArrayList<Datum> data = new ArrayList<Datum>();

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
  }

  void addDatum(Datum theDatum) {
    data.add(theDatum);
  }

  int getAccidentCount() {
    int result = 0;
    for (Datum d : data) {
      result++;
    }
    return result;
  }

  int getFatalityCount() {
    int result = 0;
    for (Datum d : data) {
      result += d.total_fatalities;
    }
    return result;
  }

  void display(PGraphics g) {
    //g.fill(col);
    g.noStroke();
    if (highlight) {
      g.fill(255);
      g.rect(this.currentX-GAP, this.currentY-GAP, this.currentW+GAP*2, this.currentH+GAP*2);
    }

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
    g.rect(this.currentX, this.currentY, this.currentW, this.currentH);
    if (hover) {

      //g.text(this.name, mappedMouse.x + 10, mappedMouse.y - 10);
    }
  }

  float getCasualtyPercentage() {
    float occupantSum = 0;
    float fatalitySum = 0;
    for (Datum d : data) {
      occupantSum += d.total_occupants;
      fatalitySum += d.total_fatalities;
    }
    if (fatalitySum == 0f) {
      return 0;
    }
    return fatalitySum/occupantSum;
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
    if (yearComparison != 0) {
      return yearComparison;
    }
    switch(currentSorting) {
    case SORT_BY_NAME:
      return this.name.compareTo(otherCountry.name);
    case SORT_BY_ACCIDENT_COUNT:
      return this.getAccidentCount() - otherCountry.getAccidentCount();
    case SORT_BY_FATALITY_COUNT:
      return this.getFatalityCount() - otherCountry.getFatalityCount();
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