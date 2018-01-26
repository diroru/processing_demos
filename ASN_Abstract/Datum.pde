class Datum {
  int year, month, day, total_fatalities, total_occupants;
  String country, phase, phase_code, location;
  
  Datum(TableRow row) {
    year = row.getInt("year");
    month = row.getInt("month");
    day = row.getInt("day");
    total_fatalities = row.getInt("total_fatalities");
    country = row.getString("accident_country");
    total_occupants = row.getInt("total_occupants");
    phase = row.getString("phase"); 
    phase_code = row.getString("phase_code"); 
    location = row.getString("location_full");
    if (country.equalsIgnoreCase("Unknown")) {
      country = "Unknown country";
    }
  }
  
  String getDate() {
    return nf(day,2) + "." + nf(month,2) + "." + nf(year,2);
  }
  
  @Override
  String toString() {
    return country + " | " + year + "/" + month + "/" + day + " : " + total_fatalities;
  }
}