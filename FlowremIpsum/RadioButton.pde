//vertical stacking
public class RadioButtonGroup {
  float x, y, w;

  ArrayList<RadioButton> buttons = new ArrayList<RadioButton>();
  RadioButton selected = null;
  PApplet parent;

  RadioButtonGroup(float theX, float theY, float theW, PApplet parent) {
    x = theX;
    y = theY;  
    w = theW;
    parent.registerMethod("mouseEvent", this);
  }

  void addRadioButton(RadioButton rb) {
    if (buttons.size() == 0) {
      selected = rb;
    }
    buttons.add(rb);
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
      result += rb.h;
    }
    return result;
  }

  void display(PGraphics g) {
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
  float x, y, w, h;
  boolean selected = false;
  boolean hover = false;
  String label;
  Method callback;
  PApplet parent;

  RadioButton(RadioButtonGroup parentGroup, float theHeight, String theLabel, PApplet theParent, String callbackName) {
    h = theHeight;
    w = parentGroup.w;
    x = parentGroup.x;
    y = parentGroup.getNextY();
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
    if (hover) {
      g.fill(255);
    } else if (selected) {
      g.fill(255, 255, 0);
    } else {
      g.fill(127);
    }
    g.text(label, x, y + h);
    //g.rect(x,y,w,h);
  }

  boolean isHover(float mx, float my) {
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