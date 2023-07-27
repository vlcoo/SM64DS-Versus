@tool
extends State

var from_jump3: bool
var long_fall: bool = false


func _on_enter(_args) -> void:
	target.animation["parameters/conditions/fell"] = true
	add_timer("TimerFalling", target.LONG_FALL_TIME)
	long_fall = false


func _after_enter(_args) -> void:
	from_jump3 = _args and _args.has("from_jump3")


func _on_update(delta: float) -> void:
	target.velocity.y -= target.GRAVITY * delta
	
	if target.is_on_floor():
		var falling_args: Array[String] = []
		if from_jump3: falling_args.append("from_jump3")
		if long_fall: falling_args.append("long_fall")
		change_state("Grounded", [], falling_args)


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/fell"] = false
	del_timer("TimerFalling")


func _on_timeout(_name) -> void:
	if _name == "TimerFalling" and is_active("None"):
		target.play_sfx("awwawawa")
		long_fall = true
