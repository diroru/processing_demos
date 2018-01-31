void initData() {
  worstData = loadTable("180111_toProcess_worst.tsv", "header"); 
  unusualData = loadTable("180111_toProcess_unusual.tsv", "header");
  for (TableRow tr : worstData.rows()) {
    Datum d = new Datum(tr);
    phaseCodes.add(d.phaseCode);
    MIN_FATALITIES = min(d.fatalities, MIN_FATALITIES);
    MAX_FATALITIES = max(d.fatalities, MAX_FATALITIES);
    MIN_OCCUPANTS = min(d.occupants, MIN_OCCUPANTS);
    MAX_OCCUPANTS = max(d.occupants, MAX_OCCUPANTS);

    if (!data.contains(d)) {
      data.add(d);
    }
  }
  for (TableRow tr : unusualData.rows()) {
    Datum d = new Datum(tr);
    phaseCodes.add(d.phaseCode);
    MIN_FATALITIES = min(d.fatalities, MIN_FATALITIES);
    MAX_FATALITIES = max(d.fatalities, MAX_FATALITIES);
    MIN_OCCUPANTS = min(d.occupants, MIN_OCCUPANTS);
    MAX_OCCUPANTS = max(d.occupants, MAX_OCCUPANTS);

    if (!data.contains(d)) {
      data.add(d);
    }
  }

  Collections.sort(data);
  println("LOADED ", data.size(), " DATA");
  println("FATALITIES", MIN_FATALITIES, " – ", MAX_FATALITIES);
  println("OCCUPANTS", MIN_OCCUPANTS, " – ", MAX_OCCUPANTS);
  println("PHASE CODES", phaseCodes);
  
  phaseProgress.put("APR", 0f); //approach
  phaseProgress.put("ICL", 0f); //initial climb
  phaseProgress.put("UNK", 0.5f); //unknown
  phaseProgress.put("TXI", 0f); //taxi
  phaseProgress.put("ENR", 0.5f); //en route
  phaseProgress.put("En route", 0.5f); //en route
  phaseProgress.put("TOF", 0f); //takeoff
  phaseProgress.put("LDG", 1f); //landing
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