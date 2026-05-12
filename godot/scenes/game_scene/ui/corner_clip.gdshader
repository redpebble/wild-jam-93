shader_type canvas_item;

uniform vec2 aspect_ratio = vec2(7, 5);

void fragment() {
	vec2 uv = UV * aspect_ratio;
	if (uv.y <= 0.5 - uv.x) {
		COLOR.a = 0.0;
	}
	if (uv.y >= 11.45 - uv.x) {
		COLOR.a = 0.0;
	}
	if (uv.y >= 4.5) {
		COLOR.a = 0.0;
	}
}
