class_name Weapon extends MyD4EquipmentData

@export var weapontype: Type = Type.Axe
@export var rotate_material: ShaderMaterial
var category: Category = Category.Weapon

enum Type {
	Axe,
	Axe2H,
	Bow,
	Crossbow,
	Dagger,
	#Offhand,
	Mace,
	Mace2H,
	Staff,
	Sword,
	Sword2H,
	Scythe,
	Scythe2H,
	Wand,
	Polearm
}


static var WEAPON_TEXTURE: Texture = preload("res://assets/images/gear/Sword.png")
static var WEAPON_TEXTURES = {
	Type.Sword: {
		"texture":preload("res://assets/images/gear/Sword.png"),
		"size":Vector2(256,256)
	},
	Type.Sword2H: {
		"texture":preload("res://assets/images/gear/Sword2H.png"),
		"size":Vector2(256,256)
	},
	Type.Axe: {
		"texture":preload("res://assets/images/gear/Axe.png"),
		"size":Vector2(256,256)
	},
	Type.Axe2H: {
		"texture":preload("res://assets/images/gear/Axe_2H.png"),
		"size":Vector2(256,256)
	},
	Type.Bow: {
		"texture":preload("res://assets/images/gear/Bow.png"),
		"size":Vector2(256,256)
	},
	Type.Dagger: {
		"texture":preload("res://assets/images/gear/Dagger.png"),
		"size":Vector2(48,48)
	},
	Type.Mace: {
		"texture":preload("res://assets/images/gear/Hammer.png"),
		"size":Vector2(256,256)
	},
	Type.Crossbow: {
		"texture":preload("res://assets/images/gear/Crossbow.png"),
		"size":Vector2(256,256)
	},
	Type.Mace2H: {
		"texture":preload("res://assets/images/gear/Mace2H.png"),
		"size":Vector2(256,256)
	},
	Type.Staff: {
		"texture":preload("res://assets/images/gear/Staff.png"),
		"size":Vector2(256,256)
	},
	Type.Scythe: {
		"texture":preload("res://assets/images/gear/Scythe.png"),
		"size":Vector2(256,256)
	},
	Type.Scythe2H: {
		"texture":preload("res://assets/images/gear/Scythe2H.png"),
		"size":Vector2(256,256)
	},
	Type.Wand: {
		"texture":preload("res://assets/images/gear/Wand.png"),
		"size":Vector2(256,256)
	},
	Type.Polearm: {
		"texture":preload("res://assets/images/gear/Polearm.png"),
		"size":Vector2(256,256)
	},
}

#func _ready() -> void:
	#var WEAPON_TEXTURE: Texture = load("res://assets/images/gear/%s.png" % weapontype)

static var WEAPON_ICONS: Dictionary = {
	Type.Axe: range(5),
	Type.Axe2H:range(3),
	Type.Bow: range(5),
	Type.Crossbow: range(4),
	Type.Dagger: range(10),
	#Type.Offhand: [70,71,72,73,74,75,76,77,78,79],
	Type.Mace: range(8),
	Type.Mace2H: range(11),
	Type.Staff: [0,1,2,3,4,5,6],
	Type.Sword: [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],
	#Type.Sword: [60,61,62,63,64,65,66,67,68,69],
	Type.Sword2H: range(5),
	Type.Scythe: range(5),
	Type.Scythe2H: range(4),
	Type.Wand: range(6),
	Type.Polearm: range(6),
}

func _get_max_sockets() -> int:
	match(weapontype):
		Type.Axe2H, Type.Bow, Type.Crossbow, Type.Mace2H, Type.Staff, Type.Sword2H, Type.Scythe2H, Type.Polearm, Type.Sword:
			return 2
		_:
			return 1


func _get_type() -> String:
	match(weapontype):
		Type.Axe2H:
			return "Two-Handed Axe"
		Type.Mace2H:
			return "Two-Handed Mace"
		Type.Sword2H:
			return "Two-Handed Sword"
		Type.Scythe2H:
			return "Two-Handed Scythe"
	return Type.keys()[weapontype]
