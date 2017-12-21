import java.util.*;

Table data;
Set<String> countryNames = new HashSet<String>();

int yearStart = 1980;
int yearEnd = 2013; 

void setup() {
  data = loadTable("GlobalMigration.tsv", "header, tsv");
  for (TableRow tr : data.rows()) {
    countryNames.add(tr.getString("from"));
    countryNames.add(tr.getString("to"));
  }
  println("there are", countryNames.size(), "unique countries");
  List<String> sortedCountries = new ArrayList<String>(countryNames);
  Collections.sort(sortedCountries);
  printArray(sortedCountries.toArray());
}