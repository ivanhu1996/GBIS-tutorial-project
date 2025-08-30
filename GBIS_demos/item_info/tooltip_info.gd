class_name UI extends Control
var tooltip: Tooltip 
var TOOLTIP_SCENE: PackedScene = preload("res://GBIS_demos/item_info/tooltip.tscn")
static var _ui: UI

func _ready() -> void:
	_ui = self if !_ui else _ui
	hide()
	GBIS.sig_item_focused.connect(func(item_data: ItemData, container_name: String):
		var tt: Tooltip = TOOLTIP_SCENE.instantiate() as Tooltip
		tt.item = item_data
		_ui.tooltip = tt
		_ui.add_child(tt)
		show()
			)
	GBIS.sig_item_focus_lost.connect(func(_item_data: ItemData): 
		if _ui.tooltip and !_ui.tooltip.is_queued_for_deletion():
			_ui.remove_child(_ui.tooltip)
			_ui.tooltip.queue_free()
			_ui.tooltip = null
		hide()
		
		)
	

func _process(_delta: float) -> void:
	position = get_global_mouse_position() + Vector2(5, -250)

func _delete_tooltip() -> void:
	if _ui.tooltip and !_ui.tooltip.is_queued_for_deletion():
		_ui.remove_child(_ui.tooltip)
		if _ui.tooltip.mouse_entered.is_connected(_ui.on_hover_item):
			_ui.tooltip.mouse_entered.disconnect(_ui.on_hover_item)
		if _ui.tooltip.mouse_exited.is_connected(_ui.on_hover_leave):
			_ui.tooltip.mouse_exited.disconnect(_ui.on_hover_leave)
		_ui.tooltip.queue_free()
		_ui.tooltip = null
