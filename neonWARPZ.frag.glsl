#ifdef GL_ES
precision mediump float;
#endif

const int AMOUNT = 3;
uniform float u_time;
uniform vec2 u_resolution;
float rectshape(vec2 position, vec2 scale){
    scale = vec2(0.5) - scale * 0.5;
    vec2 shaper = vec2(step(scale.x, position.x), step(scale.y, position.y));
    shaper *= vec2(step(scale.x, 1.0 - position.x), step(scale.y, 1.0 - position.y));
    return shaper.x * shaper.y;
}
void main(){
    vec2 coord = 0.5*gl_FragCoord.xy / u_resolution*2.0 +vec2(5.25);
    float color = 0.0;
    coord.x *= atan(20.0*coord.y,coord.x);
    coord.y += 0.5*sin(3.0*coord.x);
    for(int i = 1; i < AMOUNT; i++){
    color -= 00.5*cos(coord.x*5.0*float(i))+0.02*sin(u_time+coord.y*1.0+cos(coord.y*4.00))+u_time/90.0;
    color -= 0.25*sin(coord.y*3.0*float(i))+0.2*cos(u_time+coord.x*2.0+sin(coord.y*4.00))-u_time/300.0;
    color -= 0.1*sin(coord.y*2.0*float(i))+0.5*sin(u_time+coord.x*3.0+sin(coord.y*7.00))+u_time/50.0;
    }
    color *= 1.-rectshape(vec2(coord.x,0.5),vec2(0.1));
    gl_FragColor = tan(vec4(vec3(color*1.0,sin(color)-0.3,cos(3.0*color)),1.0)*color);
}