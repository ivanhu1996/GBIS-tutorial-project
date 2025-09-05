shader_type canvas_item;
render_mode blend_mix; // 确保透明度混合正常

// ===== 强化装备（常亮+流动） =====
uniform bool enable_enhance = false;
uniform vec4 enhance_color : source_color = vec4(0.9, 0.7, 0.3, 1.0); // 金色光效
uniform float enhance_speed : hint_range(0.1, 5.0) = 0.5;
uniform float enhance_width : hint_range(0.01, 1.0) = 1;
uniform float enhance_brightness : hint_range(0.5, 5) = 1;

// ===== 卓越装备（纯脉冲） =====
uniform bool enable_excellent = false;
uniform bool enable_rarity= false;
uniform vec4 excellent_color : source_color = vec4(0.3, 1.0, 0.4, 1.0); // 绿色光效
uniform float excellent_speed : hint_range(0.1, 3.0) = 2.2;
uniform float excellent_brightness : hint_range(0.1, 0.5) = 4;
uniform vec4 rarity_color : source_color = vec4(0.01, 0.01, 0.01, 0.01); // 默认背景色

void fragment() {
    // 读取原始纹理（关键修正：用 TEXTURE 而不是自定义 sampler2D）
    vec4 tex_color = texture(TEXTURE, UV);
	
    vec3 final_color = tex_color.rgb;
    float alpha = tex_color.a;

    // ===== 强化装备效果（常亮+流动） =====
    if (enable_enhance && alpha > 0.0) {
        float flow = sin(TIME * enhance_speed + UV.x * 5.0) * 0.3 + 0.5;
        float edge = smoothstep(1.0 - enhance_width, 1.0, alpha);
        vec3 glow = enhance_color.rgb * flow * edge * enhance_brightness;
        final_color += glow;
    }

    // ===== 卓越装备效果（纯脉冲） =====
    if (enable_excellent && alpha > 0.0) {
        float pulse = sin(TIME * excellent_speed) * 0.5 + 0.8;
        vec3 glow = excellent_color.rgb * pulse * excellent_brightness * alpha;
        final_color += glow;
    }
	if (enable_rarity&&tex_color.a < 0.01) {
        // 没有图形的地方 → 用背景色替代
      	 COLOR = vec4(rarity_color.rgb,0.75);
    }else{
		COLOR = vec4(final_color, alpha);
	}
    
	//COLOR = mix(vec4(final_color, alpha), vec4(final_color, alpha) * COLOR, COLOR.a);
}
