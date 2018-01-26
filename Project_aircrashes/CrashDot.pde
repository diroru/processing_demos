public class CrashDot { //<>// //<>// //<>// //<>//
  Datum myDatum;
  Timeline myTimeline;
  float myRadius = 3.7 * scaleFactor;
  PVector myPos;
  float margin = 1.7 * scaleFactor;
  boolean mouseOver = false;
  float myNormTime;

  CrashDot(Datum theDatum, Timeline theTimeline, ArrayList<CrashDot> previousOnes, PApplet parent, int repeatNo) {
    myDatum = theDatum;
    myTimeline = theTimeline;
    myNormTime = getNormalizedMoment(myDatum, myTimeline);
    setPosition(myDatum, myTimeline, previousOnes, repeatNo);
    parent.registerMethod("mouseEvent", this);
  }

  void setPosition(Datum theDatum, Timeline theTimeline, ArrayList<CrashDot> previousOnes, int repeatNo) {
    myPos = theTimeline.getCrashDotPosition(theDatum,18*scaleFactor,repeatNo);
    if (previousOnes.size() > 0) {
      while (this.overlaps(previousOnes)) {
        myPos = incrementRadially(myPos, myRadius + margin);
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

  boolean mouseOver(float mx, float my) {
    return abs(myPos.x - mx) <= myRadius && abs(myPos.y - my) <= myRadius;
  }

  boolean overlaps(CrashDot other) {
    float dist = PVector.dist(other.myPos, this.myPos);
    return dist < other.myRadius + margin + this.myRadius;
  }

  void display() {
    noStroke();
    if (mouseOver) {
      fill(255);
    } else {
      fill(155);
    }
      
    float deltaTime = (TIME - myNormTime) / GLOW_DURATION;
    if (deltaTime >= 0 && deltaTime <= 1) {
      fill(255 - deltaTime*100);
    }
    
    ellipseMode(RADIUS);
    ellipse(myPos.x, myPos.y, myRadius, myRadius);
    /*
    if (mouseOver) {
      fill(255);
      textSize(20);
      drawTangentialText(myDatum.date, mouseX, mouseY);
    }
    */
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      mouseOver = mouseOver(mouseX, mouseY);
      break;
    case MouseEvent.CLICK:
      //println("CLICK", e);
      
      if(mouseOver) {
        SEEK_TIME = myNormTime;
        SEEK_INC = (SEEK_TIME - TIME) / SEEK_DURATION;
        //SEEK_INC = signum(SEEK_TIME - TIME) * abs(SEEK_INC);
        currentState = STATE_SEEKING;
      }
      break;
    }
  }
}