@tool
extends State


func _on_update(_delta) -> void:
	target.velocity.x -= target.SOFT_X_DAMPING
	target.velocity.z -= target.SOFT_X_DAMPING
