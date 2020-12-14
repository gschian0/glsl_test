#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

void main(){
    vec2 coord = gl_FragCoord.xy * 1.0 - u_resolution;
    vec3 color = vec3(0.0);

    color += abs(cos(coord.x/cos(coord.y)/200.0)+sin(coord.y/cos(coord.x)/200.0) - cos(u_time));

    vec3 color2 = vec3(0.0902, 0.4863, 0.1216);
    gl_FragColor = vec4(color*color2,1.0);

}