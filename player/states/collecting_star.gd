@tool
extends State


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/gotstar"] = true
	target.got_star.emit(target.star_count)
	target.model.look_at(target.cam.global_position, Vector3.UP, true)
	add_timer("TimerUnlock", 2)


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/gotstar"] = false
	target.x_locked = false
	target.y_locked = false
	del_timer("TimerUnlock")


func _on_timeout(_name: String) -> void:
	if _name == "TimerUnlock": change_state("None")
