extends Control

@export var forest_scene: String = "res://norway_forest.tscn" # you will make later
@onready var label: Label = $Label

var _step := 0

func _ready() -> void:
	label.text = "Omg what happened, this must have been a portal, but I couldn’t resist after I saw it, I just had to go through. Hopefully I’ll get somewhere nice."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _unhandled_input(event: InputEvent) -> void:
	if not (event.is_action_pressed("confirm") or event.is_action_pressed("interact")):
		return

	if _step == 0:
		_step = 1
		label.visible = false
		await get_tree().create_timer(2.0).timeout
		# If forest doesn't exist yet, you can temporarily go back to menu or a placeholder
		if ResourceLoader.exists(forest_scene):
			get_tree().change_scene_to_file(forest_scene)
		else:
			get_tree().quit()
