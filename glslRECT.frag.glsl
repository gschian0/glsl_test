#ifdef GL_ES 
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

const int AMOUNT = 3;

float rectshape(vec2 position,vec2 scale){
    scale = vec2(0.5) - scale * 0.5;
    vec2 shaper = vec2(step(scale.x,position.x),step(scale.y,position.y));
    shaper *= vec2 (step(scale.x,1.0-position.x), step(scale.y,1.0-position.y));
    return shaper.x * shaper.y;
}

// mat3 rot(float theta){
//     mat3 (1,0,0,
//     );
// }

mat2 rotate(float angle){
    return mat2(cos(angle),-sin(angle), sin(angle),cos(angle));
}

void main() {
    // float a = u_time;
    // float s = sin(a);
    // float c = cos(a);
    // vec2 ori = vec2(0,0);
    // vec2 x = vec2(c,-s);
    // vec2 y = vec2(s,c);
    //  mat3 rot = mat3(
    //      x,0,
    //      y,0,
    //      ori,1);
    
    vec2 coord = 5.0 * (gl_FragCoord.xy - u_resolution / 2.0) / min(u_resolution.y, u_resolution.x)+.5;
  // coord += rotate(u_time)*coord*.5;
    vec2 position = gl_FragCoord.xy / u_resolution;
    float len;
    
    for (int i = 0; i < AMOUNT; i++){
        len = length(vec2(sin(5.0*coord.x),sin(3.0*coord.y)));
        coord.x = coord.x + cos(coord.y + sin(1.0*len)) + cos(u_time / 12.0)+0.5*0.5;
		coord.y = coord.y + sin(coord.x + cos(2.0*len)) + sin(u_time / 7.0);
    }
    position.x = sin(coord.x);
    position.y = sin(coord.x);
    float rectangle;
    coord = rotate(u_time) * coord.yx;
    for ( float i = -0.5; i < 1.0; i += 0.08){
        rectangle += rectshape(vec2(abs(sin(2.8*position.y+u_time)),abs(sin(position.x+u_time)))+vec2(i/2.,i),vec2(0.8,0.05));
    }


    //coord = rotate(u_time) * coord;
    vec3 color = vec3(rectangle*coord.xyx);

    gl_FragColor = vec4(cos(len * 2.0)*color.r, cos(len * 3.0)*color.g, cos(len * 3.0)*color.b, 1.0);



}