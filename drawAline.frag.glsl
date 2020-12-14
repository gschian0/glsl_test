#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.1415926535897932384626433832795

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float plot (vec2 st,float pct) {
    return smoothstep (pct - 0.07,pct,st.y) -
            smoothstep(pct,pct+0.07,st.y);
}
void main() {
    vec2 st = gl_FragCoord.xy/u_resolution;

    float y = sin(PI*st.x*20.0-u_time)+0.2;
    float x = sin(PI*st.y*30.0+u_time)+0.2;
    vec3 color = vec3(y);
    vec3 color2 = vec3(x);
    float pct = plot(st,y);
    float pct2 = plot(st,x);
    color = (1.0-pct) * color + pct * vec3(0.0,1.0,0.0)+(1.0-pct2) * color2 + pct2 * vec3(0.3882, 0.0549, 0.0549);
    gl_FragColor = vec4(color,1.0);
}