//map of country objects, labelled by their iso3 code
HashMap<String, Country> countries = new HashMap<String, Country>();
Table countryData, flowData;
int GPI_YEAR_START = 2008;
int GPI_YEAR_END = 2016;

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
    Country theCountry = new Country(name, iso3, region, subRegion);
    //add to collection of countries
    countries.put(iso3, theCountry);
    //we add the gpi value for each year to country "theCountry"
    for (int year = GPI_YEAR_START; year <= GPI_YEAR_END; year++) {
      String yearString = "score_" + year;
      Float gpi = row.getFloat(yearString);
      theCountry.setGPI(year, gpi);
    }
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