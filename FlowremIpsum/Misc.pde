void sortCountries(ArrayList<Country> theCountries, int theSortingMethod, int theActiveYear) {
  //get only countries as a list
  //set the proper sorting method for each country
  for (Country theCountry : theCountries) {
    theCountry.sortingMethod = theSortingMethod;
    theCountry.activeYear = theActiveYear;
  }
  //do the sorting
  Collections.sort(theCountries);
}