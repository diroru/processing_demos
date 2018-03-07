void initData(Timeline tl) {
  myData = loadTable("180307_plane-crashes_worst+unusual.csv", "header"); 
  for (TableRow tr : myData.rows()) {
    Datum d = new Datum(tr, tl);
    phaseCodes.add(d.phaseCode);
    MIN_FATALITIES = min(d.fatalities, MIN_FATALITIES);
    MAX_FATALITIES = max(d.fatalities, MAX_FATALITIES);
    MIN_OCCUPANTS = min(d.occupants, MIN_OCCUPANTS);
    MAX_OCCUPANTS = max(d.occupants, MAX_OCCUPANTS);

    if (!data.contains(d)) {
      data.add(d);
    }
  }

  Collections.sort(data);
  println("LOADED ", data.size(), " DATA");
  println("FATALITIES", MIN_FATALITIES, " – ", MAX_FATALITIES);
  println("OCCUPANTS", MIN_OCCUPANTS, " – ", MAX_OCCUPANTS);
  println("PHASE CODES", phaseCodes);

  phaseProgress.put("APR", 0f); //approach
  phaseProgress.put("ICL", 0f); //initial climb
  phaseProgress.put("UNK", 0.5f); //unknown
  phaseProgress.put("TXI", 0f); //taxi
  phaseProgress.put("ENR", 0.5f); //en route
  phaseProgress.put("En route ", 0.5f); //en route
  phaseProgress.put("TOF", 0f); //takeoff
  phaseProgress.put("LDG", 1f); //landing
}

void initFlights(Timeline tl) {
  CrashFlight previous = null;
  for (Datum d : data) {
    CrashFlight flight = new CrashFlight(d, tl);
    flight.previousFlight = previous;
    if (previous != null) {
      previous.nextFlight = flight;
    }
    previous = flight;
    myFlights.add(flight);
    flightsByDatum.put(d, flight);
  }
  myFlights.get(myFlights.size()-1).nextFlight = myFlights.get(0);
  myFlights.get(0).previousFlight = myFlights.get(myFlights.size()-1);
}

void initDots() {
  ArrayList<CrashDot> previousOnes = new ArrayList<CrashDot>();
  for (Datum d : data) {
    for (int i = 0; i < REPEAT_COUNT; i++) {
      //println(d);
      if (d.coordsValid()) { 
        CrashDot cd = new CrashDot(d, timeline, previousOnes, this, i); 
        myDots.add(cd);
        previousOnes.add(cd);
      } else {
        println(d, "has invalid coordinates");
      }
    }
  }
}

/*
CrashFlight getFlight(float theTime) {
  for (Datum d : data) {
    if (abs(d.normMoment - theTime) < SEEK_EPSILON) {
      return flightsByDatum.get(d);
    }
  }
  return null;
}

boolean aboutFlightTime(float time, CrashFlight flight) {
  return abs(flight.myDatum.normMoment - time) < SEEK_EPSILON;
}
*/


CrashFlight getFlightByDatum(Datum d) {
  for (CrashFlight cf : myFlights) {
    if (cf.myDatum.equals(d)) {
      return cf;
    }
  }
  return null;
}