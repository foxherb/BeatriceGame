extends Node2D


func _ready() -> void:
	_place_player_at_spawn()

func _place_player_at_spawn() -> void:
	if GameState.next_spawn_name == "":
		return

	var player = get_node_or_null("Player")
	var spawn = get_node_or_null(GameState.next_spawn_name)

	if player != null and spawn != null:
		player.global_position = spawn.global_position

	GameState.next_spawn_name = ""
