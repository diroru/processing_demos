import java.util.*;

Table dataTable;
ArrayList<String> countries;
ArrayList<Datum> data = new ArrayList<Datum>();

void setup() {
  size(1024,1024,P2D);
  dataTable = loadTable("plane-crashes.iso8_v3.csv", "header");
  HashSet<String> countrySet = new HashSet<String>();

  for (int i = 0; i < dataTable.getRowCount(); i++) {
    TableRow row = dataTable.getRow(i);
    Datum d = new Datum(row);
    data.add(d);
    countrySet.add(d.country);
  }
  countries = new ArrayList<String>(countrySet);
  Collections.sort(countries);
  println(countries);
}

void draw() {
}