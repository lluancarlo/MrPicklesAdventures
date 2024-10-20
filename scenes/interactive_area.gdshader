shader_type spatial;

uniform float gradient_height = 0.2;
uniform vec4 color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Called for every vertex the material is visible on.
void vertex() {
}

// Called for every pixel the material is visible on.
void fragment() {
	if (UV.y < gradient_height){
		ALBEDO = color.rgb;
	}else{
		ALBEDO = vec3(1.0, 1.0, 1.0);
	}
	ALPHA = color.a;
}

// Called for every pixel for every light affecting the material.
// Uncomment to replace the default light processing function with this one.
//void light() {
//}
