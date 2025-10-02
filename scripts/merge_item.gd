class_name MergeItem extends Control

#func _ready() -> void:
	#GBIS.sig_item_focused.connect(func(item_data: ItemData, container_name: String):
		#
		#GBIS.sig_merge_item_info.connect(func(item_data: ItemData,container_name: String,grid_id: Vector2i):
			#if item_data and has_property(item_data,"socketed"):
				#print(GBIS.moving_item_service.moving_item.item_name)
				#print(item_data.item_name)
				#print(item_data.socketed)
			#)
		#)
#
#func has_property(obj: Object, name: String) -> bool:
	#return obj.get_property_list().any(func(p): return p.name == name)
