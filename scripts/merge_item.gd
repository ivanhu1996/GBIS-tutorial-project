class_name MergeItem extends Control

func _ready() -> void:
	GBIS.sig_item_focused.connect(func(item_data: ItemData, container_name: String):
		GBIS.sig_merge_item_info.connect(func(item_data: ItemData,container_name: String,grid_id: Vector2i):
			if item_data:
				print(item_data.item_name)
				print(item_data.socketed)
			)
		)
