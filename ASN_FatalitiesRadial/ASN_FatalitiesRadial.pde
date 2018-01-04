import org.gicentre.utils.colour.*;    // For colour tables.

int[] days = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int dayCount = 366;
int monthCount = 12;

int minYear = 1900;
int maxYear = 2014;
int yearCount = maxYear - minYear;
float ANGLE = TWO_PI;
int maxCasualties = 0;
int maxMonthlyCasualties = 0;
color[] colors = {#fee5d9, #fcbba1, #fc9272, #fb6a4a, #ef3b2c, #cb181d, #99000d};
ColourTable myColors;
Table data, monthlyData;
float e = 1f;
boolean doSave = false;
float r0, r1;
int classCount = 5;
PFont font;
boolean invert = true;

void setup() {
  size(1200, 1200, P2D);
  pixelDensity(2);
  data = loadTable("plane-crashes_fatalities_by_day.tsv", "header");
  monthlyData = loadTable("plane-crashes_fatalities_by_month.tsv", "header");
  printArray(data.getColumnTitles());
  for (int i = 0; i < data.getRowCount(); i++) {
    TableRow r = data.getRow(i);
    maxCasualties = max(r.getInt("total"), maxCasualties);
  }
  for (int i = 0; i < monthlyData.getRowCount(); i++) {
    TableRow r = monthlyData.getRow(i);
    maxMonthlyCasualties = max(r.getInt("total"), maxMonthlyCasualties);
  }
  println("max", maxCasualties);
  myColors  = ColourTable.getPresetColourTable(ColourTable.BLUES, 0, 1);

  //draw days
  r0 = 200;
  r1 = width*0.5;
  font = createFont("georgia", 32);
  textFont(font);
  textAlign(CENTER);
}

void draw() {
  background(0);
  //drawMonthly();
  drawDaily();
  float w = 2*r0 - 100;
  //drawLegend(w, 50, w/6, w/6);
  drawLegend(w, 50, w/classCount, w/classCount);
  //drawLegend(w, 50, 1f, w/classCount);
  if (doSave) {
    saveFrame("asn_radial_exp" + e +".png");
    println("frame saved.");
    doSave = false;
  }
}

void drawLegend(float w, float h, float res, float labelRes) {
  pushMatrix();
  translate(width*0.5, (height - h)*0.5 - 50);
  fill(255);
  textSize(20);
  text("Plane accident fatalities\nby year (radius) and day (angle)", 0, 0);
  popMatrix();

  pushMatrix();
  translate((width - w)*0.5, (height - h)*0.5);
  noStroke();

  float x0 = 0;
  while (x0 < w) {
    float f = x0 / w;
    if (invert) {
      fill(myColors.findColour(1-f));
    } else {
      fill(myColors.findColour(f));
    }
    
    rect(x0, 0, res, h);
    x0 += res;
  }

  /*
  float eWidth = getExpWidth(classCount, e);
   float x0 = 0;
   for (int i = 0; i < classCount; i++) {
   //float f = x0 / w;
   float f0 = i / (classCount - 1f);
   float f1 = (i+1) / (classCount - 1f);
   float m = pow(f0, e);
   m = quantize(m, classCount);
   float v = getExpValue(f1, e, w) / eWidth;
   fill(myColors.findColour(m));
   rect(x0, 0, v, h);
   x0 += v;  
   }
   */
  stroke(255);
  noFill();
  rect(0, 0, w, h);
  fill(255);
  translate(0, h + 20);

  x0 = 0;
  textSize(16);
  while (x0 <= w) {
    float f = x0 / w;
    float v = getExpValue(f, e, maxCasualties);
    stroke(255);
    line(x0, -20, x0, -15);
    noStroke();
    text(floor(v), x0, 0);
    x0 += labelRes;
  }

  popMatrix();
}

void drawMonthly() {
  float gap = 1f;
  float w0 = ANGLE * r0 / monthCount;
  float h = (r1 - r0 - (yearCount-1) * gap) / yearCount;
  noStroke();
  pushMatrix();
  translate(width*0.5, height*0.5);
  for (int i = 0; i <= yearCount; i++) {
    for (int j = 0; j < monthCount; j++) {
      float r = map(i, 0, yearCount, r0, r1);
      float theta = j*ANGLE/monthCount + PI;
      pushMatrix();
      rotate(theta);
      translate(0, r);
      if ((minYear + i)/10 % 2 == 0) {
        fill(31);
      } else {
        fill(62);
      }

      //fill(random(255));

      rect(-w0*0.5, 0, w0, h);
      popMatrix();
    }
  }
  for (int i = 0; i < monthlyData.getRowCount(); i++) {
    TableRow tr = monthlyData.getRow(i);
    int year = tr.getInt("year");
    int month = tr.getInt("month");
    int casualties = tr.getInt("total");
    float r = map(year, minYear, maxYear, r0, r1);
    float theta = (month-1)*ANGLE/monthCount + PI;
    //float m = map(casualties, 0f, maxCasualties, mMin, mMax);
    float m = norm(casualties, 0f, maxMonthlyCasualties);
    float w = map(casualties, 0f, maxMonthlyCasualties, 0, w0);
    //m = pow(m, e);
    //println(m);
    pushMatrix();
    rotate(theta);
    translate(0, r);
    //fill(getColor(colors, m));
    fill(myColors.findColour(m));
    rect(-w*0.5, 0, w, h);
    popMatrix();
  }
  popMatrix();
}

void drawDaily() {
  float gap = 1f;
  float w = ANGLE * r0 / dayCount;
  float h = (r1 - r0 - (yearCount-1) * gap) / yearCount;
  noStroke();
  pushMatrix();
  translate(width*0.5, height*0.5);
  for (int i = 0; i <= yearCount; i++) {
    if (((i - minYear + 1) / 10) % 2 == 0) {
      fill(31);
    } else {
      fill(43);
    }
    
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
    //float m = map(casualties, 0f, maxCasualties, mMin, mMax);
    float m = norm(casualties, 0f, maxCasualties);
    m = pow(m, e);
    m = quantize(m, classCount);

    //println(m);
    pushMatrix();
    rotate(theta);
    translate(0, r);
    //fill(getColor(colors, m));
    if (invert) {
      fill(myColors.findColour(1-m));
    } else {
      fill(myColors.findColour(m));
    }
    if (casualties == 0) {
      // fill(myColors.findColour(0f), 127);
    }
    //fill(255, m*255 + 20);
    float wMin = 0.5;
    //w = (w-wMin) * m + wMin;
    rect(-w*0.5, 0, w, h);
    popMatrix();
  }
  popMatrix();
}

void mouseMoved() {
  e = map(mouseY, 0, height, 0.0, 2.0);
  classCount = floor(map(mouseX, 0, width, 2, 10));
  //e = 1f;
  println(e);
  printArray(getIntervals(colors.length, e, maxCasualties));
}

void keyPressed() {
  if (key == ' ') {
    doSave = true;
  }
  if (key == 'i') {
    invert = !invert;
  }
}

float getExpValue(float b, float exponent) {
  return getExpValue(b, exponent, 1f);
}


float getExpValue(float b, float exponent, float max) {
  return exp(log(b) / exponent) * max;
}

float[] getIntervals(int count, float exponent, float max) {
  float[] result = new float[count];
  result[0] = 0f;
  for (int i = 1; i < count-1; i++) {
    float b = i / (count-1f);
    result[i] = getExpValue(b, exponent, max);
  }
  result[result.length-1] = max;
  return result;
}

float[] getIntervals(int count, float exponent) {
  return getIntervals(count, exponent, 1f);
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

float quantize(float v, float q) {
  return floor((v - 0.001) * q) / q;
  //return floor(v * q) / q;
}

float getExpWidth(int count, float e) {
  float result = 0f;
  for (int i= 0; i <= count; i++) {
    result += getExpValue(i/(count-1f), e);
  }
  return result;
}