//COLORS
color NO_CRASHES = color(31);
color FATALITIES_ZERO = #1F1FA0; //exactly 0 or 0%
//color FATALITIES_LOW = #8888D6; //more than 0% less than 10%
color FATALITIES_MED = #8888D6; //more than 0% less than 90%
color FATALITIES_HIGH = #9EA6AA; //more than 90% less than 100%
color FATALITIES_ALL = #FFFFFF; //exactly 100%

//0 <= percentage <= 100
int getColor(int percentage) {
  if (percentage == 0) {
    return FATALITIES_ZERO;
  } else if (percentage <= 90) {
    return FATALITIES_MED;
  } else if (percentage < 100) {
    return FATALITIES_HIGH;
  }
  return FATALITIES_ALL;
}