shader_type canvas_item;

uniform sampler2D atlas_tex ;
uniform ivec2 tile_index = ivec2(0, 0); // 选中格子，默认从左上(0,0)开始计
uniform int tiles_per_row = 4;
uniform int tiles_per_col = 4;
uniform float rotation_deg = 45.0;
uniform bool center_on_rect = true;   // 居中到控件矩形
uniform bool fit_inside = true;       // 防裁剪自动缩放
uniform bool show_other_tiles = false; // 仅在 center_on_rect=false 时：是否保留其他格子

void fragment() {
    vec2 tile_size   = vec2(1.0 / float(tiles_per_row), 1.0 / float(tiles_per_col));
    vec2 tile_offset = vec2(float(tile_index.x), float(tile_index.y)) * tile_size;

    float rad = radians(rotation_deg);
    mat2 rot = mat2(vec2(cos(rad), -sin(rad)),
                    vec2(sin(rad),  cos(rad)));
    float scale = fit_inside ? inversesqrt(2.0) : 1.0; // 1/sqrt(2)

    if (center_on_rect) {
        // 以控件矩形中心为原点，将整块小图居中绘制
        vec2 p = UV - vec2(0.5);
        p *= scale*1.5;
        vec2 q = rot * p;
        vec2 uv_tile = q + vec2(0.5);

        if (any(lessThan(uv_tile, vec2(0.0))) || any(greaterThan(uv_tile, vec2(1.0)))) {
            COLOR = vec4(0.0);
        } else {
            vec2 atlas_uv = tile_offset + uv_tile * tile_size;
            COLOR = texture(atlas_tex, atlas_uv);
        }
    } else {
        // 原地只旋转选中的那一格
        vec2 local_uv = (UV - tile_offset) / tile_size;

        if (any(lessThan(local_uv, vec2(0.0))) || any(greaterThan(local_uv, vec2(1.0)))) {
            COLOR = show_other_tiles ? texture(atlas_tex, UV) : vec4(0.0);
        } else {
            vec2 p = local_uv - vec2(0.5);
            p *= scale;
            vec2 q = rot * p;
            vec2 uv_tile = q + vec2(0.5);

            if (any(lessThan(uv_tile, vec2(0.0))) || any(greaterThan(uv_tile, vec2(1.0)))) {
                COLOR = vec4(0.0);
            } else {
                vec2 atlas_uv = tile_offset + uv_tile * tile_size;
                COLOR = texture(atlas_tex, atlas_uv);
            }
        }
    }
}