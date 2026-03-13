extends Area2D

@export var target_scene: String = "res://apartment_inside.tscn"
@export var spawn_name_in_target: String = "Spawn_From_Outside"

@export var question: String = "Beatrice: Hmm… I think this is Kristoffers house, but if I go in I’m sure I won’t leave.\nI want to see him so bad, but I want to be sure that I’m ready.\n\nAm I ready?"
@export var no_message: String = "Beatrice: Not yet… I should take one more look around."

func interact(_player: Node) -> void:
	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	if choice_ui == null or dialogue_ui == null:
		return

	choice_ui.ask(question)
	var yes: bool = await choice_ui.chosen 

	if yes:
		GameState.next_spawn_name = spawn_name_in_target
		get_tree().change_scene_to_file(target_scene)
	else:
		dialogue_ui.show_message(no_message)
