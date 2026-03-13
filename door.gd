extends Area2D

@export var target_scene: String = "res://Living_room.tscn"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().call_deferred("change_scene_to_file", target_scene)
