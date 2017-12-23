class MigrationFlow {
  int year, volume;
  MigrationCountry from, to;
  MigrationFlow(MigrationCountry theFrom, MigrationCountry theTo, int theYear, int theVolume) {
    from = theFrom;
    to = theTo;
    year = theYear;
    volume = theVolume;
  }
  
  @Override
  String toString() {
    return "(" + year + ") " + from.name + " -> " + to.name + " : " + volume;
  }
}