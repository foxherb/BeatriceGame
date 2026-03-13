extends Control

@export var auto_advance_seconds: float = 0.0

@onready var ending_image: TextureRect = $EndingImage
@onready var story_label: RichTextLabel = find_child("StoryLabel", true, false) as RichTextLabel
@onready var blip: AudioStreamPlayer = get_node_or_null("TextBlip") as AudioStreamPlayer

@export var chars_per_second: float = 40.0
@export var blip_every_n_chars: int = 2
@export var blip_pitch_min: float = 0.95
@export var blip_pitch_max: float = 1.10
@export var blip_volume_db: float = -10.0

var _typing := false
var _skip_requested := false
var _full_text := ""

func _ready() -> void:
	
		# Hvis vi har en egen anim-scene for denne endingen, gå dit i stedet
	if GameState.has_method("get") and GameState.get("ending_anim_scene") != null:
		pass

	if "ending_anim_scene" in GameState and GameState.ending_anim_scene != "":
		get_tree().change_scene_to_file(GameState.ending_anim_scene)
		return
	# ... resten av ending_scene-koden din (bilde, typewriter, musikk osv) ...
	
	if GameState.ending_music_path != "":
			MusicPlayer.play_music(GameState.ending_music_path, GameState.music_volume_db)
	else:
		# valgfritt: hvis du vil stoppe musikk når ending ikke har musikk
		# MusicPlayer.stop_music()
			pass
	# bilde
	if GameState.ending_image_path != "" and ResourceLoader.exists(GameState.ending_image_path):
		ending_image.texture = load(GameState.ending_image_path)

	# tekst (typewriter)
	_full_text = GameState.ending_story_text
	if story_label != null:
		story_label.text = _full_text
		story_label.visible_characters = 0

	_typing = true
	_skip_requested = false
	await _typewriter()

	# auto-advance hvis du vil (etter at teksten er ferdig)
	if auto_advance_seconds > 0.0:
		await get_tree().create_timer(auto_advance_seconds).timeout
		_go_to_black_screen()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()

		# hvis vi fortsatt skriver: skip til full tekst
		if _typing:
			_skip_requested = true
			return

		# ellers: videre
		_go_to_black_screen()

func _typewriter() -> void:
	if story_label == null:
		_typing = false
		return

	var total: int = _full_text.length()
	var cps: float = maxf(chars_per_second, 1.0)
	var delay: float = 1.0 / cps
	var shown: int = 0

	while shown < total and _typing:
		if _skip_requested:
			break

		shown += 1
		story_label.visible_characters = shown

		var ch := _full_text[shown - 1]
		if blip != null \
		and ch != " " and ch != "\n" and ch != "\t" \
		and (shown % maxi(blip_every_n_chars, 1) == 0):
			blip.pitch_scale = randf_range(blip_pitch_min, blip_pitch_max)
			blip.volume_db = blip_volume_db
			blip.play()

		await get_tree().create_timer(delay).timeout

	story_label.visible_characters = -1
	_typing = false
	_skip_requested = false

func _go_to_black_screen() -> void:
	get_tree().change_scene_to_file("res://EndingScreen.tscn")
