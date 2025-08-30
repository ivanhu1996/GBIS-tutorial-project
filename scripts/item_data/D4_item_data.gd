extends ItemData
class_name D4ItemData

@export_group("basic attribute")
@export var description: String

#@export var image: Texture2D
@export var quantity: int = 1
@export var stackable: bool = false
@export var value: int = 1
@export var rarity: Rarities = Rarities.Common
@export var tier: Tiers = Tiers.Normal
@export var level_requirement: int = 1
@export var tradable: bool = true
@export var salvageable: bool = true
@export var is_account_bound: bool = false
@export_flags(
	"Barbarian",
	"Druid",
	"Necromancer",
	"Rogue",
	"Sorcerer",) var class_restrictions = 0

var class_strings = "Classes: ":
	get:
		var class_string = []
		for _id in Classes.size():
			var _class = Classes.values()[_id]
			if _class and (class_restrictions & _class) == _class:
				var key = Classes.keys()[_id]
				class_string.append(str(key))
		return ", ".join(class_string)

var compound_category = "":
	get:
		return _get_compound_category()

enum Classes {
	None = 0x0,
	Barbarian = 0x1,
	Druid = 0x2,
	Necromancer = 0x4,
	Rogue = 0x8,
	Sorcerer = 0x16,
}

enum Category {
	Item,
	Armor,
	Weapon,
	Jewelry,
	Gem
}

enum Tiers {
	Normal,
	Sacred,
	Ancestral
}

enum Rarities {
	Common,
	Magic,
	Rare,
	Legendary,
	Unique
}

static var RARITY_COLORS: Array[Color] = [
	Color(.3, .3, .3, 1),
	Color(.18, .23, .63, 1),
	Color(.58, .5, .0, 1),
	Color(.56, .21, .0, 1),
	Color(.54, .34, .12, 1),
]

#需重写
func _get_compound_category() -> String:
	return "Item"
	
#需重写
func _get_type() -> String:
	return "Item"
