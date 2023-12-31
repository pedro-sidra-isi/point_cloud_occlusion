#shader vertex
#version 400 core

// Calculate lights etc. on Vertex Shader

layout( location = 0 ) in vec3 vPosition;
layout( location = 1 ) in vec3 vNormal;
layout( location = 2 ) in uint vMaterialIdx;

// Model-View-Proj
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Lights
struct Light {
    vec3 position;
    vec3 color;
    float strength;
};
uniform Light light;

// Vertex color
varying vec3 vertColor;
varying vec3 v_pos;
varying vec3 normal;
flat out uint materialIdx;
flat out Light light_transformed;

void main()
{
    vec4 v_pos4 = view * model * vec4(vPosition,1.0);
    v_pos = vec3(v_pos4);

    normal = normalize( transpose(inverse(mat3(view * model))) * vec3(vNormal) );

    gl_Position =  projection * v_pos4;
        light_transformed = light;
        light_transformed.position  = vec3(vec4(light.position,1.0));
}

// Fragment shader doesn't do much since Gourad shading
#shader fragment
#version 400 core

struct Material {
  vec3 ambient; 
  vec3 diffuse;
  vec3 specular;
  float shine;
};
uniform Material materials[5];

varying vec3 vertColor;
varying vec3 v_pos;
varying vec3 normal;
flat in uint materialIdx;
// Lights
struct Light {
    vec3 position;
    vec3 color;
    float strength;
};
flat in Light light_transformed;


out vec4 fColor;

void main()
{
    // fColor = vec4(vertColor, 1.0);

    vec3 v_to_light = normalize(light_transformed.position - v_pos);

    vec3 v_to_eye = normalize(0-v_pos);
    vec3 v_reflection = normalize(-reflect(v_to_light,normal));

    vec3 ambient_color = materials[materialIdx].ambient;
    vec3 diffuse_color = materials[materialIdx].diffuse;
    vec3 specular_color = materials[materialIdx].specular;
    float shine = materials[materialIdx].shine;

    vec3 ambient_light = ambient_color;
    vec3 diffuse_light = max(dot(normal, v_to_light), 0.0) * diffuse_color * light_transformed.color * light_transformed.strength;
    vec3 specular_light = pow(max(dot(v_reflection, v_to_eye), 0.0), shine) * specular_color * light_transformed.color * light_transformed.strength;

    fColor = vec4(ambient_light + diffuse_light + specular_light, 1.0);

}
