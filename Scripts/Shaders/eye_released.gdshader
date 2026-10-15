shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture;

uniform vec2 eye_center = vec2(960.0, 540.0);
uniform float eye_point_rad = 20.0;

uniform int pixel_size : hint_range(1, 64) = 2;

uniform float smooth_coeff : hint_range(0.0, 400.0) = 120.0;
uniform vec2 highest_side_point = vec2(744.0, 0.0);
uniform vec2 center_line_point = vec2(833.0, 540.0);

uniform float alpha : hint_range(0.0, 1.0) = 1.0;
uniform float full_red_alpha : hint_range(0.0, 1.0) = 0.0;

// 0 = fully open, 1 = closed. The lid travels from the top of the eye to the bottom.
uniform float blink : hint_range(0.0, 1.0, 0.001) = 0.0;

uniform vec2 abberation_vec = vec2(0.0,0.0);

const vec3 GHOST_PURPLE = vec3(0.67, 0.16, 0.90);

float cicrleSDF(vec2 center, float r, vec2 pos) {
	return length(center - pos) - r;
}

// Drawn eye radius is 2 * radius: the shape is smoothstep(0, 50, 2 * radius - length).
float eye_open_from_top(vec2 local, float radius, float closed) {
	float reach = max(radius * 2.0, 1.0);
	float feather = max(reach * 0.15, 2.0);
	float lid = mix(-reach - feather, reach + feather, closed);
	return smoothstep(lid, lid + feather, local.y);
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

	float rad = eye_point_rad;
	float epicenter = cicrleSDF(eye_center, rad, frag_px);
	float diff_shape = smoothstep(0.0, 50.0, rad - epicenter);
	float closed = clamp(blink, 0.0, 1.0);
	diff_shape *= eye_open_from_top(frag_px - eye_center, rad, closed);
	float vignette = left_paraboloid(pixel_px);

	vec4 output = texture(screen_tex, SCREEN_UV);
	
	output.r = texture(screen_tex, SCREEN_UV + abberation_vec * SCREEN_PIXEL_SIZE).r;
	output.g = texture(screen_tex, SCREEN_UV).g;
	output.b = texture(screen_tex, SCREEN_UV + abberation_vec * SCREEN_PIXEL_SIZE).b;

	vec3 rgb = mix(output.rgb, GHOST_PURPLE, diff_shape);
	vec4 base = vec4(mix(rgb, vec3(0.0), 0.5), vignette * alpha);
	COLOR = mix(base, vec4(1.0, 0.0, 0.0, 1.0), clamp(full_red_alpha, 0.0, 1.0));
}
