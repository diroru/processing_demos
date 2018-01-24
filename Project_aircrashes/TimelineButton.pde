public class TimelineButton {

  float myWidth, myAngle, myDeltaAngle;
  Timeline myTimeline;
  boolean mouseOver = false;

  TimelineButton(float theWidth, Timeline theTimeline, float theAngle, PApplet parent) {
    myWidth = theWidth;
    myTimeline = theTimeline;
    myAngle = theAngle;
    myDeltaAngle = getPhiFromSides(myWidth, myTimeline.myRadius);
    parent.registerMethod("mouseEvent", this);
  }

  void display() {
    pushStyle();
    noFill();
    if (mouseOver) {
      stroke(0,0,255);
    } else {
      stroke(255);
    }
    myTimeline.drawArcAround(myAngle + HALF_PI, myDeltaAngle);
    popStyle();
  }

  float getWidth() {
    return myWidth;
  }

  boolean mouseOver(float mx, float my) {
    float dx = mx - width *0.5;
    float dy = my - height *0.5;
    float r = sqrt(dx * dx + dy * dy);
    float theta = atan2(dy, dx);
    return theta +PI +HALF_PI >= myAngle - myDeltaAngle && theta +PI +HALF_PI<= myAngle + myDeltaAngle && r >= myTimeline.innerRadius() && r <= myTimeline.outerRadius(); 
    //return false;
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      mouseOver = mouseOver(mouseX, mouseY);
      break;
    case MouseEvent.CLICK:
      //println("CLICK", e);
      break;
    }
  }
}