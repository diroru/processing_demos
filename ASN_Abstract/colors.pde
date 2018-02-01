//COLORS
color NO_CRASHES = #141419;
color FATALITIES_ZERO = #3535C6; //exactly 0 or 0%
//color FATALITIES_LOW = #8888D6; //more than 0% less than 10%
color FATALITIES_MED = #2C8CFC; //more than 0% less than 90%
color FATALITIES_HIGH = #90C3FF; //more than 90% less than 100%
color FATALITIES_ALL = #FFFFFF; //exactly 100%

color WHITE = color(255);
color LIGHT_GREY = color(127);
color MID_GREY = color(74);
color DARK_GREY = color(46);
color DARKER_GREY = color(20);

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

int getColor(Datum d) {
  int p = 0;
  if (d.total_occupants > 0 && d.total_fatalities > 0) {
    p = (d.total_fatalities * 100) / d.total_occupants; 
  }
  return getColor(p);
}