shader_type canvas_item;

uniform float blur = 1.5;
uniform float saturation = 1.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_enable, filter_nearest_mipmap;

void fragment() {
	vec3 c = textureLod(screen_texture, SCREEN_UV, blur).rgb;

    c.rgb = mix(vec3(0.0), c.rgb, 0.6);
    c.rgb = mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation);

    COLOR.rgb = c;
}
