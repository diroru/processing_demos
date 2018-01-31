void initData() {
  worstData = loadTable("180111_toProcess_worst.tsv", "header"); 
  unusualData = loadTable("180111_toProcess_unusual.tsv", "header");
  for (TableRow tr : worstData.rows()) {
    Datum d = new Datum(tr);
    if (!data.contains(d)) {
      data.add(d);
    }
    
  }
  for (TableRow tr : unusualData.rows()) {
    Datum d = new Datum(tr);
    if (!data.contains(d)) {
      data.add(d);
    }
  }

  Collections.sort(data);
  println("LOADED ", data.size(), " DATA");
  println("FATALITIES", MIN_FATALITIES, " – ", MAX_FATALITIES);
  println("OCCUPANTS", MIN_OCCUPANTS, " – ", MAX_OCCUPANTS);
}

void initFlights(Timeline tl) {
  for (Datum d : data) {
    myFlights.add(new CrashFlight(d, tl));
  }
}

void initDots() {
  ArrayList<CrashDot> previousOnes = new ArrayList<CrashDot>();
  for (Datum d : data) {
    for (int i = 0; i < REPEAT_COUNT; i++) {
      //println(d);
      CrashDot cd = new CrashDot(d, timeline, previousOnes, this, i); 
      myDots.add(cd);
      previousOnes.add(cd);
    }
  }
}