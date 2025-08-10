class_name Affix extends RefCounted

@export var stat: String
@export var type: Type
@export var min_amount: float
@export var max_amount: float
@export var amount: float
@export var template_string: String:
	get:
		match(type):
			Type.Percent:
				return "+{amount}% {stat}"
			Type.Stat:
				return "+{amount} {stat}"
		return "Affix Modifier"

var label: String:
	get:
		return template_string.format({
			"amount": ("%.2f" % amount) if (type == Type.Percent) else ("%d" % amount),
			"stat": stat.replace("_", " ")
		})


enum Type {
	Percent,
	Stat
}

enum Stat {
	Dexterity,
	Intelligence,
	Strength,
	Willpower,
	All_Stats
}

static var PERCENT_STATS: Dictionary = {
	"Total Armor": {
		"min": 2.0,
		"max": 4.8
	},
	"Damage": {
		"min": 4.4,
		"max": 10.0
	},
	"Attack Speed": {
		"min": 4.4,
		"max": 10.0
	},
	"Basic Skill Attack Speed": {
		"min": 4.4,
		"max": 10.0
	},
}

static func roll_affix() -> Affix:
	var affix = Affix.new()
	var affix_type = Type.values().pick_random()
	affix.type = affix_type
	var _stat
	var data
	match(affix_type):
		Type.Percent:
			_stat = PERCENT_STATS.keys().pick_random()
			data = PERCENT_STATS.get(_stat)
			affix.min_amount = data.min
			affix.max_amount = data.max
			affix.amount = randf_range(affix.min_amount, affix.max_amount)
		Type.Stat:
			_stat = Stat.keys().pick_random()
			affix.stat = _stat 
			data = [
				{
					"min": 28,
					"max": 42
				},
				{
					"min": 38,
					"max": 52
				}
			].pick_random()
			affix.min_amount = data.min
			affix.max_amount = data.max
			affix.amount = randi_range(int(affix.min_amount), int(affix.max_amount))
	
	affix.min_amount = data.min
	affix.max_amount = data.max
	affix.amount = randf_range(affix.min_amount, affix.max_amount)
	affix.stat = _stat
	return affix
