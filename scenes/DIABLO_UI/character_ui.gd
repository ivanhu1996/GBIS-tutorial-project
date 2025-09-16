extends Control

@export var items: Array[ItemData]
var rotate_shader: ShaderMaterial = preload("res://assets/images/gear/Rotate_shader.tres")
var overlay_shader: ShaderMaterial = preload("res://scenes/UI/shader/color_overlay_sahder.tres")
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

func generate_item(item: ItemData) -> ItemData:
	#var category :String = item.type
	var category :int = item.category
	var atlas: AtlasTexture = AtlasTexture.new()
	#var weapontype: String

	match(category):
		MyD4EquipmentData.Category.Gem:
			item.gemtype = Gem.Type.values().pick_random()
			item.type=Gem.Type.keys()[item.gemtype]
			item.quality = Gem.Quality.values().pick_random()
			item.salvageable = false
			item.item_name = "{quality}{spacer}{type}".format({
				"quality": "" if item.quality == Gem.Quality.Normal else Gem.Quality.keys()[item.quality],
				"spacer": "" if item.quality == Gem.Quality.Normal else " ",
				"type": Gem.Type.keys()[item.gemtype]
			})
			item.quantity = randi_range(1, 3)
			return item
			
		MyD4EquipmentData.Category.Weapon:
			#item = Weapon.new()
			#item.weapontype = Weapon.Type.values().pick_random()
			item.weapontype = Weapon.Type.values().pick_random()

			#待补全素材 将武器不限于剑
			#item.weapontype=6
			item.type=Weapon.Type.keys()[item.weapontype]
			atlas.atlas = Weapon.WEAPON_TEXTURE[item.weapontype]["texture"]
			var icon_size = Weapon.WEAPON_TEXTURE[item.weapontype]["size"]
			#get TEXTURES col & row
			var col = int(atlas.atlas.get_size().x/icon_size.x)
			#var row =int(atlas.atlas.get_size().y/icon_size.y)
			#atlas.atlas = Weapon.WEAPON_TEXTURE
			item.icon_index = Weapon.WEAPON_ICONS[item.weapontype].pick_random()
			atlas.region = Rect2((item.icon_index % col) * icon_size.x, (item.icon_index / col) * icon_size.y, icon_size.x, icon_size.y)
			#atlas.region = Rect2((item.icon_index % 4) * 256, (item.icon_index / 4) * 256, 256, 256)
			item.icon=atlas
			
		MyD4EquipmentData.Category.Armor:
			#item = Armor.new()
			item.armortype = Armor.Type.values().pick_random()
			item.type=Armor.Type.keys()[item.armortype]
			atlas.atlas = Armor.ARMOR_TEXTURE[item.armortype]["texture"]
			var icon_size = Armor.ARMOR_TEXTURE[item.armortype]["size"]
			var col = int(atlas.atlas.get_size().x/icon_size.x)
			item.icon_index = Armor.ARMOR_ICONS[item.armortype].pick_random()
			atlas.region = Rect2((item.icon_index % col) * icon_size.x, (item.icon_index / col) * icon_size.y, icon_size.x, icon_size.y)
			item.icon=atlas
			
		MyD4EquipmentData.Category.Jewelry:
			item.jewelrytype = Jewelry.Type.values().pick_random()
			item.type=Jewelry.Type.keys()[item.jewelrytype]
			atlas.atlas = Jewelry.JEWELRY_TEXTURE[item.jewelrytype]["texture"]
			var icon_size = Jewelry.JEWELRY_TEXTURE[item.jewelrytype]["size"]
			var col = int(atlas.atlas.get_size().x/icon_size.x)
			item.icon_index = Jewelry.JEWELRY_ICONS[item.jewelrytype].pick_random()
			atlas.region = Rect2((item.icon_index % col) * icon_size.x, (item.icon_index / col) * icon_size.y, icon_size.x, icon_size.y)
			item.icon=atlas
			
	item.image = atlas
	item.icon=atlas
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
	var item: ItemData
	#var atlas: AtlasTexture = AtlasTexture.new()
	#var type: int
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

#func rotate_texture(tex: Texture2D, angle_deg: float) -> Texture2D:
	## 创建 SubViewport
	#var vp := SubViewport.new()
	#vp.disable_3d = true
	#vp.transparent_bg = true
	#vp.size = Vector2(tex.get_width(), tex.get_height()) * 2  # 放大避免裁剪
	#vp.render_target_update_mode = SubViewport.UPDATE_ONCE
#
	## 添加 Sprite2D 显示贴图并旋转
	#var sprite := Sprite2D.new()
	#sprite.texture = tex
	#sprite.centered = true
	#sprite.position = vp.size / 2
	#sprite.rotation_degrees = angle_deg
	#vp.add_child(sprite)
#
	## 临时挂到场景树渲染
	#get_tree().root.add_child(vp)
	#await get_tree().process_frame
#
	## 获取渲染结果
	#var img := vp.get_texture().get_image()
	#get_tree().root.remove_child(vp)
#
	#return ImageTexture.create_from_image(img)

func _on_button_add_test_items_pressed() -> void:
	for item in items:
		if item is Gem:
			item = item.duplicate()
			item = generate_item(item)
			(item as ItemData).shader_params = {"enable_gem_rarity": true,"gem_color": item.color}
		elif "category" in item:
			if randi_range(1, 100) > 50:                      
				item = item.duplicate()
				item = generate_item(item)
				(item as ItemData).shader_params = {"enable_excellent": true,"enable_rarity": true,"rarity_color": item.RARITY_COLORS[item.rarity]}
			else:
				item = item.duplicate()
				item= generate_item(item)
				(item as ItemData).shader_params = {"enable_rarity": true,"rarity_color": item.RARITY_COLORS[item.rarity]}
		#print(item.item_name)
		#print(item.compound_category)
		#print(item.class_strings)
		#if item.affixes:
			#for affix in item.affixes:
				##print(affix.label)
		##print("\n")
		GBIS.add_item("inv_test", item)

func _on_button_save_pressed() -> void:
	GBIS.save()

func _on_button_load_pressed() -> void:
	GBIS.load()
	
