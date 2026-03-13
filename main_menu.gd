extends Control

@onready var start_button: Button = $CenterContainer/VBoxContainer/StartButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton
@onready var letter_button: Button = $CenterContainer/VBoxContainer/LetterButton
@onready var gift: AnimatedSprite2D = $AnimatedSprite2D
@onready var intro_bubble: Control = $IntroBubble
@export var first_scene: String = "res://node_2d.tscn"

var starting := false

func _ready() -> void:
	start_button.grab_focus()
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	MusicPlayer.play_music("res://Musikk/MainMenu.ogg", GameState.music_volume_db)

	GameState.load_progress()
	letter_button.disabled = not GameState.all_endings_seen()
	letter_button.pressed.connect(_on_letter_pressed)

	# Sørg for at gaven står på første frame når menyen åpner
	if gift.sprite_frames != null and gift.sprite_frames.has_animation("open_gift"):
		gift.play("open_gift")
		gift.stop()
		gift.frame = 0

func _unhandled_input(event: InputEvent) -> void:
	if starting:
		return

	# Space/Enter bekrefter valgt knapp
	if event.is_action_pressed("confirm"):
		# Unngå repeat hvis man holder inne tasten
		if event is InputEventKey and (event as InputEventKey).echo:
			return

		var f := get_viewport().gui_get_focus_owner()
		if f is Button:
			f.emit_signal("pressed")

		accept_event()

func _on_start_pressed() -> void:
	if starting:
		return
	starting = true

	SFXPlayer.play_sfx("res://SFX/ui_confirm.ogg", -6.0)

	# Skjul tekst + lås meny
	intro_bubble.visible = false
	start_button.disabled = true
	quit_button.disabled = true
	letter_button.disabled = true

	SFXPlayer.play_sfx("res://SFX/box-open.ogg", -6.0)

	# Spill gave-anim
	gift.play("open_gift")
	$CenterContainer.visible = false
	await gift.animation_finished

	# Start spillet
	GameState.reset_run()
	get_tree().change_scene_to_file(first_scene)

func _on_letter_pressed() -> void:
	if starting:
		return
	get_tree().change_scene_to_file("res://letter_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
