#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform float u_time;

const int AMOUNT = 9 ;

void main(){
    vec2 coord =5.0 * (gl_FragCoord.xy - u_resolution / 2.0)/ min(u_resolution.y,u_resolution.x);

    float len;

    for(int i = 0; i < AMOUNT;i++){
    
        len = length(vec2(coord.x,coord.y));

        coord.x = coord.x +sin(coord.y*coord.y + cos(len)) * sin(u_time / 2.0);
        coord.y = fract(coord.y*coord.y + cos(coord.x*coord.x + sin(len)) * cos(u_time / 2.0));
    }

    //gl_FragColor = vec4(cos(len*2.0),cos(len),cos(len),1.0);
    gl_FragColor = vec4(cos(len*sin(2.0+u_time)),sin(len*3.0-u_time*1.0),cos(len*1.39*sin(u_time*1.0)),0.9);
}
