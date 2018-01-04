//TODO: decide about 2014!!!

import java.util.*;

Table dataTable;
ArrayList<String> countries;
ArrayList<Datum> data = new ArrayList<Datum>();

int YEAR_START = Integer.MAX_VALUE;
int YEAR_END = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_YEAR = Integer.MIN_VALUE;

HashMap<Integer, FatalitiesByYear> byYear = new HashMap<Integer, FatalitiesByYear>();
TreeMap<Integer, Integer> totalDistribution, yearlyDistribution;

void setup() {
  size(1680, 1050, P2D);
  dataTable = loadTable("plane-crashes.iso8_v3.csv", "header");
  HashSet<String> countrySet = new HashSet<String>();
  for (int i = 0; i < dataTable.getRowCount(); i++) {
    TableRow row = dataTable.getRow(i);
    Datum d = new Datum(row);
    data.add(d);
    countrySet.add(d.country);
    YEAR_START = min(d.year, YEAR_START);
    YEAR_END = max(d.year, YEAR_END);
  }
  countries = new ArrayList<String>(countrySet);
  Collections.sort(countries);
  println(countries);

  for (int i = YEAR_START; i <= YEAR_END; i++) {
    byYear.put(i, new FatalitiesByYear(i));
  }
  for (Datum d : data) {
    byYear.get(d.year).addFatalities(d.country, d.total);
  }

  for (FatalitiesByYear fat : byYear.values()) {
    MAX_FATALITIES_PER_YEAR = max(MAX_FATALITIES_PER_YEAR, fat.total);
  }

  println("MAX PER YEAR", MAX_FATALITIES_PER_YEAR);

  //DRAW "MATRIX"
  
  background(0);
  float m = 20;
  float p = 2;
  float w = (width - m*2 - (countries.size()-1) * p) / float(countries.size());
  float h = (height - m*2 - (byYear.size()-1) * p) / float(byYear.size());
  float x0 = m;
  float y0 = m;
  float x = x0;
  float y = y0;
  for (int i = YEAR_START; i <= YEAR_END; i++) {
    FatalitiesByYear fby = byYear.get(i);
    for (String country : countries) {
      Integer fatalities = fby.getFatalities(country);
      if (fatalities == null) {
        fill(16);
      } else if (fatalities == 0) {
        fill(63);
      } else {
        float f = map(fatalities, 0, MAX_FATALITIES_PER_YEAR, 63, 255);
        fill(255, f, f);
      }
      noStroke();
      rect(x,y,w,h);
      x += w + p;
    }
    x = x0;
    y += h + p;
  }
  
  totalDistribution = getTotalDistribution(dataTable);
  yearlyDistribution = getYearlyDistribution(new ArrayList<FatalitiesByYear>(byYear.values()));
}

void draw() {
  /*
  background(0);
  drawDistribution(totalDistribution, color(255,0,0), 20);
  drawDistribution(yearlyDistribution, color(0,255,0), 20);
*/
}