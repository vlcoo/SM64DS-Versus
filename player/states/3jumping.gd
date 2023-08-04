@tool
extends State


func _on_enter(_args) -> void:
	target.velocity.y = target.JUMP_STRENGTH * target.JUMP3_MULTIPLIER
	target.animation["parameters/conditions/3jumped"] = true
	target.play_sfx(["ya", "yoshi"].pick_random())
	target.play_sfx("jump", true)


func _on_update(delta: float) -> void:
	target.velocity.y -= target.GRAVITY * delta
	
	if target.is_on_floor():
		change_state("Grounded", [], ["from_jump3"])
	
	if target.velocity.y < 0: change_state("Falling", [], ["from_jump3"])
	
	# if Input.is_action_just_released("jump") and target.velocity.y > target.JUMP_INTERRUPT_THRESHOLD:
	#	target.velocity.y = target.JUMP_INTERRUPT_THRESHOLD


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/3jumped"] = false
