extends RigidBody3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.on_collected_star()
		queue_free()
