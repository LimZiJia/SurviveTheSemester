shader_type canvas_item;

uniform float lerp_percent: hint_range(0.0, 1.0);

vec3 make_gray(vec3 rgb) {
	vec3 gray_weights = vec3(0.299, 0.587, 0.114);
	return vec3(1.0) * dot(rgb, gray_weights);
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	vec2 pos = 2.0 * UV - vec2(1);
	float angle = atan(-pos.x, pos.y);
	float pixel_percent = (angle + PI) / (2.0 * PI);
	if (pixel_percent < lerp_percent) {
		COLOR = pixel_color;
	} else {
		COLOR.rgb = make_gray(pixel_color.rgb);
	}
}