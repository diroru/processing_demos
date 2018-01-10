class Datum {
  int year, month, day, total_fatalities, total_occupants;
  String country, phase;
  
  Datum(TableRow row) {
    year = row.getInt("year");
    month = row.getInt("month");
    day = row.getInt("day");
    total_fatalities = row.getInt("total_fatalities");
    country = row.getString("accident_country");
    total_occupants = row.getInt("total_occupants");
    phase = row.getString("phase"); 
    if (country.equalsIgnoreCase("Unknown")) {
      country = "Unknown country";
    }
  }
  
  @Override
  String toString() {
    return country + " | " + year + "/" + month + "/" + day + " : " + total_fatalities;
  }
}