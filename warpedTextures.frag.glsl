#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform sampler2D gTex;
uniform sampler2D gTex2;

// Reference to
// http://thndl.com/square-shaped-shaders.html

void main(){

	vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    
    uv = uv*2.;
    uv = uv-1.;
    uv = abs(uv); 
    
    uv = uv-.3;
    
    float angle = atan(uv.y*2.,uv.x*2.0);
    float dist = length(uv);
    
    dist = dist+dist*sin(dist*20.+u_time)*.5;
    
    uv.y = sin(angle+u_time*.5)*dist;
    uv.x = cos(angle+u_time*.1)*dist;
	
    uv = uv+.5;
    
    vec4 color = texture2D(gTex, abs(uv));
    color += texture2D(gTex2, uv);
                           
    //color += sin(color*10.+dist)*500.;
    
    
    color.rgb = sin((color.rgb+vec3(0.11,.88,.11))*6.28+u_time);
   
    
   	color = mix(color,color,uv.x);
    
    uv.xy = uv.xy+color.rg*.1-.1;
  gl_FragColor = vec4(color);
}
