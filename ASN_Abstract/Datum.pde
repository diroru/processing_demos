class Datum {
  int year, month, day, total_fatalities, total_occupants;
  String country;
  
  Datum(TableRow row) {
    year = row.getInt("year");
    month = row.getInt("month");
    day = row.getInt("day");
    total_fatalities = row.getInt("total_fatalities");
    country = row.getString("accident_country");
    total_occupants = row.getInt("total_occupants");
    if (country.equalsIgnoreCase("Unknown")) {
      country = "Unknown country";
    }
  }
}