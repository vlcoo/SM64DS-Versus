@tool
extends State


func _on_enter(_args) -> void:
	target.velocity.y = target.LONGJUMP_Y_STRENGTH
	target.animation["parameters/conditions/longjumped"] = true
	target.play_sfx("yoshi")


func _on_update(delta) -> void:
	target.velocity.y -= target.GRAVITY * delta
	
	if target.is_on_floor():
		change_state("Grounded")


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/longjumped"] = false
