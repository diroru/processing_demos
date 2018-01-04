class MigrationFlow {
  Country origin, destination;
  int year;
  Long flow;
  
  MigrationFlow(Country theOrigin, Country theDestination, int theYear, Long theFlow) {
    origin = theOrigin;
    destination = theDestination;
    year = theYear;
    flow = theFlow;
    origin.addEmigrationFlow(this);
    //destination.addImigrationFlow(this);
  }
    
  void display() {
  }
}