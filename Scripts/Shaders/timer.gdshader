shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.5;
uniform vec4 background_color : source_color = vec4(0.5, 0.5, 0.5, 1.0);
uniform sampler2D color_gradient : source_color;

void fragment() {
    vec2 uv = UV;
	
    vec4 gradient_color = texture(color_gradient, vec2(progress, 0.5));
    
    vec4 final_color = background_color;
    
    if (uv.x < progress) {
        final_color = mix(gradient_color, background_color, 0.2);
    }
    
    COLOR = final_color;
}