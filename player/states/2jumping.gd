@tool
extends State


func _on_enter(_args) -> void:
	target.velocity.y = target.JUMP_STRENGTH * target.JUMP2_MULTIPLIER
	target.animation["parameters/conditions/2jumped"] = true
	target.play_sfx(["pom", "ton"].pick_random())
	target.play_sfx("step_jump", true)


func _on_update(delta: float) -> void:
	target.velocity.y -= target.GRAVITY * delta
	
	if target.is_on_floor():
		change_state("Grounded", [], ["from_jump2"])
	
	# if Input.is_action_just_released("jump") and target.velocity.y > target.JUMP_INTERRUPT_THRESHOLD:
	#	target.velocity.y = target.JUMP_INTERRUPT_THRESHOLD


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/2jumped"] = false
