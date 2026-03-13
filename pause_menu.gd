extends Control

@onready var continue_button: Button = $UI/Panel/VBoxContainer/Button
@onready var exit_button: Button = $UI/Panel/VBoxContainer/Button2

func _ready() -> void:
	# This lets the menu still receive input while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	# Toggle menu with ESC
	if event.is_action_pressed("pause_menu"):
		toggle()
		get_viewport().set_input_as_handled()
		return

	# Confirm with Space
	if visible and event.is_action_pressed("confirm"):
		var f := get_viewport().gui_get_focus_owner()
		if f is Button:
			f.emit_signal("pressed")
		get_viewport().set_input_as_handled()

func toggle() -> void:
	if visible:
		close_menu()
	else:
		open_menu()

func open_menu() -> void:
	visible = true
	get_tree().paused = true
	continue_button.grab_focus()

func close_menu() -> void:
	visible = false
	get_tree().paused = false

func _on_continue_pressed() -> void:
	close_menu()

func _on_exit_pressed() -> void:
	get_tree().quit()
