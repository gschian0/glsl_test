#ifdef GL_ES
precision mediump float;
#endif

const int AMOUNT = 5;
uniform float u_time;
uniform vec2 u_resolution;
float rectshape(vec2 position, vec2 scale){
    scale = vec2(0.5) - scale * 0.5;
    vec2 shaper = vec2(step(scale.x, position.x), step(scale.y, position.y));
    shaper *= vec2(step(scale.x, 1.0 - position.x), step(scale.y, 1.0 - position.y));
    return shaper.x * shaper.y;
}
void main(){
    vec2 coord = gl_FragCoord.xy / u_resolution/32.0 *2.0 +vec2(5.25);
    float color = 0.0;
    for(int i = 1; i < AMOUNT; i++){
    color += cos(coord.x*50.0*float(i))+sin(u_time+coord.y*1.0+cos(coord.y*40.00))+u_time/90.0;
    color += sin(coord.y*30.0*float(i))+cos(u_time+coord.x*2.0+sin(coord.y*40.00))-u_time/300.0;
    color += sin(coord.y*20.0*float(i))+sin(u_time+coord.x*3.0+sin(coord.y*70.00))+u_time/50.0;
    }
    color += rectshape(coord,vec2(0.5));
    gl_FragColor = tan(vec4(vec3(color*1.0,sin(color)-0.3,cos(3.0*color)),1.0)*color);
}