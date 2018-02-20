import java.util.*;

ArrayList<Integer> years = new ArrayList<Integer>();
HashSet<String> countryNames = new HashSet<String>();
HashMap<Integer, ArrayList<Datum>> yearlyData = new HashMap<Integer, ArrayList<Datum>>();

String countryLabel ="Major area, region, country or area of destination";
Table sourceData, outputData;

void setup() {
  size(100,100);
  sourceData = loadTable("UN_MigrantStockByOriginAndDestination_2017.csv", "header, tsv");
  println(sourceData.getRowCount(), sourceData.getColumnCount());
  //get start and end years, years and country names
  int yearStart = Integer.MAX_VALUE;
  int yearEnd = Integer.MIN_VALUE;
  for (TableRow tr : sourceData.rows()) {
    Integer y = tr.getInt("Year");
    yearStart = min(yearStart, y);
    yearEnd = max(yearEnd, y);
    if (!years.contains(y)) {
      years.add(y);
    }
    String countryName = tr.getString(countryLabel);
    countryNames.add(countryName);
  }
  println("start: ", yearStart, " end: ", yearEnd, years);
  println("countries: ", countryNames);

  for (Integer y : years) {
    yearlyData.put(y, new ArrayList<Datum>());
  }
  //TODO: define excludes
  for (TableRow tr : sourceData.rows()) {
    Integer year = tr.getInt("Year");
    String toCountry = tr.getString(countryLabel);
    for (String fromCountry : countryNames) {
      try {
        Long migrantCount = tr.getLong(fromCountry);
        if (migrantCount > 0) {
          yearlyData.get(year).add(new Datum(fromCountry, toCountry, year, migrantCount));
          println(fromCountry, toCountry, year, migrantCount);
        }
      } catch(Exception e) {

      }
    }
  }
  outputData = new Table();
  outputData.addColumn("year");
  outputData.addColumn("from");
  outputData.addColumn("to");
  outputData.addColumn("migrant_count");
  
}

class Datum {
  String from;
  String to;
  Integer year;
  Long migrantCount;

  Datum(String from, String to, Integer year, Long migrantCount) {
    this.from = from;
    this.to = to;
    this.year = year;
    this.migrantCount = migrantCount;
  }

  @Override
  boolean equals(Object o) {
    Datum other = (Datum)o;
    return from.equals(other.from) && to.equals(other.to) && year.equals(other.year);
  }
}
