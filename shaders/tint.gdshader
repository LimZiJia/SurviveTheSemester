shader_type canvas_item;
uniform vec3 tint;


void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = (COLOR.rgb + tint.rgb) / 2.0;
}
