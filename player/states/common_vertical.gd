@tool
extends State


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("crouch") and is_active("None") and \
	["Jumping", "2Jumping", "3Jumping", "Falling"].any(func(s): return active_states.has(s)):
		change_state("ChargingGroundpound")
	
	if Input.is_action_just_pressed("jump") and Input.is_action_pressed("crouch") and \
	is_active("Grounded") and _can_longjump():
		change_state("LongJumping")


func _can_longjump() -> bool:
	return (target.velocity * Vector3(1, 0, 1)).length() > target.RUN_SPEED - 0.1 and \
	((Input.get_action_strength("move_up") > Input.get_action_strength("move_left") and \
	Input.get_action_strength("move_up") > Input.get_action_strength("move_right")) or \
	(Input.get_action_strength("move_down") > Input.get_action_strength("move_left") and \
	Input.get_action_strength("move_down") > Input.get_action_strength("move_right")))
