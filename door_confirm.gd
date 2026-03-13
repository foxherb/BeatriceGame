extends Area2D

@export var question: String = "Go through the door?"
@export var target_scene: String = ""
@export var cancel_text: String = "Not yet."

var _busy := false

func _on_body_entered(body: Node2D) -> void:
	if _busy:
		return
	if not body.is_in_group("player"):
		return

	_busy = true
	call_deferred("_ask_and_go")

func _ask_and_go() -> void:
	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")

	if choice_ui == null or dialogue_ui == null:
		_busy = false
		return

	choice_ui.ask(question)
	var yes: bool = await choice_ui.chosen

	if yes:
		get_tree().call_deferred("change_scene_to_file", target_scene)
	else:
		dialogue_ui.show_message(cancel_text)
		_busy = false
