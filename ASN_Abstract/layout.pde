final int SET_START_POS = 0;
final int SET_END_POS = 1;

void makeLayout(LayoutInfo theLayout) {
  makeLayout(theLayout, SET_START_POS, new ArrayList<Integer>());
}

void makeLayout(LayoutInfo theLayout, ArrayList<Integer> decades) {
  makeLayout(theLayout, SET_START_POS, decades);
}

void makeLayout(LayoutInfo theLayout, int thePos) {
  makeLayout(theLayout, thePos, new ArrayList<Integer>());
}

void makeLayout(LayoutInfo theLayout, int thePos, ArrayList<Integer> decades) {
  TreeMap<Integer, ArrayList<Country>> c = getCountriesByYears(decades);
  for (Integer year : c.keySet()) {
    println(year);
    for (Country theCountry : c.get(year)) {
      //print(theCountry.name + ",");
    }
  }
}