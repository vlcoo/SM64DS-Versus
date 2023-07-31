@tool
extends State


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/crouched"] = true
	target.x_locked = true


func _on_update(_delta) -> void:
	if Input.is_action_just_released("crouch"): change_state("Idling")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/crouched"] = false
	target.x_locked = false
