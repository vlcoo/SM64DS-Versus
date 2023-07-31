@tool
extends State


func _on_update(_delta: float) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (target.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	direction = direction.rotated(Vector3.UP, target.cam_pivot.rotation.y)
	if direction and not target.x_locked:
		var is_jumping: bool = ["2Jumping", "3Jumping"] \
			.any(func(s): return active_states.has(s))
		if is_jumping: direction *= Vector3(0.7, 1, 0.7)
		target.velocity.x = direction.x * target.RUN_SPEED
		target.velocity.z = direction.z * target.RUN_SPEED
		if is_active("LongJumping"): target.velocity *= Vector3(target.LONGJUMP_X_MULTIPLIER, 1, target.LONGJUMP_X_MULTIPLIER)
		if not is_jumping and not is_active("LongJumping"):
			target.model.rotation.y = atan2(target.velocity.x, target.velocity.z)
		target.animation["parameters/Moving blend/TimeScale/scale"] = target.velocity.length() * 1.2
	else:
		target.velocity.x = move_toward(target.velocity.x, 0, target.RUN_SPEED / target.DECEL_STRENGTH)
		target.velocity.z = move_toward(target.velocity.z, 0, target.RUN_SPEED / target.DECEL_STRENGTH)
		target.model.rotation.x = 0

	target.move_and_slide()
