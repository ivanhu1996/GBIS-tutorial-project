extends Control

@export var items: Array[ItemData]

#@onready var inventory: ColorRect = $Inventory
#@onready var character: ColorRect = $Character

#func _on_button_close_inventory_pressed() -> void:
	#inventory.hide()

#func _on_button_close_character_pressed() -> void:
	#character.hide()
#
#func _on_button_toggle_inventory_pressed() -> void:
	#inventory.visible = not inventory.visible
#
#func _on_button_toggle_character_info_pressed() -> void:
	#character.visible = not character.visible
var prefixes: Array = [
	"",
	"Shadow",
	"Guardian‘s",
	"Swift",
	"Phoenix",
	"Steadfast",
	"Hearty",
	"Wise",
	"Great",
	"Prophetic",
	"Glowing",
	"Slayer's",
	"Hero's"
	]

var suffixes: Array = [
	"",
	"of Endurance",
	"of Fast",
	"of Sacred Redemption",
	"of Control",
	"of Destruction",
	"of Plenty",
	"of Speed",
	"of Desire"
	]

func generate_item(item: MyD4EquipmentData) -> MyD4EquipmentData:
	var category :String = item.type
	var atlas: AtlasTexture = AtlasTexture.new()
	#var weapontype: String
	match(category):
		MyD4EquipmentData.Category.Weapon:
			item = Weapon.new()
			item.weapontype = Weapon.Type.values().pick_random()
			atlas.atlas = Weapon.WEAPON_TEXTURE
			var i = Weapon.WEAPON_ICONS[item.weapontype].pick_random()
			atlas.region = Rect2((i % 10) * 24, (i / 10) * 24, 24, 24)
		MyD4EquipmentData.Category.Armor:
			item = Armor.new()
			item.armortype = Armor.Type.values().pick_random()
			atlas.atlas = Armor.ARMOR_TEXTURE
			var i = Armor.ARMOR_ICONS[item.armortype].pick_random()
			atlas.region = Rect2((i % 8) * 32, (i / 8) * 32, 32, 32)

	item.image = atlas
	item.item_name = generate_name(item)
	item.power = randi_range(0, 820)
	item.value = randi_range(10000, 200000)
	item.rarity = MyD4EquipmentData.Rarities.values().pick_random()
	item.tier = MyD4EquipmentData.Tiers.values().pick_random()			
	item.level_requirement = randi_range(0, 100)
	item.is_account_bound = randi_range(0,1) == 0
	item.salvageable = true
	item.tradable = (item.rarity != MyD4EquipmentData.Rarities.Unique)
	item.roll()

	for socket in randi_range(0, item.sockets):
	#for socket in item.sockets:
		var gem = generate_gem(D4ItemData.Category.Gem)
		#print(item.sockets)
		#print(gem)
		item.socket(gem)
	#print(item.socketed)
	return item
	
func generate_name(item: MyD4EquipmentData) -> String:
	var prefix = prefixes.pick_random()
	var suffix = suffixes.pick_random()
	return "{pre}{prefix_spacer}{type}{suffix_spacer}{suff}".format({
		"pre": prefix,
		"prefix_spacer": "" if prefix == "" else " ",
		"type": item._get_type(),
		"suff": suffix,
		"suffix_spacer":  "" if suffix == "" else " ",
	})	

func generate_gem(category: D4ItemData.Category) -> D4ItemData:
	var item: D4ItemData
	var atlas: AtlasTexture = AtlasTexture.new()
	var type: int
	match(category):
		D4ItemData.Category.Gem:
			item = Gem.new()
			item.gemtype = Gem.Type.values().pick_random()
			item.quality = Gem.Quality.values().pick_random()
			item.salvageable = false
			item.item_name = "{quality}{spacer}{type}".format({
				"quality": "" if item.quality == Gem.Quality.Normal else Gem.Quality.keys()[item.quality],
				"spacer": "" if item.quality == Gem.Quality.Normal else " ",
				"type": Gem.Type.keys()[item.gemtype]
			})
			item.quantity = randi_range(1, 3)
			return item
	return item
	
func _on_button_add_test_items_pressed() -> void:
	for item in items:
		if randi_range(1, 100) > 50:                      
			item = item.duplicate()
			item=generate_item(item)
			(item as ItemData).shader_params = {"enable_excellent": true,"rarity_color": item.RARITY_COLORS[item.rarity]}
		else:
			item = item.duplicate()
			item=generate_item(item)
			(item as ItemData).shader_params = {"rarity_color": item.RARITY_COLORS[item.rarity]}
		print(item.item_name)
		print(item.compound_category)
		print(item.class_strings)
		if item.affixes:
			for affix in item.affixes:
				print(affix.label)
		print("\n")
		GBIS.add_item("inv_test", item)

func _on_button_save_pressed() -> void:
	GBIS.save()

func _on_button_load_pressed() -> void:
	GBIS.load()
	
