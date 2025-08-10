extends CharacterBody3D
class_name Player

signal sig_player_cause_damage

@export_range(3.0, 12.0, 0.1) var max_speed := 6.0
@export_range(1.0, 50.0, 0.1) var steering_factor := 20.0

@onready var player_skin: PlayerSkin = $PlayerKnight

const GRAVITY := 40.0 * Vector3.DOWN

var inv_name = "inv_1"

func _ready() -> void:
	Global.player = self
	player_skin.damage_timer.timeout.connect(sig_player_cause_damage.emit)

func _physics_process(delta: float) -> void:
	if player_skin.is_attacking:
		velocity = Vector3.ZERO
		return
	_move(delta)
	player_skin.linear_velocity = Vector2(velocity.x, velocity.z).length()

func _move(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_vector.x, 0.0, input_vector.y)
	if direction.length() > 0:
		var target_angle := atan2(direction.x, direction.z)
		player_skin.rotation.y = lerp_angle(player_skin.rotation.y, target_angle, steering_factor * delta)
	var desired_ground_velocity := max_speed * direction
	var steering_vector := desired_ground_velocity - velocity
	steering_vector.y = 0.0
	var steering_amount: float = min(steering_factor * delta, 1.0)
	velocity += steering_vector * steering_amount
	velocity += GRAVITY * delta
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		if not GBIS.has_moving_item() and not Global.game.player_info.visible and not Global.game.inventory.visible:
			#print(GBIS.item_focus_service._current_focus_item)
			player_skin.attack()
	if event.is_action_released("attack"):
		player_skin.stop_attack()
