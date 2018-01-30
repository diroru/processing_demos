float TOOLTIP_WIDTH = 330;
float TOOLTIP_HEADER_HEIGHT = 30;
float TOOLTIP_DATUM_HEIGHT = 16;
float TOOLTIP_MARGIN = 5;
int[] TOOLTIP_COLS = {15, 15, 70, 120, 60, 50};

Country tooltipCountry = null;

void setTooltip(Country theTooltipCountry) {
  tooltipCountry = theTooltipCountry;
}

Country getTooltip() {
  return tooltipCountry;
}

void drawTooltip() {
  drawTooltip(matrixLayout, DELTA_Y);
}

void drawTooltip(LayoutInfo matrixLayout, float deltaY) {

  if (tooltipCountry != null && tooltipCountry.data.size()>0) {
    float locationWidth = TOOLTIP_COLS[3];
    float x = tooltipCountry.currentX + tooltipCountry.currentW + GAP;
    float y = tooltipCountry.currentY + deltaY;
    float w = TOOLTIP_WIDTH;
    float h = getTooltipHeight(tooltipCountry, locationWidth);
    if (x + w > matrixLayout.x + matrixLayout.w) {
      x = x - w - tooltipCountry.currentW - GAP * 2;
    }
    if (y + h > matrixLayout.y + matrixLayout.h) {
      y = y - h + tooltipCountry.currentH;
    }

    canvas.pushStyle();
    canvas.textAlign(LEFT, TOP);
    canvas.fill(DARKER_GREY);
    canvas.textFont(smallFont);
    canvas.rect(x, y, w, h);
    x += TOOLTIP_MARGIN;
    y += TOOLTIP_MARGIN;
    canvas.fill(WHITE);
    canvas.text(tooltipCountry.getHeader(), x, y);
    y += TOOLTIP_HEADER_HEIGHT;
    for (int i = 0; i < tooltipCountry.data.size(); i++) {
      Datum d = tooltipCountry.data.get(i); 
      int fieldNo = 0;
      float x0 = x;
      canvas.text(i+1+"", x0, y);
      x0 += TOOLTIP_COLS[fieldNo++];

      float s = 8;
      canvas.fill(getColor(d));
      canvas.rect(x0, y, s, s);
      x0 += TOOLTIP_COLS[fieldNo++];
      canvas.fill(WHITE);
      canvas.text(d.getDate(), x0, y);
      x0 += TOOLTIP_COLS[fieldNo++];

      /*
      canvas.fill(tooltipCountry.c1);
       canvas.triangle(x0, y, x0 + s, y, x0, y + s);
       canvas.fill(tooltipCountry.c0);
       canvas.triangle(x0 + s, y, x0 + s, y + s, x0, y +s);
       */

      //TODO: lineCount
      float locationHeight = getTextBlockHeight(d.location, TOOLTIP_DATUM_HEIGHT, locationWidth);
      canvas.text(d.location, x0, y, locationWidth, locationHeight);
      //canvas.text("TODO: location", x0, y);
      x0 += TOOLTIP_COLS[fieldNo++];

      canvas.text(d.phase_code, x0, y);
      x0 += TOOLTIP_COLS[fieldNo++];

      tooltipCountry.drawFatalities(canvas, x0, y, d);
      x0 += TOOLTIP_COLS[fieldNo++];

      y += locationHeight;
    }
    canvas.popStyle();
  }
}

int getTooltipHeight(Country c, float colWidth) {
  float textHeight = 0;
  for (int i = 0; i <  c.data.size(); i++) {
    textHeight += getTextBlockHeight(c.data.get(i).location, TOOLTIP_DATUM_HEIGHT, colWidth);
  }
  return floor(TOOLTIP_MARGIN * 2 + TOOLTIP_HEADER_HEIGHT + textHeight);
}

float getTextBlockHeight(String text, float unitHeight, float colWidth) {
  float w = canvas.textWidth(text);
  float result = unitHeight;
  while (w > colWidth) {
    w -= colWidth;
    result += unitHeight;
  }
  return result;
}