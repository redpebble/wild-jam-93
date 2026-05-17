[gd_resource type="Shader" format=3 uid="uid://30wc8ctsb2yu"]

[resource]
code = "shader_type canvas_item;

uniform vec2 aspect_ratio = vec2(7, 5);

uniform float alpha = 1.0;
uniform float inner_radius = 0.0;
uniform float outer_radius = 1.0;

float vignette(vec2 uv) {
	float x = abs(uv.r-.5)*5.0/2.0;
	float y = abs(uv.g-.5)*7.0/2.0;
	float q = 1.0-(1.0-sqrt(x*x+y*y)/outer_radius)/(1.0-inner_radius);
	return 1.0 - q*alpha;
}

// Uses very specific UV values to crop areas that would overlap with the UI
float clip_to_fit(float a, vec2 uv_base) {
	vec2 uv = uv_base * aspect_ratio;
	bool top_left_corner = uv.y <= 0.5 - uv.x;
	bool bottom_right_corner = uv.y >= 11.45 - uv.x;
	bool bottom = uv.y >= 4.95;
	if (top_left_corner || bottom_right_corner || bottom)
		return 0.0;
	else
		return a;
}

void fragment() {
	COLOR.a = vignette(UV);
	COLOR.a = clip_to_fit(COLOR.a, UV);
}
"
