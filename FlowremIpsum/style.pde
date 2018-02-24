color PRIMARY= #00FFD6;
color SECONDARY= #FAB065;
color INDEX1= #BBBBBB;
color INDEX2= #BBBBBB;
color INDEX3= #818181;
//color INDEX4= #414141;
color INDEX4= #222222;

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

int HEADLINETITLE_SIZE = 40;
int HEADLINESUBTITLE_SIZE = 40;
int HEADLINEALTSUBTITLE_SIZE = 14;
int INFOHEADLINE_SIZE = 20;
int INFO_SIZE = 11;
int HEADLINECOUNTRY_SIZE = 44;
int TOPNUMBER_SIZE = 76;
int SECONDNUMBER_SIZE = 48;
int THIRDNUMBER_SIZE = 36;

void initFonts() {
  HEADLINETITLE= loadFont ("Fonts/HelveticaNeue-Bold-44.vlw");
  HEADLINESUBTITLE= loadFont ("Fonts/HelveticaNeue-Thin-40.vlw");
  HEADLINEALTSUBTITLE= loadFont ("Fonts/HelveticaNeue-Bold-14.vlw");

  INFOHEADLINE= loadFont ("Fonts/HelveticaNeue-Medium-20.vlw");
  INFO= loadFont ("Fonts/HelveticaNeue-Medium-11.vlw");

  HEADLINECOUNTRY= loadFont ("Fonts/HelveticaNeue-Bold-44.vlw");

  TOPNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-76.vlw");
  SECONDNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-48.vlw");
  THIRDNUMBER= loadFont ("Fonts/HelveticaNeue-Medium-36.vlw");
}
