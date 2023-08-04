extends RigidBody3D

## Amount of force to apply when a player first touches the star.
@export var BREACH_STRENGTH: float
## Extra bouncing force.
@export var BOUNCE_STRENGTH: float

@onready var sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D

var sfx_bounce := preload("res://audio/sfx/environment/star_bounce.ogg")
var sfx_breach := preload("res://audio/sfx/environment/star_breach.ogg")


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		if freeze: 
			freeze = false
			apply_central_impulse(body.velocity.normalized() * BREACH_STRENGTH)
			$GlassCase.visible = false
			$GPUParticles3D.emitting = true
			sfx.stream = sfx_breach
			sfx.play()
		else:
			body.on_collected_star()
			queue_free()
	elif body.is_in_group("Terrain"):
		sfx.stream = sfx_bounce
		sfx.play()
		apply_central_impulse(Vector3(0, BOUNCE_STRENGTH, 0))
