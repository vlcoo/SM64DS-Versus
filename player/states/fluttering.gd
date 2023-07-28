@tool
extends State


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/fluttered"] = true
	add_timer("TimerFlutter", target.FLUTTER_TIME)
	target.play_sfx("hnngh")


func _on_update(delta) -> void:
	target.velocity.y += target.FLUTTER_STRENGTH * delta
	
	if Input.is_action_just_released("jump"): change_state("Falling")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/fluttered"] = false
	target.sfx.stop()


func _on_timeout(_name) -> void:
	change_state("Falling")
