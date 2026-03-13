extends Area2D

@export var question: String = "Call Kristoffer?"
@export var no_message: String = "Not yet…"

func interact(_player: Node) -> void:
	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	if choice_ui == null or dialogue_ui == null:
		return

	choice_ui.ask(question)
	var yes: bool = await choice_ui.chosen

	if yes:
		GameState.ending_title = "Ending 2: The call"
		GameState.mark_ending_seen(2)
		GameState.ending_progress = "Ending 2 of 4"
		GameState.ending_next_scene = "res://MainMenu.tscn"
		GameState.ending_image_path = "res://Endings/ending2.png" # eller der filen ligger
		GameState.ending_story_text = "Kris: Beatrice happy birthay!!! I love you sooo much \n you truly are the love of my life and I can't wait for us to be togheter IRL. \n I hope you had an amazing day, and this celebration might be one of the last ones online. \n I love you with all my heart. Te amo, jeg elsker deg."   # teksten du vil vise på bildet-skjermen
		GameState.ending_music_path = "res://Musikk/Ending2.ogg" # kan være tom nå
		get_tree().change_scene_to_file("res://ending_scene.tscn")
	else:
		dialogue_ui.show_message(no_message)
