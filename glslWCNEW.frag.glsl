#ifdef GL_ES
precision mediump float;
#endif
uniform vec2 u_resolution;
uniform float u_time;

#define PI 3.14159265358979323846

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

void main(){
    // *12 for original setting
    
    vec2 coord = 12.0 * gl_FragCoord.xy / u_resolution;
    //coord = tile(coord,sin(u_time*.01));
    for (int n =1; n < 30; n++){
        float i = float(n);
        coord -= vec2(0.7/i*1.0*sin(i*coord.y + u_time + 0.3*i) + 0.7, 0.4/i*1.0*sin(5.0*coord.x + u_time + 0.3*i)+ 1.6);
        coord -= vec2(0.7/i*cos(i*coord.y + u_time + 0.3*i) + 0.0, 0.4/i*sin(5.0*coord.x + u_time + 0.3*i)+ 1.6);
       // coord = rotate2D(coord,PI*0.25+u_time*.001);
    }


   // coord += vec2(0.7/sin(coord.y + u_time + 0.3) + 0.8, 0.4/sin(coord.x + u_time + 0.3)+ 1.6);
    
    
    
    //vec3 color = vec3(0.5 * sin(coord.x)+0.5, 0.5 * sin(coord.y)+0.5,sin(coord.x + coord.y));
    vec3 color = vec3(0.5 * sin(5.9*coord.x)+0.5, 0.5 * sin(16.0*coord.y)+0.5,sin(coord.x + 10.0*coord.y));
    gl_FragColor = vec4(color,1.0);
}