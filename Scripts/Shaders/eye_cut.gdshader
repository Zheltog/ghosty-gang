shader_type canvas_item;

uniform vec2 eye_center = vec2(300.0, 540.0);
uniform vec2 needle_center = vec2(300.0, 540.0);
uniform vec2 eye_mouse_offset = vec2(0.0);
uniform float camera_dist = 10.0;

uniform float eye_point_rad = 30.0;
uniform float eye_line_width = 20.0;

uniform sampler2D cellur_noise : repeat_enable;
uniform int pixel_size : hint_range(1, 64) = 2;

// Left-side mask. The edge is a parabola through highest_side_point and
// center_line_point, mirrored around the center-line point. smooth_coeff is
// the width of the fade from covered to clear, in screen pixels.
uniform float smooth_coeff : hint_range(0.0, 400.0) = 120.0;
uniform vec2 highest_side_point = vec2(744.0, 0.0);
uniform vec2 center_line_point = vec2(833.0, 540.0);

uniform float time = 0.0;

uniform float flow_depth : hint_range(0.1, 2.0, 0.01) = 0.6;
uniform float color_shift : hint_range(0.0, 3.0, 0.01) = 1.2;
uniform float swirl : hint_range(-2.0, 2.0, 0.01) = 0.2;
uniform float density : hint_range(0.0, 16.0, 0.01) = 8.8;
uniform float pain_coef : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float alpha : hint_range(0.0, 1.0) = 0.0;
uniform bool show_line = true;
uniform float full_red_alpha : hint_range(0.0, 1.0) = 0.0;

const float TWO_PI = 6.28318530718;

float distanceToSegment(vec2 P, vec2 A, vec2 B) {
    vec2 AB = B - A;
    vec2 AP = P - A;
    
    float t = dot(AP, AB) / dot(AB, AB);
    
    t = clamp(t, 0.0, 1.0);
    
    vec2 closestPoint = A + t * AB;
  
    return length(P - closestPoint);
}

vec2 rot2d(vec2 p, float angle) {
	float c = cos(angle);
	float s = sin(angle);
	return vec2(c * p.x + s * p.y, -s * p.x + c * p.y);
}


float fbm(vec2 p) {
	float val = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 5; i++) {
		val += amp * texture(cellur_noise, p * 0.05).r;
		p = rot2d(p, 0.5) * 2.02;
		amp *= 0.5;
	}
	return val;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
	return a + b * cos(TWO_PI * (c * t + d));
}

vec3 compute_deep_flow(vec2 uv, vec2 screen_px_size) {
	vec2 p = uv * (2.2 / max(0.1, flow_depth));

	float radius = length(p);
	float swirl_angle = sin(radius * 2.5 - time * 0.4) * swirl;
	p = rot2d(p, swirl_angle);

	vec2 q = vec2(0.0);
	q.x = fbm(p + vec2(0.0, 0.0) + time * 0.15);
	q.y = fbm(p + vec2(5.2, 1.3) + time * 0.12);

	vec2 warp = vec2(0.0);
	warp.x = fbm(p + 4.0 * q + vec2(1.7, 9.2) + time * 0.18);
	warp.y = fbm(p + 4.0 * q + vec2(8.3, 2.8) + time * 0.14);

	float f = fbm(p + 4.0 * warp * density);

	vec3 color_a = vec3(0.1, 0.15, 0.35);
	vec3 color_b = vec3(0.5, 0.4, 0.5);
	vec3 color_c = vec3(1.0, 1.0, 1.0);
	vec3 color_d = vec3(0.0, 0.33, 0.67) + color_shift * 0.25;

	float color_t = f + radius * 0.15 + time * 0.05 * color_shift;
	vec3 base_col = palette(color_t, color_a, color_b, color_c, color_d);

	float caustic = pow(clamp(f * 1.3, 0.0, 1.0), 3.0);
	vec3 highlight_col = vec3(0.25, 0.85, 1.0) * caustic;

	vec3 final_col = mix(base_col, highlight_col, f * 0.6);
	final_col += vec3(0.05, 0.12, 0.25) * length(q);

	return base_col;
}

float cicrleSDF(vec2 center, float r, vec2 pos) {
	return length(center - pos) - r;
}

float smin( float a, float b, float k )
{
    k *= 1.0;
    float r = exp2(-a/k) + exp2(-b/k);
    return -k*log2(r);
}

float lineSDF(vec2 a, vec2 b, vec2 p, float r) {
	return distanceToSegment(p,a,b) - r;
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
	vec2 screen_uv = SCREEN_UV;
	vec2 frag_px = screen_uv * RES;

	vec2 eye = eye_center - eye_mouse_offset * camera_dist;

	float epicenter = cicrleSDF(eye, eye_point_rad, frag_px);
	float nail = cicrleSDF(needle_center, eye_point_rad, frag_px);
	float line = lineSDF(needle_center, eye, frag_px, eye_line_width);

	vec2 middle = mix(eye, needle_center, 0.5);

	vec2 normalized_uv = (floor(screen_uv * desired_tex_size) + vec2(0.5)) / desired_tex_size;
	vec2 pixel_px = normalized_uv * RES;

	vec2 uv = (pixel_px - middle) / RES.y;

	vec3 col = compute_deep_flow(uv, 1.0 / RES);

	float vignette = left_paraboloid(pixel_px);
	float in_countur = clamp(step(0.55, col.r) - step(0.6, col.r), 0.0, 1.0) * 1.5;

	float diff_intensity = length(needle_center - eye) / 80.0;
	float connector = show_line ? line : 1.0e4;
	float diff_shape = smoothstep(0.0, 50.0, 3.0 - smin(smin(epicenter, nail, 50.0), connector, 50.0));
	float pain = (col.b + in_countur + diff_shape * diff_intensity) * (pain_coef + diff_intensity * 0.05);

	vec4 base = vec4(pain, 0.0, 0.0, vignette * alpha) + vec4(pain, 0.0, 0.0, pain * alpha) * 0.2;
	COLOR = mix(base, vec4(1.0, 0.0, 0.0, 1.0), clamp(full_red_alpha, 0.0, 1.0));
}
