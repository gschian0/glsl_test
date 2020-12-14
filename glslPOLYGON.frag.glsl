#ifdef GL_ES
precision mediump float;
#endif

const float PI = 3.1415926535;

uniform vec2 u_resolution;

float polygonshape(vec2 position, float radius, float sides){
    position = position * 2.0 - 1.0;
    float angle = atan(position.x,position.y);
    float slice = PI * 2.0 / sides;

    return step(radius, cos(floor(0.5+angle /slice) * slice - angle) * length(position));
    //return step(radius, cos(floor(angle /slice) * slice - angle) * length(position));
}



void main(){
    vec2 position = gl_FragCoord.xy / u_resolution;

    vec3 color = vec3(0.0);
    //position.x = .3*sin(position.y);
    float polygon = polygonshape(position+vec2(0,-0.09),0.5, 3.0);
      color = vec3(1)-vec3(polygon)* vec3(1.0, 1.0, 1.0);
      float polygon2 = polygonshape(position+vec2(0,-0.09),0.4,3.0);
      color += vec3(polygon2)* vec3(0.0, 0.0, 0.0);
      float polygon3 = polygonshape(position+vec2(0,-0.07),0.3,3.0);
      color += vec3(0.0, 0.0, 0.0)-vec3(polygon3)* vec3(1.0, 1.0, 1.0);
      float polygon4 = polygonshape(position+vec2(0,-0.07),0.,2.0);
      color += vec3(polygon4)* vec3(0.0078, 0.0078, 0.0078);
      //color += vec3(polygon3+vec3(0.5))* vec3(1.0, 0.0, 0.0);
     // color += vec3(polygon3+vec3(0.2))* vec3(0.2, 1.0, 0.0);
       //color += vec3(polygon)* vec3(0.1569, 0.2667, 0.0078);


    gl_FragColor = vec4(color,1.0);
}