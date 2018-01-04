import java.util.*;

Table countryData, flowData, populationData;

//GENERAL CONSTANTS
final int GPI_YEAR_START = 2008;
final int GPI_YEAR_END = 2016;
final int MIGRATION_YEAR_START = 1980;
final int MIGRATION_YEAR_END = 2013;
final int GPI_MIN = 1;
final int GPI_MAX = 5;
final int SET_START_POS = 0;
final int SET_END_POS = 1;

//SORTING TYPE CONSTANTS
final int SORT_BY_COUNTRY_NAME = 0;
final int SORT_BY_CONTINENT = 1;
final int SORT_BY_INDEX = 2; //needs an active year
final int SORT_BY_CONTINENT_THEN_INDEX = 3;

float TIME = 0;
float TIME_INC = 0.01;

//Layout globals
float margin = 10;
float gap = 2;
Long POPULATION_MIN = Long.MAX_VALUE;
Long POPULATION_MAX = Long.MIN_VALUE;

ArrayList<Hoverable> hoverables = new ArrayList<Hoverable>();
ArrayList<Country> countries = new ArrayList<Country>();
//Map of countries, labelled by names
HashMap<String, Country> countriesByName = new HashMap<String, Country>();

HashMap<Integer, ArrayList<MigrationFlow>> migrationFlows = new HashMap<Integer, ArrayList<MigrationFlow>>(); 

int currentYear = 2013;

void setup() {
  size(1024, 512);
  //load tables
  countryData = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  flowData = loadTable("GlobalMigration.tsv", "header, tsv");
  populationData = loadTable("API_SP.POP.TOTL_DS2_en_csv_v2.csv", "header");
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
    countries.add(theCountry);
    hoverables.add(theCountry);
    countriesByName.put(name, theCountry);

    //we add the gpi and population value for each year to country "theCountry"
    for (int year = GPI_YEAR_START; year <= GPI_YEAR_END; year++) {
      String yearString = "score_" + year; //building the right column name
      Float gpi = row.getFloat(yearString); //retrieving the value (a float number) for the given column (year)
      theCountry.setGPI(year, gpi); //putting the value into the country

      //find country row by iso-3 code
      TableRow countryRow = populationData.findRow(theCountry.iso3, 1);
      if (countryRow == null) {
        println(theCountry.name, "not FOUND!!!");
      } else {
        Long pop = countryRow.getLong(year + "");
        theCountry.setPOP(year, pop);
        POPULATION_MIN = Math.min(pop, POPULATION_MIN);
        POPULATION_MAX = Math.max(pop, POPULATION_MAX);
      }
    }
  }
  for (TableRow tr : flowData.rows()) {
    int from = max(GPI_YEAR_START, MIGRATION_YEAR_START);
    int to = min(GPI_YEAR_END, MIGRATION_YEAR_END);
    for (int year = from; year <= to; year++) {
      String originName = tr.getString("from");
      String destinationName = tr.getString("to");
      Country origin = countriesByName.get(originName);
      Country destination = countriesByName.get(destinationName);
      if (origin == null) {
        println("ORIGIN NOT FOUND", originName);
      } else if (destination == null) {
        println("DESTINATION NOT FOUND", destinationName);
      } else {
        Long flow = tr.getLong(year + "");
        if (flow != null) {
          ArrayList<MigrationFlow> flows = migrationFlows.get(year);
          if (flows == null) {
            flows = new ArrayList<MigrationFlow>();
            migrationFlows.put(year, flows);
          }
          flows.add(new MigrationFlow(origin, destination, year, flow));
        }
      }
    }
  }
  //print all keys
  //println("KEYS:\n", countries.keySet());
  //println("-----");
  //print all countries
  //println("VALUES:\n", countries);
  //println("-----");
  //showing the Iceland’s GPI for 2008
  //println(countries.get("ISL").getGPI(2016));

  //Example of animating between two layouts
  //first sort by one criterium, then set start layout
  sortCountries(countries, SORT_BY_COUNTRY_NAME, currentYear);
  makeLayout(margin, margin, width - 2 * margin, height-2*margin, gap, countries, SET_START_POS, currentYear);

  //sort by other criterium, then set end layout
  sortCountries(countries, SORT_BY_CONTINENT_THEN_INDEX, 2016);
  makeLayout(margin, margin, width - 2 * margin, height-2*margin, gap, countries, SET_END_POS, currentYear);
  println("Population MIN", POPULATION_MIN);
  println("Population MAX", POPULATION_MAX);
}

void draw() {
  //draw countries
  background(0);
  noStroke();
  fill(255);
  textSize(20);
  for (Country theCountry : countries) {
    //println(theCountry.name);
    theCountry.update(TIME);
    theCountry.display(g);
  }

  if (TIME < 1) {
    checkHover();
  }

  TIME += TIME_INC;
  TIME = min(TIME, 1);
  //println(TIME);
}

void checkHover() {
  for (Hoverable h : hoverables) {
    if (h.isHover(mouseX, mouseY)) {
      h.hoverOn();
    } else {
      h.hoverOff();
    }
  }
}

void mouseMoved() {
  checkHover();
}