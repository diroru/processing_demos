import java.util.*;

ArrayList<Integer> years = new ArrayList<Integer>();
HashSet<String> countryNames = new HashSet<String>();
HashMap<Flow, Datum> data = new HashMap<Flow, Datum>();

String countryLabel ="Major area, region, country or area of destination";
Table sourceData, outputData;

void setup() {
  size(100, 100);
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

  //TODO: define excludes
  //building new database
  //going through all rows
  for (TableRow tr : sourceData.rows()) {
    Integer year = tr.getInt("Year");
    String toCountry = tr.getString(countryLabel);
    for (String fromCountry : countryNames) {
      try {
        Long migrantCount = tr.getLong(fromCountry);
        if (migrantCount > 0) {
          Flow f = new Flow(fromCountry, toCountry);
          Datum d = data.get(f);
          if (d == null) {
            d = new Datum(fromCountry, toCountry);
            data.put(f, d);
          }
          d.addData(year, migrantCount);
          //println(fromCountry, toCountry, year, migrantCount);
        }
      } 
      catch(Exception e) {
      }
    }
  }
  for (Datum d : data.values()) {
    //println(d);
  }
  outputData = new Table();
  //outputData.addColumn("year");
  outputData.addColumn("from");
  outputData.addColumn("to");
  //outputData.addColumn("migrant_count");
  for (int i = yearStart; i <= yearEnd; i++) {
    outputData.addColumn(i + "");
  }
  int c = 0;
  for (Datum d : data.values()) {
    TableRow row = outputData.addRow();
    row.setString("from", d.flow.from);
    row.setString("to", d.flow.to);

    int lastYear = yearStart;
    Long lastCount = d.getData(lastYear);
    for (int i = yearStart; i <= yearEnd; i++) {
      Long count = d.getData(i);
      int nextYear = i;
      if (count == 0L) {
        Long nextCount = count;
        while (nextCount == 0 && nextYear <= yearEnd) {
          nextYear++;
          nextCount = d.getData(nextYear);
        }
        count = floor(float(i - lastYear) / (nextYear - lastYear) * (nextCount - lastCount) + lastCount) + 0L;
      } else {
        print("* ");
        lastCount = count;
        lastYear = i;
      }
      row.setLong(i + "", count);
      println(i, count);
    }
    //println(c++);
  }
  saveTable(outputData, "data/output.tsv", "tsv");
  saveStrings("data/countries.txt", countryNames.toArray(new String[countryNames.size()]));
  println("finished");
  exit();
}

class Flow {
  String from;
  String to;
  Flow(String from, String to) {
    this.from = from;
    this.to = to;
  }
  @Override
    boolean equals(Object o) {
    Flow other = (Flow)o;
    return from.equals(other.from) && to.equals(other.to);
  }

  @Override
    public int hashCode() {
    return Objects.hash(from, to);
  }

  @Override
    String toString() {
    return from + " -> " + to + "\n";
  }
}

class Datum {
  Flow flow;
  HashMap<Integer, Long> migrantCount = new HashMap<Integer, Long>();

  Datum(String from, String to) {
    this.flow = new Flow(from, to);
  }

  void addData(int year, Long count) {
    migrantCount.put(year, count);
  }

  Long getData(Integer year) {
    Long result = 0L;
    if (migrantCount.get(year) != null) {
      result = migrantCount.get(year);
    }
    return result;
  }

  @Override
    boolean equals(Object o) {
    Datum other = (Datum)o;
    return flow.equals(other.flow);
  }

  @Override
    public int hashCode() {
    return Objects.hash(flow);
  }

  @Override
    String toString() {
    String result = flow.toString();
    for (Integer y : migrantCount.keySet()) {
      result += y + ": " + migrantCount.get(y) + "\n";
    }
    result += "--------\n";
    return result;
  }
}