shader_type canvas_item;

uniform vec2 aspect_ratio = vec2(7, 5);

uniform float alpha = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

// Uses very specific UV values to crop areas that would overlap with the UI
float clip_to_fit(float a, vec2 uv_base) {
	vec2 uv = uv_base * aspect_ratio;
	bool top_left_corner = uv.y <= 0.5 - uv.x;
	bool bottom_right_corner = uv.y >= 11.85 - uv.x;
	bool bottom = uv.y >= 5.35;
	if (top_left_corner || bottom_right_corner || bottom)
		return 0.0;
	else
		return a;
}

void fragment() {
	COLOR.a = clip_to_fit(COLOR.a, UV);
}
