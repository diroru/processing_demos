final int SET_START_POS = 0;
final int SET_END_POS = 1;

ArrayList<Country> makeLayout(LayoutInfo theLayout) {
  return makeLayout(theLayout, SET_START_POS, new ArrayList<Integer>());
}

ArrayList<Country> makeLayout(LayoutInfo theLayout, ArrayList<Integer> decades) {
  return makeLayout(theLayout, SET_START_POS, decades);
}

ArrayList<Country> makeLayout(LayoutInfo theLayout, int thePos) {
  return makeLayout(theLayout, thePos, new ArrayList<Integer>());
}

ArrayList<Country> makeLayout(LayoutInfo theLayout, int thePos, ArrayList<Integer> decades) {
  ArrayList<Country> result = new ArrayList<Country>();
  TreeMap<Integer, ArrayList<Country>> c = getCountriesByYears(decades);
  for (ArrayList<Country> countryList : c.values()) {
    Collections.sort(countryList);
  }
  int count = 0;
  int hCount = c.values().iterator().next().size();
  int vCount = c.keySet().size();
  float cellHeight = theLayout.getUnitHeight(vCount);
  float cellWidth = theLayout.getUnitWidth(hCount);
  float x = theLayout.x;
  float y = theLayout.y;
  for (Integer year : c.keySet()) {
    //println(year);
    for (Country theCountry : c.get(year)) {
      count++;
      //print(theCountry.name + ",");
      
      switch(thePos) {
      case SET_START_POS:
        theCountry.setStartLayout(x, y, cellWidth, cellHeight);
        theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight);
        break;
      case SET_END_POS:
        //theCountry.setCurrentLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndLayout(x, y, cellWidth, cellHeight);
        theCountry.setEndPos(x, y, 1000);
        break;
      }
      

      result.add(theCountry);
      x += theLayout.deltaX(hCount);
    }
    x = theLayout.x;
    y += theLayout.deltaY(vCount);
  }
  //println("COUNT", hCount, vCount, count);
  return result;
}