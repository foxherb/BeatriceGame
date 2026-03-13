extends Node

@onready var bgm: AudioStreamPlayer = get_node_or_null("BGM")
var current_path: String = ""

func play_music(path: String, volume_db: float = 0.0) -> void:
	if bgm == null:
		push_error("MusicPlayer: BGM node not found at runtime. Check Autoload uses music_player.tscn.")
		return

	if path == "" or path == current_path:
		return

	if not ResourceLoader.exists(path):
		push_error("MusicPlayer: File not found: " + path)
		return

	var stream: AudioStream = load(path)
	if stream == null:
		push_error("MusicPlayer: Failed to load: " + path)
		return

	bgm.stream = stream
	bgm.volume_db = volume_db
	bgm.play()
	current_path = path

func stop_music() -> void:
	if bgm == null:
		return
	bgm.stop()
	current_path = ""
