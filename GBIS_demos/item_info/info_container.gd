extends Panel

@onready var content_box: VBoxContainer = $MarginContainer/VBoxContainer

func _process(_delta):
	# 自动根据内容调整 Panel 的最小大小
	#print(content_box.size.y)
	#size.y = content_box.get_combined_minimum_size().y
	size.y = content_box.size.y
