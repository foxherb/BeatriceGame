extends Node

var coffee_boost: bool = false
var bedroom_intro_done: bool = false
var living_room_intro_done: bool = false
var bedroom_night_intro_done: bool = false
var ending_title: String = ""
var ending_progress: String = ""
var ending_next_scene: String = "" # optional, for “back to menu” etc
var forest_intro_done := false
var songsvann_trigger_done: bool = false
var sheets_collected := {} # dictionary, ex: {"sheet_1": true}
var next_spawn_name: String = ""
var ending_anim_scene: String = ""
var endings_seen := {1: false, 2: false, 3: false, 4: false}

func reset_run() -> void:
	coffee_boost = false

	sheets_collected.clear()
	next_spawn_name = ""

	# intro flags
	bedroom_intro_done = false
	living_room_intro_done = false
	bedroom_night_intro_done = false
	forest_intro_done = false
	songsvann_trigger_done = false

	# ending data
	ending_title = ""
	ending_progress = ""
	ending_next_scene = ""
	ending_image_path = ""
	ending_music_path = ""
	ending_story_text = ""
	ending_anim_scene = ""

func mark_ending_seen(n: int) -> void:
	if endings_seen.has(n):
		endings_seen[n] = true
		save_progress()

func all_endings_seen() -> bool:
	return endings_seen[1] and endings_seen[2] and endings_seen[3] and endings_seen[4]

func save_progress() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "endings_seen", endings_seen)
	cfg.save("user://progress.cfg")

func load_progress() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load("user://progress.cfg")
	if err == OK:
		var data = cfg.get_value("progress", "endings_seen", null)
		if typeof(data) == TYPE_DICTIONARY:
			endings_seen = data

# nye, for senere
var ending_image_path: String = ""   # feks "res://Endings/ending1.png"
var ending_music_path: String = ""   # feks "res://Music/ending1.ogg"

var music_volume_db: float = -6.0
var sfx_volume_db: float = -6.0

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_volume_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_volume_db)

var ending_story_text: String = ""
