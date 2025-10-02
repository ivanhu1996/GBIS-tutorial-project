class_name UISocket extends Control

		
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

@export var item: Gem:
	set(_item):
		item = _item
		#print("big",gem)
		_update_gem()
		

var overlay_shader: ShaderMaterial = preload("res://scenes/UI/shader/color_overlay_sahder.tres" )
var inv_shader: ShaderMaterial = preload("res://GBIS_demos/materials/equipment_glow.tres")
var parent_data :ItemData
var old_parent_data :ItemData
var gem_index :int
var old_gem_index :int
var old_item :ItemData

func _ready() -> void:
	self.show()
	#if GBIS.has_moving_item():
		#self.hide()
	if get_parent().get_parent() is ItemView:
		parent_data = (get_parent().get_parent() as ItemView).data
		if GBIS.moving_item_service.moving_item == (get_parent().get_parent() as ItemView).data:
			self.hide()
	_update_gem()
	if item:
		item.source=get_path()
		#print("reaDY",item.source)
		var node=get_node(item.source)
		#if node is UISocket:
			#print("has source")
	#GBIS.sig_inv_item_added.connect(_gem_socket_removed)


func _update_gem() -> void:
	if item:
		if gem and overlay_shader:
			gem.show()
			gem_socket.hide()
			var shader_material = overlay_shader.duplicate()
			var ui_shader_material = inv_shader.duplicate()
			shader_material.set_shader_parameter("color", item.color)
			#ui_shader_material.set_shader_parameter("enable_gem_rarity", true)
			#ui_shader_material.set_shader_parameter("gem_color", item.color)
			gem.material = shader_material
			item.material = ui_shader_material
			item.shader_params = {"enable_gem_rarity": true,"gem_color": item.color}
	else:
		if gem:
			gem.hide()
		if gem_socket:
			gem_socket.show()




func _on_gem_socket_mouse_entered() -> void:
	parent_data = (get_parent().get_parent() as ItemView).data
	#print(parent_data.item_name)
	if item:
		pass
		#print("Filled with gem")
	else:
		pass
		#print("socket enter")
	#var parent_data = (get_parent().get_parent() as ItemView).data
	#GBIS.get_socket_data.emit(parent_data)
	#print(parent_data = (get_parent().get_parent() as ItemView).data)
	#var path = get_path()
	#print(path)

func _on_gem_socket_mouse_exited() -> void:
	old_parent_data = parent_data
	old_gem_index = gem_index
	old_item=item
	
func _on_gem_icon_mouse_entered() -> void:
	parent_data = (get_parent().get_parent() as ItemView).data
	#print(parent_data.item_name)

	#print(path)
	
func _gui_input(event: InputEvent) -> void:
	if not event.is_pressed():  # 只处理按键按下事件
		return
	if event.is_action_pressed(GBIS.input_click):
		#parent_data = (get_parent().get_parent() as ItemView).data
		#print(parent_data.item_name)
		gem_index = get_index()
		#parent_data.socketed[gem_index] = null
		#print(parent_data.socketed)
		#print(gem_index)
		if item and not GBIS.moving_item_service.moving_item:
			GBIS.moving_item_service.move_item_by_data(item, Vector2i.ZERO, 30)
			on_gem_removed()
			return
			
		if not item and GBIS.moving_item_service.moving_item:
			receive_gem(GBIS.moving_item_service.moving_item)
			if GBIS.moving_item_service.moving_item.current_amount==1:
				GBIS.moving_item_service.clear_moving_item()
			elif GBIS.moving_item_service.moving_item.current_amount>1:
				GBIS.moving_item_service.moving_item.current_amount=GBIS.moving_item_service.moving_item.current_amount-1
				GBIS.add_item(GBIS.moving_item_service.moving_item.source, GBIS.moving_item_service.moving_item)
				GBIS.moving_item_service.clear_moving_item()
			return
		
		if  item and GBIS.moving_item_service.moving_item:
			if GBIS.moving_item_service.moving_item.current_amount==1:
				var item_swap = item.duplicate(true)
				receive_gem(GBIS.moving_item_service.moving_item)
				GBIS.moving_item_service.moving_item = item_swap
				GBIS.moving_item_service.get_moving_item_layer().get_child(0).data=item_swap
				return
			elif GBIS.moving_item_service.moving_item.current_amount>1:
				var item_swap = item.duplicate(true)
				receive_gem(GBIS.moving_item_service.moving_item)
				GBIS.moving_item_service.moving_item.current_amount=GBIS.moving_item_service.moving_item.current_amount-1
				GBIS.add_item("inv_test", GBIS.moving_item_service.moving_item)
				GBIS.moving_item_service.moving_item = item_swap
				GBIS.moving_item_service.get_moving_item_layer().get_child(0).data=item_swap
				return
		#if GBIS.moving_item_service.moving_item == item:
			#pass
			##clear_item()
	#
		#if GBIS.moving_item_service.moving_item :
			#match(GBIS.moving_item_service.moving_item.category):
				#MyD4EquipmentData.Category.Gem:
					#var new_gem = GBIS.moving_item_service.moving_item
					##print("new_gem "+str(new_gem.item_name) )
					##print("inv name")
					##print(new_gem.source)
				#
					#if item:
						##print(item.item_name)
						##print("old_source")
						##print(item.source)
						#new_gem=GBIS.moving_item_service.moving_item
						#if GBIS.moving_item_service.moving_item.current_amount-1>0:
							#GBIS.moving_item_service.moving_item.current_amount=GBIS.moving_item_service.moving_item.current_amount-1
							#GBIS.add_item("inv_test", GBIS.moving_item_service.moving_item)
						#var item_swap=GBIS.moving_item_service.moving_item.duplicate(true)
						#item_swap.current_amount=1
						#GBIS.moving_item_service.moving_item = item
						#GBIS.moving_item_service.get_moving_item_layer().get_child(0).data=item
						##GBIS.moving_item_service.clear_moving_item()
						#item=item_swap
						#parent_data.socketed[gem_index]=item_swap
						#
					#else:
						##print("empty")
						#new_gem=GBIS.moving_item_service.moving_item
						#if GBIS.moving_item_service.moving_item.current_amount-1>0:
							#GBIS.moving_item_service.moving_item.current_amount=GBIS.moving_item_service.moving_item.current_amount-1
							#GBIS.add_item("inv_test", GBIS.moving_item_service.moving_item)
						#var item_swap=GBIS.moving_item_service.moving_item.duplicate(true)
						#item_swap.current_amount=1
						#GBIS.moving_item_service.clear_moving_item()
						#item=item_swap
						#print(len(parent_data.socketed))
						#print(item_swap)
						#print(parent_data.socketed)
						#print(len(parent_data.socketed))
						#parent_data.socketed.append(item_swap)
						#old_parent_data.socketed[old_gem_index]=null
						#if gem_index > len(parent_data.socketed):
							#0:
								#parent_data.socketed.append(item_swap)
							#1:	
								#match gem_index 
								#parent_data.socketed[gem_index]=item_swap
		
						
				#清除移動宝石		
					
				#GBIS.moving_item_service.clear_moving_item()
				#item.shader_params = {"enable_gem_rarity": true,"gem_color": item.color}
					
					
					
		#GBIS.moving_item_service.moving_item = item
func _gem_socket_removed(inv_name:String, item_data: ItemData, grids: Array[Vector2i]) -> void:
	#print(item_data)
	#print(item)
	if item_data and item and parent_data:
		if item_data.item_name == item.item_name:
			#print("back to bag")
			item = null
			parent_data.socketed[gem_index]=null
			#_update_gem()
			
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
	item = gem_data.duplicate(true)
	item.current_amount=1
	if len(parent_data.socketed) < parent_data.sockets:
		parent_data.socketed.append(null)
	parent_data.socketed[gem_index] = item
	_update_visual()

	# 如果来源是另一个 socket，需要在来源 socket 中移除（通知）
	if gem_data.has_method("source") and (get_node(gem_data.source) is UISocket):
		var path = gem_data.source
		if get_tree().root.has_node(path):
			var src = get_tree().root.get_node(path)
			if src and src.has_method("on_gem_removed"):
				src.on_gem_removed(gem_data)

	# 可能要更新装备数据模型（保存值）
	_save_to_equipment(item)
	return true

func _handle_existing_gem(old_gem: Gem, new_gem: Gem) -> void:
	# 默认行为：把旧宝石放回新宝石的来源（如果是 socket 则通知其接收）
	if new_gem.has_method("source") and (get_node(new_gem.source) is UISocket) :
		if get_tree().root.has_node(new_gem.source):
			var src = get_tree().root.get_node(new_gem.source)
			if src and src.has_method("receive_gem"):
				# 试图放回去（比如交换）
				var accepted = src.receive_gem(old_gem)
				if accepted:
					item = null
					return
#镶嵌
#func receive_gem(gem_data: Gem) -> bool:
	## gem_data 包含 gem_id, texture, source_socket (NodePath)
	## 在这里检查是否允许插入（例如类型匹配，槽位是否已满等）
	## 示例：允许替换。返回 true 表示接收成功，DragManager 会结束拖拽。
	#if not _validate_gem(gem_data):
		#return false
#
	## 如果已有宝石，先把旧的返回给来源或背包（视设计）
	#if item:
		#_handle_existing_gem(item, gem_data)
#
	## 把新宝石“镶嵌”到这里：更新数据、界面
	#item = gem_data.duplicate(true)
	#_update_visual()
#
	## 如果来源是另一个 socket，需要在来源 socket 中移除（通知）
	#if gem_data.has("source_socket") and gem_data.source_socket:
		#var path = gem_data.source_socket
		#if get_tree().root.has_node(path):
			#var src = get_tree().root.get_node(path)
			#if src and src.has_method("on_gem_removed"):
				#src.on_gem_removed(gem_data)
#
	## 可能要更新装备数据模型（保存值）
	#_save_to_equipment(item)
	#return true
	
func _validate_gem(gem_data: Gem) -> bool:
	# 示例：允许所有宝石，或检查 gem_data.gem_id 是否符合插槽类型
	return true

#func _handle_existing_gem(old_gem: Gem, new_gem: Gem) -> void:
	## 默认行为：把旧宝石放回新宝石的来源（如果是 socket 则通知其接收）
	#if new_gem.has("source") and new_gem.source != "inv_test":
		#if get_tree().root.has_node(new_gem.source_socket):
			#var src = get_tree().root.get_node(new_gem.source_socket)
			#if src and src.has_method("receive_gem"):
				## 试图放回去（比如交换）
				#var accepted = src.receive_gem(old_gem)
				#if accepted:
					#item = null
					#return
	## 否则把旧宝石放入背包或掉落（这里简单销毁/丢回背包逻辑）
	#_return_gem_to_bag(old_gem)
	#item = null

func on_gem_removed() -> void:
	# 当其他插槽把来自这里的宝石接走时，清除当前状态
	#if item and item.gemtype == gem_data.gemtype:
	if item:
		item = null
		parent_data.socketed[gem_index]=null
		_update_gem()

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
