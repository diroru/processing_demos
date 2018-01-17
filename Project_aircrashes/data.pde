int[] days = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int dayCount = 366;
int monthCount = 12;

float getNormalizedMoment(Datum d, Timeline tl) {
  return getNormalizedMoment(d.day, d.month, d.year, tl.startYear, tl.endYear);
}

float getNormalizedMoment(int d, int m, int y, int startYear, int endYear) {
  //TODO: might need long sometimes
  int timeInterval = (endYear - startYear) * 366;
  
  int moment = d + (y - startYear) * 366;
  for (int i = 0; i < m - 1; i++) {
    moment += days[i];
  }
  return moment / (timeInterval-0f);
}

void initData() {
  worstData = loadTable("180111_toProcess_worst.tsv", "header"); 
  unusualData = loadTable("180111_toProcess_unusual.tsv", "header");
  for (TableRow tr : worstData.rows()) {
    data.add(new Datum(tr));
  }
  /*
  for (TableRow tr : unusualData.rows()) {
    data.add(new Datum(tr));
  }
  */
  for (Datum d : data) {
    println(d);
  }
}