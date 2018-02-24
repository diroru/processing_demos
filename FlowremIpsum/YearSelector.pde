public class YearSelector {
  int year;
  boolean _hover = false;
  LayoutInfo myLayout;

  YearSelector(int theYear, LayoutInfo theLayout, PApplet parent) {
    year = theYear;
    //parent.registerMethod("mouseEvent", this);
    myLayout = theLayout;
  }

  void display(PGraphics g) {

    if (isHover()) {
      g.fill(PRIMARY);
    } else if (year == currentYear){
      g.fill(WHITE);
    } else {
      g.fill(DARK_GREY);
    }
    g.textFont(INFO);
    g.textAlign(LEFT, BOTTOM);
    g.text(year, myLayout.x, myLayout.y + myLayout.h);
    g.fill(255,0,0,63);
    //g.rect(myLayout.x, myLayout.y, myLayout.w, myLayout.h);
  }

  void hover(float x, float y) {
    _hover = x >= myLayout.x && x <= myLayout.x + myLayout.w && y >= myLayout.y && y <= myLayout.y + myLayout.h;
  }

  boolean isHover() {
    return _hover;
  }

  void trigger() {
    setCurrentYear(year);
  }

  /*
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
  */
}
