color PRIMARY= #00FFD6;
color SECONDARY= #FF8000;
color INDEX1= #FFFFFF;
color INDEX2= #BBBBBB;
color INDEX3= #818181;
color INDEX4= #414141;
color POPULATION= #402000;
color WHITE = #FFFFFF;
color DARK_GREY = color(74);

PFont HEADLINETITLE;
PFont HEADLINESUBTITLE;
PFont HEADLINEALTSUBTITLE;

PFont INFOHEADLINE;
PFont INFO;

PFont HEADLINECOUNTRY;

PFont TOPNUMBER;
PFont SECONDNUMBER;
PFont THIRDNUMBER;

void initFonts() {
  HEADLINETITLE= loadFont ("Fonts/HelveticaNeue-Thin-40.vlw");
  HEADLINESUBTITLE= loadFont ("Fonts/HelveticaNeue-Thin-40.vlw");
  HEADLINEALTSUBTITLE= loadFont ("Fonts/HelveticaNeue-Bold-14.vlw");

  INFOHEADLINE= loadFont ("Fonts/HelveticaNeue-Medium-20.vlw");
  INFO= loadFont ("Fonts/HelveticaNeue-Medium-14.vlw");

  HEADLINECOUNTRY= loadFont ("Fonts/HelveticaNeue-Bold-44.vlw");

  TOPNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-76.vlw");
  SECONDNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-48.vlw");
  THIRDNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-36.vlw");
}