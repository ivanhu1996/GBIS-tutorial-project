extends Control
## 物品视图，控制物品的绘制
class_name ItemView

var SOCKET_SCENE = preload("res://scripts/ui_socket.tscn")
## 堆叠数字的字体
var stack_num_font: Font
## 堆叠数字的字体大小
var stack_num_font_size: int
## 堆叠数字的边距
var stack_num_margin: int = 4
## 堆叠数字的颜色
var stack_num_color: Color = Color.WHITE

## 物品数据
var data: ItemData
## 绘制基础大小（格子大小）
var base_size: int:
	set(value):
		base_size = value
		call_deferred("recalculate_size")
## 是否正在移动
var _is_moving: bool = false
## 移动偏移量（坐标）
var _moving_offset: Vector2i = Vector2i.ZERO
var old_size:Vector2 = size
## 构造函数
@warning_ignore("shadowed_variable")
func _init(data: ItemData, base_size: int, stack_num_font: Font = null, stack_num_font_size: int = 16, stack_num_margin: int = 2, stack_num_color: Color = Color.WHEAT) -> void:
	self.data = data
	self.base_size = base_size
	self.stack_num_font = stack_num_font if stack_num_font else get_theme_font("font")
	self.stack_num_font_size = stack_num_font_size
	self.stack_num_margin = stack_num_margin
	self.stack_num_color = stack_num_color
	recalculate_size()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	# 如果 material 不为空，则加上 material
	if data.material:
		material = data.material.duplicate()
	elif GBIS.item_material:
		material = GBIS.item_material.duplicate()
	data.sig_refresh.connect(queue_redraw)

## 重写计算大小
func recalculate_size() -> void:
	old_size = size
	size = Vector2(data.columns * base_size, data.rows * base_size)
	
	queue_redraw()
## 移动
func move(offset: Vector2i = Vector2i.ZERO) -> void:
	_is_moving = true
	_moving_offset = offset

## 绘制物品
func _draw() -> void:
	if data.icon:
		#var target_rect=Rect2(Vector2.ZERO, size)
		#var tex_size = data.icon.get_size()
		#var scale =  min(target_rect.size.x / tex_size.x, target_rect.size.y / tex_size.y)
		#var new_size = tex_size * scale
		#var pos = (target_rect.size - new_size) / 2.0
		#var dst_rect = Rect2(pos, new_size)
		#draw_texture_rect(data.icon, dst_rect, false)
		draw_texture_rect(data.icon, Rect2(Vector2.ZERO, size),false)
		
	if data is D4EquipmentData:
		#print(data.sockets)
		if data.sockets:
			var socket_gem = SOCKET_SCENE.instantiate() as UISocket
			var gem_scale=Vector2(base_size,base_size)*0.75/socket_gem.size
			socket_gem.scale=gem_scale
			#socket_gem.set_position(Vector2(data.columns * base_size/2,data.rows * base_size/2)-socket_gem.size/2)
			socket_gem.set_position(Vector2(data.columns * base_size/2,data.rows * base_size/2)-socket_gem.size*socket_gem.scale/2)
			match(data.sockets):
				1:
					socket_gem.set_position(Vector2(data.columns * base_size/2,data.rows * base_size/2)-socket_gem.size*socket_gem.scale/2)
					if data.socketed:
						socket_gem.item=data.socketed[0]
				2:
					socket_gem.set_position(Vector2(data.columns * base_size/2,data.rows * base_size/3)-socket_gem.size*socket_gem.scale/2)
					var socket_gem_sec = SOCKET_SCENE.instantiate() as UISocket
					socket_gem_sec.scale=gem_scale
					socket_gem_sec.set_position(Vector2(data.columns * base_size/2,data.rows * base_size*2/3)-socket_gem.size*socket_gem.scale/2)
					
					if data.socketed:
						match(data.socketed.size()):
							1:
								socket_gem.item=data.socketed[0]
							2:
								socket_gem.item=data.socketed[0]
								socket_gem_sec.item=data.socketed[1]
					self.add_child(socket_gem_sec)
			self.add_child(socket_gem)

	if data is StackableData:
		var text_size = stack_num_font.get_string_size(str(data.current_amount), HORIZONTAL_ALIGNMENT_RIGHT, -1, stack_num_font_size)

		var pos = Vector2(
			size.x - text_size.x - stack_num_margin,
			size.y - stack_num_font.get_descent(stack_num_font_size) - stack_num_margin
		)
		draw_string(stack_num_font, pos, str(data.current_amount), HORIZONTAL_ALIGNMENT_RIGHT, -1, stack_num_font_size, stack_num_color)
	if material:
		for param_name in data.shader_params.keys():
			(material as ShaderMaterial).set_shader_parameter(param_name, data.shader_params[param_name])

## 跟随鼠标
func _process(_delta: float) -> void:
	if _is_moving:
		@warning_ignore("integer_division")
		global_position = get_global_mouse_position() - Vector2(base_size * _moving_offset) - Vector2(base_size / 2, base_size / 2)
