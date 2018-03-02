import java.util.Arrays;

PFont fontA, fontB, fontC;
ArrayList<PFont> fonts;
//FormattedText ftA, ftB, ftC;
ArrayList<FormattedText> myFormattedTexts = new ArrayList<FormattedText>();
ArrayList<Float> margins;
ArrayList<String> stringsA, stringsB, stringsC;
float myReferenceWidth = 300f;

void setup() {
  size(1000, 800);
  fontA = loadFont("HelveticaNeue-Medium-48.vlw");
  fontB = loadFont("HelveticaNeue-Medium-20.vlw");
  fontC = loadFont("HelveticaNeue-Medium-12.vlw");
  fonts = new ArrayList<PFont>();
  fonts.add(fontA);
  fonts.add(fontB);
  fonts.add(fontC);
  stringsA = new ArrayList<String>(Arrays.asList("Header A", "Lorem ipsum fdsfiet", "Somdsfooenrgoinksdnfsdlr"));
  stringsB = new ArrayList<String>(Arrays.asList("Header B", "Lorem ipsum fdsfiet", "Somdsfooenrgoinksdnfsdlr"));
  stringsC = new ArrayList<String>(Arrays.asList("Header C", "Lorem ipsum fdsfiet", "Somdsfooenrgoinksdnfsdlr"));
  margins = new ArrayList<Float>(Arrays.asList(new Float(30f), new Float(30f), new Float(30f)));
}
void draw() {
  background(0);
  PVector origin = new PVector(400, 300);
  myFormattedTexts.clear();
  myFormattedTexts.add(new FormattedText(stringsA, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));
  myFormattedTexts.add(new FormattedText(stringsB, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));
  myFormattedTexts.add(new FormattedText(stringsC, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));
  myFormattedTexts.add(new FormattedText(stringsA, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));
  myFormattedTexts.add(new FormattedText(stringsB, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));
  myFormattedTexts.add(new FormattedText(stringsC, fonts, margins, origin, LAYOUT_ABOVE_MIDDLE));

  /*
  println(myFormattedTexts.get(0).getLayoutInfo(myReferenceWidth));
   println(myFormattedTexts.get(1).getLayoutInfo(myReferenceWidth));
   println(myFormattedTexts.get(2).getLayoutInfo(myReferenceWidth));
   println(myFormattedTexts.get(0).intersects(myFormattedTexts.get(1), myReferenceWidth));
   println("-----");
   */

  boolean resolutionFound = resolveLayout(myFormattedTexts, myReferenceWidth);
  println("resolution found", resolutionFound, frameCount);
  try {
    myFormattedTexts.get(0).display(g, color(255, 0, 0, 127), myReferenceWidth);
    myFormattedTexts.get(1).display(g, color(0, 255, 0, 127), myReferenceWidth);
    myFormattedTexts.get(2).display(g, color(0, 127, 255, 127), myReferenceWidth);
    myFormattedTexts.get(3).display(g, color(0, 255, 0, 127), myReferenceWidth);
    myFormattedTexts.get(4).display(g, color(0, 127, 255, 127), myReferenceWidth);
    myFormattedTexts.get(5).display(g, color(255, 0, 0, 127), myReferenceWidth);
  } 
  catch (Exception e) {
  }
}


//////////

final int LAYOUT_ABOVE_MIDDLE = 0;
final int LAYOUT_BELOW_MIDDLE = 1;
final int LAYOUT_BELOW_LEFT = 2;
final int LAYOUT_BELOW_RIGHT = 3;
final int LAYOUT_ABOVE_LEFT = 4;
final int LAYOUT_ABOVE_RIGHT = 5;
final int LAYOUT_FIRST_OPTION = LAYOUT_ABOVE_MIDDLE;
final int LAYOUT_LAST_OPTION = LAYOUT_ABOVE_RIGHT;

class FormattedText {
  ArrayList<String> myStrings;
  ArrayList<PFont> myFonts;
  ArrayList<Float> myMargins;
  PVector myOrigin;
  int myLayoutMode;
  float myPadding;

  FormattedText(ArrayList<String> s, ArrayList<PFont> f, ArrayList<Float> m, PVector origin, int theLayoutMode) {
    this(s, f, m, origin, theLayoutMode, 10);
  }


  FormattedText(ArrayList<String> s, ArrayList<PFont> f, ArrayList<Float> m, PVector origin, int theLayoutMode, float padding) {
    myStrings = s;
    myFonts = f;
    myMargins = m;
    myOrigin = origin.copy();
    myLayoutMode = theLayoutMode;
    myPadding = padding;
  }

  LayoutInfo getLayoutInfo(float referenceWidth) {
    float w = 0f;
    float h = 0f;

    pushStyle();
    for (int i = 0; i < myStrings.size(); i++) {
      PFont theFont = myFonts.get(i);
      textFont(theFont);
      String theString = myStrings.get(i);
      Float theMargin = myMargins.get(i);
      if (theMargin == null) {
        theMargin = 0f;
      }
      w = max(w, textWidth(theString)) + myPadding*2;
      h += theFont.getDefaultSize() + theMargin + myPadding*2;
    }

    popStyle();
    LayoutInfo result = null;
    switch(myLayoutMode) {
    case LAYOUT_ABOVE_MIDDLE:
      result = new LayoutInfo(myOrigin.x, myOrigin.y - h, w, h);
      break;
    case LAYOUT_BELOW_MIDDLE:
      result = new LayoutInfo(myOrigin.x, myOrigin.y, w, h);
      break;
    case LAYOUT_BELOW_LEFT:
      result = new LayoutInfo(myOrigin.x - w, myOrigin.y, w, h);
      break;
    case LAYOUT_BELOW_RIGHT:
      result = new LayoutInfo(myOrigin.x + referenceWidth, myOrigin.y, w, h);
      break;
    case LAYOUT_ABOVE_LEFT:
      result = new LayoutInfo(myOrigin.x - w, myOrigin.y - h, w, h);
      break;
    case LAYOUT_ABOVE_RIGHT:
      result = new LayoutInfo(myOrigin.x + referenceWidth, myOrigin.y - h, w, h);
      break;
    }

    return result;
  }

  boolean intersects(FormattedText other, float referenceWidth) {
    return getLayoutInfo(referenceWidth).intersects(other.getLayoutInfo(referenceWidth));
  }

  void cycleLayout() {
    myLayoutMode = (myLayoutMode + 1) % (LAYOUT_LAST_OPTION+1);
  }

  void display(PGraphics pg, color c, float referenceWidth) {

    LayoutInfo myLayout = getLayoutInfo(referenceWidth);
    pg.pushStyle();
    pg.noStroke();
    pg.fill(c);
    pg.rect(myLayout.x, myLayout.y, myLayout.w, myLayout.h);

    pg.pushMatrix();
    pg.fill(255);
    pg.translate(myOrigin.x, myOrigin.y);
    float y =  myPadding;
    float x =  myPadding;
    switch(myLayoutMode) {
    case LAYOUT_ABOVE_MIDDLE:
      pg.textAlign(LEFT, TOP);
      y -= myLayout.h;
      break;
    case LAYOUT_BELOW_MIDDLE:
      pg.textAlign(LEFT, TOP);
      break;
    case LAYOUT_BELOW_LEFT:
      pg.textAlign(RIGHT, TOP);
      x = -myPadding;
      break;
    case LAYOUT_BELOW_RIGHT:
      pg.textAlign(LEFT, TOP);
      x += referenceWidth;
      break;
    case LAYOUT_ABOVE_LEFT:
      pg.textAlign(RIGHT, TOP);
      y = -myLayout.h + myPadding;
      x = -myPadding;
      break;
    case LAYOUT_ABOVE_RIGHT:
      pg.textAlign(LEFT, TOP);
      y -= myLayout.h;
      x += referenceWidth;
      break;
    }

    for (int i = 0; i < myStrings.size(); i++) {
      PFont theFont = myFonts.get(i);
      pg.textFont(myFonts.get(i));
      String theString = myStrings.get(i);
      Float theMargin = myMargins.get(i);
      if (theMargin == null) {
        theMargin = 0f;
      }

      pg.text(theString, x, y); 
      y += theFont.getDefaultSize() + theMargin;
    }
    pg.popMatrix();

    pg.popStyle();
  }
}

LayoutInfo mergeLayoutsVertically(LayoutInfo l0, LayoutInfo l1) {
  float x = min(l0.x, l1.x);
  float y = min(l0.y, l1.y);
  float w = max(l0.x + l0.w, l1.x + l1.w) - l0.x;
  float h = l0.h + l1.h;
  return new LayoutInfo(x, y, w, h);
}

boolean resolveLayout(ArrayList<FormattedText> ft, float referenceWidth) {
  boolean result = true;
  int maxIterations = 1000;
  int it = 0;
  int intersectionIndex = intersectsOthers(ft, referenceWidth);
  while (intersectionIndex > -1 && it < maxIterations) {
    //println("intersection index", intersectionIndex);
    ft.get(intersectionIndex).cycleLayout();
    //println(intersectionIndex, ft.get(intersectionIndex).myLayoutMode);
    intersectionIndex = intersectsOthers(ft, referenceWidth);
    /*
    if (intersectionIndex == ft.size()-1) {
     //resetting options for the rest of the elements
     
     if (firstElement.myLayoutMode < LAYOUT_LAST_OPTION) {
     for (int i = 1; i < ft.size(); i++) {
     ft.get(i).myLayoutMode = LAYOUT_FIRST_OPTION;
     }
     }
     
     firstElement.myLayoutMode = (firstElement.myLayoutMode+1) % LAYOUT_LAST_OPTION;
     } else {
     FormattedText intersectsOthers = ft.get(intersectionIndex);
     if (intersectsOthers.myLayoutMode < LAYOUT_LAST_OPTION) {
     intersectsOthers.cycleLayout();
     } else {
     ft.get(intersectionIndex+1).cycleLayout();
     }
     }
     */
    it++;
  }
  if (intersectionIndex == -1) {
    println("found solution");
    result = true;
  } else {
    println("could not find a solution");
    result = false;
  }
  println("took iterations", it);
  println("-------");
  return result;
}

int intersectsOthers(ArrayList<FormattedText> ft, float referenceWidth) {
  for (int i = 0; i < ft.size(); i++) {
    for (int j = 0; j < ft.size(); j++) {
      if (i < j) {
        FormattedText ft0 = ft.get(i);
        FormattedText ft1 = ft.get(j);
        if (ft0.intersects(ft1, referenceWidth)) {
          return j;
        }
      }
    }
  }
  return -1;
}

////////////////////////

class LayoutInfo {
  float x, y, w, h;
  float gap;

  LayoutInfo(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  boolean hover(float mx, float my) {
    return mx >= x && mx <= y + w && my >= y && my <= y + h;
  }

  boolean intersects(LayoutInfo other) {
    /*
    float x0 = min(this.x, other.x);
     float y0 = min(this.y, other.y);
     float x1 = max(this.x + this.w, other.x + other.w);
     float y1 = max(this.y + this.h, other.y + other.h);
     println(x1 - x0, this.w + other.w , y1 - y0, this.h + other.h);
     return (x1 - x0) >= this.w + other.w &&  (y1 - y0) >= this.h + other.h;
     */
    float x1 = max(this.x, other.x);
    float x0 = min(this.x + this.w, other.x + other.w);
    float y1 = max(this.y, other.y);
    float y0 = min(this.y + this.h, other.y + other.h);
    //println(x1 - x0, this.w + other.w , y1 - y0, this.h + other.h);
    return x0 > x1 && y0 > y1;
  }

  @Override
    String toString() {
    return x + " | " + y + " | " + w + " | " + h;
  }
}