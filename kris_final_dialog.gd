extends Area2D

@export var question_ready: String = "Kris: Are you ready to celebrate?"
@export var not_ready_message: String = "Kris: Aww, take your time cutie. I’ll wait here until you’re ready."

@export var ending3_title: String = "Ending 3: Together in Norway"
@export var ending3_progress: String = "Ending 3 of 4"

@export var ending4_title: String = "Ending 4: Secret jazz ending"
@export var ending4_progress: String = "Ending 4 of 4"

var intro_done := false
var asked_before := false
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

	# 1) Spille intro-dialog bare første gang
	if not intro_done:
		await _run_intro(dialogue_ui)
		intro_done = true

	# 2) Spør om hun er klar (kortere tekst hvis hun har sagt "nei" før)
	if asked_before:
		choice_ui.ask("Kris: Are you ready now?")
	else:
		choice_ui.ask(question_ready)

	var yes: bool = await choice_ui.chosen
	await get_tree().process_frame  # hindrer at samme tast lukker neste melding direkte

	if not yes:
		asked_before = true
		dialogue_ui.show_message(not_ready_message)
		await dialogue_ui.closed
		busy = false
		return

	# 3) Hvis "ja" -> gå til ending basert på sheets
	var has_all := GameState.sheets_collected.has("sheet_1") \
		and GameState.sheets_collected.has("sheet_2") \
		and GameState.sheets_collected.has("sheet_3")

	if has_all:
		GameState.ending_title = "Ending 4: Jazz ending"
		GameState.mark_ending_seen(4)
		GameState.ending_progress = "Ending 4 of 4"
		GameState.ending_next_scene = "res://MainMenu.tscn"
		GameState.ending_story_text = "..."
		GameState.ending_music_path = "res://Musikk/Ending4.ogg" # kan være tom nå
		GameState.ending_anim_scene = "res://ending4_anim.tscn"
		GameState.ending_image_path = ""
		call_deferred("_go_to_scene", "res://ending_scene.tscn")
		get_tree().paused = false
		busy = false
		return



	else:
		GameState.ending_title = ending3_title
		GameState.mark_ending_seen(3)
		GameState.ending_progress = ending3_progress
		GameState.ending_image_path = "res://Endings/ending3.png" # eller der filen ligger
		GameState.ending_anim_scene = ""      # viktig: tøm anim
		GameState.ending_story_text = "Kris: Beatrice I can't belive that you are here. I'm so happy, Beatrice happy birthey I love you so much, and I truly hope that even though I didnt prepare anything for you here, that you still have an amazing day. I love you."   # teksten du vil vise på bildet-skjermen
		GameState.ending_music_path = "res://Musikk/Ending3.ogg" # kan være tom nå


	GameState.ending_next_scene = "res://MainMenu.tscn"
	call_deferred("_go_to_scene", "res://ending_scene.tscn")


	busy = false


func _run_intro(dialogue_ui: Node) -> void:
	# Lang dialog, en linje av gangen
	await _say(dialogue_ui, "Kris: OMG Beatrice… I was just about to call you on Discord. How the hell did you end up here?")
	await _say(dialogue_ui, "Beatrice: It’s a long story tbh. I think I’d rather tell you IRL, not in the game haha… But the most important is that I’m here now.")
	await _say(dialogue_ui, "Kris: Aww that’s true… and you can’t understand how happy I am to have you here with me right now. I love you so much Beatrice <3")
	await _say(dialogue_ui, "Beatrice: I love you too. I’m so happy I can celebrate with you.")


func _say(dialogue_ui: Node, text: String) -> void:
	dialogue_ui.show_message(text)
	await dialogue_ui.closed

func _go_to_scene(path: String) -> void:
	var tree := get_tree()
	if tree != null:
		tree.change_scene_to_file(path)
