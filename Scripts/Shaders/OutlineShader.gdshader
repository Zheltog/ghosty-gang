shader_type canvas_item;

// Stub outline. Thickness, color and softness live on the shared material.
// `enabled` is per sprite, so hover can turn the outline on for one instance.
uniform float outline_thickness : hint_range(0.0, 32.0) = 2.0;
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outline_softness : hint_range(0.0, 1.0) = 0.25;
instance uniform bool enabled = false;
// Baked collision masks keep their silhouette in alpha and hide the fill.
instance uniform bool fill_visible = true;

void vertex() {
	if (enabled && outline_thickness > 0.0) {
		VERTEX += (UV * 2.0 - 1.0) * outline_thickness;
	}
}

void fragment() {
	vec2 uv = UV;
	if (enabled && outline_thickness > 0.0) {
		vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(outline_thickness * 2.0));
		uv = (uv - texture_pixel_size * outline_thickness) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
	}

	bool outside = uv != clamp(uv, vec2(0.0), vec2(1.0));
	vec4 texel = outside ? vec4(0.0) : texture(TEXTURE, uv);
	vec4 shown = fill_visible ? texel : vec4(0.0);
	if (!enabled || outline_thickness <= 0.0) {
		COLOR = shown;
	} else {
		vec2 size = TEXTURE_PIXEL_SIZE * outline_thickness;
		float neighbor = 0.0;
		neighbor = max(neighbor, texture(TEXTURE, clamp(uv + vec2(size.x, 0.0), vec2(0.0), vec2(1.0))).a);
		neighbor = max(neighbor, texture(TEXTURE, clamp(uv + vec2(-size.x, 0.0), vec2(0.0), vec2(1.0))).a);
		neighbor = max(neighbor, texture(TEXTURE, clamp(uv + vec2(0.0, size.y), vec2(0.0), vec2(1.0))).a);
		neighbor = max(neighbor, texture(TEXTURE, clamp(uv + vec2(0.0, -size.y), vec2(0.0), vec2(1.0))).a);
		neighbor = smoothstep(outline_softness, 1.0, neighbor);
		float edge = clamp(neighbor * (1.0 - texel.a), 0.0, 1.0);
		vec4 outline = vec4(outline_color.rgb, edge * outline_color.a);
		if (outside) {
			COLOR = outline;
		} else {
			COLOR = mix(outline, shown, shown.a);
		}
	}
}
