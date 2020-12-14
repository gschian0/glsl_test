#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
const float PI = 3.14159265359;

void main (){
    float len;
    vec2 coord = gl_FragCoord.xy / u_resolution;
    len = length(vec2(coord.x,coord.y));
    vec3 color = vec3(0);
    color.r = step(sin(10.0*fract(10.0*coord.x)-u_time)*sin(u_time),0.5);
    color.b = sin(fract(10.0*coord.y)+u_time);
    color.g = cos(10.0*fract(20.0*coord.y)-u_time);
    color.r = fract(20.0*coord.x);
    float d = length(vec2(coord.x,coord.y))-0.5*sin(2.0+u_time);
    coord.x += coord.x - cos(coord.y + sin(len)) + cos(u_time / 9.0);
    

    gl_FragColor = vec4(cos(2.0*color.r)*d,sin(3.0*color.g)*d,cos(3.0*color.b)*d,1.0);
}