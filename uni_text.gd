extends Control

@export var next_scene: String = "res://Bedroom_Night.tscn"

func _ready() -> void:
	SFXPlayer.play_sfx("res://SFX/Uni.ogg", -6.0)
	$Label.text = "Beatrice: I went to uni. It was a long day, but it was nice talking to Kristoffer in the breaks.\n\nHe said he wasn’t going to bed before I came home today, so I gotta go see him and tell him to go to bed now."
	$Label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		get_tree().change_scene_to_file(next_scene)
