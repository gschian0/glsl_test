#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
const float PI = 3.14159265359;

// Simplex 2D noise
//
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }

float snoise(vec2 v){
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
           -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
  + i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

mat2 scale(vec2 scale){
    return mat2(scale.x,0.0,0.0,scale.y);
}

float rectshape(vec2 position, vec2 scale){
    scale = vec2(0.5) - scale * 0.5;
    vec2 shaper = vec2(step(scale.x, position.x), step(scale.y, position.y));
    shaper *= vec2(step(scale.x, 1.0 - position.x), step(scale.y, 1.0 - position.y));
    return shaper.x * shaper.y;
}

mat2 rotate(float angle){
    return mat2(cos(angle),-sin(angle), sin(angle),cos(angle));
}

void main(){
    vec2 coord = abs(1.0*gl_FragCoord.xy / u_resolution/ 0.5 - vec2(1.));
    vec3 color = vec3(0.1765, 0.6863, 0.1294);
    vec3 color2 = vec3(0.1294, 0.6863, 0.298);
    for(int i = 0; i < 3; i++){
   // coord = scale(vec2(abs(sin(u_time)) + 0.5)) * cos(coord + 0.5-sin(u_time)-cos(u_time));
    coord -= vec2(0.5);
   // coord = rotate(-u_time*PI*2.0*00.01) * coord;
    coord += vec2(1.0);
    color += vec3(rectshape(coord,vec2(0.9,0.9)));
    coord *= abs(fract(coord));
    coord *= length(-1.5*1.0) ;
    coord = rotate(u_time) * coord;
    color += color * mod(sin(30.0*coord.x*coord.y-u_time),0.5);
    color *= abs(color * 1.0-color2);
}
    float noisey = snoise(0.9*coord);
    
    gl_FragColor = vec4(color-0.5,1.0)*noisey+0.2;
}