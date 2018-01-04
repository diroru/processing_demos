class FatalitiesByYear {
  int year, total;
  HashMap<String, Integer> byCountry = new HashMap<String, Integer>();
 
  FatalitiesByYear(int theYear) {
    year = theYear;
    total = 0;
  }
  
  void addFatalities(String country, int count) {
    Integer existing = byCountry.get(country);
    if (existing != null) {
      //println("MULTIPLE ACCIDENTS FOR", year, country, existing);
    } else {
      existing = 0;
    }
    byCountry.put(country, existing + count);
    total += count;
  }
  
  Integer getFatalities(String country) {
    return byCountry.get(country);
  }
}