#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
const float PI = 3.14159265359;

void main(){
    vec2 coord = fract(10.0* (gl_FragCoord.xy  / u_resolution)) ;
    vec3 color = vec3(0.0);
    vec2 translate = vec2(-0.5,-0.5);
    coord += translate;

    color.r += step(abs(0.1 + tan(length(coord.x*coord.y)-0.6) * abs(cos(u_time * 1.0))),0.1);
    color.g += step(abs(0.1 + atan(length(coord.y*coord.x)-0.4 )* abs(sin(u_time * 1.0))),0.1);
    color.b += step(abs(0.1 + length(coord)-0.4 * abs(sin(tan(u_time) * 1.5))),0.1);
    gl_FragColor = vec4(color-0.4, 1.0);
}
