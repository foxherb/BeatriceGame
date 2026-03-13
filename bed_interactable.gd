extends Area2D

@export var question: String = "Am I sure I want to go to bed? Kristoffer said he wanted to talk."
@export var yes_ending_message: String = "Ending 1: Bed ending\nEnding 1 of 4"
@export var no_message: String = "No… I should talk to him first."

var used := false

func interact(_player: Node) -> void:
	# Optional: stop spamming the choice after you've already ended it
	if used:
		return

	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")

	if choice_ui == null or dialogue_ui == null:
		return

	choice_ui.ask(question)
	var yes: bool = await choice_ui.chosen

	if yes:
		GameState.ending_title = "Ending 1: Bed ending"
		GameState.mark_ending_seen(1)
		GameState.ending_progress = "Ending 1 of 4"
		GameState.ending_next_scene = "res://MainMenu.tscn" # or credits later
		GameState.ending_image_path = "res://Endings/ending1.png" # eller der filen ligger
		GameState.ending_story_text = "Beatrice: I wish I could have seen Kristoffer today, but Uni ended so late \n Well he told me we would celebrate this weekend, even though I don't really want to. \n Will be amazing to see him again."   # teksten du vil vise på bildet-skjermen
		GameState.ending_music_path = "res://Musikk/Ending1.ogg" # kan være tom nå
		get_tree().change_scene_to_file("res://ending_scene.tscn")

	else:
		dialogue_ui.show_message(no_message)
