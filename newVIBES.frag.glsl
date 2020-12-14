#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
const float PI = 3.1415926535;

float polygonshape(vec2 position, float radius, float sides){
    position = position * 2.0 - 1.0;
    float angle = atan(position.x,position.y);
    float slice = PI * 2.0 / sides;

    return step(radius, cos(floor(0.5+angle /slice) * slice - angle) * length(position));
    //return step(radius, cos(floor(angle /slice) * slice - angle) * length(position));
}
mat2 rotate(float angle){
    return mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
}
mat2 scale(vec2 scale){
    return mat2(scale.x, 0.0, 0.0, scale.y);
}
void main(){
    vec2 coord = 11.0*gl_FragCoord.xy/u_resolution;
    vec3 color = vec3(0.0);
   for(float i = 0.0; i <1.5; i += 1.0){
    coord.x += sin(2.1*coord.y+u_time/22.0-i)- cos(1.2*coord.y-u_time+i/4.0);
    coord.y += sin(2.3*coord.x+u_time/25.0-i)+ cos(2.2*coord.x-u_time-i/5.0);
    coord.y += cos(2.5*coord.x-u_time/20.0+i);
    coord.x += ceil(sin(1.0*coord.y-u_time/3.0+i/2.0)-cos(u_time/coord.y*0.002*i));
    coord.y *= sin(coord.x*4.0*i);
   }
    color.r += floor(coord.x*coord.x);
    color.g += sin(coord.y);
    coord.y += floor(cos(coord.y*coord.y+u_time/2.0));
    color.r *= floor(50.0*sin(10.0*coord.x-u_time/2.0)-cos(11.0*coord.y+u_time));
    color.b *= floor(pow(coord.y,2.0));
    for (float j = 0.0; j < 1.0; j++){
    scale(vec2(0.9));
    float polygon = polygonshape(gl_FragCoord.xy/u_resolution,0.9, 9.0);
    
    color -= vec3(polygon)/ vec3(color)*2.0;
    }
    gl_FragColor = vec4(color, 1.0);
}