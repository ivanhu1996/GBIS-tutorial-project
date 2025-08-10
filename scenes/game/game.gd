extends Node3D
class_name Game

@export var enemy_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_container: Node = $EnemyContainer
@onready var droppable_container: Node = $DroppableContainer
@onready var inventory: ColorRect = $UI/Inventory
@onready var player_info: ColorRect = $UI/PlayerInfo

var enemies: Array[Enemy] = []

func throw_item(item_data: ItemData) -> void:
	var rad = randf_range(0,2*PI)
	var x = cos(rad)*1.5
	var z = sin(rad)*1.5
	var drop_position = Global.player.position +Vector3(x,0,z)
	var drop = Droppable.new_drop(drop_position,item_data)
	droppable_container.add_child(drop)
	
	
func _ready() -> void:
	Global.game=self
	spawn_timer.timeout.connect(_spawn)
	inventory.hide()
	player_info.hide()
	_spawn()
	#GBIS.current_inventories = [Global.player.inv_name]

func _spawn() -> void:
	if enemies.size() < 2:
		var enemy: Enemy = enemy_scene.instantiate()
		enemy.position = Vector3(randf_range(-4.5, 4.5), 0, randf_range(-4.5, 4.5))
		enemy_container.add_child(enemy)
		enemies.append(enemy)
		enemy.sig_dead.connect(_on_enemy_dead)

func _on_enemy_dead(dead_enemy: Enemy) -> void:
	#print("drop sth")
	var drop : Droppable = Droppable.new_drop(dead_enemy.position)
	droppable_container.add_child(drop)
	await get_tree().create_timer(1).timeout
	enemies.erase(dead_enemy)
	dead_enemy.queue_free()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		inventory.visible = not inventory.visible
	if event.is_action_pressed("open_player_info"):
		player_info.visible = not player_info.visible
