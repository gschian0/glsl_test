#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
const float PI = 3.14159265359;



float poly(vec2 position, float radius, float sides){
    position = position * 2.0 - 1.0;
    float angle = atan(position.x, position.y);
    float slice = PI * 2.0 / sides;
    return step(radius, cos(floor(0.5 + angle / slice) * slice - angle) * length(position));
}
void main(){
    vec2 coord =5.0 * (gl_FragCoord.xy - u_resolution / 2.0)/ min(u_resolution.y,u_resolution.x);
    vec3 color = vec3(0.0);
    float polygon = poly(coord, .5,7.);
    
    gl_FragColor = vec4(color, 1.0);
}