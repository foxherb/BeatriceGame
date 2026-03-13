extends Node2D

@export var pan_time: float = 1.2

@onready var player := $Player
@onready var player_camera: Camera2D = $Player/Camera2D
@onready var cutscene_camera: Camera2D = $CutsceneCamera
@onready var dialogue_ui := $Ui/DialogueUI

@onready var cam_start: Marker2D = $CutscenePoints/CamStart
@onready var main_door_focus: Marker2D = $CutscenePoints/MainDoorFocus
@onready var garden_focus: Marker2D = $CutscenePoints/GardenFocus

func _ready() -> void:
	if GameState.living_room_intro_done:
		return
	GameState.living_room_intro_done = true
	run_intro()

func run_intro() -> void:
	player.set_physics_process(false)

	player_camera.enabled = false
	cutscene_camera.enabled = true
	cutscene_camera.global_position = cam_start.global_position

	# 1) Small starter text
	dialogue_ui.show_message("Beatrice: Finally out of my room…")
	await dialogue_ui.closed

	# 2) Pan to main door, then talk about uni
	await _pan_to(main_door_focus.global_position)
	dialogue_ui.show_message("Beatrice: I really need to hurry and get to uni.")
	await dialogue_ui.closed

	# 3) Pan to garden, then talk about the garden
	await _pan_to(garden_focus.global_position)
	dialogue_ui.show_message("Beatrice: Oh… what’s that in the garden? I think I can see something. Maybe I should check it out.")
	await dialogue_ui.closed

	# Give control back (no flash)
	cutscene_camera.enabled = false
	player_camera.enabled = true
	player.set_physics_process(true)


func _pan_to(target_pos: Vector2) -> void:
	var t := create_tween()
	t.tween_property(cutscene_camera, "global_position", target_pos, pan_time)
	await t.finished


func _on_door_bedroom_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_door_uni_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_door_garden_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
