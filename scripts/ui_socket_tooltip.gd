class_name UISocket_tooltip extends Control

		
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
	_update_gem()




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
