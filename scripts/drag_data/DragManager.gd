extends Node
var dragging_data = null        # 任意数据结构，例如: { "gem_id": "ruby", "texture": Texture2D, "source_socket": NodePath }
var preview: Control = null
var preview_offset := Vector2.ZERO

func start_drag(data: ItemData) -> void:
	# data: 自定义字典，包含宝石 id、属性、来源 socket（可选）等
	# preview_node: 一个 Control（TextureRect）会被添加到场景最顶层作为跟随鼠标的预览
	stop_drag() # ensure no leftover
	dragging_data = data
	set_process(true)

func stop_drag() -> void:
	dragging_data = null
	set_process(false)

#func _process(delta):
	#if preview:
		#preview.position = get_viewport().get_mouse_position() - preview_offset

func try_drop() -> void:
	# 在释放鼠标时调用：查找鼠标下的 Control，并尝试调用其 receive_gem
	if dragging_data == null:
		stop_drag()
		return
	var mouse_pos = get_viewport().get_mouse_position()
	var target = get_viewport().gui_pick(mouse_pos)
	if target:
		# 如果目标是 socket 或其父级，查找最近的可接收节点
		var receiver = _find_receiver(target)
		if receiver:
			# 调用目标的接口进行接收（目标自己判断是否合法）
			if receiver.has_method("receive_gem"):
				var accepted = receiver.receive_gem(dragging_data)
				if accepted:
					stop_drag()
					return
	# 如果没有被接收：恢复原位或直接销毁 preview（视需求）
	_cancel_drop()

func _find_receiver(node: Node) -> Node:
	# 往上遍历查找实现 receive_gem 的节点（例如 Socket）
	var cur = node
	while cur:
		if cur.has_method("receive_gem"):
			return cur
		cur = cur.get_parent()
	return null

func _cancel_drop():
	# 取消拖拽的回退行为：若 dragging_data.source_socket 有值可以通知回去实现回滚
	if dragging_data and dragging_data.has("source_socket"):
		var path = dragging_data.source_socket
		if path and get_tree().root.has_node(path):
			var src = get_tree().root.get_node(path)
			if src and src.has_method("on_drag_cancel"):
				src.on_drag_cancel(dragging_data)
	stop_drag()
