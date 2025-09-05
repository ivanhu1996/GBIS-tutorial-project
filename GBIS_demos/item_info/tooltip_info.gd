class_name UI extends Control
var tooltip: Tooltip 
var TOOLTIP_SCENE: PackedScene = preload("res://GBIS_demos/item_info/tooltip.tscn")
static var _ui: UI
@export var margin : int = 10 
@export var tooltip_width : float = 958 
@export var tooltip_height : float = 1564
@onready var character_ui: Control = $".."
@onready var inventory_view: InventoryView = %InventoryView

func _ready() -> void:
	_ui = self if !_ui else _ui
	hide()
	GBIS.sig_item_focused.connect(func(item_data: ItemData, container_name: String):
		var tt: Tooltip = TOOLTIP_SCENE.instantiate() as Tooltip
		if tt.info_container:
			tooltip_width = tt.info_container.size.x
			tooltip_height = tt.info_container.size.y
		tt.item = item_data
		match(container_name):
			"Helmet","Cap","Pants","Boots","MainHand","OffHand":
				tt.equipped_state = true
			
			
			
		#if GBIS.shop_names.has(container_name):
			#item_name_label.text = "[Shop] %s" % item_data.item_name
		#else:
			#item_name_label.text = item_data.item_name
			#item_attribute.text = item_data.compound_category

		#print(item_data.affixes)
		#print(tt.item.affixes)
		_ui.tooltip = tt
		_ui.add_child(tt)
		#show_tooltip()
		show()
			)
	GBIS.sig_item_focus_lost.connect(func(_item_data: ItemData): 
		if _ui.tooltip and !_ui.tooltip.is_queued_for_deletion():
			_ui.remove_child(_ui.tooltip)
			_ui.tooltip.queue_free()
			_ui.tooltip = null
		hide()
		
		)
	#

func _process(_delta: float) -> void:
	position.x =-character_ui.position.x + get_global_mouse_position().x - tooltip_width -inventory_view.base_size*4
	#position.x =-character_ui.position.x +1200 - tooltip_width -inventory_view.base_size*5
	position.y = 0

#func show_tooltip():
	#var mouse_pos = get_viewport().get_mouse_position()
	#var screen_size = get_viewport_rect().size
	#
	#print(screen_size)
	## 初始位置设置在鼠标附近
	#var new_pos = mouse_pos 
	#
	## 检查是否靠近右边
	##if mouse_pos.x + tooltip_width + margin > screen_size.x:
	#if mouse_pos.x  > screen_size.x /2:
		#print("here")
		## 靠近右边，改到左边
		#new_pos.x = mouse_pos.x - tooltip_width*1.3 - margin 
	## 检查是否靠近左边
	#elif mouse_pos.x - tooltip_width< margin:
		## 靠近左边，改到右边
		#new_pos.x = mouse_pos.x + margin 
	#
	## 检查靠近底部
	#if mouse_pos.y + tooltip_height + margin > screen_size.y:
		#print("bottom")
		#new_pos.y = mouse_pos.y - tooltip_height - margin -200
		#new_pos.y = mouse_pos.y -  tooltip_height /2
	## 检查靠近顶部
	#elif mouse_pos.y < margin:
		#print("top")
		#new_pos.y = mouse_pos.y + margin
	#
	#position = new_pos
	#show()

func _delete_tooltip() -> void:
	if _ui.tooltip and !_ui.tooltip.is_queued_for_deletion():
		_ui.remove_child(_ui.tooltip)
		if _ui.tooltip.mouse_entered.is_connected(_ui.on_hover_item):
			_ui.tooltip.mouse_entered.disconnect(_ui.on_hover_item)
		if _ui.tooltip.mouse_exited.is_connected(_ui.on_hover_leave):
			_ui.tooltip.mouse_exited.disconnect(_ui.on_hover_leave)
		_ui.tooltip.queue_free()
		_ui.tooltip = null
