class_name Armor extends MyD4EquipmentData

@export var armortype: Type = Type.Chest

enum Type {
	Chest,
	Helmet,
	Pants,
	Footwear,
	Gloves,
	Shield
}

#static var ARMOR_TEXTURE: Texture = preload("res://assets/images/icons/#1 - Transparent Icons.png")
static var ARMOR_TEXTURE = {
	Type.Gloves: {
		"texture":preload("res://assets/images/armor/gloves.png"),
		"size":Vector2(256,256)
	},
	Type.Helmet: {
		"texture":preload("res://assets/images/armor/Helmet.png"),
		"size":Vector2(256,256)
	},
	Type.Chest: {
		"texture":preload("res://assets/images/armor/Chest.png"),
		"size":Vector2(256,256)
	},
	Type.Pants: {
		"texture":preload("res://assets/images/armor/Pants.png"),
		"size":Vector2(256,256)
	},
	Type.Shield: {
		"texture":preload("res://assets/images/armor/Shield.png"),
		"size":Vector2(256,256)
	},
	Type.Footwear: {
		"texture":preload("res://assets/images/armor/Shoes.png"),
		"size":Vector2(256,256)
	},
}


static var ARMOR_ICONS = {
	Type.Chest: range(6),
	Type.Helmet: range(5),
	Type.Pants: range(4),
	Type.Footwear: range(5),
	Type.Gloves: range(4),
	Type.Shield: range(6),
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
