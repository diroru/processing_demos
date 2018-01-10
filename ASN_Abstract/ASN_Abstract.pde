//TODO: decide about 2014!!!
//TODO: treat Unknown country!!!

import java.util.*;

Table dataTable;
ArrayList<String> countryNames;
ArrayList<Datum> data = new ArrayList<Datum>();
ArrayList<Country> countries = new ArrayList<Country>();
//a crude database listing all countries, first by name, then by year
TreeMap<String, TreeMap<Integer, Country>> dataBase = new TreeMap<String, TreeMap<Integer, Country>>(); 

int YEAR_START = Integer.MAX_VALUE;
int YEAR_END = Integer.MIN_VALUE;
int MAX_FATALITIES_PER_YEAR = Integer.MIN_VALUE;


float margin = 20;

PVector mappedMouse = new PVector();

LayoutInfo matrixLayout = new LayoutInfo(0, 0, 1000, 400, 2, 2);

void setup() {
  size(1200, 600, P2D);
  initData(); //see data.pde
  ArrayList<Integer> decades = new ArrayList<Integer>(Arrays.asList(1900, 1910, 1920, 1930, 1940, 1950, 1960, 1970, 1980, 1990, 2000));
  makeLayout(matrixLayout, decades);
}

void draw() {
  background(0);

  /*
   drawDistribution(totalDistribution, color(255,0,0), 20);
   drawDistribution(yearlyDistribution, color(0,255,0), 20);
   */
  stroke(255);
  strokeWeight(1);
  line(margin, height-margin, width-margin, height-margin);
}