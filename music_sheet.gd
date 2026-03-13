extends Area2D

@export var sheet_id: String = "sheet_1"
@export var pickup_question: String = "Beatrice: It looks like a music sheet. Do you want to pick it up?"
@export var picked_message: String = "Beatrice: I picked it up."
@export var already_message: String = "Beatrice: I already took this."

func _ready() -> void:
	# If already collected, remove it when the scene loads
	if GameState.sheets_collected.has(sheet_id):
		queue_free()

func interact(_player: Node) -> void:
	var choice_ui = get_tree().current_scene.get_node_or_null("Ui/ChoiceUI")
	var dialogue_ui = get_tree().current_scene.get_node_or_null("Ui/DialogueUI")
	if choice_ui == null or dialogue_ui == null:
		return

	# Safety: if somehow already collected
	if GameState.sheets_collected.has(sheet_id):
		dialogue_ui.show_message(already_message)
		return

	choice_ui.ask(pickup_question)
	var yes: bool = await choice_ui.chosen

	if yes:
		GameState.sheets_collected[sheet_id] = true
		dialogue_ui.show_message(picked_message)
		queue_free()
	else:
		# Do nothing, stays on the ground
		pass
