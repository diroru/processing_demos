import java.util.*;

Table data;
Set<String> countryNames = new HashSet<String>();
Set<String> done = new HashSet<String>();
HashMap<String, Float> xPositions = new HashMap<String, Float>();
float margin = 20;

int yearStart = 1980;
int yearEnd = 2013; 

void setup() {
  size(1200, 400, JAVA2D);
  data = loadTable("GlobalMigration.tsv", "header, tsv");
  for (TableRow tr : data.rows()) {
    countryNames.add(tr.getString("from"));
    countryNames.add(tr.getString("to"));
  }
  println("there are", countryNames.size(), "unique countries");
  List<String> sortedCountries = new ArrayList<String>(countryNames);
  Collections.sort(sortedCountries);
  for (int i = 0; i < sortedCountries.size(); i++) {
    float xPos = map(i, 0, sortedCountries.size()-1, margin, width-margin);
    String countryName = sortedCountries.get(i);
    xPositions.put(countryName, xPos);
  }
  //printArray(sortedCountries.toArray());
}

void draw() {
  float delta = mouseY;
  background(0);
  noFill();
  stroke(255, 16);
  int drawn = 0;
  bezierDetail(16);
  for (TableRow tr : data.rows()) {
    String from = tr.getString("from");
    String to = tr.getString("to");
    String test = to + "+" + from;
    if (!done.contains(test)) {
      float x0 = xPositions.get(from);
      float y0 = margin;
      float x1 = xPositions.get(to);
      float y1 = height-margin;
      //line(x0, y0, x1, y1);
      drawn++;
      bezier(x0, y0, x0, margin + delta, x1, height-margin-delta, x1, y1);
      done.add(from + "+" + to);
    }
  }
  //println("drawn", drawn);
}