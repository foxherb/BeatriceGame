extends Control

@onready var anim: AnimatedSprite2D = $Anim

func _ready() -> void:
	# Start animasjon (loop kan være på i SpriteFrames)
	if anim != null:
		anim.play("jazz")  # spiller default animasjon, eller bruk anim.play("jazz") om den heter det

	# Start ending-musikk hvis den finnes
	if GameState.ending_music_path != "":
		MusicPlayer.play_music(GameState.ending_music_path, GameState.music_volume_db)

func _unhandled_input(event: InputEvent) -> void:
	# Space / confirm / interact for å gå videre
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()

		# (Valgfritt) stopp musikken her hvis du vil at den ikke skal fortsette i EndingScreen/MainMenu
		# MusicPlayer.stop_music()

		get_tree().change_scene_to_file("res://EndingScreen.tscn")
