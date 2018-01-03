ArrayList<Country> getSortedCountries(HashMap<String, Country> theCountries, int theSortingMethod, int theActiveYear) {
  //get only countries as a list
  ArrayList<Country> result = new ArrayList<Country>(theCountries.values());
  //set the proper sorting method for each country
  for (Country theCountry : result) {
    theCountry.sortingMethod = theSortingMethod;
    theCountry.activeYear = theActiveYear;
  }
  //do the sorting
  Collections.sort(result);
  return result;
}