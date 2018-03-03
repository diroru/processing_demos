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

  boolean isInside(LayoutInfo other) {
    boolean result = x >= other.x && y >= other.y && x + w <= other.x + other.w && y + h <= other.y + other.h;
    /*
    if (!result) {
      println(x, y, x+w, y+h, other.x, other.y, other.x + other.w, other.y + other.h);
    }
    */
    return result;
  }

  @Override
    String toString() {
    return x + " | " + y + " | " + w + " | " + h;
  }
}

void updateTopThreeLayouts(ArrayList<MigrationFlow> topThreeFlows) {
  ArrayList<FormattedText> ft = new ArrayList<FormattedText>();
  for (int i = 0; i < topThreeFlows.size(); i++) {
    try {
      MigrationFlow mf = topThreeFlows.get(i);
      if (mf != null) {
        mf.myLayoutMode = LAYOUT_ABOVE_MIDDLE;
        //mf.myLayoutMode = LAYOUT_BELOW_RIGHT;
        ft.add(mf.getFormattedText(i));
      }
    } catch (Exception e) {
    }
    
  }
  
  boolean layoutResolved = resolveLayout(ft, flowLayout);
  
  for (int i = 0; i < topThreeFlows.size(); i++) {
    //println(topThreeFlows.get(i).myLayoutMode, "->", ft.get(i).myLayoutMode);
    topThreeFlows.get(i).myLayoutMode = ft.get(i).myLayoutMode;
  }
  //println("------");
  
  for (FormattedText ftt : ft) {
    ftt.display(canvas,color(255,255,0,63));
  }
}


//////////

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
  float myReferenceWidth;
  float myReferenceHeight;

  FormattedText(ArrayList<String> s, ArrayList<PFont> f, ArrayList<Float> m, PVector origin, float theReferenceWidth, float theReferenceHeight, int theLayoutMode) {
    this(s, f, m, origin, theReferenceWidth, theReferenceHeight, theLayoutMode, 10);
  }


  FormattedText(ArrayList<String> s, ArrayList<PFont> f, ArrayList<Float> m, PVector origin, float theReferenceWidth, float theReferenceHeight, int theLayoutMode, float padding) {
    myStrings = s;
    myFonts = f;
    myMargins = m;
    myOrigin = origin.copy();
    myLayoutMode = theLayoutMode;
    myReferenceWidth = theReferenceWidth;
    myReferenceHeight = theReferenceHeight;
    myPadding = padding;
  }

  LayoutInfo getLayoutInfo() {
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
      w = max(w, textWidth(theString) + myPadding*2);
      w = max(w, myReferenceWidth);
      if (i < myStrings.size()-1) {
        h += theFont.getDefaultSize() + theMargin + myPadding*2;
      } else {
        h += theFont.getDefaultSize();
      }
    }
    h += myPadding*2;

    popStyle();
    LayoutInfo result = null;
    switch(myLayoutMode) {
    case LAYOUT_ABOVE_MIDDLE:
      result = new LayoutInfo(myOrigin.x, myOrigin.y - myReferenceHeight, w, h);
      break;
    case LAYOUT_BELOW_MIDDLE:
      result = new LayoutInfo(myOrigin.x, myOrigin.y, w, h);
      break;
    case LAYOUT_BELOW_LEFT:
      result = new LayoutInfo(myOrigin.x - w, myOrigin.y, w, h);
      break;
    case LAYOUT_BELOW_RIGHT:
      result = new LayoutInfo(myOrigin.x + w, myOrigin.y, w, h);
      break;
    case LAYOUT_ABOVE_LEFT:
      result = new LayoutInfo(myOrigin.x - w, myOrigin.y - myReferenceHeight, w, h);
      break;
    case LAYOUT_ABOVE_RIGHT:
      result = new LayoutInfo(myOrigin.x + w, myOrigin.y - myReferenceHeight, w, h);
      break;
    }

    return result;
  }

  boolean intersects(FormattedText other) {
    return getLayoutInfo().intersects(other.getLayoutInfo());
  }

  void cycleLayout() {
    myLayoutMode = (myLayoutMode + 1) % (LAYOUT_LAST_OPTION+1);
  }

  void display(PGraphics pg, color c) {

    LayoutInfo myLayout = getLayoutInfo();
    pg.pushStyle();
    pg.noStroke();
    pg.fill(c);
    pg.rect(myLayout.x, myLayout.y, myLayout.w, myLayout.h);
    
    pg.fill(255,63);
    pg.ellipse(myOrigin.x, myOrigin.y, 10, 10);
    
    pg.noFill();
    pg.stroke(255);
    pg.rect(myLayout.x, myLayout.y, myReferenceWidth, myLayout.h);
    pg.noStroke();

    pg.pushMatrix();
    pg.fill(255);
    pg.translate(myOrigin.x, myOrigin.y);
    float y =  myPadding;
    float x =  myPadding;
    switch(myLayoutMode) {
    case LAYOUT_ABOVE_MIDDLE:
      pg.textAlign(LEFT, TOP);
      y -= myReferenceHeight;
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
      x += myReferenceWidth;
      break;
    case LAYOUT_ABOVE_LEFT:
      pg.textAlign(RIGHT, TOP);
      y = -myReferenceHeight + myPadding;
      x = -myPadding;
      break;
    case LAYOUT_ABOVE_RIGHT:
      pg.textAlign(LEFT, TOP);
      y -= myReferenceHeight;
      x += myReferenceWidth;
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

boolean resolveLayout(ArrayList<FormattedText> ft) {
  return resolveLayout(ft, new LayoutInfo(Float.MIN_VALUE, Float.MIN_VALUE, Float.MAX_VALUE, Float.MAX_VALUE));
}

boolean resolveLayout(ArrayList<FormattedText> ft, LayoutInfo containerLayout) {
  boolean result = true;
  int maxIterations = 100;
  int it = 0;
  int intersectionIndex = intersectsOthers(ft, containerLayout);
  while (intersectionIndex > -1 && it < maxIterations) {
    //println("intersection index", intersectionIndex);
    ft.get(intersectionIndex).cycleLayout();
    //println(intersectionIndex, ft.get(intersectionIndex).myLayoutMode);
    intersectionIndex = intersectsOthers(ft, containerLayout);
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
    println("found solution", frameCount);
    result = true;
  } else {
    println("could not find a solution", frameCount);
    result = false;
  }
  //println("took iterations", it);
  //println("-------");
  return result;
}

int intersectsOthers(ArrayList<FormattedText> ft, LayoutInfo containerLayout) {
  for (int i = 0; i < ft.size(); i++) {
    FormattedText ft0 = ft.get(i);
    if (!ft0.getLayoutInfo().isInside(containerLayout)) {
      return i;
    }
  }
  for (int i = 0; i < ft.size(); i++) {
    for (int j = 0; j < ft.size(); j++) {
      if (i < j) {
        FormattedText ft0 = ft.get(i);
        FormattedText ft1 = ft.get(j);
        if (ft0.intersects(ft1)) {
          return j;
        }
      }
    }
  }
  return -1;
}