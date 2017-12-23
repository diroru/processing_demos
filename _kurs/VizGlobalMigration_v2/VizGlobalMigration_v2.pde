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

int yearStart = 1980;
int yearEnd = 2013; 

void setup() {
  size(1200, 400, JAVA2D);
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

  //printArray(migrationCountries.get("France").outFlows.get(2013).toArray());
  //printArray(migrationCountries.get("France").inFlows.get(2013).toArray());
  //printArray(sortedCountries.toArray());
}

boolean checkExistence(String a, String b, int year) {
  //String idAB = a + "+" + b + "+" + year;
  String idBA = b + "+" + a + "+" + year;
  if (uniqueFlows.contains(idBA)) {
    return true;
  } else {
    uniqueFlows.add(idBA);
  }
  return false;
}

void addTotal(HashMap<Integer, Integer> theTotal, int year, int vol) {
  Integer total = theTotal.get(year);
  if (total == null) {
    total = 0;
  }
  total = new Integer(total + vol);
  theTotal.put(year, total);
}

void addFlow(MigrationFlow theFlow) {
  ArrayList<MigrationFlow> flowsForYear = flows.get(theFlow.year);
  if (flowsForYear == null) {
    flowsForYear = new ArrayList<MigrationFlow>();
    flows.put(theFlow.year, flowsForYear);
  }
  flowsForYear.add(theFlow);
}

void draw() {
}