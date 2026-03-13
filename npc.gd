extends Area2D

@export var sheet_id: String = "sheet_3"

@export var intro: String = "??? : …"
@export var question: String = "??? : Looking for this paper?"
@export var give_message: String = "??? : Fine… take it."
@export var no_message: String = "Beatrice: Uh… nevermind."
@export var already_message: String = "??? : I already gave you the paper."

var busy := false

func interact(_player: Node) -> void:
	if busy:
		return
	busy = true

	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	if dialogue_ui == null or choice_ui == null:
		busy = false
		return

	# Hvis allerede tatt
	if GameState.sheets_collected.has(sheet_id):
		dialogue_ui.show_message(already_message)
		await dialogue_ui.closed
		busy = false
		return

	# Intro
	dialogue_ui.show_message(intro)
	await dialogue_ui.closed

	# Spørsmål
	choice_ui.ask(question)
	var yes: bool = await choice_ui.chosen

	# VIKTIG: vent til neste frame så "Space" fra valget ikke lukker neste melding
	await get_tree().process_frame

	if yes:
		dialogue_ui.show_message(give_message)
		await dialogue_ui.closed
		GameState.sheets_collected[sheet_id] = true
	else:
		dialogue_ui.show_message(no_message)
		await dialogue_ui.closed

	busy = false
