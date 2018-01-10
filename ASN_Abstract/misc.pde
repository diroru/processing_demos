PVector mapMouse(PGraphics target, int mx, int my) {
  float dx = (mx - width * 0.5) / width * 2f;
  float dy = (my - height * 0.5) / height * 2f;
  float r = sqrt(dx * dx + dy * dy);
  float phi = atan2(dy, dx);
  float x0 = cos(phi) * r;
  float y0 = sin(phi) * r;
  float x = (map(phi, -PI, PI, target.width, 0) + target.width * 0.5 ) % target.width;
  float y = map(r, 0, 1, 0, target.height);
  return new PVector(x, y);
}