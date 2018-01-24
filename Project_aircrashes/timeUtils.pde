int[] days = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
int dayCount = 366;
int monthCount = 12;

float getNormalizedMoment(Datum d, Timeline tl) {
  return getNormalizedMoment(d.day, d.month, d.year, tl.startYear, tl.endYear);
}

float getNormalizedMomentNoDay(Datum d, Timeline tl) {
  return getNormalizedMoment(0, d.month, d.year, tl.startYear, tl.endYear);
}

float getNormalizedMomentNoDayNoMonth(Datum d, Timeline tl) {
  return getNormalizedMoment(0, 0, d.year, tl.startYear, tl.endYear);
}

float getNormalizedMoment(int[] date, int startYear, int endYear) {
  return getNormalizedMoment(date[0], date[1], date[2], startYear, endYear);
}

float getNormalizedMoment(int d, int m, int y, int startYear, int endYear) {
  //TODO: might need long sometimes
  int timeInterval = (endYear - startYear) * 366;

  int moment = d - 1 + (y - startYear) * 366;
  for (int i = 0; i < m - 1; i++) {
    moment += days[i];
  }
  return moment / (timeInterval-0f);
}

int[] getDatumFromNormMoment(float theMoment) {
  return getDatumFromNormMoment(theMoment, YEAR_START, YEAR_END);
}

int[] getDatumFromNormMoment(float theMoment, int startYear, int endYear) {
  float timeInterval = (endYear - startYear) * 366 * theMoment;
  int deltaYears = floor(timeInterval / 366f);
  int daysInYear = floor(timeInterval - deltaYears * 366);
  int d = 0;
  int month = 0;
  int day = 0;
  for (int i = 0; i < days.length; i++) {
    if (d <= daysInYear) {
      day = daysInYear - d + 1;
      d += days[i];
      month = i + 1;
    }
  }
  int year = deltaYears + startYear;
  return new int[]{day, month, year};
}