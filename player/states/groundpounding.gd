@tool
extends State


func _on_enter(_args) -> void:
	add_timer("TimerImpact", target.GROUNDPOUND_IMPACT_TIME)


func _on_update(_delta) -> void:
	if target.is_on_floor():
		change_state("Grounded")


func _on_timeout(_name) -> void:
	target.velocity.y = -target.GROUNDPOUND_STRENGTH
