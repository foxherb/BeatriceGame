extends Node2D

@export var shake_time: float = 2.0
@export var shake_strength: float = 6.0

@export var message_before: String = "Beatrice: Oh, it's my birthday today, wish I didn't have to go to uni today ;("
@export var message_after: String = "Beatrice: Wow, was that an earthquake on my birthday. Well, guess it can only go up from here."

@onready var player := $Player
@onready var camera: Camera2D = $Player/Camera2D
@onready var dialogue_ui := $Ui/DialogueUI

var _rng := RandomNumberGenerator.new()
var _base_offset: Vector2

func _ready() -> void:
	if GameState.bedroom_intro_done:
		return
	GameState.bedroom_intro_done = true
	_rng.randomize()
	_base_offset = camera.offset
	_run_intro()
	MusicPlayer.play_music("res://Musikk/Chile.ogg", GameState.music_volume_db)

func _run_intro() -> void:
	# lock player controls
	player.set_physics_process(false)

	# Message 1
	dialogue_ui.show_message(message_before)
	await dialogue_ui.closed

# Start lyd samtidig som shake starter
	SFXPlayer.play_sfx("res://SFX/earthquake.ogg", -6.0)

	# Shake for shake_time seconds
	var end_time := Time.get_ticks_msec() + int(shake_time * 1000.0)
	while Time.get_ticks_msec() < end_time:
		_shake_once()
		await get_tree().create_timer(1.0 / 30.0).timeout


	# Stop shake
	camera.offset = _base_offset

	# Message 2
	dialogue_ui.show_message(message_after)
	await dialogue_ui.closed

	# unlock controls
	player.set_physics_process(true)

func _shake_once() -> void:
	camera.offset = _base_offset + Vector2(
		_rng.randf_range(-shake_strength, shake_strength),
		_rng.randf_range(-shake_strength, shake_strength)
	)
