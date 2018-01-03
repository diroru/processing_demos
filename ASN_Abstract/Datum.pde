class Datum {
  int year, month, day, total;
  String country;
  
  Datum(TableRow row) {
    year = row.getInt("year");
    month = row.getInt("month");
    day = row.getInt("day");
    total = row.getInt("total_fatalities");
    country = row.getString("accident_country");
    if (country.equalsIgnoreCase("Unknown")) {
      country = "Unknown country";
    }
  }
}