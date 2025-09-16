class_name UISocket extends Control

@export var item: Gem:
	set(_item):
		item = _item
		_update_gem()
		
		
@export var gem_colors: Array[Color] = [
	Color(.68, .66, .62),
	Color(0, .23, .96),
	Color(.8, .12, .16),
	Color(.07, .58, .05),
	Color(.51, 0, .81),
	Color(.83, .57, .15)
]

@onready var gem: TextureRect = %Gem_Icon
@onready var gem_socket: TextureRect = $Gem_Socket



var overlay_shader: ShaderMaterial = preload("res://scenes/UI/shader/color_overlay_sahder.tres" )


func _ready() -> void:
	self.show()
	if GBIS.has_moving_item():
		self.hide()
	_update_gem()
	

func _update_gem() -> void:
	if item:
		if gem and overlay_shader:
			gem.show()
			gem_socket.hide()
			var shader_material = overlay_shader.duplicate()
			shader_material.set_shader_parameter("color", item.color)
			gem.material = shader_material
	else:
		gem.hide()




func _on_gem_socket_mouse_entered() -> void:
	if item:
		print("Filled with gem")
	else:
		print("socket enter")
	var parent_data = (get_parent().get_parent() as ItemView).data
	GBIS.get_socket_data.emit(parent_data)
	print(parent_data.item_name)
	var path = get_path()
	print(path)
	
func _on_gem_icon_mouse_entered() -> void:
	print("gem enter")
	var path = get_path()
	print(path)

#镶嵌
func receive_gem(gem_data: Gem) -> bool:
	# gem_data 包含 gem_id, texture, source_socket (NodePath)
	# 在这里检查是否允许插入（例如类型匹配，槽位是否已满等）
	# 示例：允许替换。返回 true 表示接收成功，DragManager 会结束拖拽。
	if not _validate_gem(gem_data):
		return false

	# 如果已有宝石，先把旧的返回给来源或背包（视设计）
	if item:
		_handle_existing_gem(item, gem_data)

	# 把新宝石“镶嵌”到这里：更新数据、界面
	item = gem_data.duplicate()
	_update_visual()

	# 如果来源是另一个 socket，需要在来源 socket 中移除（通知）
	if gem_data.has("source_socket") and gem_data.source_socket:
		var path = gem_data.source_socket
		if get_tree().root.has_node(path):
			var src = get_tree().root.get_node(path)
			if src and src.has_method("on_gem_removed"):
				src.on_gem_removed(gem_data)

	# 可能要更新装备数据模型（保存值）
	_save_to_equipment(item)
	return true
	
func _validate_gem(gem_data: Gem) -> bool:
	# 示例：允许所有宝石，或检查 gem_data.gem_id 是否符合插槽类型
	return true

func _handle_existing_gem(old_gem: Gem, new_gem: Gem) -> void:
	# 默认行为：把旧宝石放回新宝石的来源（如果是 socket 则通知其接收）
	if new_gem.has("source_socket") and new_gem.source_socket:
		if get_tree().root.has_node(new_gem.source_socket):
			var src = get_tree().root.get_node(new_gem.source_socket)
			if src and src.has_method("receive_gem"):
				# 试图放回去（比如交换）
				var accepted = src.receive_gem(old_gem)
				if accepted:
					item = null
					return
	# 否则把旧宝石放入背包或掉落（这里简单销毁/丢回背包逻辑）
	_return_gem_to_bag(old_gem)
	item = null

func on_gem_removed(gem_data: Gem) -> void:
	# 当其他插槽把来自这里的宝石接走时，清除当前状态
	if item and item.gemtype == gem_data.gemtype:
		item = null
		_update_visual()

func on_drag_cancel(drag_data: Dictionary) -> void:
	# 当 DragManager 取消时（比如拖回原处或回退），可做额外处理
	pass

func _update_visual():
	# 更新插槽的 UI，比如显示宝石图标或空插槽
	if item:
		# 显示宝石图
		var icon = $Icon if has_node("Icon") else null
		if icon and icon is TextureRect:
			icon.texture = item.texture
			icon.visible = true
	else:
		if has_node("Icon"):
			$Icon.visible = false

func _return_gem_to_bag(gem_data: Gem) -> void:
	# 实现：把宝石放回背包 UI，或生成一个 GemIcon 放回
	# 这里省略实现，按你现有背包结构实现
	pass

func _save_to_equipment(gem_data: Gem) -> void:
	# 把 gem_data 写入装备的数据模型（Resource、字典或服务器）
	pass
