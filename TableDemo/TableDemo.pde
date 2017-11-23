import java.util.*;

Table data;

void setup() {
  size(800,600,P2D);
  data = loadTable("env_wasgen/env_wasgen_2.tsv", "header, tsv");
  println("rows:", data.getRowCount());
  println("columns:", data.getColumnCount());
  println("column names:");
  printArray(data.getColumnTitles());
  println("DATA TYPES", "cat:", Table.CATEGORY, "double:", Table.DOUBLE, "float:", Table.FLOAT, "int:", Table.INT, "long:", Table.LONG, "String:", Table.STRING);
  printArray(data.getColumnTypes());
  printArray(data.getRow(0).getString(0).split(","));
  //printArray(data.getRow(0).getString("GEO,UNIT,HAZARD,NACE_R2,TIME\\WASTE").split(",")); //yields the same
  println("-----");
  for (int i = 0; i < data.getRowCount(); i++) {
    println(data.getRow(i).getString("GEO/WASTE"), "\t", data.getRow(i).getLong("Total Waste"));
  }
  println("-----");
  float sum = data.getRow(0).getLong("Total Waste");
  for (int i = 0; i < data.getRowCount(); i++) {
    println(data.getRow(i).getString("GEO/WASTE"), "\t", data.getRow(i).getLong("Total Waste")/(sum+0f)*100, "%");
  }
  //find min and max
  //find mean
  
  int margin = 20;
  int dataCount = data.getRowCount()-1;
  float barWidth = (width - margin * 2f) / dataCount;
  float barHeightMax = height - margin*2f;
  fill(#FF0000);
  for (int i = 1; i <= dataCount; i++) {
    float barHeightNorm = data.getRow(i).getLong("Total Waste")/(sum+0f);
    float barHeight = barHeightNorm * barHeightMax;
    float x = i * barWidth;
    float y = height - margin - barHeight;
    rect(x,y,barWidth,barHeight);
  }
}

void draw() {
}