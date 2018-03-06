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
      stroke(255, 255, 255, 100);
    } else {
      stroke(255);
    }
    myTimeline.drawArcAround(myAngle + HALF_PI, myDeltaAngle);
    popStyle();

    PVector pos = myTimeline.pointAtAngle(myAngle + HALF_PI + radians(0.2));
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(myAngle);
    rectMode(CENTER);
    fill(0);
    float s = 15 * scaleFactor;
    float dy = 5 * scaleFactor;
    switch(currentState) {
    case STATE_PAUSED:
      triangle(0, -s* sqrt(3) * 0.5 + dy, s, 0 + dy, 0, s * sqrt(3) * 0.5 + dy);
      break;
    default:
      rect(0, dy, s*0.4, s);
      rect(s*0.6, dy, s*0.4, s);
      break;
    }

    popMatrix();
  }

  float getWidth() {
    return myWidth;
  }

  boolean mouseOver(float mx, float my) {
    float dx = mx - width *0.5;
    float dy = my - height *0.5;
    float r = sqrt(dx * dx + dy * dy);
    float theta = atan2(dy, dx) - ORIENTATION;
    return theta +PI +HALF_PI >= myAngle - myDeltaAngle && theta +PI +HALF_PI<= myAngle + myDeltaAngle && r >= myTimeline.innerRadius() && r <= myTimeline.outerRadius();
    //return false;
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      mouseOver = mouseOver(mouseX, mouseY);
      //println("timeline button move", e);
      break;
    case MouseEvent.CLICK:
      if (mouseOver) {
        switch(currentState) {
        case STATE_PLAY:
          pauseSafely(timeAni);      
          pauseSafely(mapScaleOutAni);
          pauseSafely(lonAni);
          pauseSafely(lonPostAni);
          pauseSafely(latAni);
          pauseSafely(mapScaleInAni);
          pauseSafely(fadeInAni);
          pauseSafely(trajectoryShowAni);
          pauseSafely(crashInfoShowAni);
          pauseSafely(fadeOutAni);

          currentState = STATE_PAUSED;
          println("STATE_PLAY > STATE_PAUSED");
          break;
        case STATE_PAUSED:
          //if (activeFlight == null) {
          //globalAniSequence.start();
          resumeSafely(timeAni);
          resumeSafely(mapScaleOutAni);
          resumeSafely(lonAni);
          resumeSafely(lonPostAni);
          resumeSafely(latAni);
          resumeSafely(mapScaleInAni);
          resumeSafely(fadeInAni);
          resumeSafely(trajectoryShowAni);
          resumeSafely(crashInfoShowAni);
          resumeSafely(fadeOutAni);

          currentState = STATE_PLAY;
          println("STATE_PAUSED > STATE_PLAY");
          break;
        }
      }
    }
  }
}