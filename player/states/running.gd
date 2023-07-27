@tool
extends State


func _on_enter(_args) -> void:
	if not target.is_node_ready(): return
	target.animation["parameters/conditions/moving"] = true


func _on_update(_delta) -> void:
	if not is_active("None") or (target.velocity * Vector3(1, 0, 1)).length() == 0:
		change_state("Idling")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/moving"] = false
	target.animation["parameters/conditions/celeb"] = false
