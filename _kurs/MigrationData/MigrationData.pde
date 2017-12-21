String[] countries = {"Armenia","Australia","Austria","Azerbaijan","Belarus","Belgium","Bulgaria","Canada","Croatia","Cyprus","Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary","Iceland","Ireland","Italy","Kazakhstan","Kyrgyzstan","Latvia","Liechtenstein","Lithuania","Luxembourg","Malta","Netherlands","New Zealand","Norway","Poland","Portugal","Republic of Moldova","Romania","Russian Federation","Slovakia","Slovenia","Spain","Sweden","Switzerland","TfYR of Macedonia","Ukraine","United Kingdom","United States of America"};

HashMap<String, Table> countryData = new HashMap<String, Table>();

void setup() {
  size(200,200,P2D);
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
}