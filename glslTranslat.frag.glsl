#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

float circleshape(vec2 position, float radius){
    return step(radius, length(position - vec2(0.5)));
}

void main(){
    vec2 coord = gl_FragCoord.xy / u_resolution;
    vec3 color = vec3(0.0);
    vec2 translate = vec2(0.5*sin(3.0+u_time*10.0),0.5*cos(9.0+u_time*15.0));
    coord += translate * 0.5;

    color += vec3(circleshape(coord,0.1));

    gl_FragColor = vec4(color,1.0);
}