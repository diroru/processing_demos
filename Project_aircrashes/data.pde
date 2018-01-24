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

void initDots() {
  ArrayList<CrashDot> previousOnes = new ArrayList<CrashDot>();
  for (Datum d : data) {
    println(d);
    CrashDot cd = new CrashDot(d, timeline, previousOnes, this); 
    myDots.add(cd);
    previousOnes.add(cd);
  }
}