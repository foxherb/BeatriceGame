extends Control

@export var pages: Array[String] = [
"Kris: Beatrice happy birthday!\n\nFeliz cumpleaños!!\n\nGratulerer med dagen!\n\nYou're finally 25, and you know what that means right? ....\n\nYeah about that hate to be the bearer of bad news on your birthday, but idk if your brain really is fully developed, opsi.",

"Kris: Guess we can take an online test together to see haha, but anyway you're 25!!!!\n\n25, my cutie is getting older and I finally don't have to compete with Leo anymore, but don't worry I love you way too much to be like him anyway.",

"Kris: I'm so happy that I'm able to celebrate your birthday with you.\n\nAnd even though we are far apart right now, celebrating with you like this is still better than not celebrating with you at all.",

"Kris: I can't believe I'm lucky enough to have had the pleasure of getting to know you, and not only that, falling for you.\n\nIt's honestly crazy to think that we didn't know each other a year ago, and now you are the person I think about above all else.",

"Kris: Beatrice I love you so much.\n\nHow have you been able to take my heart like this, and how have you been able to treat me so amazingly that I actually want you to keep it?",

"Kris: Because there is truly no one else like you, Beatrice.\n\nYou are funny, smart, creative, kind and beautiful.\n\nI truly can't get enough of you.",

"Kris: Beatrice you are truly the greatest gift I've ever received and I truly hope I can give you the same gift you've given me.\n\nYou brighten my days, and you bring so much to my life.",

"Kris: My love I still won't forget the first moment you took your hand up and said blblblbl, insinuating that I talked too much that day.\n\nIt was the first time you truly showed me something that could be taken the wrong way, but you did it so magically that there wasn't anything wrong and just laughter.",

"Kris: I also want you to know that you bring out the best in me.\n\nYou have helped me become more creative, and more structured.\n\nYeah imagine that I have gotten more structure?\n\nwhat the helly haha, but you really did bring that out of me.",

"Kris: There's a saying that you become more and more like the person you spend most of your time with.\n\nAnd honestly if that's true then I truly won the jackpot in being able to spend all my time with you.",

"Kris: You make me feel incredibly safe, you also make me feel braver.\n\nJust being with you I do things I wouldn't normally.\n\nYou give me a sense of calmness in my days, and whenever I do want to talk about something that has happened you are there helping and listening.",

"Kris: Thank you for being your true self with me.\n\nThank you for telling me no sometimes.\n\nAnd thank you for letting me introduce spice to someone else's life.",

"Kris: I can't wait for the times in the future where I can tell you all these things in person.\n\nAnd we don't have to be on the opposite sides of the globe.\n\nBut knowing that both of us are aiming for being together brings me so much happiness and you really show me that it brings happiness to you too.",

"Kris: I promise to keep staying with you, and to keep trying new things for you.\n\nI love you with all my heart, with every piece of me.\n\nAnd I hope that some of my love is being shown through this game.",

"Kris: Thank you for being in my life, and I hope you like this present.\n\nI love you, jeg elsker deg, te amo\n\n-Kristoffer"
]

@export var letter_music_path: String = "res://Musikk/Ending3.ogg"
@export var panel_top_anchor: float = 0.35

var pages_done := false
var showing_final_gift := false

@onready var kris: AnimatedSprite2D = $KrisSprite
@onready var final_gift_image: TextureRect = $FinalGiftImage

func _ready() -> void:
	get_tree().paused = false

	if letter_music_path != "":
		MusicPlayer.play_music(letter_music_path, GameState.music_volume_db)

	var dialogue_ui = $Ui/DialogueUI

	var choice_ui = $Ui.get_node_or_null("ChoiceUI")
	if choice_ui != null:
		choice_ui.hide()

	if dialogue_ui.has_signal("typing_started"):
		dialogue_ui.typing_started.connect(_on_typing_started)
	if dialogue_ui.has_signal("typing_finished"):
		dialogue_ui.typing_finished.connect(_on_typing_finished)

	_set_letter_ui_size(dialogue_ui, panel_top_anchor)

	# Skjul bildet til slutt
	if final_gift_image != null:
		final_gift_image.visible = false

	await _show_pages(dialogue_ui)
	pages_done = true

	# Etter siste side: vis bildet
	_show_final_gift()

func _show_final_gift() -> void:
	showing_final_gift = true
	if final_gift_image != null:
		final_gift_image.visible = true
		# Spill lyden akkurat når bildet vises
	SFXPlayer.play_sfx("res://SFX/gift_reveal.ogg", -8.0)

func _set_letter_ui_size(dialogue_ui: Node, top_anchor: float) -> void:
	var panel: Control = dialogue_ui.get_node("Panel")
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.anchor_top = top_anchor
	panel.anchor_bottom = 1.0
	panel.offset_left = 0
	panel.offset_right = 0
	panel.offset_top = 0
	panel.offset_bottom = 0

func _show_pages(dialogue_ui: Node) -> void:
	for p in pages:
		dialogue_ui.show_message(p)
		await dialogue_ui.closed

func _on_typing_started() -> void:
	if kris != null:
		kris.play("talk")

func _on_typing_finished() -> void:
	if kris != null:
		kris.stop()
		kris.frame = 0

func _unhandled_input(event: InputEvent) -> void:
	if not (event.is_action_pressed("confirm") or event.is_action_pressed("interact")):
		return

	var dialogue_ui = $Ui/DialogueUI

	# 1) Hvis dialogen fortsatt er åpen, la DialogueUI håndtere input
	if dialogue_ui != null and dialogue_ui.is_open:
		return

	# 2) Hvis vi viser sluttbildet, neste Space = tilbake til meny
	if pages_done and showing_final_gift:
		accept_event()
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		return
