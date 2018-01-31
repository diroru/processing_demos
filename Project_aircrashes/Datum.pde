class Datum implements Comparable {
  int day, month, year;
  String date;
  Integer id;
  String depCountry, dstCountry;
  Float[] depLatLng = new Float[2], dstLatLng = new Float[2];
  String phaseCode;
  int fatalities, occupants;
  boolean isUnusual;

  Datum(TableRow tr) {
    //month = tr.getInt("month");
    year = tr.getInt("year");
    date = tr.getString("date");
    month = Integer.parseInt(date.split("/")[0]);
    day = Integer.parseInt(date.split("/")[1]);
    id = tr.getInt("id");
    depCountry = tr.getString("departure");
    dstCountry = tr.getString("destination_country");
    depLatLng[0] = tr.getFloat("departure_airport_lat");
    depLatLng[1] =tr.getFloat("departure_airport_lng");
    dstLatLng[0] = tr.getFloat("destination_airport_lat");
    dstLatLng[1] = tr.getFloat("destination_airport_lng");
    phaseCode = tr.getString("phase_code");
    fatalities = tr.getInt("total_fatalities");
    occupants = tr.getInt("total_occupants");

    int unusualFlag = tr.getInt("unusual_flag");
    isUnusual = unusualFlag > 0;
    //year = Integer.parseInt(date.split("/")[2]);
  }

  @Override
    String toString() {
    return year + " | " + month + " | " + day;
  }

  @Override
    public boolean equals(Object obj) {
    if (!(obj instanceof Datum)) {
      return false;
    }
    Datum d = ((Datum) obj);
    //TODO!!!
    return d.id.equals(this.id);
  }

  boolean coordsValid() {
    return depLatLng[0] != null && depLatLng[1] != null && dstLatLng[0] != null && dstLatLng[1] != null;
  }

  @Override
    public int compareTo(Object o) {
    Datum other = (Datum) o;
    int dayComparison = this.day - other.day;
    int monthComparison = this.month - other.month;
    int yearComparison = this.year - other.year;

    if (yearComparison != 0) return yearComparison;
    if (monthComparison != 0) return monthComparison;
    return dayComparison;
  }
}