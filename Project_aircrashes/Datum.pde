class Datum implements Comparable {
  int day, month, year;
  String date;
  Integer id;
  
  Datum(TableRow tr) {
    //month = tr.getInt("month");
    year = tr.getInt("year");
    date = tr.getString("date");
    month = Integer.parseInt(date.split("/")[0]);
    day = Integer.parseInt(date.split("/")[1]);
    id = tr.getInt("id");
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