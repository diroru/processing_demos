//vertical stacking
public class RadioButtonGroup {
  float x, y, w;

  ArrayList<RadioButton> buttons = new ArrayList<RadioButton>();
  RadioButton selected = null;
  RadioButton lastButton = null;
  PApplet parent;

  RadioButtonGroup(float theX, float theY, float theW, PApplet parent) {
    x = theX;
    y = theY;  
    w = theW;
    parent.registerMethod("mouseEvent", this);
  }

  void addRadioButton(RadioButton rb) {
    addRadioButton(rb, false);
  }

  void addRadioButton(RadioButton rb, boolean isSelected) {
    if (buttons.size() == 0 || isSelected) {
      selected = rb;
      rb.selected = true;
    }
    buttons.add(rb);
    lastButton = rb;
  }

  float getNextY() {
    return y + getHeight();
  }

  boolean isHover(float mx, float my) {
    return mx >= x && mx <= x + w && my >= y && my <= y + getHeight();
  }

  float getHeight() {
    float result = 0;
    for (RadioButton rb : buttons) {
      result += rb.h + rb.m;
    }
    return result;
  }

  void display(PGraphics g) {
    float strokeW = 15;
    float y0 = y + strokeW * 0.5;
    float y1 = y + getHeight() - lastButton.h - lastButton.m + 2;
    g.pushStyle();
    g.stroke(DARK_GREY);
    g.strokeCap(ROUND);
    g.strokeWeight(strokeW);
    g.beginShape(LINES);
    g.vertex(x-strokeW, y0, -1);
    g.vertex(x-strokeW, y1, -1);
    g.endShape();
    
    g.ellipseMode(CENTER);
    g.noStroke();
    g.fill(DARK_GREY);
    g.ellipse(x-strokeW, y0, strokeW, strokeW);
    g.ellipse(x-strokeW, y1, strokeW, strokeW);
    g.popStyle();
    for (RadioButton rb : buttons) {
      rb.display(g);
    }
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.CLICK:
      //println("CLICK", e);
      if (isHover(mappedMouse.x, mappedMouse.y)) {
        for (RadioButton rb : buttons) {
          rb.selected = false;
          if (rb.isHover(mappedMouse.x, mappedMouse.y)) {
            rb.selected = true;
            selected = rb;
          }
        }
      }
      break;
    }
  }
}

public class RadioButton {
  float x, y, w, h, m;
  boolean selected = false;
  boolean hover = false;
  String label;
  Method callback;
  PApplet parent;

  RadioButton(RadioButtonGroup parentGroup, float theHeight, String theLabel, PApplet theParent, PGraphics pg, String callbackName) {
    this(parentGroup, theHeight, theHeight*0.5, theLabel, theParent, pg, callbackName);
  }

  RadioButton(RadioButtonGroup parentGroup, float theHeight, float theBottomMargin, String theLabel, PApplet theParent, PGraphics pg, String callbackName) {
    h = theHeight;
    w = parentGroup.w;
    /*
    pg.textFont(INFO);
    float labelW = pg.textWidth(theLabel);
    while (labelW >= w) {
      h += theHeight;
      labelW -= w;
    }
    */
    x = parentGroup.x;
    y = parentGroup.getNextY();
    m = theBottomMargin;
    parentGroup.addRadioButton(this);

    label = theLabel;
    parent = theParent;
    parent.registerMethod("mouseEvent", this);
    try {
      //callback = FlowremIpsum.class.getMethod(callbackName);
      callback = parent.getClass().getMethod(callbackName);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
  }

  void display(PGraphics g) {
    g.textFont(INFO);
    g.textAlign(LEFT, TOP);
    if (hover) {
      g.fill(PRIMARY);
    } else if (selected) {
      g.fill(WHITE);
    } else {
      g.fill(WHITE);
    }
    g.text(label, x, y, w, h*2);
    if (selected) {
      g.fill(WHITE);
    } else if (hover) {
      g.fill(PRIMARY);
    } 
    if (hover || selected) {
      g.pushStyle();
      g.noStroke();
      g.ellipseMode(LEFT);
      g.ellipse(x-23, y-2, 16, 16);
      //g.fill(255, 0, 0, 127);
      //g.rect(x, y, w, h);
      g.popStyle();
    }
  }

  boolean isHover(float mx, float my) {
    //return ((mx >= x && mx <= x + w) || (mx >= x + canvas.width && mx <= x + w + canvas.width)) && (my >= y && my <= y + h);
    return mx >= x && mx <= x + w && my >= y && my <= y + h;
  }

  void mouseEvent(MouseEvent e) {
    //println("mouseEvent: " + e);
    switch(e.getAction()) {
    case MouseEvent.MOVE:
      hover = isHover(mappedMouse.x, mappedMouse.y);
      break;
    case MouseEvent.CLICK:
      if (hover) {
        try {
          callback.invoke(parent);
        } 
        catch (Exception ex) {
        }
      }
      break;
    }
  }
}