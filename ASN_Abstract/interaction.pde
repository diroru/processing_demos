void setHighlight(String countryName, int year) { //<>//
  for (Country c : getCountries()) { //<>//
    if (c.name.equalsIgnoreCase(countryName)) { //<>//
      println(countryName); //<>//
      c.highlight = true;
    } else if (c.year == year) {
      println(year);
      c.highlight = true;
    } else {
      c.highlight = false;
    }
  }
}

void unsetHighlight() {
  for (Country c : getCountries()) {
    c.highlight = false;
  }
}