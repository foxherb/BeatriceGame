extends Control

signal typing_started
signal typing_finished
signal closed

# Finn Panel automatisk (slipper node-path trøbbel)
@onready var panel: Control = find_child("Panel", true, false) as Control

# Finn tekst-label automatisk.
# Hvis din heter "Text" eller "StoryLabel" så funker dette.
@onready var text_label: CanvasItem = (
	find_child("StoryLabel", true, false)
	if find_child("StoryLabel", true, false) != null
	else find_child("Text", true, false)
) as CanvasItem

@onready var blip: AudioStreamPlayer = get_node_or_null("TextBlip") as AudioStreamPlayer

var is_open := false
var _typing := false
var _skip_requested := false
var _full_text := ""

@export var chars_per_second: float = 40.0
@export var blip_every_n_chars: int = 2
@export var blip_pitch_min: float = 0.95
@export var blip_pitch_max: float = 1.10
@export var blip_volume_db: float = -10.0
@export var beatrice_pitch_min: float = 0.98
@export var beatrice_pitch_max: float = 1.05

@export var kris_pitch_min: float = 0.78
@export var kris_pitch_max: float = 0.88

@export var other_pitch_min: float = 0.90
@export var other_pitch_max: float = 1.20

var _pitch_min: float = 0.95
var _pitch_max: float = 1.10


func _ready() -> void:
	if panel != null:
		panel.visible = false

	# Start med “ingen typewriter begrensning”
	_set_visible_chars(-1)

func show_message(msg: String) -> void:
	# Velg pitch basert på hvem som snakker
	var lower := msg.strip_edges().to_lower()

	if lower.begins_with("beatrice:"):
		_pitch_min = beatrice_pitch_min
		_pitch_max = beatrice_pitch_max
	elif lower.begins_with("kris:") or lower.begins_with("kristoffer:"):
		_pitch_min = kris_pitch_min
		_pitch_max = kris_pitch_max
	else:
		_pitch_min = other_pitch_min
		_pitch_max = other_pitch_max

	# resten av show_message som før...
	_full_text = msg
	is_open = true
	_typing = true
	_skip_requested = false

	if panel != null:
		panel.visible = true

	_set_text(_full_text)
	_set_visible_chars(0)

	# Start typewriter
	await _typewriter()

func hide_message() -> void:
	_typing = false
	_skip_requested = false
	is_open = false
	if panel != null:
		panel.visible = false
	closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return

	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()

		# Hvis vi skriver tekst nå, første trykk = skip
		if _typing:
			_skip_requested = true
			return

		# Hvis ferdig skrevet, neste trykk = lukk
		hide_message()

func _typewriter() -> void:
	typing_started.emit()
	var total: int = _full_text.length()
	var cps: float = maxf(chars_per_second, 1.0)
	var delay: float = 1.0 / cps
	var shown: int = 0

	while shown < total and _typing:
		if _skip_requested:
			break

		shown += 1
		_set_visible_chars(shown)

		# Blip: ikke på space/linjeskift, og bare hver N tegn
		var ch := _full_text[shown - 1]
		if blip != null \
		and ch != " " and ch != "\n" and ch != "\t" \
		and (shown % maxi(blip_every_n_chars, 1) == 0):
			_play_blip()

		await get_tree().create_timer(delay).timeout

	# Hvis skip: vis alt
	_set_visible_chars(-1)
	typing_finished.emit()
	_typing = false
	_skip_requested = false

func _play_blip() -> void:
	if blip == null:
		return
	blip.pitch_scale = randf_range(_pitch_min, _pitch_max)
	blip.volume_db = blip_volume_db
	blip.play()
# --- Helper-funksjoner som støtter Label og RichTextLabel ---

func _set_text(t: String) -> void:
	if text_label == null:
		return

	if text_label is RichTextLabel:
		(text_label as RichTextLabel).text = t
	elif text_label is Label:
		(text_label as Label).text = t

func _set_visible_chars(n: int) -> void:
	if text_label == null:
		return

	if text_label is RichTextLabel:
		(text_label as RichTextLabel).visible_characters = n
	elif text_label is Label:
		(text_label as Label).visible_characters = n
