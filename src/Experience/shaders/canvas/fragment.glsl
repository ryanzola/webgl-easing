uniform vec3 iResolution;
uniform float iTime;

varying vec2 vUv;

float EaseIn(float x) {
  return x * x;
}

float EaseOut(float x) {
  return 1.0 - EaseIn(x - 1.0);
}

float EaseInOut(float x) {
  return x * x * (3.0 - (2.0 * x));
}

float Overshoot(float x, float n, float k) {
  x = x * x * (3.0 - 2.0 * x);
  float a = n * (x * x);
  float b = 1.0 - (k * ((x - 1.0) * (x - 1.0)));
  return a * (1.0 - x) + b * x;
}

float Dot(vec2 uv, float x, float y) {
  x = mix(-0.8, 0.8, x);
  return smoothstep(0.01, 0.0, length(uv - vec2(x, y)) - 0.02);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  vec2 uv = (fragCoord - 1.0 * iResolution.xy)/iResolution.y;

  vec3 col = vec3(0);

  float x = min(1.0, iTime);
  col += vec3(1.0, 0.0, 0.0) * Dot(uv, x, 0.8);   // linear
  col += vec3(1.0, 0.5, 0.0) * Dot(uv, EaseIn(x), 0.6);   // ease in
  col += vec3(1.0, 1.0, 0.0) * Dot(uv, EaseOut(x), 0.4);   // ease out
  col += vec3(0.0, 0.5, 0.0) * Dot(uv, EaseInOut(x), 0.2);   // smooth
  col += vec3(0.0, 0.5, 1.0) * Dot(uv, Overshoot(x, 3.0, 3.0), 0.0);   // smooth

  if(abs(abs(uv.x) - 0.8) < .002) col += 1.0;

  fragColor = vec4(col, 1.0);
}

void main() {
  mainImage(gl_FragColor, gl_FragCoord.xy);
}
