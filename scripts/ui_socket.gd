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
			var shader_material = overlay_shader.duplicate()
			shader_material.set_shader_parameter("color", item.color)
			gem.material = shader_material
	else:
		gem.hide()
