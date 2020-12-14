#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

void main(){
    vec3 color = vec3(0.0);
    vec2 st = gl_FragCoord.xy / u_resolution;

    color.rg = cos(5.0*sin(99.0*st)+1.0)+vec2(1.0,1.0);
    


    gl_FragColor = vec4(sin(color+cos(u_time)), 1.0);
}