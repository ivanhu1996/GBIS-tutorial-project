extends Area3D
class_name Droppable

static var scene: PackedScene = preload("res://scenes/droppable/droppable.tscn")

static var drop_list: Array[ItemData] = [
	preload("res://resource/small_sword.tres"),
	preload("res://resource/small_shield.tres"),
	preload("res://resource/iron_helmet.tres"),
	preload("res://resource/silk_cape.tres")
]

@onready var model: Node3D = $Model

var data : ItemData

static func new_drop(potion: Vector3, item_data: ItemData = null) -> Droppable:
	var item_to_drop :Droppable = scene.instantiate()
	item_to_drop.position = potion
	if item_data:
		item_to_drop.data = item_data
	return item_to_drop
	
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	if not data:
		data = drop_list.pick_random() as MyEquipmentData
		#print(data)
	model.add_child(data.drop_model.instantiate())
	await get_tree().create_timer(60).timeout
	queue_free()
	
func _on_body_entered(_body: Node3D) -> void:
	#闪光
	if randi_range(1, 100) > 50:
		data = data.duplicate()
		(data as ItemData).shader_params = {"enable_enhance": true}
	GBIS.add_item(Global.player.inv_name,data)
	queue_free()
