extends Control

@export var default_next_scene: String = "res://MainMenu.tscn" # change if yours is different

@onready var title_label: Label = find_child("TitleLabel", true, false) as Label
@onready var progress_label: Label = find_child("ProgressLabel", true, false) as Label

func _ready() -> void:
	if title_label != null:
		title_label.text = GameState.ending_title
	if progress_label != null:
		progress_label.text = GameState.ending_progress

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		var next_scene := GameState.ending_next_scene
		if next_scene == "":
			next_scene = default_next_scene

		get_viewport().set_input_as_handled()

		if next_scene != "" and ResourceLoader.exists(next_scene):
			get_tree().change_scene_to_file(next_scene)
		else:
			get_tree().quit()
