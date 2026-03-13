extends Control

@export var next_scene: String = "res://norway_intro_text.tscn"
@export var animation_name: String = ""  # leave empty to play current animation

@onready var anim_sprite: AnimatedSprite2D = $AnimRoot/PortalAnim

func _ready() -> void:
	# Play animation
	SFXPlayer.play_sfx("res://SFX/Portal.ogg", -6.0)
	if animation_name == "":
		anim_sprite.play()
	else:
		anim_sprite.play(animation_name)

	# Wait for animation duration, then go next
	var frames: SpriteFrames = anim_sprite.sprite_frames
	var name: StringName = anim_sprite.animation
	var frame_count: int = frames.get_frame_count(name)
	var fps: float = frames.get_animation_speed(name)

	var duration: float = float(frame_count) / max(fps, 1.0)

	await get_tree().create_timer(duration).timeout
	get_tree().change_scene_to_file(next_scene)
