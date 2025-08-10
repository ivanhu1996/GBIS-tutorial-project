extends Control

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var num: Label = $HBoxContainer/Num


@export var stat_value: int = 10:
	set(value):
		stat_value = value
		_update_labels()

@export var stat_icon: Texture:
	set(value):
		stat_icon = value
		_update_labels()


func _ready():
	_update_labels()


func _update_labels():
	if num:
		num.text = str(stat_value)

	if texture_rect:
		texture_rect.texture = stat_icon
