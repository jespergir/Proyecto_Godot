shader_type canvas_item;

uniform float cutoff_x : hint_range(0.0, 1.0) = 1.0; // cuánto de X se muestra (1.0 = todo, 0.0 = nada)
uniform float cutoff_y : hint_range(0.0, 1.0) = 1.0; // (opcional) para recortar vertical también

void fragment() {
	if (UV.x > cutoff_x || UV.y > cutoff_y) {
		discard;
	}
	COLOR = texture(TEXTURE, UV);
}
