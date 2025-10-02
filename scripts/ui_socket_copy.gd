extends Control
@onready var socket: EquipmentSlotView = %Socket

@export var socket_name ="Gem"

func _ready() -> void:
	socket.slot_name=socket_name
