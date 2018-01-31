void initData() {
  worstData = loadTable("180111_toProcess_worst.tsv", "header"); 
  unusualData = loadTable("180111_toProcess_unusual.tsv", "header");
  for (TableRow tr : worstData.rows()) {
    data.add(new Datum(tr));
  }
  for (TableRow tr : unusualData.rows()) {
    data.add(new Datum(tr));
  }

  Collections.sort(data);
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