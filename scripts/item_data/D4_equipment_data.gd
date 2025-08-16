extends EquipmentData
## 装备数据基类，你的装备数据类应该继承此类
class_name D4EquipmentData

@export_group("item attribute")
@export var description: String
@export var image: Texture
@export var quantity: int = 1
@export var stackable: bool = false
@export var value: int = 1
@export var rarity: Rarities = Rarities.Common
@export var tier: Tiers = Tiers.Normal
@export var level_requirement: int = 1
@export var is_account_bound: bool = false
@export var tradable: bool = true
@export var salvageable: bool = true

@export var gem_socket_icon: Texture2D
@export var gem_icon: Texture2D

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

#ITEM
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
func _get_type() -> String:
	return "Item"
#end Item

@export_group("gear attribute")
@export var power: int = 0
@export var affix_count: int = 0
@export var equipped_state: bool = false

static var AFFIX_COUNTS: Dictionary = {
	 Rarities.Common: {
		"min": 0,
		"max": 0
	},
	Rarities.Magic: {
		"min": 1,
		"max": 2
	},
	Rarities.Rare: {
		"min": 2,
		"max": 4
	},
	Rarities.Legendary: {
		"min": 4,
		"max": 4
	},
	Rarities.Unique: {
		"min": 4,
		"max": 4
	}
}

@export var upgrades: int = 0

@export var max_upgrades: int = 0:
	get:
		return _get_max_upgrades()
		
@export var sockets: int = 0
		
@export var max_sockets: int = 2:
	get:
		return _get_max_sockets()
		
@export var socketed: Array[Socketable] = []

@export var durability: int = 100
@export var max_durability: int = 100

var affixes: Array[Affix] = [
]

var breakpoint_tier: int:
	get:
		if power < 150:
			return 1
		elif power < 340:
			return 2
		elif power < 460:
			return 3
		elif power < 625:
			return 4
		elif power < 725:
			return 5
		return 6

var min_ranges: Dictionary = {
	Tiers.Normal: 0,
	Tiers.Sacred: 600,
	Tiers.Ancestral: 685
}

var max_ranges: Dictionary = {
	Tiers.Normal: 620,
	Tiers.Sacred: 720,
	Tiers.Ancestral: 820
}

var rolled = false
	

func _get_max_sockets():
	return 1

#
func _get_max_upgrades():
	match(tier):
		Tiers.Normal:
			match(rarity):
				Rarities.Common:
					return 0
				Rarities.Magic:
					return 2
				Rarities.Rare:
					return 3
				Rarities.Legendary:
					return 4
				Rarities.Unique:
					return 5
		_:
			return 5



#需重写
func _get_compound_category() -> String:
	var _tier = Tiers.keys()[tier]
	var _rarity = Rarities.keys()[rarity]
		   
	return "{tier}{rarity}{type}".format({
		"tier": "%s " % _tier if tier != Tiers.Normal else "",
		"rarity": "%s " % _rarity if rarity != Rarities.Common else "",
		"type": _get_type()
	})

func roll_affixes() -> void:
	affixes.clear()
	var affix_tier = AFFIX_COUNTS[rarity]
	for _i in randi_range(affix_tier.min, affix_tier.max):
		var has_affix = true
		var affix
		while(has_affix):
			affix = Affix.roll_affix()
			has_affix = affixes.any(func(a: Affix):
				return a.stat == affix.stat
			)
		affixes.append(affix)
		
#inventory.gd使用方法
#var item: MyD4EquipmentData
#item.roll()

func roll() -> void:
	sockets = randi_range(0, max_sockets)
	upgrades = randi_range(0, max_upgrades)
	roll_affixes()
	rolled = true
	
	
func socket(item: Socketable) -> void:
	if socketed.size() < sockets:
		socketed.append(item)
	return



## 检测装备是否可用，需重写
func test_need(slot_name: String) -> bool:
	push_warning("[Override this function] [%s] test passed." % slot_name)
	return true

## 装备时调用，需重写；也可以使用 GBIS.sig_slot_item_equipped 信号行处理
func equipped(slot_name: String) -> void:
	push_warning("[Override this function] equipped item [%s] at slot [%s]" % [item_name, slot_name])

## 脱装备时调用，需重写；也可以用 GBIS.sig_slot_item_unequipped 信号进行处理
func unequipped(slot_name: String) -> void:
	push_warning("[Override this function] unequipped item [%s] at slot [%s]" % [item_name, slot_name])
