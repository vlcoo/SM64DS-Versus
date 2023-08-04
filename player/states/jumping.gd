@tool
extends State


func _on_enter(_args) -> void:
	target.velocity.y = target.JUMP_STRENGTH
	target.animation["parameters/conditions/jumped"] = true
	target.play_sfx(["ha", "ho"].pick_random())
	target.play_sfx("jump", true)


func _on_update(delta: float) -> void:
	target.velocity.y -= target.GRAVITY * delta
	
	if target.is_on_floor():
		change_state("Grounded", [], ["from_jump"])
	
	if Input.is_action_just_released("jump") and target.velocity.y > target.JUMP_INTERRUPT_THRESHOLD:
		target.velocity.y = target.JUMP_INTERRUPT_THRESHOLD
	
	if Input.is_action_pressed("jump") and target.velocity.y < -target.FLUTTER_THRESHOLD:
		change_state("Fluttering")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/jumped"] = false
