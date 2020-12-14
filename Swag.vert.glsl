#ifdef GL_ES
precision mediump float;
#endif

uniform mat4 u_modelViewProjectionMatrix;
uniform mat4 u_modelViewMatrix;
uniform mat4 projectionwMatrix;
uniform vec3 u_camera;

attribute vec4 a_position;
varying vec4 v_position;

#ifdef MODEL_VERTEX_COLOR
attribute vec4 a_color;
varying vec4 v_color;
#endif

#ifdef MODEL_VERTEX_NORMAL
attribute vec3 a_normal;
varying vec3 v_normal;
#endif

#ifdef MODEL_VERTEX_TEXCOORD
attribute vec2 a_texcoord;
varying vec2 v_texcoord;
#endif

const float pi = 3.141592653589;

void main() {	
    v_position = a_position;

    #ifdef MODEL_VERTEX_COLOR
    v_color = a_color;
    #endif

    #ifdef MODEL_VERTEX_NORMAL
    v_normal = a_normal;
    #endif

    #ifdef MODEL_VERTEX_TEXCOORD
    v_texcoord = a_texcoord;
    #endif

    gl_Position = u_modelViewProjectionMatrix * v_position;
  //gl_Position = projectionMatrix * u_modelViewMatrix * vec4( position, 1.0 );
}