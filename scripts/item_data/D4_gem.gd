class_name Gem extends Socketable

@export var gemtype: Type = Type.Diamond
@export var quality: Quality = Quality.Crude:
	set(qual):
		quality = qual
		level_requirement = LEVEL_REQUIREMENTS[quality]

enum Type {
	Diamond,
	Saphire,
	Ruby,
	Emerald,
	Amethyst,
	Topaz
}

enum Quality {
	Crude,
	Chipped,
	Normal,
	Flawless,
	Royal
}

var LEVEL_REQUIREMENTS = [
	15,
	20,
	40,
	50,
	60
]

var texture = preload("res://assets/images/icons/UI_GemsBTile.png")

var COLORS: Array[Color] = [
	Color(.68, .66, .62),
	Color(0, .23, .96),
	Color(.8, .12, .16),
	Color(.07, .58, .05),
	Color(.51, 0, .81),
	Color(.83, .57, .15)
]

var category: Category = Category.Gem

var color: Color:
	get:
		return COLORS[gemtype]


func _init() -> void:
	stackable = true
	value = 4
	image = texture
	
	
func _get_compound_category() -> String:
	return "Gem"
	
	
func _get_type() -> String:
	return Type.keys()[gemtype]
