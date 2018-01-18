void fitImage(PImage img) {
  float scaleFactor = fittingScaleFactor(img);
  image(img,0,0,img.width*scaleFactor,img.height*scaleFactor);
}

float fittingScaleFactor(PImage src) {
  return fittingScaleFactor(src, g);
}

float fittingScaleFactor(PImage src, PImage target) {
  return min(float(target.width)/src.width, float(target.height)/src.height);
}