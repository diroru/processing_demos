float TOOLTIP_WIDTH = 330;
float TOOLTIP_HEADER_HEIGHT = 30;
float TOOLTIP_DATUM_HEIGHT = 16;
float TOOLTIP_MARGIN = 5;
int[] TOOLTIP_COLS = {20, 70, 120, 60, 50};

Country tooltipCountry = null;

void setTooltip(Country theTooltipCountry) {
  tooltipCountry = theTooltipCountry;
}

Country getTooltip() {
  return tooltipCountry;
}

void drawTooltip() {
  if (tooltipCountry != null && tooltipCountry.data.size()>0) {
    
    float x = tooltipCountry.currentX + tooltipCountry.currentW;
    float y = tooltipCountry.currentY;
    canvas.pushStyle();
    canvas.textAlign(LEFT, TOP);
    canvas.fill(MID_GREY);
    canvas.rect(x, y, TOOLTIP_WIDTH, getTooltipHeight());
    x += TOOLTIP_MARGIN;
    y += TOOLTIP_MARGIN;
    canvas.fill(WHITE);
    canvas.text(tooltipCountry.getHeader(),x,y);
    canvas.textFont(smallFont);
    y += TOOLTIP_HEADER_HEIGHT;
    for (int i = 0; i < tooltipCountry.data.size(); i++) {
      Datum d = tooltipCountry.data.get(i); 
      int fieldNo = 0;
      float x0 = x;
      canvas.text(i+"",x0,y);
      x0 += TOOLTIP_COLS[fieldNo++];

      canvas.text(i+"",x0,y);
      x0 += TOOLTIP_COLS[fieldNo++];
      
      //tooltipCountry.drawFatalitiesRect(canvas,x0,y,d);
      //x0 += TOOLTIP_COLS[fieldNo++];

      //TODO: lineCount
      //canvas.text(d.location,x0,y);
      canvas.text("TODO: location",x0,y);
      x0 += TOOLTIP_COLS[fieldNo++];

      canvas.text(d.phase_code,x0,y);
      x0 += TOOLTIP_COLS[fieldNo++];

      tooltipCountry.drawFatalities(canvas,x0,y,d);
      x0 += TOOLTIP_COLS[fieldNo++];
      
      y += TOOLTIP_DATUM_HEIGHT;
    }
    canvas.popStyle();
  }
}

int getTooltipHeight() { 
  return floor(TOOLTIP_MARGIN * 2 + TOOLTIP_HEADER_HEIGHT + TOOLTIP_DATUM_HEIGHT * tooltipCountry.data.size());
}