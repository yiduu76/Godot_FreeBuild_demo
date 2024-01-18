shader_type canvas_item;
uniform float white_scale:hint_range(0.0,1.0);
void fragment(){
vec4 color =texture(TEXTURE,UV);
COLOR = mix (color,vec4(1,1,1,1),white_scale);
COLOR.a = color.a;
}