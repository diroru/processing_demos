class Datum {
  int day, month, year;
  String date;
  
  
  Datum(TableRow tr) {
    //month = tr.getInt("month");
    year = tr.getInt("year");
    date = tr.getString("date");
    month = Integer.parseInt(date.split("/")[0]);
    day = Integer.parseInt(date.split("/")[1]);
    //year = Integer.parseInt(date.split("/")[2]);
  }
  
  @Override
  String toString() {
    return year + " | " + month + " | " + day;
  }
}