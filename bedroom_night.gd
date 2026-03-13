extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.play_music("res://Musikk/Chile.ogg", GameState.music_volume_db)
	SFXPlayer.play_sfx("res://SFX/door-slam.ogg", -6.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
