extends ColorRect

@onready var item_name_label: Label = %ItemNameLabel
@onready var item_attribute: Label = %Itemattribute


func _ready() -> void:
	hide()
	GBIS.sig_item_focused.connect(func(item_data: ItemData, container_name: String): 
		#show()
		if GBIS.shop_names.has(container_name):
			item_name_label.text = "[Shop] %s" % item_data.item_name
		else:
			item_name_label.text = item_data.item_name
			#item_attribute.text = item_data.compound_category
			)
	#GBIS.sig_item_focus_lost.connect(func(_item_data: ItemData): hide())
	

func _process(_delta: float) -> void:
	position = get_global_mouse_position() + Vector2(5, 5)
