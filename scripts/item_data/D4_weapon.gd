class_name Weapon extends MyD4EquipmentData

@export var weapontype: Type = Type.Axe

var category: Category = Category.Weapon

enum Type {
	Axe,
	Axe2H,
	Bow,
	Crossbow,
	Dagger,
	Offhand,
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

static var WEAPON_TEXTURE: Texture = preload("res://assets/images/icons/#1 - Transparent Icons.png")

static var WEAPON_ICONS: Dictionary = {
	Type.Axe: [44,46,47,48,49],
	Type.Axe2H: [44,46,47,48,49],
	Type.Bow: [90,91,92,93,94,95,96,97,98,99],
	Type.Crossbow: [80,81,82,83,84,85,86,87,88,89],
	Type.Dagger: [30,31,32,34,36,37,38,39],
	Type.Offhand: [70,71,72,73,74,75,76,77,78,79],
	Type.Mace: [43,45,50,51,52,53,54,55,56,59],
	Type.Mace2H: [43,45,52,53,54,55,56,59],
	Type.Staff: [0,1,2,3,4,5,6,7,8,9],
	Type.Sword: [60,61,62,63,64,65,66,67,68,69],
	Type.Sword2H: [40,41,60,61,62,63,64,65,66,67,68,69,],
	Type.Scythe: [33,35],
	Type.Scythe2H: [33,35],
	Type.Wand: [10,11,12,13,14,15,16,17,18,19],
	Type.Polearm: [20,21,22,23,24,25,26,27,28,29],
}

func _get_max_sockets() -> int:
	match(type):
		Type.Axe2H, Type.Bow, Type.Crossbow, Type.Mace2H, Type.Staff, Type.Sword2H, Type.Scythe2H, Type.Polearm:
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
