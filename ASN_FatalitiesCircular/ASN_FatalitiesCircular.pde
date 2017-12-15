int[] days = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int dayCount = 366;

int minYear = 1900;
int maxYear = 2014;
int yearCount = maxYear - minYear;
float ANGLE = TWO_PI;
int maxCasualties = 0;
color[] colors = {#fee5d9, #fcbba1, #fc9272, #fb6a4a, #ef3b2c, #cb181d, #99000d};
Table data;

void setup() {
  size(1200, 1200, P2D);
  pixelDensity(2);
  data = loadTable("plane-crashes_fatalities_by_day.tsv", "header");
  printArray(data.getColumnTitles());
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow r = data.getRow(i);
    maxCasualties = max(r.getInt("total"), maxCasualties);
  }
  println("max", maxCasualties);
  //draw days

}

void draw() {
    background(0);
  float r0 = 200;
  float r1 = 600;
  float gap = 1f;
  float w = ANGLE * r0 / dayCount;
  float h = (r1 - r0 - (yearCount-1) * gap) / yearCount;
  noStroke();
  fill(31);
  pushMatrix();
  translate(width*0.5, height*0.5);
  for (int i = 0; i <= yearCount; i++) {
    for (int j = 0; j < dayCount; j++) {
      float r = map(i, 0, yearCount, r0, r1);
      float theta = getAngle(j, ANGLE);
      pushMatrix();
      rotate(theta);
      translate(0, r);
      //fill(random(255));

      rect(-w*0.5, 0, w, h);
      popMatrix();
    }
  }
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow tr = data.getRow(i);
    int year = tr.getInt("year");
    int month = tr.getInt("month");
    int day = tr.getInt("day");
    int casualties = tr.getInt("total");
    float r = map(year, minYear, maxYear, r0, r1);
    float theta = getAngle(month, day, ANGLE);
    float mMin = 0.01;
    float mMax = 0.3f;
    //float m = map(casualties, 0f, maxCasualties, mMin, mMax);
    float m = norm(casualties, 0f, maxCasualties);
    //m = pow(m, 0.1f);
    //println(m);
    pushMatrix();
    rotate(theta);
    translate(0, r);
    fill(getColor(colors, m));
    /*
    if (casualties == 0) {
      fill(0,255,0);
    }
    */
    /*
    if (casualties <= maxCasualties * mMin) {
      fill(127);
      //} else if (casualties < maxCasualties * 0.01f) {
      //   fill(0,255,255); 
      //} else if (casualties < maxCasualties * 0.90f) {
      //  fill(0,255,127);
      //} else {
      //  fill(255,0,0);
      //}
    } else if (casualties > maxCasualties * mMin && casualties < maxCasualties * mMax) {
      fill(lerpColor(color(0, 255, 255), color(0, 255, 127), m));
    } else {
      fill(255, 0, 0);
    }
    //fill(lerpColor(color(0,255,0), color(255,0,0), m));
    */
    rect(-w*0.5, 0, w, h);
    popMatrix();
  }
  popMatrix();
}

color getColor(color[] c, float f) {
  float fs = f * (c.length-1);
  int i0 = floor(fs);
  int i1 = ceil(fs);
  float f1 = fs - i0;
  return lerpColor(c[i0], c[i1], f1);
}

//month: 1-12, day: 1-31
float getAngle(int month, int dayOfMonth, float totalAngle) {
  int dAcc = dayOfMonth;
  for (int i = month-1; i > 0; i--) {
    dAcc += days[i-1];
  }
  return dAcc * totalAngle / dayCount + PI;
}

float getAngle(int dayOfYear, float totalAngle) {
  return dayOfYear * totalAngle / dayCount + PI;
}