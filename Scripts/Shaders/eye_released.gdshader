shader_type canvas_item;

uniform vec2 eye_center = vec2(960.0, 540.0);
uniform float eye_point_rad = 20.0;
uniform float pulse_amount = 0.35;
uniform float pulse = 0.0;

uniform int pixel_size : hint_range(1, 64) = 2;

uniform float smooth_coeff : hint_range(0.0, 400.0) = 120.0;
uniform vec2 highest_side_point = vec2(744.0, 0.0);
uniform vec2 center_line_point = vec2(833.0, 540.0);

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float full_red_alpha : hint_range(0.0, 1.0) = 0.0;

float cicrleSDF(vec2 center, float r, vec2 pos) {
	return length(center - pos) - r;
}

float left_paraboloid(vec2 px) {
	float span = highest_side_point.y - center_line_point.y;
	float t = span == 0.0 ? 0.0 : (px.y - center_line_point.y) / span;
	float edge_x = mix(center_line_point.x, highest_side_point.x, t * t);
	float half_w = max(smooth_coeff, 0.0001) * 0.5;
	return 1.0 - smoothstep(edge_x - half_w, edge_x + half_w, px.x);
}

void fragment() {
	const vec2 RES = vec2(1920.0, 1080.0);
	vec2 desired_tex_size = RES / vec2(float(pixel_size));
	vec2 uv = UV;
	vec2 frag_px = uv * RES;
	vec2 normalized_uv = (floor(uv * desired_tex_size) + vec2(0.5)) / desired_tex_size;
	vec2 pixel_px = normalized_uv * RES;

	float rad = eye_point_rad * (1.0 + pulse_amount * sin(pulse));
	float epicenter = cicrleSDF(eye_center, rad, frag_px);
	float diff_shape = smoothstep(0.0, 50.0, rad - epicenter);
	float vignette = left_paraboloid(pixel_px);

	vec4 base = vec4(diff_shape * 0.4, 0.0, 0.0, vignette * alpha);
	COLOR = mix(base, vec4(1.0, 0.0, 0.0, 1.0), clamp(full_red_alpha, 0.0, 1.0));
}
