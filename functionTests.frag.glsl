#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time; 

const float PI = 3.14159265359;

float rectshape(vec2 position,vec2 scale){
    scale = vec2(0.5) - scale * 0.5;
    vec2 shaper = vec2(step(scale.x,position.x),step(scale.y,position.y));
    shaper *= vec2 (step(scale.x,1.0-position.x), step(scale.y,1.0-position.y));
    return shaper.x * shaper.y;
}

// Plot a line on Y using a value between 0.0-1.0
float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

mat2 rotate(float angle){
    return mat2(cos(angle),-sin(angle), sin(angle),cos(angle));
}

void main(){
   vec2 coords = fract(2.0*(gl_FragCoord.xy - u_resolution / 2.0) / min(u_resolution.y, u_resolution.x)+vec2(sin(u_time),cos(u_time)));
   vec3 color = vec3(0.0);
   
   
    coords -= vec2(0.5);
    coords = rotate(-u_time*.2) * coords;
    coords += vec2(0.5);

    float rect = 1.0-rectshape(vec2(coords)-vec2(0.0,0.0),vec2(0.2,0.2));
    float rect2 = rectshape(vec2(coords)-vec2(0.0,0.0),vec2(0.2,0.2));
    vec3 col = vec3(0.0,1.0,0.0);
    vec3 col2 = vec3(0.4078, 0.098, 0.3412);
    vec3 swang = fract(abs(1.0-20.0*mix(col,col2,sin(2.0*coords.x+u_time*.2))));
    gl_FragColor = vec4(vec3(rect)*abs(2.0*coords.xyy-abs(sin(u_time*.02*2.0*PI)*2.0))+rect2 *swang, 1.0);
}




