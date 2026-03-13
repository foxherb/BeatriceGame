extends Control

signal chosen(result: bool)

@onready var panel: Panel = $Panel
@onready var question: Label = $Panel/Question
@onready var yes_button: Button = $Panel/VBoxContainer/YesButton
@onready var no_button: Button = $Panel/VBoxContainer/NoButton

var is_open := false

func _ready() -> void:
	visible = false
	yes_button.pressed.connect(func(): _pick(true))
	no_button.pressed.connect(func(): _pick(false))

func ask(q: String) -> void:
	question.text = q
	visible = true
	is_open = true
	yes_button.grab_focus()

func _pick(v: bool) -> void:
	visible = false
	is_open = false
	chosen.emit(v)

func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return

	# Space confirms the focused button
	if event.is_action_pressed("confirm"):
		var f := get_viewport().gui_get_focus_owner()
		if f is Button:
			f.emit_signal("pressed")
