class_name Jewelry  extends MyD4EquipmentData

@export var jewelrytype: Type = Type.Ring
@export var rotate_material: ShaderMaterial
var category: Category = Category.Jewelry

enum Type {
	Ring,
	Amulet
}

#static var JEWELRY_TEXTURE: Texture = preload("res://assets/images/jewelry/Amulet.png")
static var JEWELRY_TEXTURE = {
	Type.Amulet: {
		"texture":preload("res://assets/images/jewelry/Amulet.png"),
		"size":Vector2(256,256)
	},
	Type.Ring: {
		"texture":preload("res://assets/images/jewelry/Ring.png"),
		"size":Vector2(256,256)
	},
}
static var JEWELRY_ICONS = {
	Type.Ring: range(5),
	Type.Amulet: range(5),
}

func _get_max_sockets() -> int:
	return 2


func _get_type() -> String:
	return Type.keys()[jewelrytype]
