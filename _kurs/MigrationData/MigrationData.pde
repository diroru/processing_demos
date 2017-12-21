String[] countries = {"Armenia", "Australia", "Austria", "Azerbaijan", "Belarus", "Belgium", "Bulgaria", "Canada", "Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Kazakhstan", "Kyrgyzstan", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg", "Malta", "Netherlands", "New Zealand", "Norway", "Poland", "Portugal", "Republic of Moldova", "Romania", "Russian Federation", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "TfYR of Macedonia", "Ukraine", "United Kingdom", "United States of America"};

HashMap<String, Table> countryData = new HashMap<String, Table>();

void setup() {
  size(200, 200, P2D);
  // for(int i = 0; i < countries.length; i++) { //sames as
  for (String countryName : countries) { //iterate trough countries
    String fileName = countryName + ".csv"; //generate file name, adds .csv
    Table countryTable = loadTable(fileName, "header, tsv");
    //println(countryName);
    //println(countryTable.getColumnTitles());
    if (countryTable.getColumnTitles().length == 0) { //checks if column titles are right
      println(countryName, "ERROR");
    }

    countryData.put(countryName, countryTable); //adding table
  }
  Table globalData = new Table();
  Table first = countryData.get("Armenia");
  String[] columnTitles = first.getColumnTitles(); //get sample column titles from first element

  globalData.setColumnTitle(0, "from");
  globalData.setColumnTitle(1, "to");
  for (int i = 0; i < columnTitles.length; i++ ) {
    globalData.setColumnTitle(i + 2, columnTitles[i]); //set column titles of global data table
  }
  printArray(globalData.getColumnTitles());

  for (String countryName : countries) {
    Table countryDatum = countryData.get(countryName);
    for (TableRow sourceRow : countryDatum.rows()) {
      TableRow newRow = globalData.addRow(); //add empty row to global table
      copyRow(sourceRow, newRow);
    }
  }
  saveTable(globalData, "test.csv");
  exit();
}

void copyRow(TableRow from, TableRow to) {
  for (String column : from.getColumnTitles()) {
    int columnType = from.getColumnType(column);
    switch(columnType) {
    case Table.INT:
      to.setInt(column, from.getInt(column));
      break;
    case Table.LONG:
      to.setLong(column, from.getLong(column));
      break;
    case Table.DOUBLE:
      to.setDouble(column, from.getDouble(column));
      break;
    case Table.FLOAT:
      to.setFloat(column, from.getFloat(column));
      break;
    case Table.STRING:
      to.setString(column, from.getString(column));
      break;
    }
  }
}