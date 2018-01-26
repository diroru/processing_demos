void loadData(boolean verbose) {
  //load tables
  countryData = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  flowData = loadTable("GlobalMigration.tsv", "header, tsv");
  populationData = loadTable("API_SP.POP.TOTL_DS2_en_csv_v2.csv", "header");

  treatTableExceptions();

  //instantiate countries
  for (int i = 0; i < countryData.getRowCount(); i++) {
    TableRow row = countryData.getRow(i);
    String iso3 = row.getString("alpha-3");
    String name = row.getString("country");
    String region = row.getString("region");
    String subRegion = row.getString("sub-region");

    //make new country, only local
    Country theCountry = new Country(name, iso3, region, subRegion, this, canvas, graphLayout);

    //add to collection of countries
    countries.add(theCountry);
    countriesByName.put(name, theCountry);

    //we add the gpi and population value for each year to country "theCountry"
    for (int year = GPI_YEAR_START; year <= GPI_YEAR_END; year++) {
      String yearString = "score_" + year; //building the right column name
      Float gpi = row.getFloat(yearString); //retrieving the value (a float number) for the given column (year)
      theCountry.setGPI(year, gpi); //putting the value into the country

      //find country row by iso-3 code
      TableRow countryRow = populationData.findRow(theCountry.iso3, 1);
      if (countryRow == null) {
        if (verbose) println(theCountry.name, "not FOUND!!!");
      } else {
        Long pop = countryRow.getLong(year + "");
        theCountry.setPOP(year, pop);
        POPULATION_MIN = Math.min(pop, POPULATION_MIN);
        POPULATION_MAX = Math.max(pop, POPULATION_MAX);
      }
    }
  }
  int from  = YEAR_START;
  int to = YEAR_END;

  for (int year = from; year <= to; year++) {
    migrationFlows.put(year, new ArrayList<MigrationFlow>());
  }
  for (TableRow tr : flowData.rows()) {
    //int from = max(GPI_YEAR_START, MIGRATION_YEAR_START);
    //int to = min(GPI_YEAR_END, MIGRATION_YEAR_END);
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
          if (!missingCountries.contains(originTemp)) {
            if (verbose) println("ORIGIN STILL NOT FOUND: ", originTemp, "->", destinationName);
          }
        }
      }
      if (destination == null) {
        String destinationTemp = originName + "";
        //println("DESTINATION NOT FOUND (1ST ATTEMPT)", originName, "->", destinationName);
        destinationName = countryLookupTable.get(destinationName);
        destination = countriesByName.get(destinationName);
        if (destination == null) {
          if (!missingCountries.contains(destinationTemp)) {
            if (verbose) println("DESTINATION STILL NOT FOUND: ", originName, "->", destinationTemp);
          }
        }
      }

      if (origin == null) {
        //println("ORIGIN NOT FOUND", originName);
      } else if (destination == null) {
        //println("DESTINATION NOT FOUND", destinationName);
      } else if (!originName.equalsIgnoreCase(destinationName)) {
        try {
          Long flowVolume = tr.getLong(year + "");
          if (flowVolume != null) {
            ArrayList<MigrationFlow> flows = migrationFlows.get(year);
            /*
            if (flows == null) {
             flows = new ArrayList<MigrationFlow>();
             migrationFlows.put(year, flows);
             }
             */
            flows.add(new MigrationFlow(origin, destination, year, flowVolume));
            MIGRATION_FLOW_MIN = Math.min(flowVolume, MIGRATION_FLOW_MIN);
            MIGRATION_FLOW_MAX = Math.max(flowVolume, MIGRATION_FLOW_MAX);
          }
        } 
        catch (Exception e) {
          //e.printStackTrace();
        }
      }
    }
  }
  for (Integer y : migrationFlows.keySet()) {
    println(y, migrationFlows.get(y).size());
  }
}

void treatTableExceptions() {
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
}