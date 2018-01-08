public class YearSelector {
  int year;
  boolean hover = false;
  LayoutInfo myLayout;

  YearSelector(int theYear, LayoutInfo theLayout, PApplet parent) {
    year = theYear;
    parent.registerMethod("mouseEvent", this);
    myLayout = theLayout;
  }

  void display(PGraphics g) {
    g.fill(255);
    g.text(year, myLayout.x, myLayout.y + myLayout.h);
    if (hover) {
      g.fill(0,255,0,63);
    } else {
      g.fill(255,0,0,63);
    }
    g.rect(myLayout.x, myLayout.y, myLayout.w, myLayout.h);
  }

  boolean isHover(float x, float y) {
    return x >= myLayout.x && x <= myLayout.x + myLayout.w && y >= myLayout.y && y <= myLayout.y + myLayout.h;
  }

  void mouseEvent(MouseEvent e) {
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      hover = isHover(mappedMouse.x, mappedMouse.y);
      break;
    case MouseEvent.CLICK:
      if(hover) {
        //println("CLICK from year", year);
        setCurrentYear(year);
      }
      break;
    }
  }
}