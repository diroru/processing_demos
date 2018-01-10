//distribution of fatalities by number of deaths
//counts individual accidents, not on yearly basis!
//sorted by keys
TreeMap<Integer, Integer> distribution;

TreeMap<Integer, Integer> getTotalDistribution(Table data) {
  TreeMap<Integer, Integer> result = new TreeMap<Integer, Integer>();
  for (TableRow row : data.rows()) {
    Integer count = row.getInt("total_fatalities");
    Integer existing = result.get(count);
    if (existing == null) {
      existing = 0;
    }
    existing = existing+1;
    result.put(count, existing);
  }
  println(result.keySet());
  return result;
};

//returns rounded percents as integers
TreeMap<Integer, Integer> getRelativeDistribution(Table data) {
  TreeMap<Integer, Integer> result = new TreeMap<Integer, Integer>();
  for (TableRow row : data.rows()) {
    Integer fat = row.getInt("total_fatalities");
    Integer occ = row.getInt("total_occupants");
    Integer percent = 0;
    if (occ > 0) {
      percent = round(100f * fat / float(occ));
    }
    percent = floor(quantize(percent, 0, 100, 100));
    Integer existing = result.get(percent);
    if (existing == null) {
      existing = 0;
    }
    existing = existing+1;
    result.put(percent, existing);
  }
  println(result.keySet());
  return result;
};

TreeMap<Integer, Integer> getYearlyDistribution(ArrayList<FatalitiesByYear> byYear) {
  TreeMap<Integer, Integer> result = new TreeMap<Integer, Integer>();
  for (FatalitiesByYear fatalities : byYear) {
    for (Integer count : fatalities.byCountry.values()) {
      Integer existing = result.get(count);
      if (existing == null) {
        existing = 0;
      }
      existing = existing+1;
      result.put(count, existing);
    }
  }
  println(result.keySet());
  return result;
};

void drawDistribution(TreeMap<Integer, Integer> dist, color c, float margin) {
  drawDistribution(dist, c, margin, 1);
}
void drawDistribution(TreeMap<Integer, Integer> dist, color c, float margin, float e) {
  int countMin = Integer.MAX_VALUE;
  int countMax = Integer.MIN_VALUE;
  int freqMin = Integer.MAX_VALUE;
  int freqMax = Integer.MIN_VALUE;
  for (Integer count : dist.keySet()) {
    countMin = min(countMin, count);
    countMax = max(countMax, count);
    freqMin =  min(freqMin, dist.get(count));
    freqMax =  max(freqMax, dist.get(count));
  }
  //println(countMin, countMax, freqMin, freqMax);
  stroke(c);
  strokeWeight(4);
  for (Integer count : dist.keySet()) {
    int freq = dist.get(count);
    float x = map(count, countMin, countMax, margin, width-margin*2);
    float y = norm(freq, freqMin, freqMax);
    y = pow(y,e);
    y = map(y, 0, 1, height-margin*2, margin);
    point(x,y);
  }
}