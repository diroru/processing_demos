float quantize(float v, float q) {
  return floor((v - 0.001) * q) / q;
  //return floor(v * q) / q;
}

float quantize(float v, float min, float max, float q) {
  return map(quantize(norm(v,min,max), q), 0, 1, min, max);
}