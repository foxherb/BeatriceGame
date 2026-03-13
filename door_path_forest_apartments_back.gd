extends Area2D

@export var target_scene: String = "res://norway_forest_apartments.tscn"
@export var spawn_name_in_target: String = "Spawn_From_Apartments"

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	GameState.next_spawn_name = spawn_name_in_target
	get_tree().call_deferred("change_scene_to_file", target_scene)
