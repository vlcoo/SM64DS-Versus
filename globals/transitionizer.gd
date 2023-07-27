extends CanvasLayer

enum Styles {DISSOLVE}

@onready var color_rect: ColorRect = $ColorRect


func transition(in_style: Styles, out_style: Styles, dark: bool, target: String, show_loading: bool = false) -> void:
	assert(target != null and (target.begins_with("$") or ResourceLoader.exists(str(target))), 
		"Tried to transition into non-existent Scene.")
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	color_rect.color = Color.BLACK if dark else Color.WHITE
	$ColorRect/RichTextLabel.visible = show_loading
	create_tween().tween_method(_set_fadeable_music_db, 0, -25, .6).set_ease(Tween.EASE_IN)
	$AnimationPlayer.play(Styles.keys()[in_style].to_lower())
	await $AnimationPlayer.animation_finished
	
	if target.begins_with("$"):
		_do_special_command(target.split("$")[1])
	else:
		get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards(Styles.keys()[out_style].to_lower())
	_set_fadeable_music_db(0)
	await $AnimationPlayer.animation_finished
	
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$ColorRect/RichTextLabel.visible = false


func _set_fadeable_music_db(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FadeableMusic"), value)


func _do_special_command(cmd: String):
	match cmd:
		"quit":
			get_tree().quit()


func _on_timer_timeout() -> void:
	$ColorRect/RichTextLabel.visible = true
