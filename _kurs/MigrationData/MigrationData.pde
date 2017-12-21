String[] countries = {"Armenia","Australia","Austria","Azerbaijan","Belarus","Belgium","Bulgaria","Canada","Croatia","Cyprus","Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary","Iceland","Ireland","Italy","Kazakhstan","Kyrgyzstan","Latvia","Liechtenstein","Lithuania","Luxembourg","Malta","Netherlands","New Zealand","Norway","Poland","Portugal","Republic of Moldova","Romania","Russian Federation","Slovakia","Slovenia","Spain","Sweden","Switzerland","TfYR of Macedonia","Ukraine","United Kingdom","United States of America"};

HashMap<String, Table> countryData = new HashMap<String, Table>();

void setup() {
  size(200,200,P2D);
  // for(int i = 0; i < countries.length; i++) { //sames as
  for (String countryName : countries) {
    String fileName = countryName + ".csv";
    Table countryTable = loadTable(fileName, "header, tsv");
    //println(countryName);
    println(countryTable.getColumnTitles());
    if (countryTable.getColumnTitles().length == 0) {
      println(countryName, "ERROR");
    }
    
    countryData.put(countryName, countryTable);
  }
  Table globalData = new Table();
}