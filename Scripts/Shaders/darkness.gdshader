shader_type canvas_item;

uniform vec2 mouse_pos;
uniform bool light_on;
uniform float light_dist = 200.0;

float get_alpha_by_dist(float dist) {
	
	return clamp(dist / light_dist, 0.0, 1.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (light_on) {
		COLOR.a = get_alpha_by_dist(distance(VERTEX, mouse_pos));
	}
}
