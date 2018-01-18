void initData() {
  dataTable = loadTable("plane-crashes.iso8_v3.csv", "header");
  countryNameSet = new HashSet<String>();
  for (int i = 0; i < dataTable.getRowCount(); i++) {
    TableRow row = dataTable.getRow(i);
    Datum d = new Datum(row);
    data.add(d);
    countryNameSet.add(d.country);
    YEAR_START = min(d.year, YEAR_START);
    YEAR_END = max(d.year, YEAR_END);
  }
  currentYear = YEAR_END;
  countryNames = new ArrayList<String>(countryNameSet);
  Collections.sort(countryNames);
  println(countryNames, countryNames.size() );

  for (String countryName : countryNames) {
    TreeMap<Integer, Country> countryMap = new TreeMap<Integer, Country>(); 
    for (int year = YEAR_START; year <= YEAR_END; year++) {
      Country theCountryInYear = new Country(countryName, year, this);
      countries.add(theCountryInYear);
      countryMap.put(year, theCountryInYear);
    }
    dataBase.put(countryName, countryMap);
  }

  for (Datum d : data) {
    TreeMap<Integer, Country> countryMap = null;
    Country c = null;
    try {
      countryMap = dataBase.get(d.country);
      c = countryMap.get(d.year);
      c.addDatum(d);
    } 
    catch(Exception e) { //<>//
      if (countryMap == null) { //<>//
        println("ERROR in DB!!!, null", c, d);
      } else {
        println("ERROR in DB!!!", countryMap.size(), c, d);
      }
    }
  }

  //println("MAX PER YEAR", MAX_FATALITIES_PER_YEAR);
}

TreeMap<Integer, ArrayList<Country>> getCountriesByYears(TreeMap<String, TreeMap<Integer, Country>>db, int yearStart, int yearEnd, ArrayList<Integer> decades) {
  TreeMap<Integer, ArrayList<Country>> result = new TreeMap<Integer, ArrayList<Country>>();
  int currentDecade = -1;
  Iterator di = decades.iterator();
  if (di.hasNext()) {
    currentDecade = (Integer)(di.next());
  }

  int year = yearStart;
  while (year <= yearEnd) {
    TreeMap<String, Country> countries = new TreeMap<String, Country>();
    if (year == currentDecade) {
      //println("dec", currentDecade);
      for (int i = 0; i < 10; i++) {
        int yearInDecade = year + i;
        if (yearInDecade <= yearEnd) {
          for (String countryName : countryNames) {
            Country c = countries.get(countryName);
            if (c == null) {
              c = db.get(countryName).get(yearInDecade);
            } else {
              c = new Country(yearInDecade, c, db.get(countryName).get(yearInDecade), this);
            }
            countries.remove(countryName);
            countries.put(countryName, c);
          }
        }
      }
      result.put(year, new ArrayList<Country>(countries.values()));
      year+= 10;
      if (di.hasNext()) {
        currentDecade = (Integer)(di.next());
      }
    } else {
      for (String countryName : countryNames) {
        countries.put(countryName, db.get(countryName).get(year));
      }
      result.put(year, new ArrayList<Country>(countries.values()));
      year++;
    }
  }

  return result;
}

TreeMap<Integer, ArrayList<Country>> getCountriesByYears(ArrayList<Integer> decades) {
  return getCountriesByYears(dataBase, YEAR_START, YEAR_END, decades);
}


TreeMap<Integer, ArrayList<Country>> getCountriesByYears() {
  return getCountriesByYears(dataBase, YEAR_START, YEAR_END, new ArrayList<Integer>());
}

ArrayList<Country> getCountries() {
  /*
  ArrayList<Country> result = new ArrayList<Country>();
  for (ArrayList<Country> c : getCountriesByYears().values()) {
     result.addAll(c);
  }  
  return result;
  */
  return countries;
}

int getColumnCount() {
  return countryNameSet.size();
}

int getRowCount() {
  return YEAR_END - YEAR_START;
}

Country getContryInYear(String countryName, int year) {
  return dataBase.get(countryName).get(year);
}

int getFatalityComparison(String countryA, String countryB, int theYear) {
  return getContryInYear(countryA, theYear).getTotalFatalities() - getContryInYear(countryB, theYear).getTotalFatalities();
}