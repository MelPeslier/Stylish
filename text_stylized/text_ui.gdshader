shader_type canvas_item;

uniform float percentage_visible;

uniform sampler2D color_ramp : hint_default_black;
uniform bool vertical = true;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec4 tex_color = texture(color_ramp, UV);
	
	tex.rgb = tex_color.rgb;
	
	COLOR = tex;
}
