@tool
class_name Tooltip extends Control

@export var color: Color
@export var item: ItemData
@export var equipped_state : bool
@onready var equipped_plate: Control = %EquippedPlate
#@onready var info_container: MarginContainer = %InfoContainer
@onready var info_container: Panel = %InfoContainer
@onready var bg: ColorRect = %BG
@onready var icon_texture: TextureRect = %IconTexture
@onready var item_name: RichTextLabel = %ItemName
@onready var category: RichTextLabel = %Category
@onready var power: RichTextLabel = %Power
@onready var upgrades: RichTextLabel = %Upgrades
@onready var stat_separator: ColorRect = %StatSeparator
@onready var description: RichTextLabel = %Description
@onready var stat: RichTextLabel = %Stat
@onready var affix_separator: ColorRect = %AffixSeparator
@onready var affix: RichTextLabel = %Affix
@onready var level_requirement: RichTextLabel = %LevelRequirement
@onready var account_bound: RichTextLabel = %AccountBound
@onready var salvageable: RichTextLabel = %Salvageable
@onready var tradable: RichTextLabel = %Tradable
@onready var class_identifier: RichTextLabel = %ClassName
@onready var price: HBoxContainer = %Price
@onready var sell_value: RichTextLabel = %SellValue
@onready var coin_icon: TextureRect = %CoinIcon
@onready var durability: RichTextLabel = %Durability
@onready var gradient_rect: NinePatchRect = %GradientRect
@onready var border_rect: NinePatchRect = %BorderRect

	
@onready var node_map: Dictionary = {
	"item_name": item_name,
	"category": category,
	"power": power,
	"upgrades": upgrades,
	"description": description,
	"stat": stat,
	"affix": affix,
	"level_requirement": level_requirement,
	"account_bound": account_bound,
	"salvageable": salvageable,
	"tradable": tradable,
	"class_identifier": class_identifier,
	"sell_value": sell_value,
	"durability": durability,
}

var SOCKET_CONTAINER: PackedScene = preload("res://scripts/ui_socket.tscn")
var overlay_shader: ShaderMaterial = preload("res://scenes/UI/shader/color_overlay_sahder.tres")

var string_templates: Dictionary:
	get:
		return {
			"item_name": "[b]{item_name}{qty_string}[/b]",
			"category": "{compound_category}",
			"power": "{base_power}{bonus_power_string} Item Power",
			"upgrades": "[b]Upgrades[/b]: {current_upgrades}/{max_upgrades}",
			"description": "{description}",
			"stat": "Stat Modifier",
			"socket_label": "Empty Socket",
			"level_requirement": "Requires Level {level_requirement}",
			"account_bound": "Account Bound",
			"salvageable": "Cannot Salvage",
			"tradable": "Not Tradable",
			"class_identifier": "{class_identifier}",
			"sell_value": "[color=#d5af88]Sell Value[/color]: {sell_value}",
			"durability": "[color=#d5af88]Durability[/color]: {durability}/{max_durability}"
		}


var item_tokens: Dictionary:
	get:
		if !item:
			return {
				"item_name": "Test Item 2000",
				"compound_category": "Sacred Legendary Gloves",
				"base_power": "700",
				"bonus_power_string": "+25" if true else "",
				"current_upgrades": 4,
				"max_upgrades": 5,
				"level_requirement": 80,
				"class_identifier": "Rogue",
				"sell_value": 14000
			}
		else:
			var details: Dictionary = {
				"item_name": item.item_name,
				"qty_string": (" (%d)" % item.quantity) if (item.stackable and item.quantity > 1) else "",
				"compound_category": item.compound_category,
				"level_requirement": item.level_requirement,
				"class_identifier": str(item.class_strings),
				"sell_value": StringHelper.comma_sep(item.value),
			}
			if item is D4EquipmentData:
				var extras: Dictionary = {
					"base_power": item.power,
					"bonus_power_string": "+{power}".format({"power": item.upgrades * 5}) if item.upgrades else "",
					"current_upgrades": item.upgrades if item is D4EquipmentData else 0,
					"max_upgrades": item.max_upgrades if item is D4EquipmentData else 0,
					"durability": item.durability,
					"max_durability": item.max_durability
				}
				details.merge(extras)
			if item is Gem:
				var extras: Dictionary = {
					"description": "Can be inserted into equipment with sockets."
				}
				details.merge(extras)
			return details

var hidden_nodes: Array:
	get:
		var nodes = []
		match(item.category):
			MyD4EquipmentData.Category.Weapon,MyD4EquipmentData.Category.Armor,MyD4EquipmentData.Category.Jewelry,MyD4EquipmentData.Category.Gem:
				nodes.append_array([
					"class_identifier",
					"stat",
					"durability"
				])
			_:
				nodes.append_array([
					"description"
				])
		return nodes


func _ready() -> void:
	_update_tooltip_values()
	
func _update_tooltip_values() -> void:
	if !item:
		return
	icon_texture.texture = item.image
	#print((item as D4EquipmentData).image.get_size())
	#var icon_texture_mat = rotate_shader.duplicate() as ShaderMaterial
	#icon_texture_mat.set_shader_parameter("angle_deg", 0)
	#icon_texture_mat.set_shader_parameter("rotation_deg", -45)
	#icon_texture_mat.set_shader_parameter("atlas_tex", Weapon.WEAPON_TEXTURE)
	#icon_texture_mat.set_shader_parameter("tile_index", Vector2(item.icon_index % 4, item.icon_index / 4))
	#icon_texture.material=icon_texture_mat
	#
	var mat = overlay_shader.duplicate() as ShaderMaterial
	if "rarity" in item:
		var col = MyD4EquipmentData.RARITY_COLORS[item.rarity]
		mat.set_shader_parameter("color", col)
		gradient_rect.material = mat
		border_rect.material = mat
		item_name.add_theme_color_override("default_color", col.lightened(.6))
		category.add_theme_color_override("default_color", col.lightened(.6))
		upgrades.add_theme_color_override("default_color", col.lightened(.6))
	for key in node_map.keys():
		var node = node_map.get(key) as RichTextLabel
		if node:
			var template: String = string_templates.get(key, "")
			node.text = template.format(item_tokens)
			if item:
				if hidden_nodes.has(key):
					node.visible = false
				else:
					match(key):
						"upgrades": 
							node.visible = false if !(item is MyD4EquipmentData) else item.upgrades > 0
						"account_bound":
							node.visible = item.is_account_bound
						"power":
							if item is Gem:
								node.text = ""
						"salvageable":
							node.visible = !item.salvageable
						"tradable":
							node.visible = !item.tradable
						"class_identifier":
							node.visible = item.class_restrictions != 0
	var last_node = affix
	if item is D4EquipmentData:
		for _affix in item.affixes:
			#print(_affix.label)
			var affix_node = affix.duplicate()
			affix_node.text = _affix.label
			last_node.add_sibling(affix_node)
			last_node = affix_node
	match(item.category):
		D4ItemData.Category.Gem:
			var gem_mat = overlay_shader.duplicate() as ShaderMaterial
			gem_mat.set_shader_parameter("color", item.color)
			icon_texture.material = gem_mat
		MyD4EquipmentData.Category.Weapon, MyD4EquipmentData.Category.Armor, MyD4EquipmentData.Category.Jewelry:
			for i in item.sockets:
				var socket = SOCKET_CONTAINER.instantiate()
				var socket_label = "Empty Socket"
				if item.socketed.size() > i:
					var gem: Gem = item.socketed[i] as Gem
					if gem:
						socket.item = gem
						socket_label = gem._get_compound_category()
						#print(gem._get_compound_category())
						#print(gem.quality)
						#print(gem._get_type())
				var hbox := HBoxContainer.new()
				# 可选：设置属性（比如间距）
				hbox.alignment = BoxContainer.ALIGNMENT_BEGIN
				hbox.add_theme_constant_override("separation", 10) # 控件之间的间距
				last_node.add_sibling(hbox)
				last_node = hbox
				var gem_control :=Control.new()
				gem_control.add_child(socket)
				gem_control.custom_minimum_size = socket.custom_minimum_size
				#gem_control.size_flags_vertical = Control.SIZE_EXPAND_FILL
				#gem_control.size_flags_horizontal = Control.SIZE_EXPAND
				last_node.add_child(gem_control)
				var template_label: RichTextLabel = affix
				var richtext : RichTextLabel = template_label.duplicate() as RichTextLabel
				richtext.bbcode_enabled = true
				#var template: String = string_templates.get("socket_label", "")
				#richtext.bbcode_text = template.format(item_tokens)
				richtext.bbcode_text = "{gem_compound_category}".format({
				"gem_compound_category": "%s " % socket_label
				})
				richtext.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				richtext.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
				last_node.add_child(richtext)
				
				#last_node = socket
	equipped_plate.visible = item is MyD4EquipmentData and equipped_state
	info_container.force_update_transform()
	bg.set_deferred("size", Vector2(bg.size.x, info_container.get_rect().size.y))
	
#func _on_info_container_resized() -> void:
	#if info_container and bg:
		#bg.set_deferred("size", Vector2(bg.size.x, info_container.get_rect().size.y))
