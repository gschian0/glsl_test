#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;
const float PI = 3.14159265359;

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
    vec2 coord = abs(2.0*gl_FragCoord.xy / u_resolution/ 0.5-vec2(2.));
    vec3 color = vec3(0.1765, 0.6863, 0.1294);
    vec3 color2 = vec3(0.1294, 0.6863, 0.298);
    for(int i = 0; i < 9; i++){
   // coord = scale(vec2(abs(sin(u_time)) + 0.5)) * cos(coord + 0.5-sin(u_time)-cos(u_time));
    coord -= vec2(0.5);
   // coord = rotate(-u_time*PI*2.0*00.01) * coord;
    coord += vec2(0.5);
    color += vec3(rectshape(coord,vec2(0.7,0.7)));
    coord *= abs(fract(1.0*coord));
    coord *= length(-0.5*2.0) ;
    color += color * 1.0 - mod(sin(coord.x*coord.y-u_time),0.5);
    color *= abs(color * 1.0-color2);
}
    
    gl_FragColor = vec4(color-0.5,1.0)-0.5;
}