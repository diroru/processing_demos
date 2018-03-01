class LayoutInfo {
  float x,y,w,h;
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
}