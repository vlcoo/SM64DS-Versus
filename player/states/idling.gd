@tool
extends State


func _on_enter(_args) -> void:
	if not target.is_node_ready(): return
	target.animation["parameters/conditions/idling"] = true


func _on_update(_delta) -> void:
	if (target.velocity * Vector3(1, 0, 1)).length() != 0:
		change_state("Running")
	
#	if Input.is_action_just_pressed("crouch"):
#		change_state("Crouching")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/idling"] = false
