import java.util.*;
//import java.awt.event.*;
//import javax.swing.event.*;
//import java.awt.event.*;


Table countryData, flowData, populationData;

//GENERAL CONSTANTS
final int GPI_YEAR_START = 2008;
final int GPI_YEAR_END = 2016;
final int MIGRATION_YEAR_START = 1980;
final int MIGRATION_YEAR_END = 2013;
final int GPI_MIN = 1;
final int GPI_MAX = 5;
final int SET_START_POS = 0;
final int SET_END_POS = 1;

//SORTING TYPE CONSTANTS
final int SORT_BY_COUNTRY_NAME = 0;
final int SORT_BY_CONTINENT = 1;
final int SORT_BY_INDEX = 2; //needs an active year
final int SORT_BY_CONTINENT_THEN_INDEX = 3;

float TIME = 0;
float TIME_INC = 0.01;

//Layout globals
float margin = 10;
float gap = 2;
Long POPULATION_MIN = Long.MAX_VALUE;
Long POPULATION_MAX = Long.MIN_VALUE;
Long MIGRATION_FLOW_MAX = Long.MIN_VALUE;
Long MIGRATION_FLOW_MIN = Long.MAX_VALUE;
Long MIGRATION_FLOW_LOWER_LIMIT = 100L;

ArrayList<Country> countries = new ArrayList<Country>();
//Map of countries, labelled by names
HashMap<String, Country> countriesByName = new HashMap<String, Country>();

HashMap<Integer, ArrayList<MigrationFlow>> migrationFlows = new HashMap<Integer, ArrayList<MigrationFlow>>(); 

//lookup table for mismatched country names
HashMap<String, String> countryLookupTable = new HashMap<String, String>(); 
ArrayList<String> missingCountries = new ArrayList<String>();

int currentYear = 2013;

HashSet<Country> hoverCountries = new HashSet<Country>();

int MARGIN = 20;
LayoutInfo panelLayout, graphLayout, flowLayout, yearsLayout; 

void setup() {
  size(1200, 600, P2D);
   
  float panelWidth = 200;
  float yearBarHeight = 30f;
  float graphHeight = (height - MARGIN * 3 - yearBarHeight) * 0.5;
  float graphWidth = width - MARGIN * 3 - panelWidth;
  panelLayout = new LayoutInfo(MARGIN, MARGIN, panelWidth, height - 2*MARGIN);
  graphLayout = new LayoutInfo(panelWidth + 2 * MARGIN, MARGIN + graphHeight, graphWidth, graphHeight);
  flowLayout = new LayoutInfo(panelWidth + 2 * MARGIN, MARGIN, graphWidth, graphHeight);
  graphLayout.gap = gap;
  
  pixelDensity(2);
  ellipseMode(CORNER);
  textSize(20);
  loadData(false);
  //print all keys
  //println("KEYS:\n", countries.keySet());
  //println("-----");
  //print all countries
  //println("VALUES:\n", countries);
  //println("-----");
  //showing the Iceland’s GPI for 2008
  //println(countries.get("ISL").getGPI(2016));

  //Example of animating between two layouts
  //first sort by one criterium, then set start layout
  sortCountries(countries, SORT_BY_COUNTRY_NAME, currentYear);
  makeLayout(graphLayout, countries, SET_START_POS, currentYear);

  //sort by other criterium, then set end layout
  sortCountries(countries, SORT_BY_CONTINENT_THEN_INDEX, 2016);
  makeLayout(graphLayout, countries, SET_END_POS, currentYear);
  println("Population MIN", POPULATION_MIN);
  println("Population MAX", POPULATION_MAX);
  //println(countries);
}

void draw() {
  //draw countries
  background(0);
  noStroke();
  fill(255);
  noStroke();
  for (Country theCountry : countries) {
    //println(theCountry.name);
    theCountry.update(TIME);
    theCountry.display(g);
  }

  TIME += TIME_INC;
  TIME = min(TIME, 1);
  //println(TIME);

  displayFlows();
}

void displayFlows() {
  noFill();
  String hoverCountry = null;

  if (hoverCountries.size() > 0) {
    Country hc = (Country)(hoverCountries.iterator().next());
    hoverCountry = hc.name;
  }

  for (MigrationFlow mf : migrationFlows.get(currentYear)) {
    if (hoverCountry == null) {
      stroke(255, 31);
      strokeWeight(2);
      if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
        mf.display(g, height/2, margin);
      }
    } else {
      if (mf.origin.name.equals(hoverCountry)) {
        stroke(255, 0, 0, 63);
      } else if (mf.destination.name.equals(hoverCountry)) {
        stroke(0, 0, 255, 63);
      } else {
        //stroke(255, 1);
        noStroke();
      }
      if (mf.flow > MIGRATION_FLOW_LOWER_LIMIT) {
        mf.display(g, height/2, margin);
      }
    }
  }
}