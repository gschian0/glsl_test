#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359
#define PI2 6.28318530718

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

uniform sampler2D u_tex0;
uniform sampler2D u_tex1;
uniform sampler2D u_tex2;
uniform sampler2D u_tex3;

float zoom = 0.5;
vec2 offset = vec2(0.5);

vec3 smoothstepr(float center, float width, vec3 value){
    return smoothstep(center-width/2.,center+width/2.,value);
}

mat3 rotationMatrix3(vec3 v, float angle)
{  float c = cos(radians(angle));
    float s = sin(radians(angle));
    return mat3(c + (1.0 - c) * v.x * v.x, (1.0 - c) * v.x * v.y - s * v.z, (1.0 - c) * v.x * v.z + s * v.y,
        (1.0 - c) * v.x * v.y + s * v.z, c + (1.0 - c) * v.y * v.y, (1.0 - c) * v.y * v.z - s * v.x,
        (1.0 - c) * v.x * v.z - s * v.y, (1.0 - c) * v.y * v.z + s * v.x, c + (1.0 - c) * v.z * v.z
        );
}
void rotate(inout vec2 c, float angle){
    mat3 m =rotationMatrix3(vec3(0,0,1),angle);
    c = (m * vec3(c,0)).xy;
}
vec2 rotate2(in vec2 c, float angle){
    mat3 m =rotationMatrix3(vec3(0,0,1),angle);
    return (m * vec3(c,0)).xy;
}

vec3 radius(vec2 c,float r1, float r2, float angle){
    mat3 m =rotationMatrix3(vec3(0,0,1),angle);
    c = (m * vec3(c,0)).xy;
    return vec3( (smoothstep(r1,r1+.01, c.x) - smoothstep(r2,r2+.01,c.x) ) * 
                   (smoothstep(-0.02,-0.01,c.y) - smoothstep(0.01,0.02,c.y) ));
}
void addColor(inout vec3 base, vec3 new, vec3 amt){
    base = mix(base,new,amt);
}
vec3 circle(vec2 c, float r){
    return vec3( smoothstep(0.,.01,length(c)-r+0.02)-smoothstep(0.,.01,length(c)-r-0.02));
}

vec3 circles(vec2 z,float r1,float r2){
    vec3 col = vec3(0);
    addColor(col,vec3(0,1,0),radius(z, r1,r2,0.));
    addColor(col,vec3(0,0,1),radius(z, r1,r2,90.));
    addColor(col,vec3(1,1,0),radius(z, r1,r2,180.));
    addColor(col,vec3(1,0,1),radius(z, r1,r2,270.));
    addColor(col,vec3(1,0.5,0.5),circle(z,r1));
    addColor(col,vec3(1,0.5,0.5),circle(z,r2));
    return col;
}
vec3 filledcircle(vec2 c, float r){
    return vec3( 1.0-smoothstep(0.,.01,length(c)-r-0.02));
}

float cosh(float val)
{
    float tmp = exp(val);
    float cosH = (tmp + 1.0 / tmp) / 2.0;
    return cosH;
}
float tanh(float val)
{
    float tmp = exp(val);
    float tanH = (tmp - 1.0 / tmp) / (tmp + 1.0 / tmp);
    return tanH;
}
float sinh(float val)
{
    float tmp = exp(val);
    float sinH = (tmp - 1.0 / tmp) / 2.0;
    return sinH;
}
vec2 cis(float a){
    return vec2(cos(a),sin(a));
}
vec2 cMul(vec2 a, vec2 b) {
    return vec2( a.x*b.x -  a.y*b.y,a.x*b.y + a.y * b.x);
}
vec2 cPower(vec2 z, float n) {
    float r2 = dot(z,z);
    return pow(r2,n/2.0)*vec2(cos(n*atan(z.y,z.x)),sin(n*atan(z.y,z.x)));
}
vec2 cInverse(vec2 a) {
    return  vec2(a.x,-a.y)/dot(a,a);
}
vec2 cDiv(vec2 a, vec2 b) {
    return cMul( a,cInverse(b));
}
vec2 cExp(in vec2 z){
    return vec2(exp(z.x)*cos(z.y),exp(z.x)*sin(z.y));
}
vec2 cLog(vec2 a) {
    float b =  atan(a.y,a.x);
    if (b>0.0) b-=2.0*3.1415;
    return vec2(log(length(a)),b);
}
vec2 cSqr(vec2 z) {
    return vec2(z.x*z.x-z.y*z.y,2.*z.x*z.y);
}
vec2 cSin(vec2 z) {
    return vec2(sin(z.x)*cosh(z.y), cos(z.x)*sinh(z.y));
}
vec2 cCos(vec2 z) {
    return vec2(cos(z.x)*cosh(z.y), -sin(z.x)*sinh(z.y));
}
vec2 cPower2(vec2 z, vec2 a) {
    return cExp(cMul(cLog(z), a));
}
vec2 cConj(vec2 z) {
    return vec2(z.x,-z.y);
}

vec3 hash3( vec2 p ){
    vec3 q = vec3( dot(p,vec2(127.1,311.7)), 
                   dot(p,vec2(269.5,183.3)), 
                   dot(p,vec2(419.2,371.9)) );
    return fract(sin(q)*43758.5453);
}

float iqnoise( in vec2 x, float u, float v ){
//https://www.shadertoy.com/view/Xd23Dh
    vec2 p = floor(x);
    vec2 f = fract(x);

    float k = 1.0+63.0*pow(1.0-v,4.0);

    float va = 0.0;
    float wt = 0.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = vec2( float(i),float(j) );
        vec3 o = hash3( p + g )*vec3(u,u,1.0);
        vec2 r = g - f + o.xy;
        float d = dot(r,r);
        float ww = pow( 1.0-smoothstep(0.0,1.414,sqrt(d)), k );
        va += o.z*ww;
        wt += ww;
    }

    return va/wt;
}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float sphere( vec3 p, float radius )
{
    return length( p ) - radius;
}
 
//-----------------------------------------------------------------------------------------------
// The map function is the function that defines our scene.

float map( vec3 p )
{    
    return sphere( p, 1.0 );
}
 
vec3 getNormal( vec3 p )
{
    vec3 e = vec3( 0.001, 0.00, 0.00 );
    
    float deltaX = map( p + e.xyy ) - map( p - e.xyy );
    float deltaY = map( p + e.yxy ) - map( p - e.yxy );
    float deltaZ = map( p + e.yyx ) - map( p - e.yyx );
    
    return normalize( vec3( deltaX, deltaY, deltaZ ) );
}
 
float trace( vec3 origin, vec3 direction, out vec3 p )
{
    float totalDistanceTraveled = 0.0;
 
    for( int i=0; i <170; ++i)
    {
        // Here we march along our ray and store the new point
        // on the ray in the "p" variable.
        p = origin + direction * totalDistanceTraveled;
 
        // "distanceFromPointOnRayToClosestObjectInScene" is the 
        // distance traveled from our current position along 
        // our ray to the closest point on any object
        // in our scene.  Remember that we use "totalDistanceTraveled"
        // to calculate the new point along our ray.  We could just
        // increment the "totalDistanceTraveled" by some fixed amount.
        // However we can improve the performance of our shader by
        // incrementing the "totalDistanceTraveled" by the distance
        // returned by our map function.  This works because our map function
        // simply returns the distance from some arbitrary point "p" to the closest
        // point on any geometric object in our scene.  We know we are probably about 
        // to intersect with an object in the scene if the resulting distance is very small.
        float distanceFromPointOnRayToClosestObjectInScene = map( p );
        totalDistanceTraveled += distanceFromPointOnRayToClosestObjectInScene;
 
        // If our last step was very small, that means we are probably very close to
        // intersecting an object in our scene.  Therefore we can improve our performance
        // by just pretending that we hit the object and exiting early.
        if( distanceFromPointOnRayToClosestObjectInScene < 0.0001 )
        {
            break;
        }

        if( totalDistanceTraveled > 10000.0 )
        {
            totalDistanceTraveled = 0.0000;
            break;
        }
    }
 
    return totalDistanceTraveled;
}

 
// Standard Blinn lighting model.
vec3 calculateLighting(vec3 pointOnSurface, vec3 surfaceNormal, vec3 lightPosition, vec3 cameraPosition, vec3 color)
{
    vec3 fromPointToLight = normalize(lightPosition - pointOnSurface);
    float diffuseStrength = clamp( dot( surfaceNormal, fromPointToLight ), 0.0, 1.0 );
    
    vec3 diffuseColor = diffuseStrength*color;
    vec3 reflectedLightVector = normalize( reflect( -fromPointToLight, surfaceNormal ) );
    
    vec3 fromPointToCamera = normalize( cameraPosition - pointOnSurface );
    float specularStrength = pow( clamp( dot(reflectedLightVector, fromPointToCamera), 0.0, 1.0 ), 10.0 );
 
    // Ensure that there is no specular lighting when there is no diffuse lighting.
    specularStrength = min( diffuseStrength, specularStrength );
    vec3 specularColor = specularStrength * vec3( 1.0 );
    
    vec3 finalColor = diffuseColor;// + specularColor; 
 
    return finalColor;
}

vec2 sphereViewer(vec2 uv, out float distanceToClosestPointInScene){
    
    // We will need to shoot a ray from our camera's position through each pixel.  To do this,
    // we will exploit the uv variable we calculated earlier, which describes the pixel we are
    // currently rendering, and make that our direction vector.
    vec2 mouse_uv = ( u_mouse.xy / u_resolution.xy ) * 2.0 - 1.0;
    vec3 cameraPosition = vec3(0.,-15.*cis(mouse_uv.y*PI/2.));
    vec3 cameraDirection = normalize( vec3( uv.x, uv.y, -10.0) );
    cameraDirection = cameraDirection * rotationMatrix3(vec3(1,0,0),degrees(-atan(cameraPosition.y, cameraPosition.z)));
    vec3 pointOnSurface;
    distanceToClosestPointInScene = trace( cameraPosition, cameraDirection, pointOnSurface );
    vec2 projected = pointOnSurface.xy / (1.-pointOnSurface.z);
    return projected;
}

vec2 droste_(vec2 z,float r1, float r2) {
    z = cLog(z);
    float scale = log(r2/r1);
    float angle = atan(scale/(2.0*PI));
    z = cDiv(z, cExp(vec2(0,angle))*cos(angle)); 
    z.x = mod(z.x,scale);
    z = cExp(z)*r1;
    return z;
}

// ---------
vec3 smoothgear(in vec3 col, vec2 z, float r, float n, float toothHeight){
    float theta = atan(z.y,z.x);
    float R = length(z)-r-toothHeight/5.;
    float val = 0.;
    val = 1.0 - smoothstep(0.,0.01,sin(R)+sin(theta*n)*toothHeight/2.);
    val = val+smoothstepr(R-toothHeight/5.,0.01,vec3(0.)).x-1. ;
    val = clamp(val,0.,1.);
    val = val+smoothstepr(R+toothHeight/5.,0.01,vec3(0.)).x ;
    return vec3(clamp(val,0.,1.));
}
vec3 planetGear(in vec3 col, in vec2 z, float sunRadius, float planetRadius,float planetTeeth,float carrierSpeed, float planetSpeed, float stime, float angle){
    return smoothgear(col,rotate2(rotate2(z,angle+stime*carrierSpeed)-vec2(sunRadius+planetRadius,0),-(stime+angle) * planetSpeed),planetRadius,planetTeeth,0.13);
}
vec3 planetaryLinkage(vec2 z){
    vec3 col = vec3(0);
    float r1 = 0.5;
    float r2 = 1.;
    float secondsPerRotation = 40.;
    float stime = 360. * u_time/secondsPerRotation;
    float sunTeeth = 30.;
    float planetTeeth = 8.;
    float annulusTeeth = 40.;

    float sunToothHeight = 0.1;
    float sunRadius = r1+sunToothHeight;
    float carrierSpeed = 4.;    
    float planetSpeed =  annulusTeeth/planetTeeth * carrierSpeed;
    float sunSpeed = (1.+annulusTeeth/sunTeeth)*carrierSpeed;
    float planetRadius = (r2-sunRadius-0.1)/2.;
    float nPlanets = 10.;

    z = rotate2(z,-stime*1.5);
    vec3 annulusColor = vec3(1.,.1,.1);
    addColor(col,annulusColor,vec3(1)-smoothgear(col,rotate2(z,  0.),sunRadius+planetRadius+sunToothHeight*2.,annulusTeeth,0.1));
    addColor(col,annulusColor,smoothgear(col,rotate2(z,  stime*sunSpeed),sunRadius,sunTeeth,sunToothHeight*1.5));

    for( float x = 0.; x<360.; x += 36.){
        addColor(col,vec3(0.925,0.701,0.),planetGear(col,z,sunRadius+0.061,planetRadius-0.018,planetTeeth,carrierSpeed,planetSpeed,stime,x));
    }
    return col;
}
vec2 mouse_uv(){
        return ( u_mouse.xy / u_resolution.xy ) * 2.0 - 1.0;
}
vec3 phase_portrait(vec2 z){
    return vec3(hsv2rgb(vec3(atan(z.y,z.x)/PI2,1.,1.)));
}
mat2 rot_mat2(float a){
    return mat2(cos(a),-sin(a),sin(a),cos(a));
}

float DE(vec3 p){
	return 0.;
}
vec3 getDENormal( vec3 p )
{
    vec3 e = vec3( 0.001, 0.00, 0.00 );
    
    float deltaX = DE( p + e.xyy ) - DE( p - e.xyy );
    float deltaY = DE( p + e.yxy ) - DE( p - e.yxy );
    float deltaZ = DE( p + e.yyx ) - DE( p - e.yyx );
    
    return normalize( vec3( deltaX, deltaY, deltaZ ) );
}

float tracer( vec3 origin, vec3 direction, out vec3 p )
{
    float totalDistance = 0.0;

    for( int i=0; i<35; ++i)
    {
        // Here we march along our ray and store the new point
        // on the ray in the "p" variable.
        p = origin + direction * totalDistance;
        float dist = DE(p);
        totalDistance += dist;
        if( dist < 0.0001 ) break;
        if( totalDistance > 100000.0 )
        {
            totalDistance = 0.;
            break;
        }
    }
 
    return totalDistance;
}

vec3 lighting2(vec3 pointOnSurface, vec3 surfaceNormal, vec3 lightPosition, vec3 cameraPosition)
{
    vec3 fromPointToLight = normalize(lightPosition - pointOnSurface);
    float diffuseStrength = clamp( dot( surfaceNormal, fromPointToLight ), 0.0, 1.0 );
    
    vec3 diffuseColor = diffuseStrength * vec3( 1.0, 0.0, 0.0 );
    vec3 reflectedLightVector = normalize( reflect( -fromPointToLight, surfaceNormal ) );
    
    vec3 fromPointToCamera = normalize( cameraPosition - pointOnSurface );
    float specularStrength = pow( clamp( dot(reflectedLightVector, fromPointToCamera), 0.0, 1.0 ), 10.0 );
 
    // Ensure that there is no specular lighting when there is no diffuse lighting.
    specularStrength = min( diffuseStrength, specularStrength );
    vec3 specularColor = specularStrength * vec3( 1.0 );
    
    vec3 finalColor = diffuseColor + specularColor; 
 
    return finalColor;
}

vec3 simple_raymarch(vec2 uv){
    vec3 cameraPosition = vec3( 0., 0.0, -2.0 );
    vec3 cameraDirection = normalize( vec3( uv.x, uv.y, 1.0) );
    vec3 pointOnSurface;
    float distanceToClosestPointInScene = tracer( cameraPosition, cameraDirection, pointOnSurface );
    vec3 finalColor = vec3(0.0);
    if( distanceToClosestPointInScene > 0.0 )
    {
        vec3 lightPosition = vec3( 0.0, 0., -40.0 );
        vec3 surfaceNormal = getDENormal( pointOnSurface );
        finalColor = lighting2( pointOnSurface, surfaceNormal, lightPosition, cameraPosition);
    }
    return finalColor;
}

float bird_shape(vec2 z);
float bird(vec2 z){
    float color = bird_shape(z)*smoothstep(-0.001,0.001,-z.x);
    // rot 180
    color -= bird_shape(z*mat2(-1,0,0,-1)+vec2(0,-4))*smoothstep(0.,0.001,z.x);
    z *= mat2(1.,1.,-1.,1.);// rot 45, scale
    z.y += 4.;
    z = vec2(z.x,-z.y);
    color = min(color,bird_shape(z*.5));
    z *= mat2(0.,1.,-1.,0.);
    z += 4.;
    color = min(color,-bird_shape(-z*.5));
    return smoothstep(-0.001,.001,color);;
}
const vec3 light = vec3(0.995,0.964,0.573);
const vec3 mid = vec3(0.995,0.663,0.261);
const vec3 dark = vec3(0.995,0.390,0.314);
vec3 colors(int n,bool cycleDir){
    n = n > 2? n-3: n; // modulo (int x) doesn't exist, so
    if (!cycleDir) n = 2 - n;
    return n == 2? mid: n == 1? dark: light;
}
vec3 three_birds(vec2 z, int t,bool s){
    vec3 color;
    z = z.yx;
    color = bird(z)*colors(t,s);
    color = mix(color,colors(1+t,s),bird(z*mat2(0,-1,1,0)));
    z = (z+vec2(-2.,-2.))*mat2(-.5,.5,.5,.5);
    color = mix(color,colors(2+t,s),bird(z));
    return color;
}
vec2 scale_f(vec2 x){
    return exp2(-floor(log2(x)));
}
vec3 center_tile(vec2 z){
    vec3 color = vec3(0);
    z = z.yx;
    z = z*4.-2.;
    z *= mat2(.5,.5,-.5,.5);

    for (int n=0;n<=1;n++){
        // modulo(int) doesn't seem to exist, two loops
        // seems to be the cleanest way to do this.
        for (int m=0;m<=1;m++){
            color += three_birds(z*2.+2.,m+1,m==1);
            z *= mat2(0,1,-1,0);
        }
    }
    return color;
}
vec3 corner_tile(vec2 z,bool type){
    z = z.yx;
    z = z*4.-2.;
    int t = int(type);
    vec3 color = vec3(0);
    z *= mat2(.5,.5,-.5,.5);
    if ( t == 1 )
        z *= mat2(0,1,-1,0);

    color += three_birds(z*2.+2.,1+t,0+t ==1);
    z *= mat2(0,1,-1,0);
    color += three_birds(z*2.+2.,2-t,1-t ==1);
    z *= mat2(0,1,-1,0) * mat2(1,1,-1,1);
    color = mix(color,colors(0,true),bird(z));
    z *= mat2(0,-1,1,0);
    color = mix(color,colors(2-t,true),bird(z));
    z *= mat2(0,-1,1,0);
    color = mix(color,colors(1+t,true),
                bird(z+vec2(0.,-4.)));
    z *= mat2(0,-1,1,0);
    color = mix(color,colors(2,false),
                bird(z+vec2(0.,-4.)));
    return vec3(color);
}

vec3 side_tiles(vec2 z,int colStart,bool cycleDir){
    z = -z*4. + vec2(6,2);
    vec3 col = three_birds(z,colStart,cycleDir);
    vec3 tile2 = three_birds(z*mat2(0,1,-1,0)+vec2(0,4)
,1+colStart,cycleDir);
    col = max(vec3(0.),col - tile2)+tile2;

    // fill in around the edge
    // Left and right
    col = mix(col, colors(2+colStart,cycleDir),
                   bird(z*mat2(0,-1,-1,0)-vec2(0,4)));
    col = mix(col, colors(  colStart,cycleDir),
                   bird(z*mat2(0,1,1,0)-vec2(0,8)));

    // Big top bird
    col = mix(col,colors(1+colStart,cycleDir),
                  bird((z-2.)*mat2(-.5,0,0,.5)+vec2(0.,-2.)));
    // Small bottom birds.
    z.x = mod(z.x-2.,4.)+2.;
    col = mix(col,colors(colStart,cycleDir),
                  bird((z-2.)*mat2(1,1,-1,1)+vec2(2.,6.)));
    col = mix(col,colors(2+colStart,cycleDir),
                  bird((z+vec2(-2,2))*mat2(1,-1,1,1)-2.));
    return col;
}

vec3 sq_limit(vec2 z){
    if (z.y < 0.) z=-z; z = (z+1.)*.75; 
    vec2 a_z = .75-abs(z-.75), scale = scale_f(a_z);
    if (scale.x == scale.y) {
        if (scale.x == 2.) return center_tile(z*2.-1.);
        else return corner_tile(mod(z*scale,1.),z.x>1.); 
    } else if (scale.x < scale.y){
        // Top and bottom
        return side_tiles(mod(z*scale.y,2.),0,false);
    } else { //scale.x > scale.y
        if (z.x > 1.) z = -z;
        z = vec2(z.y,-z.x); // 90 degree rotation
        return side_tiles(mod(z*scale.x,2.),1,true);
    }
}float bird_shape(vec2 z){
    return 10.*(z.y+sin(u_time*3.)-cos(u_time*3.)*min(0.,abs(z.x+.5)-.5)+2.);
}
vec3 color(vec2 z) {
    return sq_limit(z);
}
void main(){
    vec2 st = (gl_FragCoord.xy/u_resolution.xy)-offset;
    st.x *= u_resolution.x/u_resolution.y;
    st = rotate2(st,20.0*u_time);
    gl_FragColor = vec4(color(st/zoom),1.0);
}