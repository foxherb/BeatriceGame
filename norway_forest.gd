extends Node2D

func _ready() -> void:
	MusicPlayer.play_music("res://Musikk/Norge.ogg", GameState.music_volume_db)
	_place_player_at_spawn()
	# your other intro code below
	if GameState.forest_intro_done:
		return
	GameState.forest_intro_done = true

	var dialogue_ui = get_node_or_null("Ui/DialogueUI")
	if dialogue_ui != null:
		dialogue_ui.show_message("Beatrice: Where am I? I better look around for clues.")


func _place_player_at_spawn() -> void:
	if GameState.next_spawn_name == "":
		return

	var player = get_node_or_null("Player")
	var spawn = get_node_or_null(GameState.next_spawn_name)

	if player != null and spawn != null:
		player.global_position = spawn.global_position

	GameState.next_spawn_name = ""
	
