@tool
extends State


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/groundpounded"] = true
	target.global_position.y += 0.1
	target.velocity = Vector3.ZERO
	target.x_locked = true
	target.y_locked = true
	target.play_sfx("roll", true)


func _on_update(_delta: float) -> void:
	if target.is_on_floor():
		change_state("Grounded")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/groundpounded"] = false
