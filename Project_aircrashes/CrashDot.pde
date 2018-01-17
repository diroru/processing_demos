public class CrashDot { //<>// //<>// //<>// //<>// //<>//
  Datum myDatum;
  Timeline myTimeline;
  float myRadius = 3.5;
  PVector myPos;
  float margin = 1;
  boolean mouseOver = false;

  CrashDot(Datum theDatum, Timeline theTimeline, ArrayList<CrashDot> previousOnes, PApplet parent) {
    myDatum = theDatum;
    myTimeline = theTimeline;
    setPosition(myDatum, myTimeline, previousOnes);
    parent.registerMethod("mouseEvent", this);
  }

  void setPosition(Datum theDatum, Timeline theTimeline, ArrayList<CrashDot> previousOnes) {
    myPos = theTimeline.getCrashDotPosition(theDatum, 10);
    if (previousOnes.size() > 0) {
      while (this.overlaps(previousOnes)) {
        myPos = incrementRadially(myPos, 2 * myRadius + margin);
      }
    }
  }

  boolean overlaps(ArrayList<CrashDot> others) {
    boolean overlaps = false;
    for (CrashDot other : others) {
      float dist = PVector.dist(other.myPos, this.myPos);
      PVector d = PVector.sub(other.myPos, this.myPos);
      float minDist = other.myRadius + margin + this.myRadius;
      if (d.mag() < minDist) {
        overlaps = true;
      }
    }
    return overlaps;
  }

  boolean mouseOver() {
    return abs(myPos.x - mouseX) <= myRadius && abs(myPos.y - mouseY) <= myRadius;
  }

  boolean overlaps(CrashDot other) {
    float dist = PVector.dist(other.myPos, this.myPos);
    return dist < other.myRadius + margin + this.myRadius;
  }

  void display() {
    fill(255, 255, 0, 127);
    ellipseMode(RADIUS);
    ellipse(myPos.x, myPos.y, myRadius, myRadius);
    if (mouseOver) {
      fill(255);
      textSize(20);
      drawTangentialText(myDatum.date, mouseX, mouseY);
    }
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      mouseOver = mouseOver();
      break;
    case MouseEvent.CLICK:
      //println("CLICK", e);
      break;
    }
  }
}