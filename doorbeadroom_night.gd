extends Area2D

@export var message: String = "Beatrice: I really should go to my computer… or go to bed."

func interact(_player: Node) -> void:
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	if dialogue_ui != null:
		dialogue_ui.show_message(message)
