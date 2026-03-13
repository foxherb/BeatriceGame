extends Area2D

@export var message: String = "Beatrice: Oh I think I might be in Norway! This place looks like Songsvann, which means I'm pretty close to Kristoffers apartment."

func _on_body_entered(body: Node2D) -> void:
	# Only react to the player
	if not body.is_in_group("player"):
		return

	# Only once (global)
	if GameState.songsvann_trigger_done:
		return
	GameState.songsvann_trigger_done = true

	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	if dialogue_ui != null:
		dialogue_ui.show_message(message)

	# Disable the trigger so it can't fire again in this session
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
