extends Node

@onready var sfx: AudioStreamPlayer = $SFX

func play_sfx(path: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	if path == "":
		return
	var stream = load(path)
	if stream == null:
		return
	sfx.stream = stream
	sfx.volume_db = volume_db
	sfx.pitch_scale = pitch
	sfx.play()
