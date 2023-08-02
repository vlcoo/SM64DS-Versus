extends Control

@onready var audio_music: AudioStreamPlayer = $AudioMusic
@onready var sfx: AudioStreamPlayer = $AudioSFX

var SFXs: Dictionary = {
	"accept": preload("res://audio/sfx/system/accept.ogg"),
	"special": preload("res://audio/sfx/system/special_top.ogg"),
	"buzzer": preload("res://audio/sfx/system/buzzer.ogg"),
	"toggle": preload("res://audio/sfx/system/toggle.ogg"),
	"quit": preload("res://audio/sfx/system/return.ogg")
}


func _ready() -> void:
	get_node("ContainerSettings/HBoxContainer2/Button" + str(Utils.config.get_value("settings", "graphics", 2) + 1)).button_pressed = true
	print(ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_3d"))


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


func _on_settings_graphics_changed(level: int) -> void:
	# 0 low, 1 medium, 2 high
	sfx.stream = SFXs["toggle"]
	sfx.play()
	Utils.config.set_value("settings", "graphics", level)
	
	match level:
		0:
			ProjectSettings.set_setting("rendering/renderer/rendering_method", "gl_compatibility")
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 0.5)
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)
		1:
			ProjectSettings.set_setting("rendering/renderer/rendering_method", "mobile")
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 1)
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 0)
		2:
			ProjectSettings.set_setting("rendering/renderer/rendering_method", "forward_plus")
			ProjectSettings.set_setting("rendering/scaling_3d/scale", 1)
			ProjectSettings.set_setting("rendering/anti_aliasing/quality/msaa_3d", 2)
	ProjectSettings.save()
