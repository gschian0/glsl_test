#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795
 
uniform float u_time;
uniform vec2 u_k;
float u_resolution;
 
void main() {
    vec2 coords = gl_FragCoord.xy / u_resolution;
    float v = 2.0;
    vec2 c = coords/64.0;
    v += sin((c.x+u_time));
    v += sin((c.y+u_time)/2.0);
    v += sin((c.x+c.y+u_time)/2.0);
    c += u_k/1.0 * vec2(sin(u_time/3.0), cos(u_time/2.0));
    v += sin(sqrt(c.x*c.y+c.y*c.y+1.0)+u_time);
    v = v/2.0;
    vec3 col = vec3(1, sin(PI*v), sin(PI*v));
    gl_FragColor = vec4(col*.5 + .5, 1);
}