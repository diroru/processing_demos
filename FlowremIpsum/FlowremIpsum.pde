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
Long MIGRATION_FLOW_MAX = Long.MIN_VALUE;
Long MIGRATION_FLOW_MIN = Long.MAX_VALUE;

ArrayList<Hoverable> hoverables = new ArrayList<Hoverable>();
ArrayList<Country> countries = new ArrayList<Country>();
//Map of countries, labelled by names
HashMap<String, Country> countriesByName = new HashMap<String, Country>();

HashMap<Integer, ArrayList<MigrationFlow>> migrationFlows = new HashMap<Integer, ArrayList<MigrationFlow>>(); 

//lookup table for mismatched country names
HashMap<String, String> countryLookupTable = new HashMap<String, String>(); 
ArrayList<String> missingCountries = new ArrayList<String>();

int currentYear = 2013;

void setup() {
  size(1024, 512, P3D);
  pixelDensity(2);
  ellipseMode(CORNER);
  textSize(20);
  //load tables
  countryData = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  flowData = loadTable("GlobalMigration.tsv", "header, tsv");
  populationData = loadTable("API_SP.POP.TOTL_DS2_en_csv_v2.csv", "header");

  countryLookupTable.put("United States of America", "United States");
  countryLookupTable.put("Viet Nam", "Vietnam");
  countryLookupTable.put("Republic of Korea", "South Korea");
  countryLookupTable.put("Iran (Islamic Republic of)", "Iran");
  countryLookupTable.put("Côte d'Ivoire", "Ivory Coast");
  countryLookupTable.put("Congo", "Republic of the Congo");
  countryLookupTable.put("Venezuela (Bolivarian Republic of)", "Venezuela");
  countryLookupTable.put("Russian Federation", "Russia");
  countryLookupTable.put("China, Taiwan Province of China", "Taiwan");
  countryLookupTable.put("Democratic People's Republic of Korea", "North Korea");
  countryLookupTable.put("Lao People's Democratic Republic", "Laos");
  countryLookupTable.put("Bolivia (Plurinational State of)", "Bolivia");
  countryLookupTable.put("Syrian Arab Republic", "Syria");
  countryLookupTable.put("The former Yugoslav Republic of Macedonia", "Macedonia");
  countryLookupTable.put("United Republic of Tanzania", "Tanzania");
  countryLookupTable.put("China (including Hong Kong Special Administrative Region)", "China");
  countryLookupTable.put("TfYR of Macedonia", "Macedonia");
  countryLookupTable.put("Republic of Moldova", "Moldova");
  countryLookupTable.put("China, Hong Kong Special Administrative Region", "China");
  countryLookupTable.put("State of Palestine", "Palestine");

 
  missingCountries.add("Wallis and Futuna Islands");
  missingCountries.add("United States Virgin Islands");
  missingCountries.add("Tuvalu");
  missingCountries.add("Turks and Caicos Islands");
  missingCountries.add("Saint Pierre and Miquelon");
  missingCountries.add("Saint Helena");
  missingCountries.add("Réunion");
  missingCountries.add("Puerto Rico");
  missingCountries.add("Palau");
  missingCountries.add("Tuvalu");
  missingCountries.add("New Caledonia");
  missingCountries.add("Niue");
  missingCountries.add("Northern Mariana Islands");
  missingCountries.add("Comoros");
  missingCountries.add("China, Macao Special Administrative Region");
  missingCountries.add("Cook Islands");
  missingCountries.add("Liechtenstein");
  missingCountries.add("Martinique");
  missingCountries.add("Marshall Islands");
  missingCountries.add("Micronesia (Federated States of)");
  missingCountries.add("Monaco");
  missingCountries.add("Montserrat");
  missingCountries.add("Nauru");
  missingCountries.add("Anguilla");
  missingCountries.add("Antigua and Barbuda");
  missingCountries.add("Aruba");
  missingCountries.add("Bahamas");
  missingCountries.add("Barbados");
  missingCountries.add("Belize");
  missingCountries.add("Bermuda");
  missingCountries.add("Seychelles");
  missingCountries.add("United Kingdom of Great Britain and Northern Ireland");
  missingCountries.add("Luxembourg");
  missingCountries.add("Maldives");
  missingCountries.add("Malta");
  missingCountries.add("Saint Kitts and Nevis");
  missingCountries.add("Saint Lucia");
  missingCountries.add("Saint Vincent and the Grenadines");
  missingCountries.add("Samoa");
  missingCountries.add("San Marino");
  missingCountries.add("Sao Tome and Principe");
  missingCountries.add("Solomon Islands");
  missingCountries.add("Suriname");
  missingCountries.add("Tonga");
  missingCountries.add("Vanuatu");
  missingCountries.add("Western Sahara");
  missingCountries.add("Andorra");
  missingCountries.add("Brunei Darussalam");
  missingCountries.add("Cabo Verde");
  missingCountries.add("Fiji");
  missingCountries.add("Holy See");
  missingCountries.add("Kiribati");
  missingCountries.add("British Virgin Islands");
  missingCountries.add("Cayman Islands");
  missingCountries.add("Dominica");
  missingCountries.add("Grenada");
  missingCountries.add("American Samoa");
  missingCountries.add("Falkland Islands (Malvinas)");
  missingCountries.add("French Guiana");
  missingCountries.add("French Polynesia");
  missingCountries.add("Gibraltar");
  missingCountries.add("Greenland");
  missingCountries.add("Guadeloupe");
  missingCountries.add("Unknown");


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
        String originTemp = originName + "";
        //println("ORIGIN NOT FOUND (1ST ATTEMPT)", originName, "->", destinationName);
        originName = countryLookupTable.get(originName);
        origin = countriesByName.get(originName);
        if (origin == null) {
           if (!missingCountries.contains(originTemp)) println("ORIGIN STILL NOT FOUND: ", originTemp, "->", destinationName);
        }
      }
      if (destination == null) {
        String destinationTemp = originName + "";
        //println("DESTINATION NOT FOUND (1ST ATTEMPT)", originName, "->", destinationName);
        destinationName = countryLookupTable.get(destinationName);
        destination = countriesByName.get(destinationName);
        if (destination == null) {
          if (!missingCountries.contains(destinationTemp)) println("DESTINATION STILL NOT FOUND: ", originName, "->", destinationTemp);
        }
      }

      if (origin == null) {
        //println("ORIGIN NOT FOUND", originName);
      } else if (destination == null) {
        //println("DESTINATION NOT FOUND", destinationName);
      } else if (!originName.equalsIgnoreCase(destinationName)) {
        Long flow = tr.getLong(year + "");
        if (flow != null) {
          ArrayList<MigrationFlow> flows = migrationFlows.get(year);
          if (flows == null) {
            flows = new ArrayList<MigrationFlow>();
            migrationFlows.put(year, flows);
          }
          flows.add(new MigrationFlow(origin, destination, year, flow));
          MIGRATION_FLOW_MIN = Math.min(flow, MIGRATION_FLOW_MIN);
          MIGRATION_FLOW_MAX = Math.max(flow, MIGRATION_FLOW_MAX);
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
  makeLayout(margin, margin  + height/2, width - 2 * margin, height/2-2*margin, gap, countries, SET_START_POS, currentYear);

  //sort by other criterium, then set end layout
  sortCountries(countries, SORT_BY_CONTINENT_THEN_INDEX, 2016);
  makeLayout(margin, margin  + height/2, width - 2 * margin, height/2-2*margin, gap, countries, SET_END_POS, currentYear);
  println("Population MIN", POPULATION_MIN);
  println("Population MAX", POPULATION_MAX);
  //println(countries);
}

void draw() {
  //draw countries
  background(0);
  noStroke();
  fill(255);
  noStroke();
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
  noFill();
  stroke(255,31);
  strokeWeight(2);
  for (MigrationFlow mf : migrationFlows.get(currentYear)) {
    if (mf.flow > 100) {
      mf.display_v4(g, height/2, margin);
    }
    
  }
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