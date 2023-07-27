@tool
extends State


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("crouch") and is_active("None") and \
	["Jumping", "2Jumping", "3Jumping", "Falling"].any(func(s): return active_states.has(s)):
		change_state("ChargingGroundpound")
