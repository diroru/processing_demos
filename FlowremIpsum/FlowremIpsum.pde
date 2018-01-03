//map of country objects, labelled by their iso3 code
HashMap<String, Country> countries = new HashMap<String, Country>();
Table countryData, flowData;

void setup() {
  size(1024, 512);
  //load tables
  countryData = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  flowData = loadTable("GlobalMigration.tsv", "header, tsv");
  //instantiate countries
  for (int i = 0; i < countryData.getRowCount(); i++) {
    TableRow row = countryData.getRow(i);
    String iso3 = row.getString("alpha-3");
    String name = row.getString("country");
    String region = row.getString("region");
    String subRegion = row.getString("sub-region");
    //make new country, only local
    Country c = new Country(name, iso3, region, subRegion);
    //add to collection of countries
    countries.put(iso3, c);
  }
  //print all keys
  println("KEYS:\n", countries.keySet());
  println("-----");
  //print all countries
  println("VALUES:\n", countries.values());
  println("-----");
}

void draw() {
}