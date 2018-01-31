class MigrationFlow implements Comparable {
  int year, volume;
  MigrationCountry origin, destination;
  int originOffset, destinationOffset;

  static final int SORT_BY_ORIGIN = 0;
  static final int SORT_BY_DESTINATION = 1;
  static final int SORT_BY_ORG_THEN_DST = 2;
  static final int SORT_BY_DST_THEN_ORG = 3;

  int sortingMethod = SORT_BY_ORG_THEN_DST;

  MigrationFlow(MigrationCountry theOrigin, MigrationCountry theDestination, int theYear, int theVolume) {
    origin = theOrigin;
    destination = theDestination;
    year = theYear;
    volume = theVolume;
  }

  @Override
    String toString() {
    return "(" + year + ") " + origin.name + " -> " + destination.name + " : " + volume;
  }

  @Override
    public boolean equals(Object obj) {
    MigrationFlow mf = ((MigrationFlow) obj); 
    return mf.origin.equals(this.origin) && mf.destination.equals(this.destination) && mf.year == this.year && mf.volume == this.volume;
  }

  @Override
    public int compareTo(Object o) {
    MigrationFlow mf = (MigrationFlow) o;
    switch(sortingMethod) {
    case SORT_BY_ORIGIN:
      return this.origin.name.compareTo(mf.origin.name);
    case SORT_BY_DESTINATION:
      return this.destination.name.compareTo(mf.destination.name);
    case SORT_BY_ORG_THEN_DST:
      int c1 = this.origin.name.compareTo(mf.origin.name);
      if (c1 == 0) {
        this.destination.name.compareTo(mf.destination.name);
      }
      return c1;
    case SORT_BY_DST_THEN_ORG:
      int c2 = this.destination.name.compareTo(mf.destination.name);
      if (c2 == 0) {
        return this.origin.name.compareTo(mf.origin.name);
        
      }
      return c2;
    }
    return 0;
  }

  void display(float scaleFactor, float margin, float bezierFactor) {
    float sWeight = volume * scaleFactor;
    float x0 = margin + originOffset * scaleFactor + sWeight*0.5;
    float y0 = margin;
    float x1 = margin + destinationOffset * scaleFactor  + sWeight*0.5;
    float y1 = height - margin;
    float cx0 = x0;
    float cy0 = margin + bezierFactor * (height - 2*margin);
    float cx1 = x1;
    float cy1 = height - margin - bezierFactor * (height - 2*margin);
    color c = color(map(x0, margin, width - margin, 0, 255), map(x1, margin, width - margin, 0, 255), 255, 127); 
    //strokeWeight(sWeight);
    //fill(c);
    //bezier(x0,y0,cx0,cy0,cx1,cy1,x1,y1);
    //drawBezier(x0, y0, x1, y1, sWeight, bezierFactor);
    //drawBezier_v2(x0, y0, x1, y1, sWeight, bezierFactor);
    //println(x0, y0, x1, y1);
    //line(x0,y0,x1,y1);  
    strokeWeight(sWeight);
    stroke(c);
    noFill();
    beginShape();
    vertex(x0, y0);
    bezierVertex(x0, y0 + (y1-y0)*bezierFactor, x1, y1 - (y1-y0)*bezierFactor, x1, y1);
    //vertex(x0, y1);
    //vertex(x0, y0);
    endShape();
  }
}