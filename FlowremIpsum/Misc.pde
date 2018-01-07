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

void drawArcLine(PGraphics g, float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3) {
  float w = x2 - x1;
  float h = min(y0, y3) - y1;
  if (w >= 2*h) {
    g.line(x0, y0, x1, y1 + h);
    g.arc(x1, y1, h*2, h*2, PI, PI+HALF_PI, OPEN);
    g.line(x1 + h, y1, x2 - h, y2);
    g.arc(x2-2*h, y2, h*2, h*2, PI+HALF_PI, TWO_PI, OPEN);
    g.line(x2, y2 + h, x3, y3);
  } else {
    g.line(x0, y0, x1, y1+w/2);
    g.arc(x1, y1, w, w, PI, PI+HALF_PI, OPEN);
    g.arc(x1, y1, w, w, PI+HALF_PI, TWO_PI, OPEN);
    g.line(x2, y2 + w*0.5, x3, y3);
  }
}

void treatTableExceptions() {
    countryLookupTable.put("United States of America", "United States");
  countryLookupTable.put("Viet Nam", "Vietnam");
  countryLookupTable.put("Republic of Korea", "South Korea");
  countryLookupTable.put("Iran (Islamic Republic of)", "Iran");
  countryLookupTable.put("Côte d'Ivoire", "Ivory Coast");
  countryLookupTable.put("Congo", "Republic of the Congo");
  countryLookupTable.put("Venezuela (Bolivarian Republic of)", "Venezuela");
  countryLookupTable.put("Russian Federation", "Russia");
  countryLookupTable.put("China, Taiwan Province of China", "Taiwan");
  countryLookupTable.put("Democratic People's Republic of Korea", "North Korea");
  countryLookupTable.put("Lao People's Democratic Republic", "Laos");
  countryLookupTable.put("Bolivia (Plurinational State of)", "Bolivia");
  countryLookupTable.put("Syrian Arab Republic", "Syria");
  countryLookupTable.put("The former Yugoslav Republic of Macedonia", "Macedonia");
  countryLookupTable.put("United Republic of Tanzania", "Tanzania");
  countryLookupTable.put("China (including Hong Kong Special Administrative Region)", "China");
  countryLookupTable.put("TfYR of Macedonia", "Macedonia");
  countryLookupTable.put("Republic of Moldova", "Moldova");
  countryLookupTable.put("China, Hong Kong Special Administrative Region", "China");
  countryLookupTable.put("State of Palestine", "Palestine");

 
  missingCountries.add("Wallis and Futuna Islands");
  missingCountries.add("United States Virgin Islands");
  missingCountries.add("Tuvalu");
  missingCountries.add("Turks and Caicos Islands");
  missingCountries.add("Saint Pierre and Miquelon");
  missingCountries.add("Saint Helena");
  missingCountries.add("Réunion");
  missingCountries.add("Puerto Rico");
  missingCountries.add("Palau");
  missingCountries.add("Tuvalu");
  missingCountries.add("New Caledonia");
  missingCountries.add("Niue");
  missingCountries.add("Northern Mariana Islands");
  missingCountries.add("Comoros");
  missingCountries.add("China, Macao Special Administrative Region");
  missingCountries.add("Cook Islands");
  missingCountries.add("Liechtenstein");
  missingCountries.add("Martinique");
  missingCountries.add("Marshall Islands");
  missingCountries.add("Micronesia (Federated States of)");
  missingCountries.add("Monaco");
  missingCountries.add("Montserrat");
  missingCountries.add("Nauru");
  missingCountries.add("Anguilla");
  missingCountries.add("Antigua and Barbuda");
  missingCountries.add("Aruba");
  missingCountries.add("Bahamas");
  missingCountries.add("Barbados");
  missingCountries.add("Belize");
  missingCountries.add("Bermuda");
  missingCountries.add("Seychelles");
  missingCountries.add("United Kingdom of Great Britain and Northern Ireland");
  missingCountries.add("Luxembourg");
  missingCountries.add("Maldives");
  missingCountries.add("Malta");
  missingCountries.add("Saint Kitts and Nevis");
  missingCountries.add("Saint Lucia");
  missingCountries.add("Saint Vincent and the Grenadines");
  missingCountries.add("Samoa");
  missingCountries.add("San Marino");
  missingCountries.add("Sao Tome and Principe");
  missingCountries.add("Solomon Islands");
  missingCountries.add("Suriname");
  missingCountries.add("Tonga");
  missingCountries.add("Vanuatu");
  missingCountries.add("Western Sahara");
  missingCountries.add("Andorra");
  missingCountries.add("Brunei Darussalam");
  missingCountries.add("Cabo Verde");
  missingCountries.add("Fiji");
  missingCountries.add("Holy See");
  missingCountries.add("Kiribati");
  missingCountries.add("British Virgin Islands");
  missingCountries.add("Cayman Islands");
  missingCountries.add("Dominica");
  missingCountries.add("Grenada");
  missingCountries.add("American Samoa");
  missingCountries.add("Falkland Islands (Malvinas)");
  missingCountries.add("French Guiana");
  missingCountries.add("French Polynesia");
  missingCountries.add("Gibraltar");
  missingCountries.add("Greenland");
  missingCountries.add("Guadeloupe");
  missingCountries.add("Unknown");
}