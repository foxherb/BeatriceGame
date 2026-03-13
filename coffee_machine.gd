extends Area2D

@export var question: String = "Do I want some coffee?"

var had_coffee: bool = false

func interact(player: Node) -> void:
	var choice_ui = get_tree().current_scene.get_node("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node("Ui/DialogueUI")

	# If already drank coffee once
	if had_coffee:
		dialogue_ui.show_message("I shouldn’t drink more coffee now.")
		return

	# Ask only when player presses interact
	choice_ui.ask(question)
	var result: bool = await choice_ui.chosen

	if result:
		player.apply_speed_boost(1.5)
		had_coffee = true
		dialogue_ui.show_message("Coffee acquired. Zoom zoom.")
	else:
		dialogue_ui.show_message("No coffee for now.")
