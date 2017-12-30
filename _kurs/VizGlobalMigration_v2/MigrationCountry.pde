class MigrationCountry {
  final String name;
  HashMap<Integer, Integer> totalOut = new HashMap<Integer, Integer>();
  HashMap<Integer, Integer> totalIn = new HashMap<Integer, Integer>();
  HashMap<Integer, ArrayList<MigrationFlow>> inFlows = new HashMap<Integer, ArrayList<MigrationFlow>>();
  HashMap<Integer, ArrayList<MigrationFlow>> outFlows = new HashMap<Integer, ArrayList<MigrationFlow>>();

  MigrationCountry(String theName) {
    name = theName;
  }

  void addFlow(MigrationFlow theFlow, HashMap<Integer, Integer> total, HashMap<Integer, ArrayList<MigrationFlow>> map) {
    int theYear = theFlow.year;
    ArrayList<MigrationFlow> fl= map.get(theYear);
    if (fl == null) {
      fl = new ArrayList<MigrationFlow>();
      map.put(theYear, fl);
    }
    fl.add(theFlow);
    
    Integer vol = total.get(theYear);
    if (vol == null) {
      vol = 0;
      total.put(theYear, vol);
    }
    vol += theFlow.volume;
  }

  void addInFlow(MigrationFlow theFlow) {
    addFlow(theFlow, totalIn, inFlows);
  }
  
  void addOutFlow(MigrationFlow theFlow) {
    addFlow(theFlow, totalOut, outFlows);
  }

  String getName() {
    return name;
  }
}