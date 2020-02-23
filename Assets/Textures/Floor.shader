shader_type spatial;
render_mode blend_mix;

uniform vec3 color_even = vec3(0.9,0.9,0.9);
uniform vec3 color_odd = vec3(0.1,0.1,0.1);

void fragment() {
	int ix = int( UV.x * 160.0 );
	int iy = int( UV.y * 160.0 );
	ix += (iy%2 == 1)? 1 : 0;
	ALBEDO = (ix%2 == 0)? color_even : color_odd;
}
