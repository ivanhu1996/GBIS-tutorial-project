extends Control
class_name GradientSeparator

@export var thickness: int = 2                # 分隔线厚度
@export var horizontal: bool = true           # 横向 / 纵向
@export var colors: Array[Color] = [          # 渐变颜色，支持任意多段
	Color(1,1,1,0),
	Color(1,1,1,1),
	Color(1,1,1,0)
]

@export var debug_print: bool = false         # 打印调试信息

func _ready():
	# 设置最小尺寸
	if horizontal:
		custom_minimum_size = Vector2(custom_minimum_size.x, thickness)
	else:
		custom_minimum_size = Vector2(thickness, custom_minimum_size.y)
	queue_redraw()

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
		if debug_print:
			print("[GradientSeparator] resized, size=", size)

func _draw():
	var steps = colors.size() - 1
	if steps < 1:
		return

	if horizontal:
		for i in range(int(size.x)):
			var t = i / float(size.x)
			# 找到 t 所在的区间
			var idx = int(floor(t * steps))
			idx = clamp(idx, 0, steps-1)
			var local_t = (t - float(idx)/steps) * steps
			var col = colors[idx].lerp(colors[idx+1], local_t)
			draw_rect(Rect2(i, 0, 1, size.y), col)
	else:
		for i in range(int(size.y)):
			var t = i / float(size.y)
			var idx = int(floor(t * steps))
			idx = clamp(idx, 0, steps-1)
			var local_t = (t - float(idx)/steps) * steps
			var col = colors[idx].lerp(colors[idx+1], local_t)
			draw_rect(Rect2(0, i, size.x, 1), col)
