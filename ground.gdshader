shader_type canvas_item;

uniform sampler2D ground;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;  // Współrzędne UV
    COLOR = texture(ground, UV);
}
