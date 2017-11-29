void calculateTime() {
  long now = millis();
  elapsed = elapsed + now - then;
  while (elapsed >= millisPerMonth) {
    currentMonth = currentMonth+1;
    if (currentMonth > 11) {
      currentMonth = 0;
      currentYear = currentYear + 1;
      if (currentYear > maxYear) {
        currentYear = minYear;
      }
    }
    elapsed = elapsed - millisPerMonth;
  }
  then = now;
}

void displayTime(int textSize) {
  textSize(textSize);
  fill(255,0,0);
  text(currentYear + "." + nf(currentMonth + 1, 2), 10, textSize + 10);
}

float getNormalizedTime(int year, int month, float distance, float speed) {
  float departureTime = (year - minYear) * 12 + month;
  float destinationTime = departureTime + distance / speed;
  float currentTime = (currentYear - minYear) * 12 + currentMonth;
  float result = map(currentTime, departureTime, destinationTime, 0, 1);
  return result;
}