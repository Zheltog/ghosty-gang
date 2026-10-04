shader_type canvas_item;

uniform vec2 mouse_pos;
uniform bool light_on;
uniform float light_dist = 200.0;
// 0 living_room, 1 living_room_to_exit, 2 kitchen, 3 storage, 4 bookcase_1, 5 bookcase_2
// 6 under_bed, 7 gun, 8 passport, 9 eye, 10 kitchen_sitting, 11 kitchen_sitting_table
// 12 living_room_open, 13 living_room_2
uniform sampler2D lighted_textures[14] : source_color, filter_linear, repeat_disable;
instance uniform int lighted_index = 0;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	vec4 lit_color = texture(lighted_textures[lighted_index], UV);
	float shade = light_on ? clamp(distance(VERTEX, mouse_pos) / light_dist, 0.0, 1.0) : 1.0;
	COLOR = mix(lit_color, base_color, shade);
}
