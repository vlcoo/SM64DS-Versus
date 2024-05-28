class_name Star
extends RigidBody3D

## Amount of force to apply when a player first touches the star.
@export var BREACH_STRENGTH: float
## Extra bouncing force.
@export var BOUNCE_STRENGTH: float

@onready var sfx: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var area_3d: Area3D = $Area3D

var sfx_bounce := preload("res://audio/sfx/environment/star_bounce.ogg")
var sfx_breach := preload("res://audio/sfx/environment/star_breach.ogg")

var starting_pos: Vector3

signal collected(star)


func _ready() -> void:
	starting_pos = global_position


func appear() -> void:
	if Utils.benchmark_mode and get_tree():
		await get_tree().create_timer(randi_range(1, 4)).timeout
	global_position = starting_pos
	area_3d.set_deferred("monitoring", true)
	$AnimationPlayer.play("appear")


func disappear() -> void:
	area_3d.set_deferred("monitoring", false)
	$AnimationPlayer.play("disappear")
	collected.emit(self)
	freeze = true


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
			disappear()
	elif body.is_in_group("Terrain"):
		sfx.stream = sfx_bounce
		sfx.play()
		apply_central_impulse(Vector3(0, BOUNCE_STRENGTH, 0))
