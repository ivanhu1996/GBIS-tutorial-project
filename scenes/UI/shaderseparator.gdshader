shader_type canvas_item;

uniform bool horizontal  = true;

uniform vec4 color_start  = vec4(1.0,1.0,1.0,0.0);
uniform vec4 color_middle  = vec4(1.0,1.0,1.0,1.0);
uniform vec4 color_end  = vec4(1.0,1.0,1.0,0.0);

void fragment() {
    float t = horizontal ? UV.x : UV.y;
    vec4 col;
    if (t < 0.5) {
        col = mix(color_start, color_middle, t * 2.0);
    } else {
        col = mix(color_middle, color_end, (t - 0.5) * 2.0);
    }
    COLOR = col*COLOR;
}