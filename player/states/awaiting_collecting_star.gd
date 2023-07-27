@tool
extends State


func _on_enter(_args) -> void:
	target.x_locked = true
	target.y_locked = true
	change_state("Falling")
	target.play_sfx("star_touched")


func _on_update(_args) -> void:
	if is_active("Grounded"):
		change_state("CollectingStar")
