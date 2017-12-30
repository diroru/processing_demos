import java.util.*;

Table data;
HashMap<String, MigrationCountry> migrationCountries = new HashMap<String, MigrationCountry>();
HashMap<Integer, Integer> totals = new HashMap<Integer, Integer>();
HashMap<Integer, ArrayList<MigrationFlow>> flows = new HashMap<Integer, ArrayList<MigrationFlow>>();
int maxFlowPerCountry = Integer.MIN_VALUE;
int minFlowPerCountry = Integer.MAX_VALUE;
int maxFlowPerYear = Integer.MIN_VALUE;
int minFlowPerYear = Integer.MAX_VALUE;

HashSet<String> uniqueFlows = new HashSet<String>();
ArrayList<MigrationFlow> testFlows;

int yearStart = 1980;
int yearEnd = 2013;
float scaleFactor;

void setup() {
  size(1200, 400, JAVA2D);
  strokeCap(MITER);
  data = loadTable("GlobalMigration.tsv", "header, tsv");
  //initializing empty countries
  for (TableRow tr : data.rows()) {
    String from = tr.getString("from");
    String to = tr.getString("to");
    if (migrationCountries.get(from) == null) {
      migrationCountries.put(from, new MigrationCountry(from));
    }
    if (migrationCountries.get(to) == null) {
      migrationCountries.put(to, new MigrationCountry(to));
    }
  }
  //adding flows
  for (TableRow tr : data.rows()) {
    String from = tr.getString("from");
    String to = tr.getString("to");
    for (int i = yearStart; i <= yearEnd; i++) {
      int flowVolume = tr.getInt(i+"");
      if (flowVolume > 0 && !checkExistence(from, to, i)) {
        //if (flowVolume > 0) {
        maxFlowPerCountry = max(flowVolume, maxFlowPerCountry);
        minFlowPerCountry = min(flowVolume, minFlowPerCountry);
        MigrationCountry fromCountry = migrationCountries.get(from);
        MigrationCountry toCountry = migrationCountries.get(to);
        MigrationFlow flow = new MigrationFlow(fromCountry, toCountry, i, flowVolume);
        addFlow(flow);
        fromCountry.addOutFlow(flow);
        toCountry.addInFlow(flow);
        addTotal(totals, i, flowVolume);
      }
    }
  }
  for (Integer year : totals.keySet()) {
    minFlowPerYear = min(minFlowPerYear, totals.get(year));
    maxFlowPerYear = max(maxFlowPerYear, totals.get(year));
  }
  println("COUNTRY MIN", minFlowPerCountry, "COUNTRY MAX", maxFlowPerCountry);
  println("YEAR MIN", minFlowPerYear, "YEAR MAX", maxFlowPerYear);

  testFlows = flows.get(2013);
  for (MigrationFlow mf : testFlows) {
    mf.sortingMethod = MigrationFlow.SORT_BY_ORG_THEN_DST;
  }
  Collections.sort(testFlows);
  int off = 0;
  for (MigrationFlow mf : testFlows) {
    mf.originOffset = off;
    off += mf.volume;
  }
  for (MigrationFlow mf : testFlows) {
    mf.sortingMethod = MigrationFlow.SORT_BY_DST_THEN_ORG;
  }
  Collections.sort(testFlows);
  off = 0;
  for (MigrationFlow mf : testFlows) {
    mf.destinationOffset = off;
    off += mf.volume;
  }
  scaleFactor = (width - 40f) / off;
  //sortedCounties.sort(Comparator.comparing(MigrationCountry::getName));

  //printArray(migrationCountries.get("France").outFlows.get(2013).toArray());
  //printArray(migrationCountries.get("France").inFlows.get(2013).toArray());
  //printArray(sortedCountries.toArray());
}

void draw() { 

  background(0);
  //stroke(255,16);
  for (MigrationFlow mf : testFlows) {
    noStroke();
    fill(255, 127);
    mf.display(scaleFactor, 20, norm(mouseY, 0, height));
  }
}