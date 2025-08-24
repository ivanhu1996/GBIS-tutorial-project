class_name Armor extends MyD4EquipmentData

@export var armortype: Type = Type.Chest

enum Type {
	Chest,
	Helm,
	Pants,
	Footwear,
	Gloves,
	Shield
}

static var ARMOR_TEXTURE: Texture = preload("res://assets/images/icons/#1 - Transparent Icons.png")

static var ARMOR_ICONS = {
	Type.Chest: [0, 8, 16, 24, 32, 40, 48, 56, 64, 72, 80, 88],
	Type.Helm: [1, 9, 17, 25, 33, 41, 49],
	Type.Pants: [2, 10, 18, 26, 34],
	Type.Footwear: [3, 11, 19, 27, 35],
	Type.Gloves: [4, 12, 20, 28, 36, 44, 52],
	Type.Shield: [7, 15, 23, 31, 39, 47],
}

var category: Category = Category.Armor

func _get_max_sockets() -> int:
	match(type):
		Type.Chest, Type.Pants:
			return 2
		_:
			return 1


func _get_type() -> String:
	return Type.keys()[armortype]
