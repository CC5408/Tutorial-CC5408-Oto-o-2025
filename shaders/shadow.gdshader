shader_type canvas_item;

uniform vec2 offset;
uniform vec4 shadow_color: source_color = vec4(0.0, 0.0, 0.0, 0.5);

uniform bool inside = false;
uniform bool add_margins = true; // only useful when inside is false
uniform vec2 number_of_images = vec2(1.0); // number of horizontal and vertical images in the sprite sheet

void vertex() {
		//VERTEX += sign(VERTEX) * max(abs(offset.x), abs(offset.y)); // replace sign(VERTEX) by (sign(VERTEX) * 2.0 - 1.0) if not Centered
		//VERTEX *= 2.0;
}
void fragment() {
	float width = max(abs(offset.x), abs(offset.y));
	//vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(width * 2.0));
	vec2 uv = UV;
	//uv = (uv - texture_pixel_size * width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;

	//vec4 color = texture(TEXTURE, UV * 2.0 + vec2(-0.5/11.0 , -0.5));
	vec4 color = texture(TEXTURE, UV);
	vec4 test = texture(TEXTURE, UV - offset * TEXTURE_PIXEL_SIZE);
	//vec4 test = texture(TEXTURE, uv - offset * TEXTURE_PIXEL_SIZE);
	if(color.a == 0.0 && test.a != 0.0){
		color = shadow_color;
	}
	COLOR = color;

	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
