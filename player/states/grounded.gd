@tool
extends State

var jump2_timer: Timer = Timer.new()
var jump3_timer: Timer = Timer.new()


func _on_enter(_args) -> void:
	if not target.is_node_ready(): return
	target.animation["parameters/conditions/landed"] = true
	target.particles.emitting = true
	target.play_sfx("step_land", true)


func _after_enter(_args) -> void:
	if _args and _args.has("from_jump"): 
		jump2_timer = add_timer("2nd_jump", target.JUMP2_TIME)
	elif _args and _args.has("from_jump2"):
		jump3_timer = add_timer("3rd_jump", target.JUMP2_TIME)
	elif is_active("None") and is_active("Idling") and _args and _args.has("from_jump3"):
		target.animation["parameters/conditions/celeb"] = true
		target.play_sfx("couple")
	
	if is_active("None") and _args and _args.has("long_fall"):
		target.animation["parameters/conditions/smooshed"] = true
		target.play_sfx(["waah", "agh"].pick_random())


func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and not target.y_locked:
		if not jump2_timer.is_stopped(): change_state("2Jumping")
		elif is_active("Running") and not jump3_timer.is_stopped(): change_state("3Jumping")
		else: change_state("Jumping")
	
	if not target.is_on_floor():
		change_state("Falling")


func _on_timeout(_timer_name: String) -> void:
	pass


func _on_exit(_args) -> void:
	target.animation["parameters/conditions/landed"] = false
	target.animation["parameters/conditions/celeb"] = false
	target.animation["parameters/conditions/smooshed"] = false
