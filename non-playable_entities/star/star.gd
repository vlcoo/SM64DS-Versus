extends RigidBody3D

## Amount of force to apply when a player first touches the star.
@export var BREACH_STRENGTH: float


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if freeze: 
			freeze = false
			apply_central_impulse(body.velocity.normalized() * BREACH_STRENGTH)
			$GlassCase.visible = false
			$GPUParticles3D.emitting = true
		else:
			body.on_collected_star()
			queue_free()
