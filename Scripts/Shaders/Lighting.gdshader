shader_type canvas_item;

uniform sampler2D palette : filter_nearest;
uniform bool use_palette = false;
uniform sampler2D dithering_noise : filter_nearest, repeat_enable;
uniform float dithering_strength : hint_range(0.0, 1.0, 0.01);
uniform bool dithering = false;
uniform int dithering_size : hint_range(1, 16) = 2;
uniform int pixel_size : hint_range(1, 64) = 2;

uniform float brightness : hint_range(0.0,8.0) = 1.0;
uniform float contrast : hint_range(0.0,8.0) = 1.0;
uniform float saturation : hint_range(0.0,8.0) = 1.0;

float color_distance(vec3 a, vec3 b) {
	vec3 norm = vec3(0.6, 0.2, 0.11);
	vec3 diff = (a - b);
	return dot(diff, diff * norm);
}

varying float x_scale;
varying float y_scale;

void vertex() {
	x_scale = MODEL_MATRIX[0][0];
	y_scale = MODEL_MATRIX[0][0];
}

void fragment() {
	vec2 desired_tex_size = vec2(textureSize(TEXTURE, 0)) * vec2(x_scale, y_scale) / vec2(float(pixel_size));
	
	vec2 normalized_uv = (floor(UV * desired_tex_size) + vec2(0.5)) / desired_tex_size;
	vec4 color = texture(TEXTURE, normalized_uv);
	
	color.rgb = mix(vec3(0.0), color.rgb, brightness);
    color.rgb = mix(vec3(0.5), color.rgb, contrast);
    color.rgb = mix(vec3(dot(vec3(1.0), color.rgb) * 0.33333), color.rgb, saturation);
	
	if (use_palette) {
		int palette_size = textureSize(palette, 0).x;
		float closest_distance = 9999.0;
		vec3 closest_color = vec3(0.0);

		for (int i = 0; i < palette_size; i++) {
			float u = (float(i) + 0.5) / float(palette_size);
			vec3 palette_color = texture(palette, vec2(u, 0.0)).rgb;
			float dist = color_distance(color.xyz, palette_color);
			if (dist < closest_distance) {
				closest_distance = dist;
				closest_color = palette_color;
			}
		}
		color = vec4(closest_color, color.a);
	}
	
	COLOR = color;
}
