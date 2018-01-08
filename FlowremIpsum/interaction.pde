void setCurrentYear(int theNewYear) {
  makeStartLayout(currentYear);
  makeEndLayout(theNewYear);
  TIME = 0;
  currentYear = theNewYear;
}