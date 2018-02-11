precision highp float;
precision highp int;

//grid code originally appears: https://github.com/diroru/domemod
#define PI 3.1415926535897932384626433832795

uniform sampler2D mapTexture;
uniform float deltaLat;
uniform float deltaLon;
uniform float scale;

varying vec2 vertTexCoord;

vec3 latLonToXYZ(vec2 latLon) {
  float lat = latLon.x;
  float lon = latLon.y;
  float x = cos(lon) * sin(lat);
  float y = sin(lon) * sin(lat);
  float z = cos(lat);
  return vec3(x,y,z);
}

vec3 rotateZ(vec3 v, float theta) {
  float x = v.x * cos(theta) + v.y * sin(theta);
  float y = -v.x * sin(theta) + v.y * cos(theta);
  float z = v.z;
  return vec3(x,y,z);
}

vec3 rotateY(vec3 v, float theta) {
  float y = v.y;
  float x = v.x * cos(theta) - v.z * sin(theta);
  float z = v.x * sin(theta) + v.z * cos(theta);
  return vec3(x,y,z);
}

vec3 rotateX(vec3 v, float theta) {
  float x = v.x;
  float y = v.y * cos(theta) - v.z * sin(theta);
  float z = v.y * sin(theta) + v.z * cos(theta);
  return vec3(x,y,z);
}

vec2 domeXYToLatLon(vec2 xy, float aperture) {
  float x = xy.x - 0.5;
  float y = xy.y - 0.5;
  float lat = sqrt(x*x + y*y) * aperture;
  float lon = atan(y,x);
  return vec2(lat, lon);
}

/*
vec2 xyzToLatLng(vec3 v) {
  float lambda = atan(v.z, v.x);
  float mu = atan(v.y, sqrt(v.x*v.x  + v.z*v.z));
  return vec2(mu, lambda);
}
*/

vec2 xyzToLatLng(vec3 v) {
  float lat = acos(v.z);
  float lon = atan(v.y, v.x);
  return vec2(lat, lon);
}

vec3 domeXYToXYZ(vec2 xy, float aperture) {
  return latLonToXYZ(domeXYToLatLon(xy, aperture));
}

float map(float v, float s0, float s1, float t0, float t1) {
  return (v - s0) / (s1 - s0) * (t1 - t0) + t0;
}

//https://en.wikipedia.org/wiki/Azimuthal_equidistant_projection
void main() {
  //vec2 v = vertTexCoord + vec2(deltaLat / PI, 0.0);
  /*
  vec2 v = vertTexCoord;
  vec2 c = vec2(0.5, 0.5);
  float lat = mod(length(v - c) * 2.0, 1.0);
  float lng = (atan(v.y - c.y, v.x - c.x) / PI + 1.0) * 0.5;

  float phi = PI * 0.5 - lat * PI;
  float lambda = lng * PI * 2.0 ;
  float phi1 = lat0;
  float lambda0 = lng0;

  float cos_rho = sin(phi1) * sin(phi) + cos(phi1) * cos(phi) * cos(lambda - lambda0);
  float tan_theta = cos(phi) * sin(lambda - lambda0) / (cos(phi1) * sin(phi) - sin(phi1) * cos(phi) * cos(lambda - lambda0));

  float rho = acos(cos_rho);
  float theta = atan(tan_theta,1);

  float s = (rho * sin(theta) + 1.0) * 0.5;
  float t = (- rho * cos(theta) + 1.0) * 0.5;
  */
  /*
  vec2 v = vertTexCoord;
  vec2 c = vec2(0.5, 0.5);
  float lat = mod(length(v - c) * 2.0, 1.0);
  float lng = (atan(v.y - c.y, v.x - c.x) / PI + 1.0) * 0.5;
  */

  //vec3 xyz = domeXYToXYZ(vertTexCoord, scale);

  float dx = vertTexCoord.x - 0.5;
  float dy = vertTexCoord.y - 0.5;
  float theta = atan(dy, dx);
  float rho = sqrt(dx * dx + dy * dy) * scale;
  float lon = theta;
  float lat = map(rho, 0, 0.5, PI*0.5, 0.0);
  float x = cos(lon) * cos(lat);
  float y = sin(lon) * cos(lat);
  float z = sin(lat);
  vec3 xyz = vec3(x,y,z);

  xyz = rotateZ(xyz, deltaLon);
  xyz = rotateY(xyz, deltaLat);
  xyz = rotateZ(xyz, -deltaLon);

  float lat1 = asin(xyz.z);
  float lon1 = atan(xyz.y, xyz.x);

  float t = map(lat1, PI * 0.5, 0.0, 0.0, 0.5);
  float s = map(lon1, -PI, PI, 0.0, 1.0);
  /*
  vec2 latLng = xyzToLatLng(xyz);
  float t = (latLng.x);
  float s = (latLng.y + PI) / PI * 0.5;
  s = mod(s, 1.0);
  t = mod(t, 1.0);
  */
  gl_FragColor = texture(mapTexture, vec2(s, t));
  //gl_FragColor = vec4(xyz * 0.5 + vec3(0.5), 1.0);
  //gl_FragColor = vec4(s, t, 0.0, 1.0);
  //gl_FragColor = texture(myBackground, vertTexCoord);
}
