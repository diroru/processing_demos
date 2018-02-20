void setup() {
  size(100,100);
  Table sourceData = loadTable("UN_MigrantStockByOriginAndDestination_2017.csv", "header, tsv");
  println(sourceData.getRowCount(), sourceData.getColumnCount());
  //get start and end years
  int yearStart = Integer.MAX_VALUE;
  int yearEnd = Integer.MIN_VALUE;
  for (TableRow tr : sourceData.rows()) {
    int y = tr.getInt("Year");
    if(y < 1990) {
      println(y);
    }
    yearStart = min(yearStart, y);
    yearEnd = max(yearEnd, y);
  }
  println("start: ", yearStart, " end: ", yearEnd);
}
