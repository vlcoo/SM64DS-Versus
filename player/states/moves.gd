@tool
extends State

@export var SPEED = 1.0

var model: Skeleton3D


func _on_enter(_args) -> void:
	model = target.get_node("Model")


func _on_update(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (target.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction:
		target.velocity.x = direction.x * SPEED
		target.velocity.z = direction.z * SPEED
		model.rotation.y = atan2(target.velocity.x, target.velocity.z)
		target.animation["parameters/MoveBlend/TimeScale/scale"] = target.velocity.length()
	else:
		target.velocity.x = move_toward(target.velocity.x, 0, SPEED)
		target.velocity.z = move_toward(target.velocity.z, 0, SPEED)
	
	# target.animation["parameters/conditions/moving"] = direction != Vector3.ZERO
	# target.animation["parameters/conditions/idling"] = direction == Vector3.ZERO

	target.move_and_slide()
