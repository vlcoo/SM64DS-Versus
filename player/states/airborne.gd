@tool
extends State

var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _on_update(_delta: float) -> void:
	if not target.is_on_floor():
		target.velocity.y -= GRAVITY * _delta
