void loadData(boolean verbose) {
  //load tables
  countryDataBase = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  countryDataExtended = loadTable("gpi_2008-2017_with_Ranking.csv", "header");
  flowData = loadTable("migrationData.tsv", "header, tsv");
  populationData = loadTable("country_populations_names.tsv", "header, tsv");

  treatTableExceptions();

  //instantiate countries
  for (int i = 0; i < countryDataBase.getRowCount(); i++) {
    TableRow row = countryDataBase.getRow(i);
    String iso3 = row.getString("alpha-3");
    String iso2 = row.getString("alpha-2");
    String name = row.getString("country");
    String region = row.getString("region");
    String subRegion = row.getString("sub-region");
    String lookupName = populationData.findRow(iso3, "alpha-3").getString("name_lookup"); 

    if (lookupName.equals("")) {
      println("lookup name not found!!!!", name, lookupName, iso3);
    }

    TableRow extendedRow = countryDataExtended.findRow(name, "Country");
    if (extendedRow == null) {
      println(name, "not found");
    }
    //println(extendedRow);


    //make new country, only local
    Country theCountry = new Country(name, lookupName, iso3, iso2, region, subRegion, this, canvas, graphLayout);
    if (!flags.containsKey(iso2)) {
      flags.put(iso2, loadImage("Flags/country-flags-master/png100px/" + iso2.toLowerCase() + ".png"));
    }

    //add to collection of countries
    countries.add(theCountry);
    countriesByName.put(name, theCountry);
    countriesByLookupName.put(lookupName, theCountry);


    //we add the gpi and population value for each year to country "theCountry"
    for (int year = GPI_YEAR_START; year <= GPI_YEAR_END; year++) {
      String yearString = year + " score"; //building the right column name
      String rankString = year + " rank"; //building the right column name
      Float gpi = extendedRow.getInt(yearString) / 1000.0; //retrieving the value (a float number) for the given column (year)
      Integer gpiRank = extendedRow.getInt(rankString);
      //if (name.equals("Palestine")) {
      //  println(year, gpi, gpiRank);
      //}
      if (gpiRank == 0) {
        theCountry.setGPI(year, GPI_LAST_RANK+0f); //putting the value into the country
        theCountry.setGPIRank(year, GPI_LAST_RANK); //putting the value into the country
      } else {
        theCountry.setGPI(year, gpi); //putting the value into the country
        theCountry.setGPIRank(year, gpiRank); //putting the value into the country
      }

      //find country row by iso-3 code
      TableRow countryRow = populationData.findRow(theCountry.iso3, "alpha-3");
      if (countryRow == null) {
        if (verbose) println(theCountry.name, "not FOUND!!!");
      } else {
        Long pop = countryRow.getLong(year + "");
        theCountry.setPOP(year, pop);
        POPULATION_MIN = Math.min(pop, POPULATION_MIN);
        POPULATION_MAX = Math.max(pop, POPULATION_MAX);
        //if (verbose) println(theCountry.name, pop);
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
    String originLookupName = tr.getString("from");
    String destinationLookupName = tr.getString("to");

    for (int year = from; year <= to; year++) {
      Country origin = countriesByLookupName.get(originLookupName);
      Country destination = countriesByLookupName.get(destinationLookupName);
      if (origin != null && destination != null) {
        try {
          Long flowVolume = tr.getLong(year + "");
          //TODO: treat negative values
          if (flowVolume > 0) {
            ArrayList<MigrationFlow> flows = migrationFlows.get(year);
            MigrationFlow mf = new MigrationFlow(origin, destination, year, flowVolume); 
            flows.add(mf);
            origin.addEmigrationFlow(mf);
            destination.addImmigrationFlow(mf);
            MIGRATION_FLOW_MIN = Math.min(flowVolume, MIGRATION_FLOW_MIN);
            MIGRATION_FLOW_MAX = Math.max(flowVolume, MIGRATION_FLOW_MAX);
          }
        } 
        catch (Exception e) {
          if (verbose) {
            e.printStackTrace();
          } 
        }
      }  /*else if (origin == null && verbose) {
        //println("ORIGIN NOT FOUND", originLookupName);
      } else if (verbose) {
        //println("DESTINATION NOT FOUND", destinationLookupName);
      }*/
    }
  }
  for (Integer y : migrationFlows.keySet()) {
    println("flow count: ", y, migrationFlows.get(y).size());
  }
  println("migration flow min:", MIGRATION_FLOW_MIN);
  println("migration flow max:", MIGRATION_FLOW_MAX);
}

/*
void stuff(boolean verbose) {
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
 }
 */

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