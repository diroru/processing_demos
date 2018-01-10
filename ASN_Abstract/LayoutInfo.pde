class LayoutInfo {
  //upper left corner
  float x, y;
  //width and height
  float w, h;
  //gaps
  float hGap, vGap;
  LayoutInfo(float theX, float theY, float theW, float theH, float theHGap, float theVGap) {
    x = theX;
    y = theY;
    w = theW;
    h = theH;
    hGap = theHGap;
    vGap = theVGap;
  }
}