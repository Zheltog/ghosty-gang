shader_type canvas_item;

uniform vec2 center_pixel_pos = vec2(300.0, 540.0);
uniform vec2 center_scr_pixel_pos = vec2(300.0, 540.0);
uniform float min_dist_influence = 1.0;

uniform sampler2D cellur_noise : repeat_enable;
uniform sampler2D vignett_tex;
uniform int pixel_size : hint_range(1, 64) = 2;

uniform float speed : hint_range(0.0, 3.0, 0.01) = 0.5;
uniform float time = 0.0;

uniform float flow_depth : hint_range(0.1, 2.0, 0.01) = 0.6;
uniform float color_shift : hint_range(0.0, 3.0, 0.01) = 1.2;
uniform float swirl : hint_range(-2.0, 2.0, 0.01) = 0.2;
uniform float glow : hint_range(0.0, 3.0, 0.01) = 1.0;
uniform float density : hint_range(0.0, 16.0, 0.01) = 8.8;
uniform float pain_coef : hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float alpha : hint_range(0.0, 1.0) = 0.0;


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
	vec3 highlight_col = vec3(0.25, 0.85, 1.0) * caustic * glow;

	vec3 final_col = mix(base_col, highlight_col, f * 0.6);
	final_col += vec3(0.05, 0.12, 0.25) * length(q);

	float glow_mask = smoothstep(0.35, 0.8, length(warp));
	final_col += vec3(0.9, 0.45, 0.85) * glow_mask * glow * 0.6;

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

void fragment() {
	const vec2 RES = vec2(1920, 1080.0);
	vec2 desired_tex_size = RES / vec2(float(pixel_size));

	vec2 normalized_uv = (floor(UV * desired_tex_size) + vec2(0.5)) / desired_tex_size;
	vec2 resolution = RES;
	vec2 uv = (normalized_uv * RES - center_pixel_pos) / resolution.y;
	
	vec3 col = compute_deep_flow(uv, 1.0 / RES);
	
	float vignette = texture(vignett_tex, normalized_uv).a;
	
	float in_countur = clamp(step(0.55, col.r) - step(0.6, col.r), 0.0, 1.0) * 1.5;
	
	vec2 diff = UV * RES - FRAGCOORD.xy;
	vec2 center_screen_pos = center_pixel_pos - diff;
	
	float diff_intensity = length(center_pixel_pos - center_screen_pos) / 80.0;
	
	float epicenter = cicrleSDF(center_screen_pos, 40.0, FRAGCOORD.xy);
	float nail = cicrleSDF(center_pixel_pos, 40.0, FRAGCOORD.xy);
	float line = lineSDF(center_pixel_pos, center_screen_pos, FRAGCOORD.xy, 10.0);
	
	float diff_shape = smoothstep(0.0, 50.0, 3.0 - smin(smin(epicenter, nail, 50.0), line, 50.0));
	
	float pain = (col.b + in_countur + diff_shape * diff_intensity) * (pain_coef + diff_intensity * 0.05);
	
	COLOR = vec4(pain, 0.0, 0.0, vignette * alpha) + vec4(pain, 0.0, 0.0, pain * alpha) * 0.2;
}
