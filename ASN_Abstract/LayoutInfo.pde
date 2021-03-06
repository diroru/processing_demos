class LayoutInfo {
  //upper left corner
  float x, y;
  //width and height
  float w, h;
  //gaps
  float hGap, vGap;
  float cellWidth, cellHeight;

  LayoutInfo(float theX, float theY, float theW, float theH, float theHGap, float theVGap) {
    x = theX;
    y = theY;
    w = theW;
    h = theH;
    hGap = theHGap;
    vGap = theVGap;
  }

  float getUnitHeight(int count) {
    return (h - (count - 1) * vGap) / float(count);
  }

  float getUnitWidth(int count) {
    return (w - (count - 1) * hGap) / float(count);
  }

  float getUnitWidthWithDetails(int count, int dCountryCount, int dCountryWidth) {
    float result = (w - dCountryCount * dCountryWidth - (count - 1) * hGap) / float(count - dCountryCount);
    println(result);
    return result;
  }

  float deltaX(int count) {
    return getUnitWidth(count) + hGap;
  }

  float deltaY(int count) {
    return getUnitHeight(count) + vGap;
  }
  
  float getYNo(int no, int count) {
    float result = y + deltaY(count) * no;
    return result;
  }
}

LayoutInfo layoutFromCellSize(float x, float y, float cellWidth, float cellHeight, float hGap, float vGap, int hCount, int vCount) {
  float layoutWidth = cellWidth * hCount + hGap * (hCount - 1);
  float layoutHeight = cellHeight * vCount + hGap * (vCount - 1);
  LayoutInfo result = new LayoutInfo(x,y,layoutWidth,layoutHeight,hGap,vGap);
  result.cellWidth = cellWidth;
  result.cellHeight = cellHeight;
  return result;
}

LayoutInfo layoutFromCellSizeRightAlign(float right, float bottom, float cellWidth, float cellHeight, float hGap, float vGap, int hCount, int vCount) {
  float layoutWidth = cellWidth * hCount + hGap * (hCount - 1);
  float layoutHeight = cellHeight * vCount + hGap * (vCount - 1);
  println(right-layoutWidth,bottom-layoutHeight,layoutWidth,layoutHeight,hGap,vGap);
  LayoutInfo result = new LayoutInfo(right-layoutWidth,bottom-layoutHeight,layoutWidth,layoutHeight,hGap,vGap); 
  result.cellWidth = cellWidth;
  result.cellHeight = cellHeight;
  return result;
}