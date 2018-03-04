void loadData(boolean verbose) {
  //load tables
  countryDataBase = loadTable("gpi_2008-2016_geocodes+continents_v4.csv", "header");
  countryDataExtended = loadTable("gpi_2008-2017_with_Ranking.csv", "header");
  flowData = loadTable("migrationData.tsv", "header, tsv");
  populationData = loadTable("country_populations_names.tsv", "header, tsv");

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

  /*
  for (int year = from; year <= to; year++) {
    migrationFlows.put(year, new ArrayList<MigrationFlow>());
  }
  */
  for (TableRow tr : flowData.rows()) {
    String originLookupName = tr.getString("from");
    String destinationLookupName = tr.getString("to");

    Country origin = countriesByLookupName.get(originLookupName);
    Country destination = countriesByLookupName.get(destinationLookupName);
    if (origin != null && destination != null) {
      MigrationRelation mr = new MigrationRelation(origin, destination);
      MigrationFlow mf = migrationFlows.get(mr);
      if (mf == null) {
        mf = new MigrationFlow(mr, flowLayout);
        migrationFlows.put(mr, mf);
      }
      for (int year = from; year <= to; year++) {
        try {
          Long flowVolume = tr.getLong(year + "");
          //TODO: treat negative values
          if (flowVolume > 0) {
            MIGRATION_FLOW_MIN = Math.min(flowVolume, MIGRATION_FLOW_MIN);
            MIGRATION_FLOW_MAX = Math.max(flowVolume, MIGRATION_FLOW_MAX);
          }
        }
        catch (Exception e) {
          if (verbose) {
            e.printStackTrace();
          }
        }
      }
    }
  }

  for (TableRow tr : flowData.rows()) {
    String originLookupName = tr.getString("from");
    String destinationLookupName = tr.getString("to");

    Country origin = countriesByLookupName.get(originLookupName);
    Country destination = countriesByLookupName.get(destinationLookupName);
    if (origin != null && destination != null) {
      MigrationRelation mr = new MigrationRelation(origin, destination);
      MigrationFlow mf = migrationFlows.get(mr);
      for (int year = from; year <= to; year++) {
        try {
          Long flowVolume = tr.getLong(year + "");
          //TODO: treat negative values
          if (flowVolume > 0) {
            //println("adding", year, flowVolume, "->", mf);
            mf.addFlow(year, flowVolume);
          }
        }
        catch (Exception e) {
          if (verbose) {
            //println("line 129");
            e.printStackTrace();
          }
        }
      }
    }
  }

  //TODO: print flows by years
  println("migration flow min:", MIGRATION_FLOW_MIN);
  println("migration flow max:", MIGRATION_FLOW_MAX);
  println("migration relation count:", migrationFlows.size());
  for (Country c : countries) {
    c.updateTotals(YEAR_START,YEAR_END);
  }
  /*
  for (MigrationFlow mf : migrationFlows.values()) {
    mf.myFlowNorm = mf.getNormFlowLog(currentYear);
  }
  */

  //clean-up in order to remove ambiguity
  /*
  HashMap<MigrationRelation, MigrationFlow> tempFlows = new HashMap<MigrationRelation, MigrationFlow>();
  for (MigrationRelation mr : migrationFlows.keySet()) {
    MigrationFlow mf = migrationFlows.get(mr);
    MigrationRelation mrInverse = new MigrationRelation(mr.destination, mr.origin);
    MigrationFlow mfInverse = migrationFlows.get(mrInverse);
    if (mfInverse != null) {
      for (int y = YEAR_START; y <= YEAR_END; y++) {
        Long flow = mf.getFlow(y);
        Long flowInverse = mfInverse.getFlow(y);
        Long delta = flow - flowInverse;
        if (flow > 0 && flowInverse > 0) {
          println(mr.origin, mr.destination, y, flow, flowInverse);
        }
        if (delta >= 0) {
          mf.updateFlow(y, delta);
          mfInverse.updateFlow(y, 0L);
        } else {
          mfInverse.updateFlow(y, -delta);
          mf.updateFlow (y, 0L);
        }
      }
    }
  }*/
}


ArrayList<MigrationFlow> getTopThree(Country theReferenceCountry) {
  ArrayList<MigrationFlow> result = new ArrayList<MigrationFlow>();
  float firstFlow = 0f;
  float secondFlow = 0f;
  float thirdFlow = 0f;
  MigrationFlow firstCountry = null;
  MigrationFlow secondCountry = null;
  MigrationFlow thirdCountry = null;
  for (MigrationRelation mr : migrationFlows.keySet()) {
    MigrationFlow mf = migrationFlows.get(mr);
    boolean consider = false;
    if(theReferenceCountry == null) {
      consider = true;
    } else if (mf.originEquals(theReferenceCountry) || mf.destinationEquals(theReferenceCountry)) {
      consider = true;
    }
    if (consider) {
      //this could be more general :D
      float candidateFlow = mf.getFlow(currentYear);
      if (candidateFlow > firstFlow) {
        thirdFlow = secondFlow;
        secondFlow = firstFlow;
        firstFlow = candidateFlow;
        thirdCountry = secondCountry;
        secondCountry = firstCountry;
        firstCountry = mf;
      } else if (candidateFlow > secondFlow) {
        thirdFlow = secondFlow;
        secondFlow = candidateFlow;
        thirdCountry = secondCountry;
        secondCountry = mf;
      } else if (candidateFlow > thirdFlow) {
        thirdFlow = candidateFlow;
        thirdCountry = mf;
      }
    }
  }

  result.add(firstCountry);
  result.add(secondCountry);
  result.add(thirdCountry);
  return result;
}
