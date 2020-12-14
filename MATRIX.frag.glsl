// The Matrix explained! - by Martijn Steinrucken aka BigWings 2020
// Email:countfrolic@gmail.com Twitter:@The_ArtOfCode
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//
// This shader can be used to follow along with my YouTube
// tutorial on matrix transformations which you can find here:
// https://youtu.be/GvK7REhWGgQ

vec3 Grid(vec2 uv) {
    vec3 col = vec3(0);
    if(abs(uv.x)<fwidth(uv.x)) col.g = 1.;
	if(abs(uv.y)<fwidth(uv.y)) col.r = 1.;
    vec2 grid = 1.-abs(fract(uv)-.5)*2.;
    grid = smoothstep(fwidth(grid), vec2(0), grid);
    col += (grid.x+grid.y)*.5;
    return col*.5;
}

float Point(vec2 uv, vec2 p) {
    return smoothstep(.08,.06, length(uv-p));
}

float Line(in vec2 p, in vec2 a, in vec2 b, float w) {
    vec2 pa = p - a, ba = b - a;
	float h = clamp(dot(pa,ba) / dot(ba,ba), 0., 1.);	
	float d = length(pa - ba * h);
    return smoothstep(w, w-fwidth(d), d);
}

float Arrow(vec2 p, vec2 a, vec2 b, float w) {
	float m = Line(p, a, b, w);
    
    vec2 n = normalize(a-b)*.1;
    vec2 c = b + n;
    vec2 d = n*.5;
    d = vec2(-d.y, d.x);
    
    m = max(m, Line(p, b, c+d, w));
    m = max(m, Line(p, b, c-d, w));
    
    return m;
}

vec3 Smiley(vec2 uv) {
    return texture(iChannel0, .25*uv*vec2(1, iResolution.x/iResolution.y)+.5).rgb;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = 6.*(fragCoord-.5*iResolution.xy)/iResolution.y;

    vec3 p	= vec3(1,1,1);	// point to transform
    
    vec2 ori= vec2(0,0);	// origin
    
    float a = iTime, s = sin(a), c=cos(a);
    
    vec2 x	= vec2(c,-s);	// basis 1
    vec2 y	= vec2(s,c);	// basis 2
    
    mat3 rot = mat3(
    		x,0,
    		y,0,
        	ori,1
    );   
    p = rot * p;
   
    mat3 offs = mat3(
    			1,0,0,
        		0,1,0,
        		2,-1,1
    );
    
    mat3 shear = mat3(
    			.7,.7,0,
        		0,1,0,
        		0,0,1
    );
   
    
    //basic stretching
    // p = p.x*x + p.y * y;
   
	//uv.x += .5*sin(uv.x*uv.y + .2*sin(6.0*uv.x/uv.y));
    vec3 col = Grid(uv);
    
    if(false) {
    	col = mix(col, vec3(1,0,0), Arrow(uv, ori, x+ori, .04));
    	col = mix(col, vec3(0,1,0), Arrow(uv, ori, y+ori, .04));  
   		col = mix(col, vec3(1,0,1), Point(uv, p.xy));
    } else {
       // uv.x += .5*sin(2.0*uv.y+iTime);
        uv = (inverse(rot)*inverse(shear)*vec3(uv,1)).xy;
        //uv = (inverse(offs)*inverse(rot)*vec3(uv,1)).xy;
    	col = mix(col, vec3(1,0,0), Arrow(uv, vec2(0), vec2(1,0), .04));  
    	col = mix(col, vec3(0,1,0), Arrow(uv, vec2(0), vec2(0,1), .04));  
    	col = mix(col, vec3(1,0,1), Point(uv, p.xy));
    	col += Smiley(uv);
    }
    
    fragColor = vec4(col,1.0);
}