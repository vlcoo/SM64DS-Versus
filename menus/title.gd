extends Control

@onready var audio_music: AudioStreamPlayer = $AudioMusic
@onready var sfx: AudioStreamPlayer = $AudioSFX

var SFXs: Dictionary = {
	"accept": preload("res://audio/sfx/system/accept.ogg"),
	"special": preload("res://audio/sfx/system/special_top.ogg"),
	"buzzer": preload("res://audio/sfx/system/buzzer.ogg"),
	"quit": preload("res://audio/sfx/system/return.ogg")
}

func _on_btn_exit_pressed() -> void:
	sfx.stream = SFXs["quit"]
	sfx.play()
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, true, "$quit")


func _on_btn_config_pressed() -> void:
	sfx.stream = SFXs["accept"]
	sfx.play()
	$AnimationPlayer.play("open_settings")


func _on_btn_vs_pressed() -> void:
	sfx.stream = SFXs["special"]
	sfx.play()
	await get_tree().create_timer(0.4).timeout
	Transitionizer.transition(Transitionizer.Styles.DISSOLVE, Transitionizer.Styles.DISSOLVE, false, "res://maps/starting_hall.tscn")
	await get_tree().create_timer(0.4).timeout
	audio_music.stop()


func _on_btn_settings_back_pressed() -> void:
	sfx.stream = SFXs["quit"]
	sfx.play()
	$AnimationPlayer.play("close_settings")
