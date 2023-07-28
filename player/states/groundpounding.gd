@tool
extends State


func _on_enter(_args) -> void:
	add_timer("TimerImpact", target.GROUNDPOUND_IMPACT_TIME)


func _on_update(_delta) -> void:
	if target.is_on_floor():
		change_state("Grounded", [], ["no_land_sfx"])


func _on_exit(_args) -> void:
	target.play_sfx("impact_groundpound", true)
	target.play_sfx("hou")


func _on_timeout(_name) -> void:
	target.velocity.y = -target.GROUNDPOUND_STRENGTH
