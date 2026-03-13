extends CharacterBody2D

@export var speed: float = 200.0
@export var idle_frame_index: int = 1

@export var speed_boost_multiplier: float = 1.5
var _speed_multiplier: float = 1.0

var facing: String = "down"
var nearby_interactable: Area2D = null

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
@onready var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")

@onready var footstep_player: AudioStreamPlayer = $FootstepPlayer
@export var step_interval: float = 0.33
var _step_timer: float = 0.0


func _ready() -> void:
	if GameState.coffee_boost:
		_speed_multiplier = speed_boost_multiplier


func _physics_process(_delta: float) -> void:
	# Freeze movement if a UI is open
	if (dialogue_ui != null and dialogue_ui.is_open) or (choice_ui != null and choice_ui.is_open):
		velocity = Vector2.ZERO
		move_and_slide()
		_step_timer = 0.0
		if footstep_player != null and footstep_player.playing:
			footstep_player.stop()
		return

	# Input
	var input_dir := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	# Move
	velocity = input_dir * speed * _speed_multiplier
	move_and_slide()

	# Direction + animation
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			facing = "right" if velocity.x > 0 else "left"
		else:
			facing = "down" if velocity.y > 0 else "up"

		anim.play("walk_" + facing)
	else:
		anim.play("walk_" + facing)
		anim.stop()
		anim.frame = idle_frame_index

	# Footsteps (steg-lyd med intervall)
	var moving := velocity.length() > 0.0
	if moving:
		_step_timer -= _delta
		if _step_timer <= 0.0:
			if footstep_player != null:
				# Valgfritt: litt variasjon så det ikke høres helt likt ut
				footstep_player.pitch_scale = randf_range(0.95, 1.05)
				footstep_player.play()
			_step_timer = step_interval
	else:
		_step_timer = 0.0

	# Interact (Space)
	if Input.is_action_just_pressed("interact"):
		# Close dialogue if open
		if dialogue_ui != null and dialogue_ui.is_open:
			dialogue_ui.hide_message()

		# Otherwise interact with nearby object
		elif nearby_interactable != null:
			if nearby_interactable.has_method("interact"):
				nearby_interactable.interact(self)
			else:
				if dialogue_ui != null:
					dialogue_ui.show_message(nearby_interactable.message)


func apply_speed_boost(mult: float) -> void:
	_speed_multiplier = mult
	GameState.coffee_boost = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("interactable"):
		nearby_interactable = area


func _on_area_2d_area_exited(area: Area2D) -> void:
	if nearby_interactable == area:
		nearby_interactable = null


func _on_door_path_forest_body_entered(body: Node2D) -> void:
	pass
