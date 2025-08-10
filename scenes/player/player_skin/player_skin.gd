extends Node3D
class_name PlayerSkin

@onready var damage_timer: Timer = $DamageTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var hit_box: HitBox = $HitBox

var equipments: Dictionary[String,Node3D] = {
	"Small Shield": $Rig/Skeleton3D/Badge_Shield,
	"Small Sword": $"Rig/Skeleton3D/1H_Sword",
	"Iron Helmet":$Rig/Skeleton3D/Knight_Helmet,
	"Silk Cape":$Rig/Skeleton3D/Knight_Cape
}

var state_machine: AnimationNodeStateMachinePlayback

var is_attacking: bool = false

func _ready() -> void:
	state_machine = animation_tree["parameters/playback"]
	GBIS.sig_slot_item_equipped.connect(_on_equipped)
	GBIS.sig_slot_item_unequipped.connect(_on_unequipped)

func _on_equipped(slot_name: String, item_data: ItemData) -> void:
	equipments[item_data.item_name].show()

func _on_unequipped(slot_name: String, item_data: ItemData) -> void:
	equipments[item_data.item_name].hide()

var linear_velocity: float = 0:
	set(value):
		animation_tree.set("parameters/Idle And Move/blend_position", value)

func attack() -> void:
	animation_tree.set("parameters/conditions/attack", true)

func stop_attack() -> void:
	animation_tree.set("parameters/conditions/attack", false)

func _process(_delta: float) -> void:
	var was_attacking = is_attacking
	is_attacking = state_machine.get_current_node() == "Attack"
	if is_attacking and not was_attacking:
		damage_timer.start()
