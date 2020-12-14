#ifdef GL_ES
precision mediump float;
#endif

uniform float u_time;
uniform vec2 u_resolution;

void main(){
    vec2 coord = gl_FragCoord.xy / u_resolution-0.5;
    vec3 color = vec3(1.0);
    float size = 12.0;
    float alpha = cos(floor(coord.x*coord.y*size*size)-(u_time * 4.0)+1.0 / 2.0)
                + sin(floor(coord.y*coord.y*size*size)-(u_time * 8.0)+1.0 / 2.0);
    alpha = alpha*alpha;
    gl_FragColor = vec4(1.0,alpha,1.0,alpha);
}