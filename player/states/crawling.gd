@tool
extends State


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/crawled"] = true


func _on_update(_delta) -> void:
	if (target.velocity * Vector3(1, 0, 1)).is_zero_approx():
		change_state("Crouching")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/crawled"] = false
	target.animation["parameters/conditions/crouched"] = true
